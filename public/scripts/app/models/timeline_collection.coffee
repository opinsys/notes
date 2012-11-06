define [
  "backbone"
  "cs!backbone.sharedcollection"
], (
  Backbone
  SharedCollection
) ->
  class TimelineCollection extends SharedCollection


    comparator: (a, b) ->
      a = a.get("created")
      b = b.get("created")
      return 0 if a is b
      if a < b
        1
      else
        -1

