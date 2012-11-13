define [
  "backbone"

  "cs!app/utils/linkpreview"
  "puppetview"
  "hbs!app/templates/link-extra"
], (
  Backbone

  linkPreview
  PuppetView
  template
) ->
  class LinkExtra extends PuppetView
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

    viewJSON: ->
      if @linkPreview.imageId
        @linkPreview.imageURL = "/image/#{ @linkPreview.imageId }.jpg"
      if @linkPreview.og?['og:image']
        @linkPreview.ogImage = @linkPreview.og['og:image']
      return @linkPreview

    render: ->
      if @linkPreview
        super
      else
        @$el.html "Loading..."



