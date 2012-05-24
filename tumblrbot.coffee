Tumblr = require("tumblr").Tumblr
util = require "util"

class TumblrBot
  constructor: (@domain, @logger) ->
    @tumblr = new Tumblr @domain, process.env.HUBOT_TUMBLR_API_KEY

  random: (options, cb) ->
    #TODO duplication
    [ options, cb ] = [ null, options] unless cb?
    options ?= {}
    @last options, (data) =>
      total_posts = data.total_posts
      offset = Math.round((total_posts - 1) * Math.random())
      options.offset = offset
      @one options, cb

  last: (number, options, cb) ->
    switch typeof number
      when "function"
        [ number, options, cb ] = [ null, null, number ]
      when "object"
        [ number, options, cb ] = [ null, number, options ]
      else
        [ options, cb ] = [ null, options] unless cb?

    number ?= 1
    options ?= {}
    options.limit ?= number

    @tumblr["posts"] options, (err, response) =>
      if err?
        @logger.error err
      else
        cb response

  one: (options, cb) ->
    [ options, cb ] = [ null, options] unless cb?
    @last 1, options, (data) ->
      cb data.posts?[0]

module.exports = tumblrbot = (robot) ->
  posts: (domain) ->
    new TumblrBot domain, robot.logger

tumblrbot[method] = func for method,func of TumblrBot.prototype

tumblrbot.logger = {
  error: (msg) ->
    util.error "ERROR: #{msg}"
  debug: ->
}
