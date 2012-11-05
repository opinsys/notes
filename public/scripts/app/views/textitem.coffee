define [
  "backbone"
  "cs!app/view"
  "hbs!app/templates/textitem"
], (
  Backbone
  View
  template
) ->
  class TextItem extends View

    className: "bb-send-form"
    template: template
    events:
      "click button": "postText"

    postText: (e) ->
      e.preventDefault()
      @collection.add new Backbone.Model
        type: "text"
        text: @$("textarea").val()

