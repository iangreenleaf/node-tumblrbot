Tumblr = require("tumblr").Tumblr

class TumblrBot
  constructor: (@logger) ->

  domain: (@domain) ->
    @tumblr = new Tumblr @domain, process.env.HUBOT_TUMBLR_API_KEY
    @

  random: (type="posts", options={}) ->
    @request
    tumblr[type] options, (error, response) ->

  request: (type, options, cb) ->
    unless options? or cb?
      cb = type
      type = "posts"
      options = {}
    else if not cb?
      cb = options
      options = {}

    @tumblr[type] options, (err, response) =>
      if err?
        @logger.error err
      else
        cb response

module.exports = tumblrbot = (robot) ->
  new TumblrBot robot.logger

tumblrbot[method] = func for method,func of TumblrBot.prototype

tumblrbot.logger = {
  error: (msg) ->
    util = require "util"
    util.error "ERROR: #{msg}"
  debug: ->
}
