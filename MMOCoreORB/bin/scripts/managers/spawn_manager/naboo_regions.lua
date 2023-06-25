-- Planet Region Definitions
--
-- {"regionName", x, y, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- For circle and ring, x and y are the center point
-- For rectangles, x and y are the bottom left corner. x2 and y2 (see below) are the upper right corner
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {CIRCLE, radius}
--   - Rectangle: {RECTANGLE, x2, y2}
--   - Ring: {RING, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.

require("scripts.managers.spawn_manager.regions")

naboo_regions = {
	{"beach_town", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
--	{"beachtown_easy_newbie", -5585, -35, {CIRCLE, 1000}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 128},
--	{"beachtown_medium_newbie", -5585, -35, {RING, 1000, 1900}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 192},
	{"bounty_hunter_camp", 5029, 4156, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"campfire_and_bones", 3939, 2701, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"campfire_and_ruins", -1771, 2387, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"central_jungle_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"central_mountain_circle", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"central_mountain_range", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"dead_tree", -675, 5203, {CIRCLE, 10}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"debris", -1691, 5427, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"debris_2", -2957, 1699, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"debris_3", -2403, 563, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
--	{"deeja_easy_newbie", 5060, -1470, {CIRCLE, 1300}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 192},
--	{"deeja_medium_newbie", 5060, -1470, {RING, 1300, 2200}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 320},
	{"deeja_peak", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"eastern_forest", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"eastern_jungle_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"eastern_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"easy_gnort_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"emperors_retreat", 2400, -3900, {CIRCLE, 500}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"fence_and_debris", -7575, 5043, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"fishing_dock", -6314, -5087, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"forest_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_forest_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_jungle_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_jungle_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_11", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_12", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_13", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_14", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_15", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_16", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_17", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gallo_mountains_6", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"gardens", 1260, 4291, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gate_and_columns", -259, -60, {CIRCLE, 60}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gazebo", 1012, -3460, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"great_grass_plains_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"great_grass_plains_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"great_grass_plains_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"great_grass_plains_4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"great_grass_plains_5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"graveyard", -3603, 3119, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_fountain", 5556, 5531, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_head", 1940, 6611, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_head_with_walls", -5046, 6178, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_monument", -7547, 2251, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_ruins", 3428, 5075, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_sacred_place", -2013, -5453, {CIRCLE, 180}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gungan_temple", -264, 2826, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"hard_capper_spineflap_sw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gungan_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_mauler_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_peko_peko_nw", -1856, 6112, {CIRCLE, 2500}, UNDEFINEDAREA},
	{"hard_veermok_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"imperial_vs_gungan_poi", 4760, 3875, {CIRCLE, 125}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"jungle_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"jungle_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
--	{"kaadara_easy_newbie", 5150, 6680, {CIRCLE, 1300}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 256},
--	{"kaadara_medium_newbie", 5150, 6680, {RING, 1300, 2200}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 384},
	{"kadaara", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"keren", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
--	{"keren_easy_newbie", 1685, 2620, {CIRCLE, 1300}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 256},
--	{"keren_medium_newbie", 1685, 2620, {RING, 1300, 2200}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 384},
	{"lainorm_swamp_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"lake_retreat", -5555, -34, {CIRCLE, 400}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"lake_retreat_gazebo", -5637, 174, {CIRCLE, 40}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"lasay_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"lianorm_swamp_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"lianorm_swamps", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mauler_stronghold", 2910, 1118, {CIRCLE, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"medium_ikopi_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_mountain_ikopi_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_mountain_ikopi_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_mountain_krevol_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_swamp_cat_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_tusk_cat_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_tusk_cat_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"moenia", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
--	{"moenia_easy_newbie", 4800, -4820, {CIRCLE, 1300}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 256},
--	{"moenia_medium_newbie", 4800, -4820, {RING, 1300, 2200}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 384},
	{"narglatch_cave", 5861, -4650, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"north_eastern_jungle_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northern_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"paitnnu_wetlands", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"plains_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rainforest_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rainforest_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rainforest_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rebel_outpost", -1499, -1732, {CIRCLE, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"rebel_outpost_2", 978, -1332, {CIRCLE, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruined_wall", -3603, -876, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruins", -2547, 6787, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruins_2", -1799, -500, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruins_3", -7319, -4143, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruins_4", 2148, 5427, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruins_5}", 1228, 5515, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"shield_generator", -1339, 6531, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"small_garden", -6459, 1747, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"small_graveyard", -2174, 6357, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"southeast_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"southwest_mountain_circle", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"southwest_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"statues", -1635, -4036, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"statues_and_droideka", -2331, 5075, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"statues_and_torches", -1147, 347, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"swamp_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"swamp_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"swamp_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"swamp_town", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"theed", -5036, 4124, {CIRCLE, 500}, NOSPAWNAREA + NOBUILDZONEAREA},
--	{"theed_easy_newbie_1", -5485, 4380, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 192},
--	{"theed_easy_newbie_2", -4940, 4030, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_easy"}, 192},
--	{"theed_medium_newbie", -5212, 4205, {RING, 1750, 2800}, SPAWNAREA + NOWORLDSPAWNAREA, {"naboo_medium"}, 448},
	{"tower", -1568, 6003, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"weapon_development_facility", -6510, -3280, {CIRCLE, 200}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"wreckage", 6314, 4248, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"western_forest", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"naboo_world", "global"}, 2048}
}
