define [
  "backbone"
  "cs!app/view"
  "cs!app/models/text-item.model"
  "hbs!app/templates/sendform"
], (
  Backbone
  View
  TextItemModel
  template
) ->
  class SendForm extends View

    className: "bb-send-form"
    template: template
    events:
      "click button": "postText"

    postText: (e) ->
      e.preventDefault()
      @collection.add new TextItemModel
        type: "text"
        text: @$("textarea").val()
        created: Date.now()
      console.log "adding model", @$("textarea").val(), @collection

