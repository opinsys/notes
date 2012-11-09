fs = require "fs"
path = require "path"

async = require "async"
uuid = require "node-uuid"
gm = require "gm"
filed = require "filed"


imageDir = path.join(__dirname,  "/../upload/")

downScale = ({width, height}, maxWidth) ->
  if width < maxWidth and height < maxWidth
    height = height
    width = width
  else if width > height
    scale = maxWidth / width
    width = maxWidth
    height = height * scale
  else
    scale = maxWidth / height
    height = maxWidth
    width = width * scale

  return {
    width: width
    height: height
  }

module.exports =

  get: (req, res, next) ->
    imageId = req.params.imageId
    filed(path.join imageDir, imageId).pipe(res)

  post: (req, res, next) ->
    image = req.files.image
    imageId = uuid.v4()

    newFilePath = imageDir + imageId

    gm(image.path).size (err, size) ->
      return next err if err

      # https://github.com/caolan/async#forEach
      async.forEach [
        max: 1000
        suffix: "_full"
      ,
        max: 400
        suffix: ""
      ,
        max: 50
        suffix: "_thumb"
      ], (opts, cb) ->

        downScaled = downScale(size, opts.max)
        gm(image.path).resize(
          downScaled.width
          downScaled.height
        ).write(newFilePath + opts.suffix, cb)

      , (err) ->
        return next err if err
        res.json imageId: imageId


