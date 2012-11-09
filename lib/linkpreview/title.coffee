
module.exports = (ob, done) ->
  if not ob.$
    return done null, ob

  console.log "setting title"

  ob.title = ob.$("title").text()
  done null, ob
