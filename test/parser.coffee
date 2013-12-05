parser = require '../src/parser'
fs = require 'q-io/fs'

xmlFile = 'test/data/Characters.xml'
bigXmlFile = 'test/data/SkillTree.xml'

describe "parser", ->

  promise = null

  beforeEach ->
    promise = fs.read(xmlFile)
      .then(parser.parse)

  it "should fulfil after parsing", (done) ->
    expect(promise).to.be.fulfilled.notify(done)

  it "should return cachedUntil and currentTime fields", (done) ->
    expect(Q.all [
      expect(promise).to.eventually.have.property('cachedUntil').that.is.a('string')
      expect(promise).to.eventually.have.property('currentTime').that.is.a('string')
    ]).notify(done)

  it "should return character list with two characters", (done) ->
    expect(Q.all [
      expect(promise).to.eventually.have.deep.property('characters[12345678].name', 'Tester Char')
      expect(promise).to.eventually.have.deep.property('characters[98765432].name', 'Another Tester')
    ]).notify(done)

describe "parser with skilltree", ->
  promise = null

  beforeEach ->
    promise = fs.read(bigXmlFile)
      .then(parser.parse)

  it "should have the drones skill", (done) ->
    expect(promise).to.eventually.have.deep.property('skillGroups[273].skills[3436].typeName', 'Drones').notify(done)
