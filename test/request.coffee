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

      describe "one", ->
        it "fires", (done) ->
          @t.one success done
        it "returns data", (done) ->
          @t.one (data) ->
            assert.deepEqual response.response.posts[0], data
            done()
        it "takes options as param", (done) ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&tag=foo&limit=1")
            .reply(200, response)
          @t.one {tag: "foo"}, success done

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
        @t = tumblrbot.posts "foo.bar.com"
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
        @t.random success done
      it "returns single post", (done) ->
        @t.random (data) ->
          assert.deepEqual response.response.posts.pop(), data
          done()

    describe "post type", ->
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
      describe "text", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/text?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.text("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.texts("foo.bar.com").one success done
      describe "quote", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/quote?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.quote("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.quotes("foo.bar.com").one success done
      describe "link", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/link?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.link("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.links("foo.bar.com").one success done
      describe "answer", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/answer?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.answer("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.answers("foo.bar.com").one success done
      describe "video", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/video?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.video("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.videos("foo.bar.com").one success done
      describe "audio", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/audio?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.audio("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.audios("foo.bar.com").one success done
      describe "photo", (done) ->
        beforeEach ->
          network = nock("http://api.tumblr.com")
            .get("/v2/blog/foo.bar.com/posts/photo?api_key=#{apiKey}&limit=1")
            .reply 200, response
        it "has singular", (done) ->
          tumblrbot.photo("foo.bar.com").one success done
        it "has plural", (done) ->
          tumblrbot.photos("foo.bar.com").one success done

  describe "errors", ->
    network = null
    never_called = ->
      assert.fail(null, null, "Success callback should not be invoked")
    beforeEach ->
      @t = tumblrbot.posts "foo.bar.com"
      network = nock("http://api.tumblr.com")
        .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}&limit=1")
    it "complains about bad response", (done) ->
      network.reply 401,
        meta: { status: 401, msg: "Not Authorized" }
        response: []
      mock_robot.onError = (msg) ->
        assert.ok /not authorized/i.exec msg
        done()
      @t.last never_called
    it "complains about client errors", (done) ->
      http = @t.tumblr
      http._old_posts = http.posts
      http.posts = (_..., cb) ->
        cb new Error "Kablooie!"
      mock_robot.onError = (msg) ->
        assert.ok /kablooie/i.exec msg
        done()
      @t.last never_called
      http.posts = http._old_posts

    describe "without robot given", ->
      unattached_t = null
      before ->
        unattached_tumblr = require("..")
        unattached_t = unattached_tumblr.posts "foo.bar.com"
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
        unattached_t.last never_called
