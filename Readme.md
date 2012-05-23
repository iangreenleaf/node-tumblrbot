# A Hubot-compatible Tumblr API wrapper for Node.js #

[![Build Status]](http://travis-ci.org/iangreenleaf/tumblrbot)

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

Make requests against the [Tumblr API] and receive the `response` object:

```coffeescript
tumblr.domain("funblog.tumblr.com").request "photos", limit: 3, (data) ->
  console.log post.title for post in data.posts
```

Get a random photo post:

```coffeescript
tumblr.domain("funblog.tumblr.com").random "photos", (post) ->
  console.log post.photos[0].original_size.url
```

## Authentication ##

If `process.env.HUBOT_TUMBLR_API_KEY` is present, you're automatically authenticated. Sweet!

## Helpful Hubot ##

Hubot will log errors if a request fails.

[Tumblr API]: http://www.tumblr.com/docs/en/api/v2
[Build Status]: https://secure.travis-ci.org/iangreenleaf/tumblrbot.png?branch=master
