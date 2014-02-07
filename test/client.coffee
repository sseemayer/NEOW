http = require 'q-io/http'
fs = require 'q-io/fs'

client = require '../src/client'
parser = require '../src/parser'

describe "Client", ->

  clnt = null

  beforeEach ->
    clnt = new client.Client
    sinon.spy parser, "parse"

    sinon.stub http, "request", (url) ->
      if url == 'https://api.eveonline.com/server/ServerStatus.xml.aspx?keyID=&vCode='
        fs.read('test/data/ServerStatus.xml')
          .then (result) -> { body: { read: () -> result }, status: 200 }
      else
        Q.reject Error "Queried invalid URL"

  afterEach ->
    http.request.restore()
    parser.parse.restore()

  it "should resolve on fetch", (done) =>
    expect(clnt.fetch('server:ServerStatus')).to.eventually.be.fulfilled.notify(done)

  it "should reject on fetch of invalid URL", (done) =>
    expect(clnt.fetch('xxx:xxx')).to.be.rejectedWith(Error).notify(done)

  it "should query the cache", (done) =>
    somedata = {some: 'data'}
    sinon.stub(clnt.cache, "get").returns Q somedata

    promise = clnt.fetch('server:ServerStatus')
      .then (result) ->

        Q.all [
          expect(result).to.deep.equal(somedata)
          expect(clnt.cache.get.calledOnce).to.be.true
        ]

    expect(promise).to.be.fulfilled.notify(done)

  
  it "should not request eve api for cache hits", (done) =>
    somedata = {some: 'data'}
    sinon.stub(clnt.cache, "get").returns Q somedata

    promise = clnt.fetch('server:ServerStatus')
      .then ->
        Q.all [
          expect(clnt.cache.get.calledOnce).to.be.true
          expect(http.request.notCalled).to.be.true
        ]

    expect(promise).to.be.fulfilled.notify(done)
    

  it "should request eve api for cache misses", (done) =>
    sinon.stub(clnt.cache, "get").returns Q.reject Error

    promise = clnt.fetch('server:ServerStatus')
      .then ->
        Q.all [
          expect(clnt.cache.get.calledOnce).to.be.true
          expect(http.request.calledOnce).to.be.true
        ]

    expect(promise).to.be.fulfilled.notify(done)

  it "should parse and set the cache after request", (done) =>
    sinon.stub(clnt.cache, "set").returns Q true

    promise = clnt.fetch('server:ServerStatus')
      .then ->
        Q.all [
          expect(clnt.cache.set.calledOnce).to.be.true
          expect(parser.parse.calledOnce).to.be.true
        ]

    expect(promise).to.be.fulfilled.notify(done)

