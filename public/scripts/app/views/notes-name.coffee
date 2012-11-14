define [
  "underscore"
  "puppetview"
  "hbs!app/templates/notes-name"
], (
  _
  PuppetView
  template
) ->

  class NotesName extends PuppetView

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
