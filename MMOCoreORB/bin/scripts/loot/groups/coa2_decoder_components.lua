coa2_decoder_components = {
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
--		{itemTemplate = "coa_decoder_housing", weight = 1666667},
--		{itemTemplate = "coa_decoder_power", weight = 1666667},
--		{itemTemplate = "coa_decoder_processor", weight = 1666667},
--		{itemTemplate = "coa_decoder_reader", weight = 1666667},
--		{itemTemplate = "coa_decoder_screen", weight = 1666666},
--		{itemTemplate = "coa_decoder_translation", weight = 1666666},
	}
}

addLootGroupTemplate("coa2_decoder_components", coa2_decoder_components)
