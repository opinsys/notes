define [], ->

  return (fn) -> (args...) ->

    try
      return fn args...
    catch err
      setTimeout ->
        throw err
      , 1

