(function() {
  var Q, _, root, sax;

  Q = require('q');

  _ = require('lodash');

  sax = require('sax');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.parse = function(data, strict) {
    var current, deferred, down, parser, peek, result, stack, up;
    if (strict == null) {
      strict = true;
    }
    deferred = Q.defer();
    parser = sax.createStream(strict, {
      trim: true
    });
    result = {};
    stack = [];
    current = {
      element: result,
      name: null
    };
    down = function(newframe) {
      stack.push(newframe);
      return newframe;
    };
    up = function() {
      var head;
      head = stack.pop();
      return peek();
    };
    peek = function() {
      return stack[stack.length - 1];
    };
    parser.on('error', function(err) {
      return deferred.reject(err);
    });
    parser.on('opentag', function(node) {
      var key, keyKey;
      if (node.name === 'row') {
        keyKey = current.key;
      } else {
        keyKey = 'name';
      }
      key = node.attributes[keyKey];
      if (!key) {
        key = node.name;
      }
      if (!current.element[key]) {
        current.element[key] = {};
      }
      if (node.name !== 'rowset') {
        _.merge(current.element[key], node.attributes);
      }
      return current = down({
        element: current.element[key],
        name: node.name,
        key: node.attributes.key
      });
    });
    parser.on('closetag', function(tagName) {
      var head;
      head = peek();
      if (!head) {
        return;
      }
      if (head.name === tagName) {
        return current = up();
      }
    });
    parser.on('text', function(text) {
      return current.element.content = text;
    });
    parser.on('end', function() {
      var res;
      if (!result.eveapi) {
        return deferred.reject(new Error("Malformed XML reply!"));
      }
      if (result.eveapi.version !== '2') {
        return deferred.reject(new Error("Wrong eveapi version!"));
      }
      if (result.eveapi.error) {
        return deferred.reject(new Error(result.eveapi.error.content));
      }
      res = result.eveapi.result;
      res.currentTime = result.eveapi.currentTime.content;
      res.cachedUntil = result.eveapi.cachedUntil.content;
      return deferred.resolve(res);
    });
    if (data.pipe) {
      data.pipe(parser);
    } else {
      parser.write(data);
      parser.end();
    }
    return deferred.promise;
  };

}).call(this);
