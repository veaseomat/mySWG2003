global_luke_skywalker = Lair:new {
	mobiles = {
	{"luke_skywalker2",2},
--	{"dark_jedi_knight",2},
--	{"dark_jedi_master",1}
	},
	spawnLimit = 12,
	buildingsVeryEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsEasy = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsMedium = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	buildingsVeryHard = {"object/building/poi/anywhere_misc_camp_small_1.iff"},
	missionBuilding = "object/tangible/lair/base/objective_power_generator.iff",
	mobType = "npc",
	buildingType = "theater",
}

addLairTemplate("global_luke_skywalker", global_luke_skywalker)
