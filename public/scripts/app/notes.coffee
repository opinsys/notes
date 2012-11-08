define ["backbone"], (Backbone) ->

  Notes =
    reset: ->
      @global = new Backbone.Model
        autoScroll: true

  Notes.reset()

  return Notes
