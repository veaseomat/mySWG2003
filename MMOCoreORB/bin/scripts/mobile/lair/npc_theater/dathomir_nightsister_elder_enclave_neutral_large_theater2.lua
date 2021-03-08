dathomir_nightsister_elder_enclave_neutral_large_theater2 = Lair:new {
	mobiles = {
		{"nightsister_protector",1},
		{"nightsister_spell_weaver",1},	
		{"nightsister_sentinel",2},
		{"nightsister_ranger",2},
		{"nightsister_initiate",4},
		{"nightsister_stalker",2},
	},
	bossMobiles = {{"nightsister_elder",1}},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/tangible/lair/base/poi_all_lair_rocks_large.iff"},
	buildingsEasy = {"object/tangible/lair/base/poi_all_lair_rocks_large.iff"},
	buildingsMedium = {"object/tangible/lair/base/poi_all_lair_rocks_large.iff"},
	buildingsHard = {"object/tangible/lair/base/poi_all_lair_rocks_large.iff"},
	buildingsVeryHard = {"object/tangible/lair/base/poi_all_lair_rocks_large.iff"},
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("dathomir_nightsister_elder_enclave_neutral_large_theater2", dathomir_nightsister_elder_enclave_neutral_large_theater2)
