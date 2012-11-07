define [
  "backbone"

  "cs!app/view"
  "hbs!app/templates/image-extra"
], (
  Backbone

  View
  template
) ->
  class ImageExtra extends View
    className: "bb-image-extra"
    template: template
    viewJSON: -> imageURL: @model.getImageURL()
