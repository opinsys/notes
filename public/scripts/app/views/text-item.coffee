define [
  "backbone"
  "moment"

  "cs!app/layout"
  "cs!app/views/link-extra"
  "cs!app/models/text-item.model"
  "hbs!app/templates/text-item"
], (
  Backbone
  moment

  Layout
  LinkExtra
  TextItemModel
  template
) ->
  class TextItem extends Layout

    className: "bb-text-item"
    template: template

    constructor: ->
      super

      @_setView ".extras", @model.getLinks().map (link) ->
        return new LinkExtra
          model: new Backbone.Model
            title: "todo"
            url: link

    viewJSON: ->
      json = @model.toJSON()
      json.createdHuman = moment.unix(@model.get("created") / 1000).fromNow()
      return json
