
http = require('http')
express = require "express"
stylus = require "stylus"
nib = require "nib"
sync = require "./lib/serversync"

app = express()
server = require('http').createServer(app)


PRODUCTION = null
app.configure "development", -> PRODUCTION = false
app.configure "production", -> PRODUCTION = true

imageRoute = require "./routes/image"

server = http.createServer(app)

if PRODUCTION or process.env.REDIS
  dbType = "redis"
else
  dbType = "none"


yalrConfig = null
app.configure "development", ->

  yalrConfig = require("yalr")(
    path: [
      "public"
      "views"
    ]
  )

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


app.get "/", (req, res) ->
  res.render "landing",
    yalrConfig: yalrConfig

app.post "/", (req, res) -> res.redirect "/notes/" + req.body.name
app.post "/linkpreview", require "./routes/linkpreview"

app.get "/notes/*", (req, res) ->
  res.render "notes",
    yalrConfig: yalrConfig

app.post "/image", imageRoute.post
app.get "/image/:imageId", imageRoute.get

sync(server)
server.listen 3000, -> console.log "listening on 3000"
