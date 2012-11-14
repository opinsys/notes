

module.exports = (config) ->

  items = []

  return {
    each: (fn, cb) ->
      items.forEach(fn)
      cb?()

    create: (item, cb) ->
      items.push(item)
      cb?()

    update: (attributes, cb) ->
      for current in items
        if current.id and current.id is attributes.id
          for k, v of attributes
            current[k] = v
      cb?()

  }
