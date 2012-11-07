define [
  "jquery"
  "underscore"
], (
  $
  _
) -> (link) ->

  return $.ajax(
    type: "POST"
    url: "/linkpreview"
    data: url: link
  )

