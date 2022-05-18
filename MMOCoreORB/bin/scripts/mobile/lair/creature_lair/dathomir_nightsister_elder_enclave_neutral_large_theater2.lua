dathomir_nightsister_elder_enclave_neutral_large_theater2 = Lair:new {
	mobiles = {
		{"nightsister_protector",1},
		{"nightsister_spell_weaver",2},	
		{"nightsister_sentinel",4},
		{"nightsister_initiate",4},
	},
	bossMobiles = {{"nightsister_elder",1}},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	buildingsEasy = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	buildingsMedium = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	buildingsHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	buildingsVeryHard = {"object/building/poi/dathomir_nightsisterpatrol_large1.iff","object/building/poi/dathomir_nightsisterpatrol_large2.iff"},
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("dathomir_nightsister_elder_enclave_neutral_large_theater2", dathomir_nightsister_elder_enclave_neutral_large_theater2)
