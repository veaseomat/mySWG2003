--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

saber2h3 = {
	minimumLevel = 0,
	maximumLevel =-1,
	newmaximumLevel = 1,
	customObjectName = "Knight's Lightsaber",
	directObjectTemplate = "object/weapon/melee/2h_sword/crafted_saber/sword_lightsaber_two_handed_s3_gen1.iff",
	craftingValues = {
		{"mindamage",395,495,0},
		{"maxdamage",505,605,0},
		{"attackspeed",2.7,2.1,1},
		{"woundchance",60.2,64.2,0},
		{"hitpoints",1000,1000,0},
		{"zerorangemod",20,20,0},
		{"maxrangemod",5,5,0},
		{"midrange",3,3,0},
		{"midrangemod",15,15,0},
		{"maxrange",5,5,0},
		{"attackhealthcost",35,25,0},
		{"attackactioncost",15,10,0},
		{"attackmindcost",10,10,0},
		{"forcecost",18.0,16.0,0},
		
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = -1,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 25,
	junkMaxValue = 45

}

addLootItemTemplate("saber2h3", saber2h3)
