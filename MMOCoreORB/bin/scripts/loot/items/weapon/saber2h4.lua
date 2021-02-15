--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

saber2h4 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Trophy Lightsaber",
	directObjectTemplate = "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_s4_gen1.iff",
	craftingValues = {
		{"mindamage",130,150,0},
		{"maxdamage",150,180,0},
		{"attackspeed",1.0,1.0,0},
		{"woundchance",100,100,0},
		{"hitpoints",1000,1000,0},
		{"zerorangemod",20,20,0},
		{"maxrangemod",5,5,0},
		{"midrange",3,3,0},
		{"midrangemod",15,15,0},
		{"maxrange",5,5,0},
		{"attackhealthcost",0,0,0},
		{"attackactioncost",1,1,0},
		{"attackmindcost",0,0,0},
		{"forcecost",2,2,0},
		
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = -1,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 25,
	junkMaxValue = 45

}

addLootItemTemplate("saber2h4", saber2h4)
