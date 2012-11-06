define [
  "cs!app/layout"

  "cs!app/views/send-form"
  "hbs!app/templates/timeline"

  "cs!app/views/text-item"
], (
  Layout

  SendForm
  template
  TextItem
) ->
  class Timeline extends Layout
    className: "bb-timeline"
    template: template

    constructor: ->
      super

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

