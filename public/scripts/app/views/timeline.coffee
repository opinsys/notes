define [
  "cs!app/layout"

  "cs!app/views/sendform"
  "hbs!app/templates/timeline"

  "cs!app/views/textitem"
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

      @_setView ".sendform-container", new SendForm
        collection: @collection

      @bindTo @collection, "add change", =>
        console.log "got add or chacnge"
        @_setView ".item-container", @collection.map (model) =>
          new TextItem
            model: model
        @render()

