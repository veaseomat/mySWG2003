pvpdjk4 = Creature:new {
	objectName = "",
	customName = "Dark Council Member",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 350,
	elite = 2.0,
	chanceHit = 23.5,
	damageMin = 1800,
	damageMax = 3310,
	baseXp = 25266,
	baseHAM = 90000,
	baseHAMmax = 101000,
	armor = 3,
	resists = {80,80,80,80,80,80,80,50,-1},
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
				{group = "rcp2", chance = 7000000},
				{group = "dark_jedi_common", chance = 3000000},
			},
		},
		{
			groups = {
				{group = "junk", chance = 3000000},
				{group = "dark_jedi_common", chance = 7000000},
			},
		},
		{
			groups = {
				{group = "junk", chance = 5000000},
				{group = "dark_jedi_common", chance = 5000000},		
			},
		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks =	merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(pvpdjk4, "pvpdjk4")
