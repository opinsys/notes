define [
  "backbone"

  "cs!app/view"
  "cs!app/utils/upload"
  "cs!app/models/text-item.model"
  "hbs!app/templates/sendform"
  "cs!app/notes"
], (
  Backbone

  View
  upload
  TextItemModel
  template
  Notes
) ->

  fileToDataURL = (file) ->
    dfd = new $.Deferred()
    reader = new FileReader
    reader.onload = (e) -> dfd.resolve e.target.result
    reader.readAsDataURL(file)
    return dfd.promise()

  dataURLToImage = (dataURL) ->
    dfd = new $.Deferred()
    img = new Image
    img.onload = => dfd.resolve img
    img.src = dataURL
    return dfd.promise()


  class SendForm extends View

    className: "bb-send-form"
    template: template

    constructor: ->
      super

      @bindTo Notes.global, "change:autoScroll", @render

    events:
      "click button": "post"
      "change .image-select": "handleImage"

    handleImage: (e) ->
      @currentImage =
        file: e.target.files[0]

      fileToDataURL(@currentImage.file).pipe(dataURLToImage).done (img) =>
        @currentImage.el = img
        @render()

    render: ->
      text = @$("textarea").val()
      super
      @$("textarea").val(text)
      if @currentImage
        @$(".image-preview").html @currentImage.el

    post: ->
      if @currentImage
        upload(@currentImage.file).fail(->
          alert "failed to post image!"

        ).done (res) =>
          @currentImage.imageId = res.imageId
          @sync()
      else
        @sync() if @$("textarea").val() != ""


    viewJSON: -> {
      imagePreview: !!@currentImage
      autoScroll: Notes.global.get "autoScroll"
    }

    sync: ->

      json =
        type: "text"
        text: @$("textarea").val()
        created: Date.now()

      if @currentImage
        json.imageId = @currentImage.imageId

      @collection.add new TextItemModel json
      @clear()
      @render()


    clear: ->
      @currentImage = null
      @$("textarea").val("")


