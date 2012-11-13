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
        console.log "cool, i should add", msg
        model = new coll.model msg.model
        model.synced = true
        coll.add model

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


  return {
    collection: syncCollection
    model: (id, model) ->
  }
