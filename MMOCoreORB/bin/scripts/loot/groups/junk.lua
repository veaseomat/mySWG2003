--Automatically generated by SWGEmu Spawn Tool v0.12 loot editor.

junk = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{groupTemplate = "oldjunk", weight = 5000000},
		{groupTemplate = "wearables_all", weight = 1000000},
		{groupTemplate = "tailor_components", weight = 750000},
		{groupTemplate = "chemistry_component", weight = 750000},			
		{groupTemplate = "weapon_component", weight = 750000},
		{groupTemplate = "armor_component", weight = 750000},
		{itemTemplate = "locked_container", weight = 250000},
		--{groupTemplate = "resourcedeed", weight = 250000},	
		{groupTemplate = "paintings", weight = 250000},
		--{groupTemplate = "skill_buffs", weight = 250000},
		{groupTemplate = "armor_all", weight = 250000},
		{groupTemplate = "weapons_all", weight = 250000},
	}
}

addLootGroupTemplate("junk", junk)
