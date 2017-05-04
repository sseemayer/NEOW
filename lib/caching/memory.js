(function() {
  var Q, caching, root,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Q = require('q');

  caching = require('./index');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.MemoryCache = (function(superClass) {
    extend(MemoryCache, superClass);

    function MemoryCache() {
      this.cache = {};
    }

    MemoryCache.prototype._get = function(idHex) {
      var element;
      element = this.cache[idHex];
      if (typeof element === 'undefined') {
        return Q.reject(new Error("Element " + idHex + " not found in cache!"));
      }
      if (caching.cacheExpired(element.cacheUntil)) {
        return this.del(idHex).then(function() {
          return Q.reject(new Error("Element " + idHex + " has expired"));
        });
      }
      return Q(element.data);
    };

    MemoryCache.prototype._set = function(idHex, cacheUntil, data) {
      var element;
      element = {
        cacheUntil: cacheUntil,
        data: data
      };
      this.cache[idHex] = element;
      return Q(true);
    };

    MemoryCache.prototype._del = function(idHex) {
      delete this.cache[idHex];
      return Q(true);
    };

    return MemoryCache;

  })(caching.Cache);

}).call(this);
