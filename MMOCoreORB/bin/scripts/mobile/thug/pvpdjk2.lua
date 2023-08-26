pvpdjk2 = Creature:new {
	objectName = "",
	customName = "Dark Jedi Templar",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 350,
	elite = 1.5,
	chanceHit = 23.5,
	damageMin = 1645,
	damageMax = 3000,
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
--				{group = "holocron_dark", chance = 300000},
				{group = "color_crystals", chance = 1000000},
--				{group = "sabers", chance = 1000000}
			}
		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks =	merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(pvpdjk2, "pvpdjk2")
