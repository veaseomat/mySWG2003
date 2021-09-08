looted_container = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		-- Junk/Misc Items (25% chance)
		-- Common
--		{itemTemplate = "broken_decryptor", weight = 87719},
--		{itemTemplate = "camera", weight = 87719},
--		{itemTemplate = "corrupt_datadisk", weight = 87719},
--		{itemTemplate = "corsec_id_badge", weight = 87719},
--		{itemTemplate = "damaged_datapad", weight = 87719},
--		{itemTemplate = "decorative_bowl", weight = 87719},
--		{itemTemplate = "decorative_shisa", weight = 87719},
--		{itemTemplate = "dermal_analyzer", weight = 87719},
--		{itemTemplate = "dud_firework_grey", weight = 87719},
--		{itemTemplate = "dud_firework_red", weight = 87719},
--		{itemTemplate = "empty_cage", weight = 87719},
--		{itemTemplate = "expensive_basket", weight = 87719},
--		{itemTemplate = "expired_ticket", weight = 87719},
--		{itemTemplate = "hyperdrive_part", weight = 87719},
--		{itemTemplate = "ledger", weight = 87719},
--		{itemTemplate = "locked_briefcase", weight = 87719},
--		{itemTemplate = "locked_container", weight = 87719},
--		{itemTemplate = "loudspeaker", weight = 87719},
--		{itemTemplate = "palm_frond", weight = 87719},
--		{itemTemplate = "photographic_image", weight = 87719},
--		{itemTemplate = "recorded_image_1", weight = 87719},
--		{itemTemplate = "recording_rod", weight = 87719},
--		{itemTemplate = "slave_collar", weight = 87719},
--		{itemTemplate = "used_ticket", weight = 87719},
--		{itemTemplate = "worklight", weight = 87719},

		-- Weapons (25% chance)
		{groupTemplate = "weapons_all", weight = 2500000},

		-- Armors (25% chance)
		{groupTemplate = "armor_all", weight = 2500000},
		
		--20%
		{groupTemplate = "weapon_component_advanced", weight = 1000000},
		{groupTemplate = "chemistry_component_advanced", weight = 1000000},
		
		-- Clothing 
		{groupTemplate = "wearables_all", weight = 1000000},
		
		
		--10%
		{groupTemplate = "attachment_clothing", weight = 500000},	
		{groupTemplate = "attachment_armor", weight = 500000},
		

		-- 
		{groupTemplate = "force_color_crystal", weight = 495000},
		{groupTemplate = "force_power_crystal", weight = 495000},
		
		--
		{groupTemplate = "holocron_nd", weight = 10000},

	}
}

addLootGroupTemplate("looted_container", looted_container)
