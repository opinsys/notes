
path = require "path"

uuid = require "node-uuid"
gm = require "gm"
async = require "async"


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

module.exports = (sourceImagePath, formats, targetDir, done) ->

  imageId = uuid.v4()

  newFilePath = path.join targetDir, imageId

  gm(sourceImagePath).size (err, size) ->
    return done err if err

    # https://github.com/caolan/async#forEach
    async.forEach formats, (opts, cb) ->
      opts.suffix ?= ""

      downScaled = downScale(size, opts.max)
      gm(sourceImagePath).resize(
        downScaled.width
        downScaled.height
      ).autoOrient().write(newFilePath + opts.suffix + ".jpg", cb)

    , (err) ->
      return done err if err
      done null, imageId

