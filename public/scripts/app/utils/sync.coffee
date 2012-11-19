define [
  "jquery"
  "underscore"
  "backbone"
  "sockjs"
  "cs!app/utils/unwraperr"
], (
  $
  _
  Backbone
  SockJS
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

        else if method is "update"
          current = model.toJSON()
          for k, v of model._synced
            if not _.isEqual(model._synced[k], current[k])
              attributes[k] = current[k]
          attributes.id = model.id

        else
          throw new Error "unknown method #{ method }"

        if _.isEmpty _.omit(attributes, "id")
          console.log "No changes, Skipping update from save()"
          return

        sock.send JSON.stringify
          method: method
          room: id
          attributes: attributes
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

        if current = coll.get(attributes.id)
          current.clear(silent: true)
          current.set attributes
          current._synced = current.toJSON()
          return

        model = new coll.model attributes
        model._synced = model.toJSON()
        coll.add model

      sockjsEmitter.on "update:#{ id }", (attributes) ->

        if model = coll.get(attributes.id)
          model.set attributes
        else
          console.warn "Cannot update model. id not found:", attributes

      sockjsEmitter.on "initdone:#{ id }", ->
        coll.trigger "initdone"


  syncModel = (id, model) ->
    coll = new Backbone.Collection
    coll.add model
    syncCollection(id, coll)

  return {
    collection: syncCollection
    model: syncModel
  }
