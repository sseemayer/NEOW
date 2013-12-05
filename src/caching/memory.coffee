Q = require 'q'
caching = require './index'

root = exports ? this

class root.MemoryCache extends caching.Cache

  constructor: ->
    @cache = {}

  _get: (idHex) ->

    element = @cache[idHex]

    if typeof(element) == 'undefined'
      return Q.reject new Error "Element #{idHex} not found in cache!"

    if caching.cacheExpired element.cacheUntil
      return @del(idHex)
        .then ->
          Q.reject new Error "Element #{idHex} has expired"

    Q element.data

  _set: (idHex, cacheUntil, data) ->
    element = {cacheUntil: cacheUntil, data: data}
    @cache[idHex] = element
    Q true

  _del: (idHex) ->
    delete @cache[idHex]
    Q true

