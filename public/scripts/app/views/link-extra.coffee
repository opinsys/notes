define [
  "backbone"

  "cs!app/utils/linkpreview"
  "cs!app/view"
  "hbs!app/templates/link-extra"
], (
  Backbone

  linkPreview
  View
  template
) ->
  class LinkExtra extends View
    className: "bb-link-extra"
    template: template

    constructor: (opts) ->
      super

      linkPreview(opts.link).done((linkPreview) =>
        @linkPreview = linkPreview
        @render()
      ).fail (err) =>
        console.log "linkpreview failed", err
        throw new Error "linkpreview failed"

    viewJSON: ->
      if @linkPreview.imageId
        @linkPreview.imageURL = "/image/#{ @linkPreview.imageId }"
      return @linkPreview

    render: ->
      if @linkPreview
        super
      else
        @$el.html "Loading..."



