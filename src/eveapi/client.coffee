url = require 'url'
_ = require 'lodash'

client = require '../client'
memoryCache = require '../caching/memory'

root = exports ? this

class root.EveClient extends client.AbstractClient
  constructor: (
    @default_params={keyID: null, vCode: null}
    api_url="https://api.eveonline.com"
    @cache=new memoryCache.MemoryCache
    @parser= require './parser'
  ) ->
    @api_url = url.parse api_url

  processURL: (path, params) ->
    _.assign {},
      @api_url,
      pathname: (
        path.replace(/^\//, '')
          .replace(/:/, '/')
          .replace(/\.xml\.aspx$/, '') + '.xml.aspx'
      )
      query: params

# EveClient is a nicer name, but support Client for backward compatibility
root.Client = root.EveClient
