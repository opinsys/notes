define [
  "backbone"
  "jquery"
], (
  Backbone
  $
) ->

  linkRegxp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

  class TextItemModel extends Backbone.Model


    getLinks: ->
      if match = @get("text")?.match(linkRegxp)
        return match
      else
        return []

    hasImage: -> !!@get("imageId")

    getImageURL: (size="") ->
      if size
        size = "_" + size
      return "/image/#{ @get("imageId") }#{ size }.jpg"

