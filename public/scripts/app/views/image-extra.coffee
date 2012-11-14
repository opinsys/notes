define [
  "backbone"
  "backbone.viewmaster"

  "hbs!app/templates/image-extra"
], (
  Backbone
  ViewMaster

  template
) ->
  class ImageExtra extends ViewMaster
    className: "bb-image-extra"
    template: template
    viewJSON: -> imageURL: @model.getImageURL()
