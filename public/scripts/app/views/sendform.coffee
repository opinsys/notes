define [
  "backbone"
  "cs!app/view"
  "hbs!app/templates/sendform"
], (
  Backbone
  View
  template
) ->
  class SendForm extends View

    className: "bb-send-form"
    template: template
    events:
      "click button": "postText"

    postText: (e) ->
      e.preventDefault()
      @collection.add new Backbone.Model
        type: "text"
        text: @$("textarea").val()
      console.log "adding model", @$("textarea").val(), @collection

