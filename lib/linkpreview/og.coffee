
module.exports = (ob, done) ->
  if not ob.$
    return done null, ob

  console.log "setting og"

  ob.og = {}

  ob.$('meta[property^=og]').each (i, el) ->
    key = el.getAttribute('property').match(/^og:(.+)/)[1]
    ob.og[key] = el.getAttribute('content')

  
  done null, ob
