heavy_weapons_consumable = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "heavy_lightning_beam", weight = 3000000},
		{itemTemplate = "heavy_acid_beam", weight = 2500000},
		{itemTemplate = "heavy_particle_beam", weight = 2500000},
		{itemTemplate = "heavy_rocket_launcher", weight = 2000000},
	}
}

addLootGroupTemplate("heavy_weapons_consumable", heavy_weapons_consumable)
