--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

force_power_crystal = {

	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
	craftingValues = {
		{"color",0,30,0},--actual color now managed in lootmanagerimp.cpp
		{"mindamage", 5,150,0},
		{"maxdamage", 10,225,0},
		{"attackspeed",0.0,-0.6,1},
		{"woundchance",0,0,0},
		{"forcecost",0,-10,0},
		--{"hitpoints",20,100,0},forcecost
		--{"midrangemod",4,20,0},
--		{"attackhealthcost",0,-9,0},
--		{"attackactioncost",0,-9,0},
--		{"attackmindcost",0,-9,0},
	},
	customizationStringNames = {},
	customizationValues = {}
}

--	minimumLevel = 0,
--	maximumLevel = -1,
--	customObjectName = "",
--	directObjectTemplate = "object/tangible/component/weapon/lightsaber/lightsaber_module_force_crystal.iff",
--	craftingValues = {
--		{"color",31,31,0},
----		{"hitpoints",700,1400,0},	
----		{"mindamage", 0,50,0},
----		{"maxdamage", 0,50,0},
----		{"attackspeed",0,-0.6,1},
----		{"woundchance",0,4,1},
----		{"useCount",1,10,0},
--	},
--	customizationStringNames = {},
--	customizationValues = {}
}

addLootItemTemplate("force_power_crystal", force_power_crystal)
