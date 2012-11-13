request = require "request"
  
module.exports = (ob, done) ->
  if not ob.$
    return done null, ob

  if not ob.url.match(/^http:\/\/www.youtube.com/)
    return done null, ob

  console.log "setting youtube"

  embed = ob.$('head link[type="application/json+oembed"]')

  if not embed.attr("href")
    return done null, ob

  request embed.attr("href"), (err, res) ->
    ob.youtube = JSON.parse res.body
    done null, ob
