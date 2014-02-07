url = require 'url'
_ = require 'lodash'

client = require '../client'
memoryCache = require '../caching/memory'

root = exports ? this

class root.EveCentralClient extends client.AbstractClient
  constructor: (
    @default_params={}
    api_url="http://api.eve-central.com/api/"
    @cache = new memoryCache.MemoryCache
    @parser = require './parser'
  ) ->
    @api_url = url.parse api_url

  processURL: (path, params) ->
    _.assign @api_url,
      pathname: @api_url.pathname + path
      query: params
