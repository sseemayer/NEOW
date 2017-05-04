(function() {
  var crypto, root, sha1sum;

  crypto = require('crypto');

  sha1sum = crypto.createHash('sha1');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.hashIdentifier = function(identifier) {
    return crypto.createHash('sha1').update(identifier).digest('hex');
  };

  root.cacheExpired = function(cacheUntil, now) {
    if (now == null) {
      now = Date.now();
    }
    return cacheUntil < now;
  };

  root.Cache = (function() {
    function Cache() {}

    Cache.prototype.get = function(identifier) {
      return this._get(root.hashIdentifier(identifier));
    };

    Cache.prototype.set = function(identifier, cacheUntil, data) {
      return this._set(root.hashIdentifier(identifier), cacheUntil, data);
    };

    Cache.prototype.del = function(identifier) {
      return this._del(root.hashIdentifier(identifier));
    };

    Cache.prototype._get = function(idHex) {
      throw new Error('Not implemented in base class!');
    };

    Cache.prototype._set = function(idHex, cacheUntil, data) {
      throw new Error('Not implemented in base class!');
    };

    Cache.prototype._del = function(idHex) {
      throw new Error('Not implemented in base class!');
    };

    return Cache;

  })();

}).call(this);
