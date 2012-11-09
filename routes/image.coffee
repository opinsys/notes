fs = require "fs"
path = require "path"

async = require "async"
uuid = require "node-uuid"
gm = require "gm"
filed = require "filed"

resize = require "../lib/resize"

imageDir = path.join(__dirname,  "/../upload/")

module.exports =

  get: (req, res, next) ->
    imageId = req.params.imageId
    filed(path.join imageDir, imageId).pipe(res)

  post: (req, res, next) ->
    image = req.files.image
    imageId = uuid.v4()

    newFilePath = imageDir + imageId
    formats = [
        max: 1000
        suffix: "_full"
      ,
        max: 400
        suffix: ""
      ,
        max: 100
        suffix: "_thumb"
    ]

    resize image.path, formats, imageDir, (err, imageId) ->
      return next err if err
      res.json imageId: imageId


