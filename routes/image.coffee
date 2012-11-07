fs = require "fs"
uuid = require "node-uuid"
gm = require "gm"

imageDir = __dirname + "/../upload/"

module.exports =

  get: (req, res, next) ->
    imageId = req.params.imageId

    stream = fs.createReadStream imageDir + imageId
    stream.pipe(res)

  post: (req, res, next) ->
    image = req.files.image
    imageId = uuid.v4()

    newFilePath = imageDir + imageId
    console.log newFilePath

    gm(image.path)
    .resize(1000, 1000)
    .write newFilePath + "_full", (err) ->
      return next err if err

    gm(image.path).thumb(50, 50, newFilePath + "_thumb", 90)

    gm(image.path)
    .resize(400, 400)
    .write newFilePath, (err) ->
      return next err if err
      res.json imageId: imageId

      
