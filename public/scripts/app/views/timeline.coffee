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

      @scrollToBottom = _.debounce @scrollToBottom, 100
      @refreshiScroll = _.debounce @refreshiScroll, 100
      if Modernizr.touch
        @addiScroll = _.debounce @addiScroll, 100
      else
        @addiScroll = ->

      @bindTo Notes.global, "change:imagePreviewActive", @setImagePreviewClass
      @setImagePreviewClass()

      @bindTo @collection, "add", (model) =>
        @setItemViews()
        @renderViews()

      @setItemViews()

      $(window).on "resize", _.debounce =>
        @scrollToBottom()
      , 200

    setImagePreviewClass: ->
      if Notes.global.get("imagePreviewActive")
        @$el.addClass "image-preview-active"
      else
        @$el.removeClass "image-preview-active"

    getItemView: (model) ->
      if view = @itemViews[model.cid]
        return view
      return @itemViews[model.cid] = new TextItem
        model: model


    elements:
      "$scrollContainer": ".item-container-wrap"

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
        wrap = @$scrollContainer
        height = wrap.get(0).scrollHeight
        position = wrap.get(0).scrollTop + wrap.height()

      res = areClose(position, height, 50)
      # alert(position + " vs " + height + " -> " + res)
      return res

    scrollToBottom: ->
      window.t = this
      if not Notes.global.get("autoScroll")
        return

      if Modernizr.touch
        @iscroll.scrollToElement(".last", 300) if @iscroll
      else
        wrap = @$scrollContainer.get(0)
        wrap.scrollTop = wrap.scrollHeight
        console.log "Scrolling to", wrap.scrollHeight

    setAutoScroll: ->
      Notes.global.set autoScroll: @isScrollAtBottom()

    addiScroll: ->
      @iscroll = new iScroll @$scrollContainer.get(0),
        onScrollEnd: => @setAutoScroll()
        onScrollStart: => Notes.global.set autoScroll: false
      @scrollToBottom()

    refreshiScroll: ->
      @iscroll?.refresh()
      @scrollToBottom()

    renderViews: ->
      super
      @refreshiScroll()

    render: ->
      @iscroll?.destroy()
      super
      @addiScroll()

      # WTF: this does not work from the events-object?!
      @$scrollContainer.on "scroll", => @setAutoScroll()

