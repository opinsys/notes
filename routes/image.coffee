fs = require "fs"
uuid = require "node-uuid"

module.exports = (req, res, next) ->
  image = req.files.image
  imageId = uuid.v4()

  fs.readFile image.path, (err, data) ->
    return next err if err
    newPath = "./upload/" + imageId
    fs.writeFile newPath, data, (err) ->
      return next err if err
      res.json imageId: imageId
    