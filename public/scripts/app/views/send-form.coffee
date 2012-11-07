define [
  "backbone"
  "cs!app/view"
  "cs!app/models/text-item.model"
  "hbs!app/templates/sendform"
], (
  Backbone
  View
  TextItemModel
  template
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
      super
      if @currentImage
        @$(".image-preview").html @currentImage.el

    post: ->
      json =
        type: "text"
        text: @$("textarea").val()
        created: Date.now()

      @collection.add new TextItemModel json



