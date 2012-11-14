define [
  "jquery"
  "underscore"
  "backbone"
  "sockjs"
  "cs!backbone.sharedcollection"
  "cs!app/utils/unwraperr"
], (
  $
  _
  Backbone
  SockJS
  SharedCollection
  unwraperr
) ->

  uuid = -> (((1 + Math.random()) * 65536) | 0).toString(16).substring(1)

  addSync = (id, model, sock) ->
    _.extend model, {
      isNew: -> !@_synced

      sync: (method, model, options) ->
        attributes = {}

        if method is "create"
          model.set "id", uuid() if not model.id
          _.extend(attributes, model.toJSON())
          console.log "Creating", model.toJSON()

        else if method is "update"
          current = model.toJSON()
          for k, v of model._synced
            if not _.isEqual(model._synced[k], current[k])
              attributes[k] = current[k]
          attributes.id = model.id
          console.log "Updating", current, "with", attributes

        else
          throw new Error "unknown method #{ method }"

        if _.isEmpty _.omit(attributes, "id")
          console.log "No changes, Skipping update from save()"
          return

        sock.send m =  JSON.stringify
          method: method
          room: id
          attributes: attributes
        console.log "send", m
        model._synced = model.toJSON()
        options.success?()
      }



  sockjsEmitter = _.extend({}, Backbone.Events)
  sock = new SockJS "/sockjs_sync"
  dfd = $.Deferred()
  sockPromise = dfd.promise()

  sock.onopen = (foo, bar) ->
    dfd.resolve(sock)
    console.log "SockJS connected"

  sock.onclose = (e) ->
    console.log "SockJS disconnected", e
    dfd.reject e

  sock.onmessage = (e) ->
    msg = JSON.parse e.data
    if not msg.room
      return console.error "room missing from", msg
    if not msg.method
      return console.error "method missing from", msg

    console.log "Got", msg
    sockjsEmitter.trigger(
      (msg.method + ":" + msg.room),
      msg.attributes
    )


  sockPromise.fail ->
    alert "Pahoittelut, mutta selaimesi ei pysty yhdistämään palvelimeen."


  syncCollection = (id, coll) ->

    sockPromise.done (sock) ->

      coll.each (model) -> addSync(id, model, sock)
      coll.on "add", (model) -> addSync(id, model, sock)

      sock.send JSON.stringify
        method: "join"
        room: id

      sockjsEmitter.on "create:#{ id }", (attributes) ->
        console.log "got create event", attributes

        if current = coll.get(attributes.id)
          console.log "populating existing model with create", attributes
          current.clear(silent: true)
          current.set attributes
          return

        coll.add new coll.model attributes

      sockjsEmitter.on "update:#{ id }", (attributes) ->

        if model = coll.get(attributes.id)
          model.set attributes
        else
          console.warn "Cannot update model. id not found:", attributes

      sockjsEmitter.on "#{ id }:initdone", ->
        console.log "INIT DONE #{ id }"
        coll.trigger "initdone"


  syncModel = (id, model) ->
    coll = new Backbone.Collection
    coll.add model
    syncCollection(id, coll)

  return {
    collection: syncCollection
    model: syncModel
  }
