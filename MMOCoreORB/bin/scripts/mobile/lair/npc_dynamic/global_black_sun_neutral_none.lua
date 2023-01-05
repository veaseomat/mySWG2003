global_black_sun_neutral_none = Lair:new {
	mobiles = {
		{"black_sun_assassin",1},
		{"black_sun_guard",2},
		{"black_sun_henchman",2},
		{"black_sun_thug",3}
	},
	spawnLimit = 6,
	buildingsVeryEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsMedium = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsVeryHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_generic_2.iff",
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("global_black_sun_neutral_none", global_black_sun_neutral_none)
