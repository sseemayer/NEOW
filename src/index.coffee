
root = exports ? this

client = require './client'
eve = require './eve'
format = require './format'

root.Client = client.Client
root.eve = eve
root.format = format
