
http = require('http')
express = require "express"
stylus = require "stylus"
nib = require "nib"
sharejs = require('share').server

app = express()

PRODUCTION = null
app.configure "development", -> PRODUCTION = false
app.configure "production", -> PRODUCTION = true

server = http.createServer(app)
sharejs.attach app,
  db:
    type: "none"


app.configure "development", ->
  require("yalr")()

  compile = (str, path) ->
    stylus(str)
      .set("paths", [
        __dirname + "/public/styles"
      ]).use(nib())

  app.use stylus.middleware
    compile: compile
    src: __dirname + "/public"

app.configure ->

  app.set('view engine', 'hbs')
  app.use(express.bodyParser({}))
  app.use express.static __dirname + "/public"


app.get "/", (req, res) -> res.render "landing"
app.post "/", (req, res) -> res.redirect "/notes/" + req.body.name
app.post "/linkpreview", require "./routes/linkpreview"

app.get "/notes/*", (req, res) ->
  res.render "notes",
    production: PRODUCTION

server.listen 3000, -> console.log "listening on 3000"
