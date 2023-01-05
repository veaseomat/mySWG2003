global_death_watch_neutral_none = Lair:new {
	mobiles = {
		{"death_watch_bloodguard",2},
		{"death_watch_ghost",2},
		{"death_watch_wraith",1},
	},
	spawnLimit = 3,
	buildingsVeryEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsMedium = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsVeryHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_generic_2.iff",
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("global_death_watch_neutral_none", global_death_watch_neutral_none)
