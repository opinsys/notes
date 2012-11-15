define [
  "backbone"
  "backbone.viewmaster"
  "moment-fi"
  "underscore.string"

  "cs!app/notes"
  "cs!app/views/link-extra"
  "cs!app/views/image-extra"
  "cs!app/models/text-item.model"
  "hbs!app/templates/text-item"
], (
  Backbone
  ViewMaster
  moment
  s

  Notes
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

    highlight: ->
      @$el.css "animation", "highlight 1s"
      setTimeout =>
        @$el.css "animation", ""
      , 1000

    render: ->
      super
      @highlight() if not Notes.global.get("loading")

    context: ->
      json = @model.toJSON()
      json.text = replaceURLWithHTMLLinks s.escapeHTML json.text
      json.text = json.text.replace(/\n/g, "<br>")
      json.createdHuman = moment.unix(
        @model.get("created") / 1000
      ).fromNow()

      return json

