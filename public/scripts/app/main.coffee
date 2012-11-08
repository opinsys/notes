define [
  "jquery"
  "backbone"
  "uri"

  "cs!app/views/timeline"


  "cs!app/models/timeline.collection"
  "cs!app/utils/unwraperr"
], (
  $
  Backbone
  uri

  Timeline
  TimelineCollection
  unwraperr
)-> -> $ ->

  $(".loading").remove()
  url = uri.parse(window.location.href)
  id = url.path.match(/\/notes\/(.+)$/)?[1]
  if not id
    throw new Error "Bad url"

  metaCollection = new Backbone.SharedCollection [],
    collectionId: id + "meta"

  window.timeline = new TimelineCollection [],
    collectionId: id

  sharejs.open "notes", "json", unwraperr (err, doc) ->

    throw err if err

    timeline.setDoc(doc)
  

    metaCollection.setDoc(doc)

    metaCollection.fetch
      error: (err) ->
        console.log "ERROR", err

      success: ->
        if not metaModel = metaCollection.get "meta"
          metaModel = new Backbone.Model
            name: "Notes"
            id: "meta"
          metaCollection.add metaModel

        timeline.fetch
          error: (err) ->
            console.log "ERROR", err
    
          success: ->
            console.log "Connected sharejs!"
    
            view = new Timeline
              collection: timeline
              model: metaModel
            view.render()
            $("body").append view.el
            

