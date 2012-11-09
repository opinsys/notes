
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
      require("./image")(imageDir)
    ], (err, ob) ->
      return done err if err
      result = {}
      for k, v of ob when k[0] isnt "_"
        result[k] = v
      done null, result



if require.main is module
  getLinkPreview "http://opinsys.fi", (err, ob) ->
    console.log "DONE", err, ob.title

  getLinkPreview "https://www.jyu.fi/spinner.gif", (err, ob) ->
    console.log "DONE", err, ob.image

