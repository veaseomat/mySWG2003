coa_encoded_disk_fragments = {
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
--		{itemTemplate = "coa_imp_1", weight = 1250000},
--		{itemTemplate = "coa_imp_2", weight = 1250000},
--		{itemTemplate = "coa_imp_3", weight = 1250000},
--		{itemTemplate = "coa_imp_4", weight = 1250000},
--		{itemTemplate = "coa_reb_1", weight = 1250000},
--		{itemTemplate = "coa_reb_2", weight = 1250000},
--		{itemTemplate = "coa_reb_3", weight = 1250000},
--		{itemTemplate = "coa_reb_4", weight = 1250000},
	}
}

addLootGroupTemplate("coa_encoded_disk_fragments", coa_encoded_disk_fragments)
