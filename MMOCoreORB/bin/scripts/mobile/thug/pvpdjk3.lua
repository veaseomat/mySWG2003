pvpdjk3 = Creature:new {
	objectName = "",
	customName = "Dark Jedi Oppressor",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 325,
	elite = 1.75,
	chanceHit = 23.5,
	damageMin = 1645,
	damageMax = 3000,
	baseXp = 25266,
	baseHAM = 90000,
	baseHAMmax = 101000,
	armor = 2,
	resists = {80,80,80,80,80,80,80,40,-1},
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
		{
			groups = {
				{group = "junk", chance = 7000000},
				{group = "dark_jedi_common", chance = 3000000},		
			},
		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks =	merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(pvpdjk3, "pvpdjk3")
