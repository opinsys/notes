
http = require('http')
express = require "express"
stylus = require "stylus"
nib = require "nib"
sync = require "./lib/backbonesock"

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


app.configure "development", ->

  yalrConfig = require("yalr")(
    path: [
      "public"
      "views"
    ]
  )

  app.use (req, res, next) ->
   res.locals.yalrConfig = yalrConfig
   next()


  compile = (str, path) ->
    stylus(str)
      .set("paths", [
        __dirname + "/public/styles"
      ]).use(nib())

  app.use stylus.middleware
    compile: compile
    src: __dirname + "/public"

app.configure ->

  app.use (req, res, next) ->
   res.locals.production = PRODUCTION
   next()

  app.set('view engine', 'hbs')
  app.use(express.bodyParser({}))
  app.use express.static __dirname + "/public"

  # Workaround iOS 6 POST caching bug
  # http://stackoverflow.com/questions/12506897/is-safari-on-ios-6-caching-ajax-results
  app.use (req, res, next) ->
    if req.method is "POST"
      res.header "Cache-Control", "no-cache"
    next()


app.get "/", (req, res) ->
  res.render "landing"

app.post "/", (req, res) -> res.redirect "/notes/" + req.body.name
app.post "/linkpreview", require "./routes/linkpreview"

app.get "/notes/*", (req, res) ->
  res.render "notes"

app.post "/image", imageRoute.post
app.get "/image/:imageId", imageRoute.get

sync(server)
server.listen 3000, -> console.log "listening on 3000"
