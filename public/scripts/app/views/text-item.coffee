define [
  "backbone"
  "moment-fi"

  "viewmaster"
  "cs!app/views/link-extra"
  "cs!app/views/image-extra"
  "cs!app/models/text-item.model"
  "hbs!app/templates/text-item"
], (
  Backbone
  moment

  ViewMaster
  LinkExtra
  ImageExtra
  TextItemModel
  template
) ->
  replaceURLWithHTMLLinks = (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target=_blank>$1</a>")

  class TextItem extends ViewMaster

    moment.lang('fi')

    className: "bb-text-item"
    template: template

    constructor: ->
      super
      @addExtras()

    addExtras: ->

      extras = @model.getLinks().map (link) =>
        new LinkExtra link: link

      if @model.hasImage()
        extras.push new ImageExtra
          model: @model

      @setViews ".extras", extras

    viewJSON: ->
      json = @model.toJSON()
      json.text = replaceURLWithHTMLLinks(json.text)
      json.createdHuman = moment.unix(@model.get("created") / 1000).fromNow()
      return json

