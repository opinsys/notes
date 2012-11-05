define [
  "jquery"
  "backbone"
  "backbone.io"
], (
  $
  Backbone
  backboneio
)->

  console.log "hello"
  Backbone.io.connect()

  class MyCollection extends Backbone.Collection


    constructor: ->
      @backend =
        name: "basic"
        channel: "foo"

      super
      @bindBackend()

  class View extends Backbone.View

    constructor: ->
      super

      @collection.on "change", =>
        @render()

    render: ->
      "<p>value: #{ @collection.first()?.get "value" }</p>"


  window.coll = new MyCollection

  view = new View
    collection: coll

  view.render()
  $("body").append view.el


