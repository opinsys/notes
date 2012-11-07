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

    viewJSON: ->
      json = @model.toJSON()
      json.createdHuman = moment.unix(@model.get("created") / 1000).fromNow()
      return json
