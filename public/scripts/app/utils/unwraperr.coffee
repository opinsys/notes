# Tool for unwraping errors from error eating library code
define [], ->
  return (fn) -> (args...) ->
    setTimeout ->
      fn args...
    , 0
