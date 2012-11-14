
Mongolian = require("mongolian")
_  = require "underscore"


server = new Mongolian
db = server.db("notes")
models = db.collection("backbonemodels")

module.exports = (config) ->

  docId = (attributes) -> "#{config.room}:#{ attributes.id }"

  return {

    create: (attributes, cb) ->
      doc =
        _id: docId(attributes)
        room: config.room
        attributes: attributes
      models.insert doc, cb

    each: (fn, cb) ->
      models.find({ room: config.room }).forEach (doc) ->
        fn doc.attributes
      , cb

    update: (attributes, cb) ->

      update = $set: {}
      for k, v of attributes
        update.$set["attributes.#{ k }"] = v

      models.findAndModify
        query:
          _id: docId(attributes)
        update: update
      , cb


  }
