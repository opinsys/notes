define [
  "underscore"
  "cs!app/layout"
  "hbs!app/templates/notes-name"
], (
  _
  Layout
  template
) ->

  class NotesName extends Layout

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
      console.log "blue keyup paste"
      console.log @$('h1').html()
      @model.set( "name", @$('h1').text() )
