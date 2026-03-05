pvpljk4 = Creature:new {
	objectName = "",
	customName = "Jedi Coincil Member",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 350,
	elite = 2.0,
	chanceHit = 23.5,
	damageMin = 1645,
	damageMax = 3000,
	baseXp = 25266,
	baseHAM = 90000,
	baseHAMmax = 101000,
	armor = 1,
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
--		"object/mobile/dressed_jedi_trainer_old_human_male_01.iff",
--		"object/mobile/dressed_jedi_trainer_chiss_male_01.iff",
--		"object/mobile/dressed_jedi_trainer_nikto_male_01.iff",
--		"object/mobile/dressed_jedi_trainer_twilek_female_01.iff",
--		"object/mobile/dressed_tiberus_anderlock.iff",
--		"object/mobile/dressed_neja_bertolo.iff"
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

CreatureTemplates:addCreatureTemplate(pvpljk4, "pvpljk4")
