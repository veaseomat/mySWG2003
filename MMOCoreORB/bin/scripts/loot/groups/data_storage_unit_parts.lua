data_storage_unit_parts = {
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
--		{itemTemplate = "datadisk_repair_kit", weight = 909095},
--		{itemTemplate = "datapad_broken", weight =     909090},
--		{itemTemplate = "datapad_backlight", weight = 909090},
--		{itemTemplate = "datapad_battery", weight = 909090},
--		{itemTemplate = "datapad_connectors", weight = 909090},
--		{itemTemplate = "datapad_casing", weight = 909095},
--		{itemTemplate = "corrupt_datadisk", weight = 909090},
--		{itemTemplate = "magnetic_burner", weight = 909090},
--		{itemTemplate = "magnetic_reader", weight = 909090},
--		{itemTemplate = "recovery_software", weight = 909090},
--		{itemTemplate = "wiring", weight = 909090},
	}
}

addLootGroupTemplate("data_storage_unit_parts", data_storage_unit_parts)
