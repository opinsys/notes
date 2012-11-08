define [
  "cs!app/layout"
  "iscroll"

  "cs!app/views/send-form"
  "hbs!app/templates/timeline"

  "cs!app/views/notes-name"

  "cs!app/views/text-item"
], (
  Layout
  iScroll

  SendForm
  template

  NotesName

  TextItem
) ->

  document.addEventListener 'touchmove', (e) -> e.preventDefault()

  class Timeline extends Layout
    className: "bb-timeline"
    template: template

    constructor: ->
      super

      @_setView "header", new NotesName
        model: @model

      @_setView ".send-form-container", new SendForm
        collection: @collection

      @bindTo @collection, "add change", =>
        @setItems()
        @render()

      @setItems()


    setItems: ->
      @collection.sort()

      @_setView ".item-container", @collection.map (model) =>
        console.log "rendering", model.get "text"
        new TextItem
          model: model

    render: ->
      super
      # iScroll does not work properly if it is immediately added
      setTimeout ->
        new iScroll(@$(".item-container").get(0))
      , 5

