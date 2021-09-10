bounty_hunter_thug = Creature:new {
	objectName = "@mob/creature_names:bounty_hunter",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "mercenary",
	faction = "",
	level = 24,
	chanceHit = 0.35,
	damageMin = 220,
	damageMax = 230,
	baseXp = 2443,
	baseHAM = 6300,
	baseHAMmax = 7700,
	armor = 0,
	resists = {20,20,0,0,0,0,-1,-1,-1},
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
	optionsBitmask = AIENABLED,
	creatureBitmask = KILLER,
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
	lootGroups = {
		{
			groups = {
				{group = "junk", chance = 1500000},
				{group = "wearables_common", chance = 2000000},
				{group = "grenades_looted", chance = 1000000},
				{group = "armor_all", chance = 1500000},
				{group = "rifles", chance = 1000000},
				{group = "carbines", chance = 1000000},
				{group = "tailor_components", chance = 1000000},
				{group = "loot_kit_parts", chance = 1000000}
			}
		}
	},
	weapons = {"pirate_weapons_heavy"},
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(bounty_hunter_thug, "bounty_hunter_thug")
