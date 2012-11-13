
module.exports = (ob, done) ->
  if not ob.$
    return done null, ob

  console.log "setting favicon"

  ob.$('head link').each (index, value) ->
    if value.href.match(/favicon/)
      ob.faviconUrl = value.href

  done null, ob
