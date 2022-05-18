boba_fett2 = Creature:new {
	objectName = "@mob/creature_names:bounty_hunter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "",
	faction = "",
	level = 300,
	chanceHit = 55,
	damageMin = 1200,
	damageMax = 2300,
	baseXp = 9336,
	baseHAM = 90000,
	baseHAMmax = 101000,
	armor = 2,
	resists = {80,80,80,80,80,80,80,80,0},
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

	templates = {"object/mobile/dressed_bountyhunter_trainer_01.iff",
		"object/mobile/dressed_bountyhunter_trainer_02.iff",
		"object/mobile/dressed_bountyhunter_trainer_03.iff",
		"object/mobile/dressed_bounty_hunter_zabrak_female_01.iff",
		"object/mobile/dressed_mercenary_warlord_hum_m.iff",
		"object/mobile/dressed_mercenary_warlord_nikto_m.iff",
		"object/mobile/dressed_mercenary_warlord_wee_m.iff",
		"object/mobile/dressed_tatooine_gunrunner.iff",
		"object/mobile/dressed_tatooine_desert_demon_bodyguard.iff",
		"object/mobile/dressed_mugger.iff",
		"object/mobile/dressed_hoodlum_zabrak_female_01.iff",
		"object/mobile/dressed_robber_twk_male_01.iff",
		"object/mobile/dressed_criminal_thug_human_female_01.iff",
		"object/mobile/dressed_robber_twk_female_01.iff",
		"object/mobile/dressed_crook_zabrak_male_01.iff",
		"object/mobile/dressed_hooligan_rodian_female_01.iff",
		"object/mobile/dressed_criminal_pirate_human_male_01.iff",
		"object/mobile/dressed_criminal_pirate_human_female_01.iff",
		"object/mobile/dressed_criminal_thug_aqualish_male_01.iff",
		"object/mobile/dressed_criminal_thug_aqualish_male_02.iff",
		"object/mobile/dressed_criminal_thug_aqualish_female_01.iff",
		"object/mobile/dressed_criminal_thug_aqualish_female_02.iff",
		"object/mobile/dressed_criminal_thug_bothan_male_01.iff",
		"object/mobile/dressed_criminal_thug_bothan_female_01.iff",
		"object/mobile/dressed_criminal_thug_human_male_01.iff",
		"object/mobile/dressed_criminal_thug_human_male_02.iff",
		"object/mobile/dressed_criminal_thug_human_female_01.iff",
		"object/mobile/dressed_criminal_thug_human_female_02.iff",
		"object/mobile/dressed_criminal_thug_rodian_male_01.iff",
		"object/mobile/dressed_criminal_thug_rodian_female_01.iff",
		"object/mobile/dressed_criminal_thug_trandoshan_male_01.iff",
		"object/mobile/dressed_criminal_thug_trandoshan_female_01.iff",
		"object/mobile/dressed_criminal_thug_zabrak_male_01.iff",
		"object/mobile/dressed_criminal_thug_zabrak_female_01.iff",
		"object/mobile/dressed_black_sun_assassin.iff",
		"object/mobile/dressed_black_sun_guard.iff",
		"object/mobile/dressed_black_sun_henchman.iff",
		"object/mobile/dressed_black_sun_thug.iff",
		"object/mobile/dressed_death_watch_gold.iff",
		"object/mobile/dressed_death_watch_silver.iff",
		"object/mobile/dressed_death_watch_red.iff",
		"object/mobile/dressed_death_watch_grey.iff"},
	lootGroups = {},
	weapons = {"bh_weapons"},
	conversationTemplate = "",
	attacks =	{
		{"dizzyattack",""},
		{"knockdownattack",""}
	}
}

CreatureTemplates:addCreatureTemplate(boba_fett2, "boba_fett2")