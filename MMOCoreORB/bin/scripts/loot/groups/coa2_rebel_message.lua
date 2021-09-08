coa2_rebel_message = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "weapons_all", weight = 2000000},
		{groupTemplate = "armor_all", weight = 2000000},
		{groupTemplate = "wearables_all", weight = 1000000},			
		{groupTemplate = "weapon_component", weight = 1000000},
		{groupTemplate = "tailor_components", weight = 1000000},
		{groupTemplate = "chemistry_component", weight = 1000000},
		{groupTemplate = "attachment_clothing", weight = 500000},	
		{groupTemplate = "attachment_armor", weight = 500000},
		{itemTemplate = "locked_container", weight = 500000},
		{groupTemplate = "skill_buffs", weight = 500000},
--		{itemTemplate = "coa_rebel_message", weight = 10000000},
	}
}

addLootGroupTemplate("coa2_rebel_message", coa2_rebel_message)
