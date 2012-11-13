
sockjs = require "sockjs"

class Room

  constructor: ->
    @members = []
    @models = []

  has: (item) ->
    @members.indexOf(item) isnt -1

  others: (me, fn) ->
    @members.forEach (member) ->
      fn member if member isnt me

  join: (item) ->
    if not @has(item)
      @members.push item
    item

  add: (model) ->
    @models.push model

  update: (changes) ->
    for current in @models
      if current.id and current.id is changes.id
        console.log "updating", current, "with", changes
        for k, v of changes
          current[k] = v


class RoomManager

  constructor: ->
    @rooms = {}

  ensureRoom: (name) ->
    @rooms[name] ?= new Room

  get: (name) -> @ensureRoom(name)


sync = (server, options) ->

  sjsServer = sockjs.createServer()
  sjsServer.installHandlers server,
    prefix: "/sockjs_sync"

  rooms = new RoomManager
  handlers =
    join: (conn, msg) ->
      room = rooms.get(msg.room)
      room.join(conn)

      for model in room.models
        console.log "sending", model
        conn.write JSON.stringify
          room: msg.room
          cmd: "add"
          model: model

      conn.write JSON.stringify
        room: msg.room
        cmd: "initdone"

    add: (conn, msg) ->
      room = rooms.get(msg.room)
      room.add(msg.model)
      room.others conn, (other) ->
        other.write JSON.stringify msg

    change: (conn, msg) ->
      room = rooms.get(msg.room)
      room.others conn, (other) ->
        other.write JSON.stringify msg
      room.update(msg.model)

    broadcast: ->

  sjsServer.on "connection", (conn) ->

    conn.on "data", (data) ->
      msg = JSON.parse data

      if not msg.room
        console.error "Room missing from", msg
        return

      handlers[msg.cmd]?(conn, msg)

module.exports = sync
