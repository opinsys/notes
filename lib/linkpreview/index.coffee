
path = require "path"

async = require "async"


module.exports = (imageDir) ->
  return getLinkPreview = (url, done) ->
    async.waterfall [
      (cb) -> cb null, url: url
      require("./head")
      require("./html")
      require("./jquery")
      require("./title")
      require("./favicon")
      require("./og")
      require("./image")(imageDir)
    ], (err, ob) ->
      return done err if err
      result = {}
      for k, v of ob when k[0] isnt "_"
        result[k] = v
      done null, result



if require.main is module
  getLinkPreview = require("../linkpreview")(path.join __dirname, "../../upload")

  getLinkPreview "http://opinsys.fi", (err, ob) ->
    console.log "DONE", err, ob.title

  getLinkPreview "https://www.jyu.fi/spinner.gif", (err, ob) ->
    console.log "DONE", err, ob.image

  getLinkPreview "http://www.yle.fi", (err, ob) ->
    console.log "DONE", err, ob.faviconUrl

  getLinkPreview "http://asdf.asdf", (err, ob) ->
    console.log "DONE", err

  getLinkPreview "http://www.yle.fi/uutiset", (err, ob) ->
    console.log "DONE", err, ob.og
