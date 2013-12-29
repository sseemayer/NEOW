Q = require 'q'
_ = require 'lodash'
sax = require 'sax'

root = exports ? this

root.parse = (data, strict=true) ->

  deferred = Q.defer()

  parser = sax.createStream strict, trim: true
  result = {}

  stack = []

  current = {element: result, name: null}

  down = (newframe) ->
    stack.push(newframe)
    newframe

  up = ->
    head = stack.pop()
    peek()

  peek = ->
    stack[stack.length - 1]

  parser.on 'error', (err) ->
    deferred.reject(err)

  parser.on 'opentag', (node) ->

    if node.name == 'row'
      keyKey = current.key
    else
      keyKey = 'name'

    key = node.attributes[keyKey]

    if not key
      key = node.name

    if not current.element[key]
      current.element[key] = {}

    if node.name != 'rowset'
      _.merge current.element[key], node.attributes

    current = down {
      element: current.element[key]
      name: node.name
      key: node.attributes.key
    }


  parser.on 'closetag', (tagName) ->

    head = peek()
    if not head then return

    if head.name == tagName
      current = up()

  parser.on 'text', (text) ->
    current.element.content = text

  parser.on 'end', ->

    if not result.eveapi
      return deferred.reject new Error "Malformed XML reply!"

    if result.eveapi.version != '2'
      return deferred.reject new Error "Wrong eveapi version!"

    if result.eveapi.error
      return deferred.reject new Error result.eveapi.error.content

    res = result.eveapi.result
    res.currentTime = result.eveapi.currentTime.content
    res.cachedUntil = result.eveapi.cachedUntil.content

    deferred.resolve res

  if data.pipe
    data.pipe(parser)
  else
    parser.write(data)
    parser.end()

  deferred.promise
