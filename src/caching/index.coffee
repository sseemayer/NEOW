crypto = require 'crypto'
sha1sum = crypto.createHash 'sha1'

root = exports ? this

root.hashIdentifier = (identifier) ->
    crypto.createHash('sha1').update(identifier).digest('hex')

root.cacheExpired = (cacheUntil, now=Date.now()) ->
  cacheUntil < now

class root.Cache

  get: (identifier) ->
    @_get(root.hashIdentifier identifier)

  set: (identifier, cacheUntil, data) ->
    @_set root.hashIdentifier(identifier), cacheUntil, data

  del: (identifier) ->
    @_del root.hashIdentifier identifier

  _get: (idHex) ->
    throw new Error('Not implemented in base class!')

  _set: (idHex, cacheUntil, data) ->
    throw new Error('Not implemented in base class!')

  _del: (idHex) ->
    throw new Error('Not implemented in base class!')
