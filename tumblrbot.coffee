Tumblr = require("tumblr").Tumblr
util = require "util"

class TumblrBot
  constructor: (@logger) ->

  domain: (@domain) ->
    @tumblr = new Tumblr @domain, process.env.HUBOT_TUMBLR_API_KEY
    @

  random: (type="posts", options={}) ->
    @request
    tumblr[type] options, (error, response) ->

  request: (type, options, cb) ->
    switch typeof type
      when "function"
        [ type, options, cb ] = [ null, null, type ]
      when "object"
        [ type, options, cb ] = [ null, type, options ]
      else
        [ options, cb ] = [ null, options] unless cb?

    type ?= "posts"
    options ?= {}

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
    util.error "ERROR: #{msg}"
  debug: ->
}
