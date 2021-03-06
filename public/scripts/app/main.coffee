define [
  "jquery"
  "backbone"
  "uri"

  "cs!app/notes"
  "cs!app/views/notes-layout"
  "cs!app/models/timeline.collection"
  "cs!app/utils/sync"
  "cs!app/utils/unwraperr"
], (
  $
  Backbone
  uri

  Notes
  NotesLayout
  TimelineCollection
  sync
  unwraperr
)-> -> $ ->


  Notes.global.set "loading", "models"
  $(".loading").remove()

  url = uri.parse(window.location.href)
  NOTES_ID = url.path.match(/\/notes\/(.+)$/)?[1]
  if not NOTES_ID
    throw new Error "Bad url"

  window.timeline = new TimelineCollection
  timeline.on "initdone", ->
    Notes.global.set "loading", null

  metaModel = new Backbone.Model
    name: "Muistio"
    id: "meta"

  view = new NotesLayout
    collection: timeline
    model: metaModel

  view.render()
  $("body").append(view.el)

  sync.collection("items:" + NOTES_ID, timeline)
  sync.model("meta:" + NOTES_ID, metaModel)

