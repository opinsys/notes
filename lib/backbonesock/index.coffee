
sockjs = require "sockjs"


class Room

  constructor: ->
    @_members = []
    @_items = []

  has: (item) ->
    @_members.indexOf(item) isnt -1

  others: (me, fn) ->
    @_members.forEach (member) ->
      fn member if member isnt me

  each: (fn) ->
    @_items.forEach(fn)

  join: (item) ->
    if not @has(item)
      @_members.push item
    item

  add: (item) ->
    @_items.push item

  update: (attributes) ->
    for current in @_items
      if current.id and current.id is attributes.id
        for k, v of attributes
          current[k] = v



class RoomManager

  constructor: ->
    @_rooms = {}

  ensureRoom: (name) ->
    @_rooms[name] ?= new Room

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

      room.each (attributes) ->
        console.log "Sending init create", attributes, msg.room
        conn.write JSON.stringify
          room: msg.room
          method: "create"
          attributes: attributes

      conn.write JSON.stringify
        room: msg.room
        method: "initdone"

    create: (conn, msg) ->
      room = rooms.get(msg.room)
      room.add(msg.attributes)
      console.log "Sending create", msg
      room.others conn, (other) ->
        other.write JSON.stringify msg

    update: (conn, msg) ->
      room = rooms.get(msg.room)
      console.log "Sending update", msg
      room.others conn, (other) ->
        other.write JSON.stringify msg
      room.update(msg.attributes)


  sjsServer.on "connection", (conn) ->

    conn.on "data", (data) ->
      msg = JSON.parse data

      if not msg.room
        console.error "Room missing from", msg
        return

      console.log "got", msg
      handlers[msg.method]?(conn, msg)

module.exports = sync
