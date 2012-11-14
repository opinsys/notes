
sockjs = require "sockjs"
_  = require "underscore"


class Room

  notImplemented = -> throw new Error "backend does not implement this method"

  constructor: ->
    @_members = []
    @_items = []

  has: (item) ->
    @_members.indexOf(item) isnt -1

  others: (me, fn) ->
    @_members.forEach (member) ->
      fn member if member isnt me


  join: (item) ->
    if not @has(item)
      @_members.push item
    item

  each: notImplemented
  create: notImplemented
  update: notImplemented



class RoomManager

  backend: require("./memory")

  constructor: ->
    @_rooms = {}

  ensureRoom: (name) ->
    if room = @_rooms[name]
      return room

    room = @_rooms[name] = new Room
    _.extend room, @backend(name: name)
    return room

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

      , (err) ->
        if err
          console.error "Failed to read db entries on join", err
          return

        conn.write JSON.stringify
          room: msg.room
          method: "initdone"


    create: (conn, msg) ->
      room = rooms.get(msg.room)
      room.create msg.attributes, (err) ->
        if err
          console.error "Failed to create db entry", err
          return

        room.others conn, (other) ->
          other.write JSON.stringify msg

    update: (conn, msg) ->
      room = rooms.get(msg.room)
      room.update msg.attributes, (err) ->
        if err
          console.error "Failed to update db entry", err
          return

        console.log "Sending update", msg
        room.others conn, (other) ->
          other.write JSON.stringify msg


  sjsServer.on "connection", (conn) ->

    conn.on "data", (data) ->
      msg = JSON.parse data

      if not msg.room
        console.error "Room missing from", msg
        return

      console.log "got", msg
      handlers[msg.method]?(conn, msg)

module.exports = sync
