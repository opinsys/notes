
http = require('http')
backboneio = require('backbone.io')
express = require "express"
stylus = require "stylus"
nib = require "nib"

app = express()

server = http.createServer(app)


backend = backboneio.createBackend()
backend.use(backboneio.middleware.memoryStore())

backboneio.listen server, mybackend: backend

app.set('view engine', 'hbs')

app.configure "development", ->

  compile = (str, path) ->
    stylus(str)
      .set("paths", [
        __dirname + "/public/styles"
      ]).use(nib())

  app.use stylus.middleware
    compile: compile
    src: __dirname + "/public"

app.use express.static __dirname + "/public"


app.get "/", (req, res) ->
  res.render "index", layout: false

server.listen 3000, -> console.log "listening on 3000"
