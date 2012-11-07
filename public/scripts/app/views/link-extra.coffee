define [
  "backbone"

  "cs!app/view"
  "hbs!app/templates/link-extra"
], (
  Backbone

  View
  template
) ->
  class LinkExtra extends View
    className: "bb-link-extra"
    template: template

    constructor: (opts) ->
      super

      opts.linkPreviewPromise.done (linkPreview) =>
        @linkPreview = linkPreview
        @render()

      opts.linkPreviewPromise.fail (linkPreview) =>
        console.log "failed load link preview"

    viewJSON: -> @linkPreview

    render: ->
      if @linkPreview
        super
      else
        @$el.html "Loading..."



