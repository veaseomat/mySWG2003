global_captain_patrol_imperial_none = Lair:new {
	mobiles = {
		{"imperial_army_captain",1},
		{"imperial_major",1},
		{"imperial_sergeant",2},
		{"imperial_trooper",3},
		{"rebel_army_captain",1},
		{"rebel_first_lieutenant",1},
		{"rebel_sergeant",2},
		{"rebel_trooper",4}
	},
	spawnLimit = 20,
	buildingsVeryEasy = {},
	buildingsEasy = {},
	buildingsMedium = {},
	buildingsHard = {},
	buildingsVeryHard = {},
	mobType = "npc",
	buildingType = "none"
}

addLairTemplate("global_captain_patrol_imperial_none", global_captain_patrol_imperial_none)
