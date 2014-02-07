Q      = require 'q'
fs     = require 'q-io/fs'

neow = require './src'
params = require './config.json'

client = new neow.Client(params, 'https://api.eveonline.com')

####
## Skill tree with requirements

client.fetch('eve:SkillTree')
  .then (result) ->

    # Flatten skills into a single ID -> skill lookup table
    flatSkills = {}
    for grpID, grp of result.skillGroups
      for sklID, skl of grp.skills
        flatSkills[sklID] = skl

    # Print out grouped skills
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


####
## Skills for first character in account
#
# The timeout is used to give NEOW a chance to reuse the eve:SkillTree from the cache
setTimeout ->
    client.fetch('account:Characters')
      .get('characters').then (characters) ->

        # quickly and dirtily get the first character
        for characterID, character of characters
          return characterID

      .then (characterID) ->

        # We need both the eve:SkillTreeand the char:CharacterSheet
        Q.all([ client.fetch('eve:SkillTree'), client.fetch('char:CharacterSheet', characterID: characterID) ])

      .then ([skillTree, characterSheet]) ->

        # Flatten the skills into a single ID -> skill hash instead of using groups for lookin up skill data later
        flatSkills = {}
        for grpID, grp of skillTree.skillGroups
          for sklID, skl of grp.skills
            flatSkills[sklID] = skl

        console.log "#{characterSheet.name.content} (ID #{characterSheet.characterID.content})"

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
