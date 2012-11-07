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

      ).fail =>
        console.log "failed load link preview"

    viewJSON: -> @linkPreview

    render: ->
      if @linkPreview
        super
      else
        @$el.html "Loading..."



