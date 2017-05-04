(function() {
  var Q, caching, fs, path, qfs, root,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  fs = require('fs');

  path = require('path');

  Q = require('q');

  qfs = require('q-io/fs');

  caching = require('./index');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.DiskCache = (function(superClass) {
    extend(DiskCache, superClass);

    function DiskCache(folder) {
      this.folder = folder != null ? folder : '/tmp/eveapi-cache';
      if (!fs.existsSync(this.folder)) {
        fs.mkdirSync(this.folder);
      }
    }

    DiskCache.prototype.get_path = function(idHex) {
      return path.resolve(this.folder, idHex);
    };

    DiskCache.prototype._get = function(idHex) {
      return qfs.read(this.get_path(idHex)).then(JSON.parse).then(function(element) {
        if (caching.cacheExpired(element.cacheUntil)) {
          return this.del(idHex).then(function() {
            return Q.reject(new Error("Element " + idHex + " has expired"));
          });
        }
        return Q(element.data).then(JSON.parse);
      });
    };

    DiskCache.prototype._set = function(idHex, cacheUntil, data) {
      var element;
      element = {
        cacheUntil: cacheUntil,
        data: JSON.stringify(data)
      };
      return qfs.write(this.get_path(idHex), JSON.stringify(element)).then(function() {
        return true;
      });
    };

    DiskCache.prototype._del = function(idHex) {
      return qfs.remove(this.get_path(idHex)).then(function() {
        return true;
      });
    };

    return DiskCache;

  })(caching.Cache);

}).call(this);
