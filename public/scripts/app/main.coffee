define [
  "jquery"
  "backbone"
  "uri"

  "cs!app/views/timeline"
  "cs!app/models/timeline_collection"
  "cs!app/utils/unwraperr"
], (
  $
  Backbone
  uri

  Timeline
  TimelineCollection
  unwraperr
)-> -> $ ->

  url = uri.parse(window.location.href)
  id = url.path.match(/\/notes\/(.+)$/)?[1]
  if not id
    throw new Error "Bad url"

  window.timeline = new TimelineCollection [],
    collectionId: id

  view = new Timeline
    collection: timeline


  sharejs.open "notes", "json", unwraperr (err, doc) ->

    throw err if err

    timeline.setDoc(doc)

    timeline.fetch
      error: (err) ->
        console.log "ERER", err

      success: (foo) ->
        console.log "Connected sharejs!", foo

  view.render()
  $("body").append view.el


