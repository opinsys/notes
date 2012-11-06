getLinkPreview = require "../lib/linkpreview"

module.exports = (req, res) ->
  getLinkPreview req.body.url, (err, info) ->
    throw err if err
    res.send info
