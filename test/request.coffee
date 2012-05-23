[ tumblrbot, assert, nock, mock_robot ] = require "./test_helper"
process.env.HUBOT_TUMBLR_API_KEY = apiKey = "789abc"
t = tumblrbot.domain "foo.bar.com"

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
        network = nock("http://api.tumblr.com")
          .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}")
          .reply(200, response)
      it "fires", (done) ->
        t.request success done
      it "returns data", (done) ->
        t.request (data) ->
          assert.deepEqual response.response, data
          done()

  describe "errors", ->
    network = null
    never_called = ->
      assert.fail(null, null, "Success callback should not be invoked")
    beforeEach ->
      network = nock("http://api.tumblr.com")
        .get("/v2/blog/foo.bar.com/posts?api_key=#{apiKey}")
    it "complains about bad response", (done) ->
      network.reply(401, message: "Bad credentials")
      mock_robot.onError = (msg) ->
        assert.ok /bad credentials/i.exec msg
        done()
      t.request never_called
    it "complains about client errors", (done) ->
      return
      mock = {
        header: -> mock,
        get: () -> (cb) ->
          cb new Error "Kablooie!"
      }
      http = require "scoped-http-client"
      http._old_create = http.create
      http.create = -> mock
      mock_robot.onError = (msg) ->
        assert.ok /kablooie/i.exec msg
        done()
      t.request never_called
      http.create = http._old_create

    describe "without robot given", ->
      before ->
        gh = require("..")
      it "complains to stderr", (done) ->
        util = require "util"
        util._old_error = util.error
        util.error = (msg) ->
          if msg.match /bad credentials/i
            util.error = util._old_error
            done()
          else
            @_old_error.call process.stderr, msg
        network.reply(401, message: "Bad credentials")
        t.request never_called
