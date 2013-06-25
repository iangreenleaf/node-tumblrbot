# A Hubot-compatible Tumblr API wrapper for Node.js #

[![Build Status]](http://travis-ci.org/iangreenleaf/tumblrbot)

Tumblrbot is a simple API client for Tumblr.

It's useful in Hubot scripts. Here are a couple examples: [pizza.coffee] and [gifsanity.coffee].

It's also perfectly usable in any other Node environment. I'd love to hear how you end up using it.

## Install ##

    npm install tumblrbot

## Require ##

Use it in your Hubot script:

```coffeescript
module.exports = (robot) ->
  tumblr = require('tumblrbot')(robot)
```

Or use it on its own:

```coffeescript
tumblr = require('tumblrbot')
```

## Use ##

```coffeescript
# Get the latest 3 posts
tumblr.posts("funblog.tumblr.com").last 3, (data) ->
  console.log post.title for post in data.posts
```

The following options are available to help you filter by post type:
`posts`, `text`, `quote`, `link`, `answer`, `video`, `audio`, `photo`.

```coffeescript
# Get the most recent video post
tumblr.video("funblog.tumblr.com").last (data) ->
  console.log data.posts[0].title

# Or use the plural form (it's just an alias)
tumblr.videos("funblog.tumblr.com").last (data) ->
  console.log data.posts[0].title

# Or get it without the array
tumblr.video("funblog.tumblr.com").one (post) ->
  console.log post.title
```

You can pass any options specified in the [Tumblr API]:

```coffeescript
tumblr.posts("funblog.tumblr.com").last 2, { tag: "potatoes" }, (data) ->
  console.log post.title for post in data.posts
```

Get a random photo post:

```coffeescript
tumblr.photo("funblog.tumblr.com").random (post) ->
  console.log post.photos[0].original_size.url
```

## Authentication ##

If `process.env.HUBOT_TUMBLR_API_KEY` is present, you're automatically authenticated. Sweet!

For many requests, it's enough for this to be the OAuth Consumer Key for your app - no need to
go through the whole authorization process.

## Helpful Hubot ##

Hubot will log errors if a request fails.

[Tumblr API]: http://www.tumblr.com/docs/en/api/v2
[Build Status]: https://secure.travis-ci.org/iangreenleaf/tumblrbot.png?branch=master
[pizza.coffee]: https://github.com/github/hubot-scripts/blob/6ee1c78caaefdedbfeba78c8baf223745b2fa4da/src/scripts/pizza.coffee
[gifsanity.coffee]: https://github.com/github/hubot-scripts/blob/edb4d78683c56bc571cd12d64af1ec796d8536c2/src/scripts/gifsanity.coffee
