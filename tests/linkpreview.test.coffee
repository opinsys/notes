

path = require "path"
fs = require "fs"


express = require "express"
{expect} = require "chai"

linkPreview = require("../lib/linkpreview")("/tmp")

port = process.env.TEST_PORT or 5748

app = express()

app.get "/logo.png", (req, res) ->
  res.sendfile path.join __dirname, "logo.png"

app.get "/basic.html", (req, res) ->
  res.send """
<!doctype html>
<html>
  <head>
    <title>Test Title</title>
  </head>
  <body>
    <h1>Basic html</h1>
  </body>
</html>
"""


describe "link preview", ->

  before (done) ->
    app.listen port, done

  it "works", ->
    expect(linkPreview).to.be.ok

  describe "title parser", ->

    it "parses title from html", (done) ->
      linkPreview "http://localhost:#{ port }/basic.html", (err, ob) ->
        expect(err).to.be.not.ok
        expect(ob.title).to.eq "Test Title"
        done()

  describe "image parser", ->

    it "adds image link to the object", (done) ->
      linkPreview "http://localhost:#{ port }/logo.png", (err, ob) ->
        expect(err).to.be.not.ok
        expect(ob.imageId).to.be.ok

        stat = fs.statSync path.join "/tmp", ob.imageId
        console.log path.join "/tmp", ob.imageId
        console.log 
        console.log stat
        expect(stat.size > 100).to.be.ok



        done()

