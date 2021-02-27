--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

saber1h1 = {
	minimumLevel = 0,
	maximumLevel =-1,
	newmaximumLevel = 1,
	customObjectName = "Knight's Lightsaber",
	directObjectTemplate = "object/weapon/melee/sword/crafted_saber/sword_lightsaber_one_handed_s1_gen1.iff",
	craftingValues = {
		{"mindamage",360,460,0},
		{"maxdamage",470,570,0},
		{"attackspeed",2.4,1.8,1},
		{"woundchance",60.2,64.2,0},
		{"hitpoints",1000,1000,0},
		{"zerorangemod",20,20,0},
		{"maxrangemod",5,5,0},
		{"midrange",3,3,0},
		{"midrangemod",15,15,0},
		{"maxrange",5,5,0},
		{"attackhealthcost",10,10,0},
		{"attackactioncost",15,10,0},
		{"attackmindcost",35,25,0},
		{"forcecost",18.0,16.0,0},
		
	},
	customizationStringNames = {},
	customizationValues = {},

	-- randomDotChance: The chance of this weapon object dropping with a random dot on it. Higher number means less chance. Set to 0 to always have a random dot.
	randomDotChance = -1,
	junkDealerTypeNeeded = JUNKARMS,
	junkMinValue = 2500,
	junkMaxValue = 4500

}

addLootItemTemplate("saber1h1", saber1h1)
