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

    elements:
      $images: "img"

    context: -> imageURL: @model.getImageURL()

    render: ->
      super
      @$images.on "load", (e) =>
        @trigger "imageloaded", e.target
