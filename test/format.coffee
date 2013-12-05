
format = require '../src/format'
fs = require 'q-io/fs'


describe "format", ->

  it "should format ISK numbers", ->
    expect(format.isk(1234.56)).to.equal("1,234.56 ISK")

  it "should format ISK strings", ->
    expect(format.isk("1234.56")).to.equal("1,234.56 ISK")

  it "should format short ISK numbers", ->
    expect(format.iskShort(1234567.89)).to.equal("1.23M ISK")
