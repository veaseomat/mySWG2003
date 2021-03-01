light_jedi_knight = Creature:new {
	objectName = "",
	customName = "a Light Jedi Knight",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 265,
	chanceHit = 23.5,
	damageMin = 1645,
	damageMax = 3000,
	baseXp = 25266,
	baseHAM = 261000,
	baseHAMmax = 320000,
	armor = 3,
	resists = {90,90,90,90,90,90,90,90,-1},
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
				{group = "junk", chance = 3000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "holocron_dark", chance = 1000000},
				{group = "color_crystals", chance = 1000000},
				{group = "sabers", chance = 1000000}
			}
		},
	},
	weapons = {"dark_jedi_weapons_gen2"},
	conversationTemplate = "",
	attacks = merge(lightsabermaster,forcepowermaster)
}

CreatureTemplates:addCreatureTemplate(light_jedi_knight, "light_jedi_knight")
