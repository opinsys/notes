define [
  "jquery"
], (
  $
) -> (file) ->

  dfd = new $.Deferred()
  fd = new FormData
  fd.append "image", file
  xhr = new XMLHttpRequest

  started = Date.now()
  xhr.upload.onprogress = (e) ->
    dfd.notify
      type: "uploadProgress"
      loaded: e.loaded / 1024
      total: e.totalSize / 1024
      percentage: Math.round(e.loaded / e.totalSize * 100)
      speed: e.loaded / ((Date.now() - started) / 1000) / 1024

   xhr.onreadystatechange = (e) ->
     if xhr.readyState is xhr.DONE
       if xhr.status is 200
         dfd.resolve JSON.parse(xhr.response)
        else
         dfd.reject xhr

  xhr.open("POST", "/image")
  xhr.send(fd)

  return dfd.promise()
