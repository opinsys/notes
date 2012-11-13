define [
  "backbone"

  "cs!app/models/text-item.model"
], (
  Backbone

  TextItemModel
) ->
  class TimelineCollection extends Backbone.Collection

    model: TextItemModel

    comparator: (a, b) ->
      a = a.get("created")
      b = b.get("created")
      return 0 if a is b
      if a > b
        1
      else
        -1

