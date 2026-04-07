pvpdjk = Creature:new {
	objectName = "",
	customName = "Dark Jedi Enforcer",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 275,
	elite = 1.25,
	chanceHit = 23.5,
	damageMin = 945,
	damageMax = 1600,
	baseXp = 25266,
	baseHAM = 90000,
	baseHAMmax = 101000,
	armor = 1,
	resists = {80,80,80,80,80,80,80,20,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = { 
		--"dark_jedi" 
		"jedi",
	},
	lootGroups = {
		{
			groups = {
				{group = "junk", chance = 9000000},
				{group = "dark_jedi_common", chance = 9000000},
			},
		},
--		{
--			groups = {
--				{group = "junk", chance = 9000000},
--				{group = "dark_jedi_common", chance = 9000000},
--			},
--		},
--		{
--			groups = {
--				{group = "junk", chance = 9000000},
--				{group = "dark_jedi_common", chance = 9000000},		
--			},
--		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks =	merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(pvpdjk, "pvpdjk")
