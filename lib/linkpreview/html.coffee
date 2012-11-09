
request = require "request"


module.exports = (ob, done) ->

  if not ob._res.headers
    return done null, ob

  if ob.mime isnt "text/html"
    return done null, ob

  request.get ob.url, (err, res, html) ->
    return done err if err
    ob.html = html
    done null, ob

