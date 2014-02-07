Q = require 'q'
http = require 'q-io/http'
url = require 'url'
_ = require 'lodash'
memoryCache = require './caching/memory'

parser = require './parser'

root = exports ? this

normalizePath = (path) ->
  path.replace(/^\//, '')
    .replace(/:/, '/')
    .replace(/\.xml\.aspx$/, '') + '.xml.aspx'

class root.Client
  constructor: (
    @default_params={keyID: null, vCode: null}
    api_url="https://api.eveonline.com"
    @cache = new memoryCache.MemoryCache
  ) ->
      @api_url = url.parse api_url

  fetch: (path, params={}) ->

    reqParams = _.clone @api_url.query || {}

    _.assign reqParams, @default_params
    _.assign reqParams, params

    reqURL = _.assign @api_url, {
      pathname: normalizePath(path)
      query: reqParams
    }

    delete reqURL.search
    delete reqURL.path

    reqURLFormatted = url.format reqURL

    self = this

    @cache.get(reqURLFormatted)
      .then (result) ->
        result
      .fail ->
        http.request(reqURLFormatted)
          .then (res) ->
            if res.status != 200
              return Q.reject new Error("API for '#{reqURLFormatted}' returned with HTTP status code #{res.status}")

            res.body.read()
          .then(parser.parse)
          .then (result) ->

            # only return after cache set is resolved
            self.cache.set(reqURLFormatted, result.cachedUntil, result)
              .then ->
                result
