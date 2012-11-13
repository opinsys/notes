
sockjs = require "sockjs"

class Room

  constructor: ->
    @members = []

  has: (item) ->
    @members.indexOf(item) isnt -1

  others: (me, fn) ->
    @members.forEach (member) ->
      fn member if member isnt me

  add: (item) ->
    if not @has(item)
      @members.push item
    item

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
      room.add conn

    add: (conn, msg) ->
      room = rooms.get(msg.room)
      console.log "sending to", msg.room, room.members.length - 1
      room.others conn, (other) ->
        console.log "send"
        other.write JSON.stringify msg

    broadcast: ->

  sjsServer.on "connection", (conn) ->

    conn.on "data", (data) ->
      msg = JSON.parse data
      console.log "got msg", msg

      if not msg.room
        console.error "Room missing from", msg
        return

      handlers[msg.cmd]?(conn, msg)



module.exports = sync
