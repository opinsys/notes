path = require "path"

getLinkPreview = require("../lib/linkpreview")(path.join __dirname, "../upload")

module.exports = (req, res, next) ->
  getLinkPreview req.body.url, (err, info) ->
    next err if err
    res.send info
