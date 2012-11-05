define [
  "jquery"
  "backbone"
  "cs!app/views/timeline"
  "cs!app/models/timeline_collection"
  "cs!app/utils/unwraperr"
], (
  $
  Backbone
  Timeline
  TimelineCollection
  unwraperr
)->

  window.timeline = new TimelineCollection [],
    collectionId: "main"

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


