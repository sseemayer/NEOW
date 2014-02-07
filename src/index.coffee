
root = exports ? this

eveApiClient = require './eveapi/client'
eveCentralClient = require './evecentral/client'

eve = require './eve'
format = require './format'

root.Client = eveApiClient.Client
root.EveCentralClient = eveCentralClient.EveCentralClient

root.eve = eve
root.format = format
