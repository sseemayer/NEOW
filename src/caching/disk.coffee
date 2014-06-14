
fs = require 'fs'
path = require 'path'

Q = require 'q'
qfs = require 'q-io/fs'
caching = require './index'

root = exports ? this


class root.DiskCache extends caching.Cache

  constructor: (@folder='/tmp/eveapi-cache') ->
    if not fs.existsSync(@folder)
      fs.mkdirSync @folder

  get_path: (idHex) ->
    path.resolve(@folder, idHex)

  _get: (idHex) ->
    qfs.read(@get_path idHex).then(JSON.parse).then (element) ->
      
      if caching.cacheExpired element.cacheUntil
        return @del(idHex)
          .then ->
            Q.reject new Error "Element #{idHex} has expired"

      Q element.data
        .then JSON.parse

  _set: (idHex, cacheUntil, data) ->
    element = {cacheUntil: cacheUntil, data: JSON.stringify(data)}
    qfs.write(@get_path(idHex), JSON.stringify element).then ->
      true

  _del: (idHex) ->
    qfs.remove(@get_path idHex).then ->
      true

