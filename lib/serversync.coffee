
sockjs = require "sockjs"

class Room

  constructor: ->
    @members = []
    @docs = []

  has: (item) ->
    @members.indexOf(item) isnt -1

  others: (me, fn) ->
    @members.forEach (member) ->
      fn member if member isnt me

  add: (item) ->
    if not @has(item)
      @members.push item
    item

  addDoc: (doc) ->
    @docs.push doc

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
      room.add(conn)
      for doc in room.docs
        conn.write JSON.stringify doc
      conn.write JSON.stringify
        room: msg.room
        cmd: "initdone"

    add: (conn, msg) ->
      room = rooms.get(msg.room)
      room.addDoc(msg)
      room.others conn, (other) ->
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
