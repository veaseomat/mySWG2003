armor_all = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		-- Common
		{itemTemplate = "chitin_armor_boots", weight = 625000},
		{itemTemplate = "chitin_armor_leggings", weight = 625000},
		
		{itemTemplate = "chitin_armor_bracer_l", weight = 250000},
		{itemTemplate = "chitin_armor_bracer_r", weight = 250000},
		{itemTemplate = "chitin_armor_bicep_l", weight = 250000},
		{itemTemplate = "chitin_armor_bicep_r", weight = 250000},
		{itemTemplate = "chitin_armor_gloves", weight = 250000},
		
		{itemTemplate = "chitin_armor_chest_plate", weight = 1250000},

		{itemTemplate = "chitin_armor_helmet", weight = 1250000},
		-- Uncommon
		{itemTemplate = "ubese_armor_pants", weight = 250000},
		{itemTemplate = "ubese_armor_boots", weight = 250000},
		{itemTemplate = "ubese_armor_gloves", weight = 250000},
				
		{itemTemplate = "ubese_armor_bracer_l", weight = 375000},
		{itemTemplate = "ubese_armor_bracer_r", weight = 375000},

		{itemTemplate = "ubese_armor_helmet", weight = 750000},
		
		{itemTemplate = "ubese_armor_jacket", weight = 750000},
		-- Rare
		{itemTemplate = "composite_armor_bicep_l", weight = 100000},
		{itemTemplate = "composite_armor_bicep_r", weight = 100000},
		{itemTemplate = "composite_armor_bracer_l", weight = 100000},
		{itemTemplate = "composite_armor_bracer_r", weight = 100000},
		{itemTemplate = "composite_armor_gloves", weight = 100000},
				
		{itemTemplate = "composite_armor_boots", weight = 250000},
		{itemTemplate = "composite_armor_leggings", weight = 250000},
		
		{itemTemplate = "composite_armor_chest_plate", weight = 500000},

		{itemTemplate = "composite_armor_helmet", weight = 500000},

	}
}

addLootGroupTemplate("armor_all", armor_all)
