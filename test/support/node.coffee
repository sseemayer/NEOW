chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
sinon = require 'sinon'
Q = require 'q'

chai.use chaiAsPromised

global.expect = chai.expect
global.fulfilledPromise = Q.resolve
global.rejectedPromise = Q.reject
global.defer = Q.defer
global.Q = Q
global.sinon = sinon
