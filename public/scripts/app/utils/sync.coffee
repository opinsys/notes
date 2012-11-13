define [
  "jquery"
  "cs!backbone.sharedcollection"
  "cs!app/utils/unwraperr"
], (
  $
  SharedCollection
  unwraperr
) ->

  shareJSDoc = do ->
    dfd = new $.Deferred()
    sharejs.open "notes", "json", unwraperr (err, doc) ->
      if err
        dfd.reject err
      else
        dfd.resolve doc
    return dfd.promise()


  return {
    collection: (id, coll) ->
      shareJSDoc.done (doc) ->
        coll.collectionId(id)
        coll.setDoc(doc)
        coll.fetch
          error: -> alert "failed to fetch collection data from ShareJS"

      shareJSDoc.fail -> alert "failed to connect to ShareJS"

    model: (id, model) ->
      shareJSDoc.done (doc) ->
        syncColl = new SharedCollection
        syncColl.collectionId(id)
        syncColl.setDoc(doc)
        syncColl.fetch
          error: -> alert "failed to fetch model data from ShareJS"
          success: ->
            if syncModel = syncColl.get(model.id)
              model.set syncModel.toJSON()
              syncModel.on "change", ->
                model.set syncModel.toJSON()
            else
              syncColl.add model
  }

