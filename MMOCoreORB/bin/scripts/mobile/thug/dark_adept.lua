dark_adept = Creature:new {
	objectName = "@mob/creature_names:dark_adept",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "dark_jedi",
	faction = "",
	level = 50,
	elite = 1.5,
	chanceHit = 4.75,
	damageMin = 945,
	damageMax = 1600,
	baseXp = 13178,
	baseHAM = 50000,
	baseHAMmax = 61000,
	armor = 1,
	resists = {80,80,80,80,80,80,80,80,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = { "dark_jedi" },
	lootGroups = {
		{
			groups = {
				{group = "armor_attachments", chance = 900000},
				{group = "clothing_attachments", chance = 900000},
				{group = "armor_all", chance = 800000},
				{group = "rifles", chance = 700000},
				{group = "carbines", chance = 700000},
				{group = "pistols", chance = 2900000},
				{group = "melee_weapons", chance = 1300000},
				{group = "power_crystals", chance = 700000},
				{group = "color_crystals", chance = 700000},
				{group = "holocron_3", chance = 1000000},
			}
		}
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster,forcewielder)
}

CreatureTemplates:addCreatureTemplate(dark_adept, "dark_adept")
