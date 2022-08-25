pvpljk = Creature:new {
	objectName = "",
	customName = "Light Jedi Knight",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "rebel",
	faction = "rebel",
	level = 350,
	elite = 2.0,
	chanceHit = 23.5,
	damageMin = 2000,
	damageMax = 4000,
	baseXp = 25266,
	baseHAM = 250000,
	baseHAMmax = 300000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,0},
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

CreatureTemplates:addCreatureTemplate(pvpljk, "pvpljk")
