define [
  "underscore"
  "backbone.viewmaster"
  "hbs!app/templates/notes-name"
], (
  _
  ViewMaster
  template
) ->

  class NotesName extends ViewMaster

    className: "bb-notes-name"
    template: template

    constructor: ->
      @updateName = _.debounce @updateName, 500
      super

      @editActive = false

      @model.bind "change", =>
        if not @editActive
          @render()

    events:
      'focus h1': "editStart"
      'blur h1': "editStop"
      'keyup h1': "updateName"
      'paste h1': "updateName"
      'keydown h1': "disableEnter"
      'click .print-button': -> window.print()

    disableEnter: (e) ->
      if e.which in [13, 27]
        e.preventDefault()
        @$("h1").blur()

    editStart: ->
      console.log "Focus: editStart"
      @editActive = true

    editStop: ->
      console.log "editStop"
      @editActive = false
      @updateName()

    updateName: ->
      @model.set( "name", @$('h1').text() )
      console.log "saving meta model"
      @model.save()
