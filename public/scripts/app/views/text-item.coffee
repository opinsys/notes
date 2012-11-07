define [
  "backbone"
  "moment"

  "cs!app/layout"
  "cs!app/views/link-extra"
  "cs!app/models/text-item.model"
  "cs!app/utils/linkpreview"
  "hbs!app/templates/text-item"
], (
  Backbone
  moment

  Layout
  LinkExtra
  TextItemModel
  linkPreview
  template
) ->
  replaceURLWithHTMLLinks = (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    return text.replace(exp,"<a href='$1' target=_blank>$1</a>")

  class TextItem extends Layout

    className: "bb-text-item"
    template: template

    constructor: ->
      super
      @fetchExtras()

    fetchExtras: ->
      console.log @model.getLinks()
      linkPreview(@model.getLinks()).fail(->
        console.log "failed to load extras :("
      ).done (links) =>
        console.log "loaded extras", links
        @_setView ".extras", links.map (link) =>
          return new LinkExtra model: new Backbone.Model link
        @render()


    viewJSON: ->
      json = @model.toJSON()
      json.text = replaceURLWithHTMLLinks(json.text)
      json.createdHuman = moment.unix(@model.get("created") / 1000).fromNow()
      return json

