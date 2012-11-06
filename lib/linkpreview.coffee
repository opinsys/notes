scraper = require('scraper');

getLinkPreview = (url, cb) ->
  info = {}

  scraper url, (err, jQuery) ->
    throw err if err
    info["title"] = jQuery('title').html()
    return cb null, info

module.exports = getLinkPreview
