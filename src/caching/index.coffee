crypto = require 'crypto'
sha1sum = crypto.createHash 'sha1'

root = exports ? this

root.hashIdentifier = (identifier) ->
    crypto.createHash('sha1').update(identifier).digest('hex')

root.cacheExpired = (cacheUntil, now=new Date) ->
  if typeof(cacheUntil) == 'string'
    cacheUntil = new Date(cacheUntil + " +00")

  console.log cacheUntil
  console.log now

  cacheUntil < now

class root.Cache

  get: (identifier) ->
    @_get(root.hashIdentifier identifier)
      .then JSON.parse

  set: (identifier, cacheUntil, data) ->
    @_set root.hashIdentifier(identifier), cacheUntil, JSON.stringify(data)

  del: (identifier) ->
    @_del root.hashIdentifier identifier

  _get: (idHex) ->
    throw new Error('Not implemented in base class!')

  _set: (idHex, cacheUntil, data) ->
    throw new Error('Not implemented in base class!')

  _del: (idHex) ->
    throw new Error('Not implemented in base class!')
