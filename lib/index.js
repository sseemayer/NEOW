(function() {
  var eve, eveApiClient, eveCentralClient, format, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  eveApiClient = require('./eveapi/client');

  eveCentralClient = require('./evecentral/client');

  eve = require('./eve');

  format = require('./format');

  root.EveClient = eveApiClient.EveClient;

  root.Client = root.EveClient;

  root.EveCentralClient = eveCentralClient.EveCentralClient;

  root.eve = eve;

  root.format = format;

}).call(this);
