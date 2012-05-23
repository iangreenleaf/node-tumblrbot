Tumblr = require("tumblr").Tumblr
util = require "util"

class TumblrBot
  constructor: (@logger) ->

  domain: (@domain) ->
    @tumblr = new Tumblr @domain, process.env.HUBOT_TUMBLR_API_KEY
    @

  random: (type, options, cb) ->
    #TODO duplication
    switch typeof type
      when "function"
        [ type, options, cb ] = [ null, null, type ]
      when "object"
        [ type, options, cb ] = [ null, type, options ]
      else
        [ options, cb ] = [ null, options] unless cb?
    type ?= "posts"
    options ?= {}
    options.limit ?= 1
    @request type, options, (data) =>
      total_posts = data.total_posts
      offset = Math.round((total_posts - 1) * Math.random())
      options.offset = offset
      @request type, options, (data) ->
        cb data.posts[0]

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
