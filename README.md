# NEOW

_N_ode.js _E_VE _O_nline API _W_rapper for the modern days - Promises, CoffeeScript, Tests, Caching, etc.

In contrast to hamster.js, NEOW can parse nested &lt;rowset&gt; elements such as found in the `eve/SkillTree.xml.aspx` API without returning garbled/partial results. Also, it's written in CoffeeScript :)

## Usage

	neow = require('neow');

	client = new neow.Client({
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
