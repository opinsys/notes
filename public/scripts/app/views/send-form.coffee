define [
  "backbone"
  "progress"


  "backbone.viewmaster"
  "cs!app/utils/upload"
  "cs!app/models/text-item.model"
  "hbs!app/templates/sendform"
  "cs!app/notes"
], (
  Backbone
  Progress

  ViewMaster
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


  class SendForm extends ViewMaster

    className: "bb-send-form"
    template: template

    constructor: ->
      super
      @bindTo Notes.global, "change:autoScroll", @render
      @$el.removeClass "textarea-focus"

    events:
      "click button": "post"
      "click .cancel-image": "cancelImage"
      "change .image-select": "handleImage"

    elements:
      "$progressCanvas": ".progress canvas"

    handleImage: (e) ->
      file = e.target.files[0]

      if not file.type.match /^image\/.+$/
        @errorMsg = "#{ file.name } ei ole kuva"
        @render()
        return

      @currentImage = file: file
      fileToDataURL(file).pipe(dataURLToImage).done (img) =>
        @currentImage.el = img
        @render()

    cancelImage: (e) ->
      e.preventDefault()
      @currentImage = null
      @render()

    render: ->
      @ctx = null

      text = @$("textarea").val()
      super
      @$("textarea").val(text)

      Notes.global.set imagePreviewActive: !!@currentImage
      if @currentImage
        @$(".image-preview").html @currentImage.el

      @errorMsg = null


    addProgressIndicator: ->
      return if @ctx
      canvas = @$progressCanvas.get(0)
      @ctx = ctx = canvas.getContext('2d')
      ratio = window.devicePixelRatio || 1
      canvas.style.width = canvas.width
      canvas.style.height = canvas.height
      canvas.width *= ratio
      canvas.height *= ratio

      @progress = new Progress()
      @progress.size 40
      @updateProgress(0)

    updateProgress: (percentage) ->
      return if not @progress
      @progress.text "#{ percentage } %"
      @progress.update percentage
      @progress.draw @ctx


    upload: (file) ->
      @addProgressIndicator()
      up = upload(file)

      up.fail -> alert "failed to post image!"

      up.progress (progress) =>
        @updateProgress(progress.percentage)

      return up

    post: ->
      if @currentImage
        @upload(@currentImage.file).done (res) =>
          @currentImage.imageId = res.imageId
          @sync()
      else
        @sync() if @$("textarea").val() != ""


    viewJSON: -> {
      errorMsg: @errorMsg
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

      model = new TextItemModel json
      @collection.add model
      model.save()
      @clear()
      @render()


    clear: ->
      @currentImage = null
      @$("textarea").val("")


