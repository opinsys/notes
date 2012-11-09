scraper = require('scraper');
linkPreviewData = {}

getLinkPreview = (url, cb) ->

  if linkPreviewData[url]
    console.log "Use cache"
    return cb null, linkPreviewData[url]

  info = {}

  scraper url, (err, jQuery) ->
    console.log "Get page source"
    throw err if err
    info["title"] = jQuery('title').html()
    info["url"] = url
    linkPreviewData[url] = info
    return cb null, info

module.exports = getLinkPreview
