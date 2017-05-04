(function() {
  var Q, _, http, root, url,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Q = require('q');

  http = require('q-io/http');

  url = require('url');

  _ = require('lodash');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.AbstractClient = (function() {
    function AbstractClient(default_params, api_url, cache, parser) {
      this.default_params = default_params;
      this.api_url = api_url;
      this.cache = cache;
      this.parser = parser;
      this.fetch = bind(this.fetch, this);
    }

    AbstractClient.prototype.fetch = function(path, params) {
      var reqParams, reqURL, reqURLFormatted, self;
      if (params == null) {
        params = {};
      }
      reqParams = _.clone(this.api_url.query || {});
      _.assign(reqParams, this.default_params);
      _.assign(reqParams, params);
      reqURL = this.processURL(path, reqParams);
      delete reqURL.search;
      delete reqURL.path;
      reqURLFormatted = url.format(reqURL);
      self = this;
      return this.cache.get(reqURLFormatted).then(function(result) {
        return result;
      })["catch"](function() {
        var client;
        client = self;
        return http.request(reqURLFormatted).then(function(res) {
          if (res.status !== 200) {
            return Q.reject(new Error("API for '" + reqURLFormatted + "' returned with HTTP status code " + res.status));
          }
          return res.body.read();
        }).then(self.parser.parse).then(function(result) {
          return self.cache.set(reqURLFormatted, new Date(result.cachedUntil + ' +00').getTime(), result).then(function() {
            return result;
          });
        });
      });
    };

    return AbstractClient;

  })();

}).call(this);
