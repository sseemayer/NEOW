(function() {
  var _, client, memoryCache, root, url,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  url = require('url');

  _ = require('lodash');

  client = require('../client');

  memoryCache = require('../caching/memory');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.EveClient = (function(superClass) {
    extend(EveClient, superClass);

    function EveClient(default_params, api_url, cache, parser) {
      this.default_params = default_params != null ? default_params : {
        keyID: null,
        vCode: null
      };
      if (api_url == null) {
        api_url = "https://api.eveonline.com";
      }
      this.cache = cache != null ? cache : new memoryCache.MemoryCache;
      this.parser = parser != null ? parser : require('./parser');
      this.api_url = url.parse(api_url);
    }

    EveClient.prototype.processURL = function(path, params) {
      return _.assign({}, this.api_url, {
        pathname: path.replace(/^\//, '').replace(/:/, '/').replace(/\.xml\.aspx$/, '') + '.xml.aspx',
        query: params
      });
    };

    return EveClient;

  })(client.AbstractClient);

  root.Client = root.EveClient;

}).call(this);
