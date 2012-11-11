define [
  "backbone"
  "puppetview"

  "hbs!app/templates/image-extra"
], (
  Backbone
  PuppetView

  template
) ->
  class ImageExtra extends PuppetView
    className: "bb-image-extra"
    template: template
    viewJSON: -> imageURL: @model.getImageURL()
