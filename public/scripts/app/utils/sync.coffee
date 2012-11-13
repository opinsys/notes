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

  sockjsEmitter = _.extend({}, Backbone.Events)
  sockPromise = do ->
    dfd = $.Deferred()

    sock = new SockJS "/sockjs_sync"

    sock.onopen = ->
      dfd.resolve(sock)
      console.log "SockJS connected"

    sock.onmessage = (e) ->
      msg = JSON.parse e.data
      console.log "got sockjs message", msg
      if not msg.room
        return console.error "room missing from", msg
      if not msg.cmd
        return console.error "cmd missing from", msg

      sockjsEmitter.trigger(
        (msg.room + ":" + msg.cmd),
        _.omit(msg, "cmd", "room")
      )

    return dfd.promise()

  syncCollection = (id, coll) ->
    sockPromise.done (sock) ->

      sock.send JSON.stringify
        cmd: "join"
        room: id

      sockjsEmitter.on "#{ id }:add", (msg) ->
        model = new coll.model msg.model
        model.synced = true
        coll.add model

      sockjsEmitter.on "#{ id }:change", (msg) ->
        console.log "cool, i should update", msg

        if model = coll.get(msg.model.id)
          model.set msg.model, local: true
        else
          console.warn "Cannot update model. id not found:", msg


      sockjsEmitter.on "#{ id }:initdone", ->
        coll.trigger "initdone"

      coll.on "change", (model, options) ->
        # If model is not yet synced there is nothing to update on remotes
        if not model.synced
          return

        if options.local
          return console.log "local update, skipping send"

        sock.send JSON.stringify
          cmd: "change"
          room: id
          model: _.extend(
            {id: model.id},
            model.changedAttributes()
          )

      coll.on "add", (model) ->
        if not model.id
          model.set id: uuid()

        if model.synced
          return

        model.synced = true
        sock.send JSON.stringify
          cmd: "add"
          room: id
          model: model.toJSON()

  syncModel = (id, model) ->
    coll = new Backbone.Collection
    coll.on "initdone", ->

      if remoteModel = coll.get(model.id)
        remoteModel.on "change", ->
          model.set remoteModel.toJSON()
        model.on "change", ->
          remoteModel.set model.toJSON()
      else
        coll.add model

    syncCollection(id, coll)

  return {
    collection: syncCollection
    model: syncModel
  }
