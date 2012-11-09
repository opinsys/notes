path = require "path"
memoize = require("memoize")
getLinkPreview = require("../lib/linkpreview")(path.join __dirname, "../upload")
getLinkPreview = memoize getLinkPreview, async: true

module.exports = (req, res, next) ->
  getLinkPreview req.body.url, (err, info) ->
    next err if err
    res.send info
