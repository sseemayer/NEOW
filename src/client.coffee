Q = require 'q'
http = require 'q-io/http'
url = require 'url'
_ = require 'lodash'

root = exports ? this

class root.AbstractClient
  constructor: (
    @default_params
    @api_url
    @cache
    @parser
  ) ->

  fetch: (path, params={}) =>

    reqParams = _.clone @api_url.query || {}

    _.assign reqParams, @default_params
    _.assign reqParams, params

    reqURL = @processURL(path, reqParams)

    delete reqURL.search
    delete reqURL.path

    reqURLFormatted = url.format reqURL

    self = this

    @cache.get(reqURLFormatted)
      .then (result) ->
        result
      .catch ->
        client = self
        http.request(reqURLFormatted)
          .then (res) ->
            if res.status != 200
              return Q.reject new Error("API for '#{reqURLFormatted}' returned with HTTP status code #{res.status}")

            res.body.read()
          .then(self.parser.parse)
          .then (result) ->

            # only return after cache set is resolved
            self.cache.set(reqURLFormatted, new Date(result.cachedUntil + ' +00').getTime(), result)
              .then ->
                result
