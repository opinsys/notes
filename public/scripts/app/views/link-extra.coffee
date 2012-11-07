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
