define [
  "viewmaster"
  "iscroll"
  "underscore"

  "hbs!app/templates/timeline"

  "cs!app/views/text-item"
  "cs!app/notes"
], (
  ViewMaster
  iScroll
  _

  template

  TextItem
  Notes
) ->

  document.addEventListener 'touchmove', (e) -> e.preventDefault()

  areClose = (a, b, threshold) ->
    return Math.abs(a - b) <= threshold


  class Timeline extends ViewMaster
    className: "bb-timeline"
    template: template

    constructor: ->
      super

      @itemViews = {}

      @bindTo @collection, "add", (model) =>
        @setItemViews()
        @renderViews()
        @scrollToBottom()

      @setItemViews()

      $(window).on "resize", _.debounce =>
        @scrollToBottom()
      , 300

    getItemView: (model) ->
      if view = @itemViews[model.cid]
        return view
      return @itemViews[model.cid] = new TextItem
        model: model


    elements:
      "scrollContainer": ".item-container-wrap"

    setItemViews: ->
      @collection.sort()

      @setViews ".item-container", @collection.map (model) =>
        view = @getItemView(model)
        view.$el.removeClass("last")
        return view

      if views = @getViews(".item-container")
        _.last(views)?.$el.addClass("last")


    isScrollAtBottom: ->
      if Modernizr.touch
        height = Math.abs(@iscroll.y)
        position = Math.abs(@iscroll.maxScrollY)
      else
        wrap = @scrollContainer
        height = wrap.get(0).scrollHeight
        position = wrap.get(0).scrollTop + wrap.height()

      res = areClose(position, height, 50)
      # alert(position + " vs " + height + " -> " + res)
      return res

    scrollToBottom: ->
      if not Notes.global.get("autoScroll")
        return
      if Modernizr.touch
        @iscroll.scrollToElement(".last")
      else
        wrap = @scrollContainer.get(0)
        wrap.scrollTop = wrap.scrollHeight

    render: ->
      super
      # iScroll does not work properly if it is immediately added
      setTimeout =>
        @iscroll = new iScroll @$(".item-container").get(0),
          vScrollbar: true
          onScrollEnd: => @setAutoScroll()
        @scrollToBottom()
      , 5

      # WTF: this does not work from the events-object?!
      @scrollContainer.on "scroll", => @setAutoScroll()


    setAutoScroll: ->
      Notes.global.set autoScroll: @isScrollAtBottom()
