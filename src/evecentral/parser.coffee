Q = require 'q'
_ = require 'lodash'
xml2js = require 'xml2js'

root = exports ? this

root.parse = (data, strict=true) ->
  Q.nfapply(xml2js.parseString, [data, {explicitArray: false, mergeAttrs: true}])
    .get('evec_api')

