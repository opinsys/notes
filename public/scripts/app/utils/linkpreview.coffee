define [
  "jquery"
  "underscore"
], (
  $
  _
) -> (links) ->
  if not _.isArray(links)
    links = [links]

  dfd = new $.Deferred()
  if links.length is 0
    dfd.resolve([])
    return dfd

  console.log "fetching", links
  $.when.apply($, links.map (link) ->
    $.ajax(
      type: "POST"
      url: "/linkpreview"
      data: url: link
    )
  ).fail( ->
    dfd.reject "failed to load link data"
  ).done (results...) ->
    console.log "GOT", results
    if links.length is 1
      return dfd.resolve [results[0]]
    dfd.resolve results.map ([data, rest...]) -> data

  return dfd

