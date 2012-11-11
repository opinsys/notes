define [
  "underscore"
  "iscroll"
  "viewmaster"

  "cs!app/views/send-form"
  "hbs!app/templates/notes-layout"

  "cs!app/views/notes-name"
  "cs!app/views/text-item"
  "cs!app/views/timeline"
], (
  _
  iScroll
  ViewMaster

  SendForm
  template

  NotesName
  TextItem
  Timeline
) ->

  class NotesLayout extends ViewMaster
    className: "bb-notes-layout"
    template: template

    constructor: (opts) ->
      super

      @setViews "header", new NotesName
        model: @model

      @setViews ".send-form-container", new SendForm
        collection: @collection

      @setViews ".timeline-container", new Timeline
        collection: @collection

