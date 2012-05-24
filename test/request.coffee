[ tumblrbot, assert, nock, mock_robot ] = require "./test_helper"
process.env.HUBOT_TUMBLR_API_KEY = apiKey = "789abc"

describe "tumblr api", ->
  describe "general purpose", ->
    network = null
    success = (done) ->
      (body) ->
        network.done()
        done()
    describe "request", ->
      response =
        meta: { status: 200, msg: "OK" }
        response:
          blog:
            title: "Foo Bar"
            posts: 333
          posts: [
            { id: 2222, post_url: "http://foo.bar.com/post/2222" }
          ]
          total_posts: 111
      beforeEach ->
        @t = tumblrbot.posts "foo.bar.com"
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&limit=1")
          .reply(200, response)
      it "fires", (done) ->
        @t.last success done
      it "returns data", (done) ->
        @t.last (data) ->
          assert.deepEqual response.response, data
          done()
      it "takes number as param", (done) ->
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&limit=3")
          .reply(200, response)
        @t.last 3, success done
      it "takes options as param", (done) ->
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&tag=foo&limit=1")
          .reply(200, response)
        @t.last {tag: "foo"}, success done
      it "takes number and options as params", (done) ->
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&tag=foo&limit=9")
          .reply(200, response)
        @t.last 9, {tag: "foo"}, success done

    describe "random", ->
      response =
        meta: { status: 200, msg: "OK" }
        response:
          blog:
            title: "Foo Bar"
            posts: 333
          posts: [
            { id: 2222, post_url: "http://foo.bar.com/post/2222" }
          ]
          total_posts: 56
      beforeEach ->
        Math.__old_random = Math.random
        Math.random = -> 0.625
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&limit=1")
          .reply(200, response)
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&limit=1&offset=34")
          .reply(200, response)
      afterEach ->
        Math.random = Math.__old_random
      it "fires", (done) ->
        t.random success done
      it "returns single post", (done) ->
        t.random (data) ->
          assert.deepEqual response.response.posts.pop(), data
          done()

  describe "errors", ->
    network = null
    never_called = ->
      assert.fail(null, null, "Success callback should not be invoked")
    beforeEach ->
      network = nock("http://api.tumblr.com")
        .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}")
    it "complains about bad response", (done) ->
      network.reply 401,
        meta: { status: 401, msg: "Not Authorized" }
        response: []
      mock_robot.onError = (msg) ->
        assert.ok /not authorized/i.exec msg
        done()
      t.request never_called
    it "complains about client errors", (done) ->
      http = t.tumblr
      http._old_posts = http.posts
      http.posts = (_..., cb) ->
        cb new Error "Kablooie!"
      mock_robot.onError = (msg) ->
        assert.ok /kablooie/i.exec msg
        done()
      t.request never_called
      http.posts = http._old_posts

    describe "without robot given", ->
      unattached_t = null
      before ->
        unattached_tumblr = require("..")
        unattached_t = unattached_tumblr.domain "foo.bar.com"
      it "complains to stderr", (done) ->
        util = require "util"
        util._old_error = util.error
        util.error = (msg) ->
          if msg.match /not authorized/i
            util.error = util._old_error
            done()
          else
            @_old_error.call process.stderr, msg
        network.reply 401,
          meta: { status: 401, msg: "Not Authorized" }
          response: []
        unattached_t.request never_called
