fs = require "fs"
uuid = require "node-uuid"

class exports.Image

  imageDir = "./upload/"

  @hello: ->
    "Hello World!"

  @get: (req, res, next) ->
    res.send "OK"

  @post: (req, res, next) ->
    image = req.files.image
    imageId = uuid.v4()

    fs.readFile image.path, (err, data) ->
      return next err if err
      newPath = imageDir + imageId
      fs.writeFile newPath, data, (err) ->
        return next err if err
        res.json imageId: imageId
