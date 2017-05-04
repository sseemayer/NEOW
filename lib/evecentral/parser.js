(function() {
  var Q, _, root, xml2js;

  Q = require('q');

  _ = require('lodash');

  xml2js = require('xml2js');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.parse = function(data, strict) {
    if (strict == null) {
      strict = true;
    }
    return Q.nfapply(xml2js.parseString, [
      data, {
        explicitArray: false,
        mergeAttrs: true
      }
    ]).get('evec_api');
  };

}).call(this);
