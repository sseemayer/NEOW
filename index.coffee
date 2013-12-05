Q      = require 'q'
fs     = require 'q-io/fs'

neow = require './src'
params = require './config.json'

client = new neow.Client(params, 'https://api.eveonline.com')

# ###
## Skill tree with requirements

client.fetch('eve:SkillTree')

#fs.read('data/SkillTree.xml')
#  .then(parser.parse)

  .then (result) ->

    flatSkills = {}
    for grpID, grp of result.skillGroups
      for sklID, skl of grp.skills
        flatSkills[sklID] = skl

    for grpID, grp of result.skillGroups
      hasGroup = false
      for sklID, skl of grp.skills
        if skl.published != '0'

          if not hasGroup
            hasGroup = true
            console.log(grp.groupName)

          console.log("> #{skl.typeName} x#{skl.rank.content}")
          #console.log(skl.description.content)

          for rsklID, rskl of skl.requiredSkills
            console.log("  - #{flatSkills[rsklID].typeName} #{neow.format.romanSkill[rskl.skillLevel || 0]}")

  .done()
# ###



# ###
#
setTimeout ->
    skillTree_characterSheet = client.fetch('account:Characters')
    .get('characters').then (characters) ->
      for characterID, character of characters
        return characterID
    .then (characterID) ->
      Q.all([ client.fetch('eve:SkillTree'), client.fetch('char:CharacterSheet', characterID: characterID) ])

    #skillTree_characterSheet = Q.all [
    #  fs.read('data/SkillTree.xml')
    #    .then parser.parse
    #  fs.read('data/CharacterSheet.xml')
    #    .then parser.parse
    #]

    skillTree_characterSheet
    .then ([skillTree, characterSheet]) ->

      flatSkills = {}
      for grpID, grp of skillTree.skillGroups
        for sklID, skl of grp.skills
          flatSkills[sklID] = skl

      console.log characterSheet.name.content

      totalSP = 0
      for sklID, skl of characterSheet.skills
        stSkill = flatSkills[sklID]

        sklMultiplier = if stSkill.rank.content > 1 then " x" + stSkill.rank.content else ""
        skillPointsNextLevel = neow.eve.skillpointsToLevel[Math.min(parseInt(skl.level) + 1, 5)] * stSkill.rank.content
        console.log "- #{stSkill.typeName} #{neow.format.romanSkill[skl.level | 0]}#{sklMultiplier} (#{skl.skillpoints} / #{skillPointsNextLevel})"

        totalSP += parseInt(skl.skillpoints)

      console.log("Total #{totalSP} skillpoints.")

    .done()
  , 2000

# ###
