define [
  "backbone"
  "cs!backbone.sharedcollection"

  "cs!app/models/text-item.model"
], (
  Backbone
  SharedCollection

  TextItemModel
) ->
  class TimelineCollection extends SharedCollection

    model: TextItemModel

    comparator: (a, b) ->
      a = a.get("created")
      b = b.get("created")
      return 0 if a is b
      if a < b
        1
      else
        -1

