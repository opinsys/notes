fs = require "fs"
uuid = require "node-uuid"

imageDir = __dirname + "../upload/"

module.exports =

  get: (req, res, next) ->
    imageId = req.params.imageId

    stream = fs.createReadStream imageDir + imageId
    stream.pipe(res)

  post: (req, res, next) ->
    image = req.files.image
    imageId = uuid.v4()

    fs.readFile image.path, (err, data) ->
      return next err if err
      newPath = imageDir + imageId
      fs.writeFile newPath, data, (err) ->
        return next err if err
        res.json imageId: imageId
