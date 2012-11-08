define [
  "cs!app/layout"
  "iscroll"
  "underscore"

  "hbs!app/templates/timeline"

  "cs!app/views/text-item"
  "cs!app/notes"
], (
  Layout
  iScroll
  _

  template

  TextItem
  Notes
) ->

  document.addEventListener 'touchmove', (e) -> e.preventDefault()

  areClose = (a, b, threshold) ->
    return Math.abs(a - b) <= threshold


  class Timeline extends Layout
    className: "bb-timeline"
    template: template

    constructor: ->
      super

      @bindTo @collection, "add change", =>
        @setItems()
        @render()

      @setItems()

      $(window).on "resize", _.debounce =>
        @scrollToBottom() if Notes.get("autoScroll")
      , 300


    elements:
      "scrollContainer": ".item-container-wrap"

    setItems: ->
      @collection.sort()

      items = @collection.map (model) =>
        new TextItem model: model
      _.last(items)?.$el.addClass "last"
      @_setView ".item-container", items

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
        @scrollToBottom() if Notes.get("autoScroll")
      , 5

      # WTF: this does not work from the events-object?!
      @scrollContainer.on "scroll", => @setAutoScroll()

    setAutoScroll: ->
      Notes.set autoScroll: @isScrollAtBottom()
