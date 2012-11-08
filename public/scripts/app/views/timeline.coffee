define [
  "cs!app/layout"
  "iscroll"
  "underscore"

  "cs!app/views/send-form"
  "hbs!app/templates/timeline"

  "cs!app/views/notes-name"

  "cs!app/views/text-item"
], (
  Layout
  iScroll
  _

  SendForm
  template

  NotesName

  TextItem
) ->

  document.addEventListener 'touchmove', (e) -> e.preventDefault()

  areClose = (a, b, threshold) ->
    return Math.abs(a - b) <= threshold


  class Timeline extends Layout
    className: "bb-timeline"
    template: template

    constructor: ->
      super

      @_setView "header", new NotesName
        model: @model

      @_setView ".send-form-container", new SendForm
        collection: @collection

      @bindTo @collection, "add change", =>
        @setItems()
        @render()

      @setItems()

      $(window).on "resize", _.debounce =>
        @scrollToBottom()
      , 300


    setItems: ->
      @collection.sort()

      @_setView ".item-container", @collection.map (model) =>
        new TextItem
          model: model

    isScrollAtBottom: ->
      if Modernizr.touch
        height = Math.abs(@iscroll.y)
        position = Math.abs(@iscroll.maxScrollY)
      else
        wrap = @$(".item-container-wrap")
        height = wrap.get(0).scrollHeight
        position = $(wrap).scrollTop() + $(wrap).height()

      res = areClose(position, height, 20)
      return res

    scrollToBottom: ->
      wrap = @$(".item-container-wrap").get(0)
      wrap.scrollTop = wrap.scrollHeight

    render: ->
      super
      # iScroll does not work properly if it is immediately added
      setTimeout =>
        @iscroll = new iScroll(@$(".item-container").get(0))
        @scrollToBottom()
      , 5

