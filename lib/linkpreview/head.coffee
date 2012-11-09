
request = require "request"

module.exports = (ob, done) ->

  console.log "setting headers"

  request.head ob.url, (err, res) ->
    return done err if err

    if res?.statusCode is 200
      ob._res = res
      ob.headers = res.headers
      ob.mime = ob._res.headers["content-type"].split(";")[0].trim()
      console.log "headers set"
      return done null,  ob

    return done new Error "request failed on: #{ ob.url }"


