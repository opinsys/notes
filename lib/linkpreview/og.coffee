
module.exports = (ob, done) ->
  if not ob.$
    return done null, ob

  console.log "setting og"

  ob.og = {}

  ob.$('meta[property^=og]').each (i, el) ->
    ob.og[el.getAttribute('property')] = el.getAttribute('content')

  
  done null, ob
