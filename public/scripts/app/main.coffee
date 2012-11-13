define [
  "jquery"
  "backbone"
  "uri"
  "cs!backbone.sharedcollection"

  "cs!app/views/notes-layout"
  "cs!app/models/timeline.collection"
  "cs!app/utils/sync"
  "cs!app/utils/unwraperr"
], (
  $
  Backbone
  uri
  SharedCollection

  NotesLayout
  TimelineCollection
  sync
  unwraperr
)-> -> $ ->

  $(".loading").remove()

  url = uri.parse(window.location.href)
  NOTES_ID = url.path.match(/\/notes\/(.+)$/)?[1]
  if not NOTES_ID
    throw new Error "Bad url"

  window.timeline = new TimelineCollection

  metaModel = new Backbone.Model
    name: "Muistio"
    id: "meta"

  view = new NotesLayout
    collection: timeline
    model: metaModel

  view.render()
  $("body").append(view.el)

  sync.collection(NOTES_ID, timeline)
  sync.model("meta" + NOTES_ID, metaModel)

