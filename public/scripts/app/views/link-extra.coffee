define [
  "backbone"

  "cs!app/utils/linkpreview"
  "backbone.viewmaster"
  "hbs!app/templates/link-extra"
], (
  Backbone

  linkPreview
  ViewMaster
  template
) ->
  class LinkExtra extends ViewMaster
    className: "bb-link-extra"
    template: template

    constructor: (opts) ->
      super

      linkPreview(opts.link).done((linkPreview) =>
        @linkPreview = linkPreview
        @render()
      ).fail (err) =>
        console.log "linkpreview failed", err
        @remove()

    context: ->
      if @linkPreview.imageId
        @linkPreview.imageURL = "/image/#{ @linkPreview.imageId }.jpg"
      return @linkPreview

    render: ->
      if @linkPreview
        super
      else
        @$el.html "Loading..."



