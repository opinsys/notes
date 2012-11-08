define [
  "cs!app/layout"
  "iscroll"
  "underscore"

  "cs!app/views/send-form"
  "hbs!app/templates/notes-layout"

  "cs!app/views/notes-name"
  "cs!app/views/text-item"
  "cs!app/views/timeline"
], (
  Layout
  iScroll
  _

  SendForm
  template

  NotesName
  TextItem
  Timeline
) ->

  class NotesLayout extends Layout
    className: "bb-notes-layout"
    template: template

    constructor: ->
      super

      @_setView "header", new NotesName
        model: @model

      @_setView ".send-form-container", new SendForm
        collection: @collection

      @_setView ".timeline-container", new Timeline
        collection: @collection

