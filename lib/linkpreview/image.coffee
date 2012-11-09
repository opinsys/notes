
path = require "path"

gm = require "gm"
filed = require "filed"
uuid = require "node-uuid"
request = require "request"

resize = require("../resize")

module.exports = (targetDir) -> (ob, done) ->

  if not ob.mime?.match /^image\/.+$/
    return done null, ob

  console.log "setting image"
  sourcePath = path.join targetDir, uuid.v4()

  fileStream = filed(sourcePath)
  request.get(ob.url).pipe(fileStream)

  fileStream.on "error", (err) -> done err
  fileStream.on "end", ->

    resize sourcePath, [
      max: 50
    ]
    , targetDir
    , (err, imageId) ->
      return done err if err

      # TODO: unlink orig

      console.log "image set", imageId
      ob.imageId = imageId
      return done null, ob
