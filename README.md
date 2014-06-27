# NEOW
[![Build Status](https://drone.io/github.com/sseemayer/NEOW/status.png)](https://drone.io/github.com/sseemayer/NEOW/latest)
[![Build Status](https://travis-ci.org/sseemayer/NEOW.svg?branch=master)](https://travis-ci.org/sseemayer/NEOW)

_N_ode.js _E_VE _O_nline API _W_rapper for the modern days - Promises, CoffeeScript, Tests, Caching, etc.

NEOW tries to be the best EVE Online and EVE-Central API wrapper available for Node.js. In contrast to hamster.js, NEOW can parse nested &lt;rowset&gt; elements such as found in the `eve/SkillTree.xml.aspx` API without returning garbled/partial results. It also includes support for parsing eve-central market data.

## Features

  * Access all of the EVE API
  * Access the EVE Central API
  * Memory and Disk Caching
  * Formatters for skill levels, ISK values, etc.
  * Unit tested
  * Examples included

## Installation

	npm install neow

## Usage

### JavaScript

	neow = require('neow');

	client = new neow.EveClient({
		keyID: '1234567',
		vCode: 'nyanyanyanyanyanyanyanyan'
	});

	client.fetch('account:Characters')
		.then(function(result){
			for(characterID in result.characters) {
				console.log(result.characters[characterID])
			}
		})
		.done().

### CoffeeScript

	neow = require 'neow'

	client = new neow.EveClient
		keyID: '1234567'
		vCode: 'nyanyanyanyanyanyanyanyan'
	
	client.fetch('account:Characters')
		.then (result) ->
			for characterID, character of result.characters
				console.log character
		.done()

## License
MIT
