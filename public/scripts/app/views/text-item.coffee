define [
  "backbone"
  "moment"

  "cs!app/view"
  "hbs!app/templates/text-item"
], (
  Backbone
  moment

  View
  template
) ->
  class TextItem extends View

    className: "bb-text-item"
    template: template

    events:
      "click button": "postText"

    postText: (e) ->
      e.preventDefault()
      @collection.add new Backbone.Model
        type: "text"
        text: @$("textarea").val()

    viewJSON: ->
      json = @model.toJSON()
      json.createdHuman = moment.unix(@model.get("created") / 1000).fromNow()
      return json
