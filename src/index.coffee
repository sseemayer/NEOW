
root = exports ? this

eveApiClient = require './eveapi/client'
eveCentralClient = require './evecentral/client'

eve = require './eve'
format = require './format'

root.EveClient = eveApiClient.EveClient
root.Client = root.EveClient # Backward compatibility

root.EveCentralClient = eveCentralClient.EveCentralClient

root.eve = eve
root.format = format
