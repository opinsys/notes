
path = require "path"

jsdom = require "jsdom"

jqueryPath = path.join __dirname, "../../public/scripts/vendor/jquery.js"


# jsdom.jQueryify eats errors on callbacks. Unwrap them.
unwrap = (fn) -> (args...) ->
  process.nextTick ->
    fn args...

module.exports = (ob, done) ->
  if not ob.html
    return done null, ob

  window = jsdom.jsdom().createWindow()

  console.log "setting jquery"

  jsdom.jQueryify window, jqueryPath, unwrap (win, $) ->
    console.log "setting jquery 2"
    body = ob.html.replace(/<(\/?)script/g, '<$1nobreakage');

    # Inject our body script-tag free to new jsdom window
    $('head').append($(body).find('head').html())
    console.log "setting jquery 3"
    $('body').append($(body).find('body').html())
    console.log "setting jquery 4"

    ob.$ = $
    console.log "jquery set"
    done null, ob




