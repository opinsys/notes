
request = require "request"

module.exports = (ob, done) ->

  console.log "setting headers"

  request.head ob.url, (err, res) ->
    return done err if err

    if res?.headers["content-type"]
      ob._res = res
      ob.headers = res.headers
      ob.mime = ob._res.headers["content-type"].split(";")[0].trim()
      console.log "headers set"
      return done null,  ob

    return done new Error "cannot find content-type for #{ ob.url }"


