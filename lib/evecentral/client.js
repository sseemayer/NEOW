(function() {
  var _, client, memoryCache, root, url,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  url = require('url');

  _ = require('lodash');

  client = require('../client');

  memoryCache = require('../caching/memory');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.EveCentralClient = (function(superClass) {
    extend(EveCentralClient, superClass);

    function EveCentralClient(default_params, api_url, cache, parser) {
      this.default_params = default_params != null ? default_params : {};
      if (api_url == null) {
        api_url = "http://api.eve-central.com/api/";
      }
      this.cache = cache != null ? cache : new memoryCache.MemoryCache;
      this.parser = parser != null ? parser : require('./parser');
      this.api_url = url.parse(api_url);
    }

    EveCentralClient.prototype.processURL = function(path, params) {
      return _.assign({}, this.api_url, {
        pathname: this.api_url.pathname + path,
        query: params
      });
    };

    return EveCentralClient;

  })(client.AbstractClient);

}).call(this);
