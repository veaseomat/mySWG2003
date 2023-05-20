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

corellia_regions = {
	{"abandoned_campsite", 6050, 6400, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"abandoned_settlement", -5170, 6227, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"afarathu_cave", -2626, 2968, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"agrilat_swamp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"agrilat_swamp_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"archway", 4853, -2663, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"archway_2", 4827, -2637, {CIRCLE, 75}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"beach1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"beach2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"beach3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"beach4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"beach_awnings", -6152, -3390, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"bela_vistal", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"bela_vistal_easy_newbie", 6750, -5740, {CIRCLE, 900}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 128},
	{"bela_vistal_medium_newbie", 6750, -5740, {RING, 900, 1500}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_medium"}, 192},
	{"bindreg_hills_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"bindreg_hills_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"bindreg_hills_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"blocks", -375, 6075, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"blocks_2", 2520, 5970, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"blocks_3", 2387, 670, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"broken_bridge", -4275, 3650, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"broken_ore_extractor", 170, 1720, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"buried_arches", 2922, 1600, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"central_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"corellia_mountain_fortress", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"corellia_pvp", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"corellia_rebel_riverside_fort", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"coronet_easy_newbie", -230, -4460, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 256},
	{"coronet", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
--	{"coronet", -178, -4504, {CIRCLE, 581}, NOSPAWNAREA},--this one works
	{"coronet_medium_newbie", -230, -4460, {RING, 1750, 2500}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_medium"}, 384},
	{"crystal_arch_hall", -6831, 2200, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"daoba_guerfel", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"denendre_valley_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"denendre_valley_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"denendre_valley_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"denendre_valley_4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"destroyed_outpost", 1877, -236, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"doaba_guefel_easy_newbie", 3210, 5360, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 256},
	{"doaba_guefel_medium_newbie", 3210, 5360, {RING, 1750, 2500}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_medium"}, 384},
	{"doaba_guerfel", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"drall_patriots_cave", 937, 4106, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"dregans_pike", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"east_sea_coast", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"forest_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"garden_monument", 4254, -163, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"gated_area", 1699, -2171, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"geyser", 4875, 6685, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"golden_beaches_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_6", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_7", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"golden_beaches_8", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland6", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland7", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"grassland8", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_crimson_sand_panther_sw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_greater_gulginaw_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gronda_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gronda_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gronda_sw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gulginaw_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"hard_gulginaw_sw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"kor_vella", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"kor_vella_easy_newbie", -3390, 3024, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 256},
	{"kor_vella_medium_newbie", -3390, 3024, {RING, 1750, 2500}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_medium"}, 384},
	{"lake1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"lake2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"lake3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"large_broken_tower", 4990, 2890, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"listening_post", -1450, 1990, {CIRCLE, 35}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"loch_khaxus", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"long_wall", 2550, 4740, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"lord_nyax_cult", 1359, -326, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"malal_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_dire_cat_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_dire_cat_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_murra_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_murra_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_plumed_rasp_ne", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_sand_panther_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_slice_hound_nw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_slice_hound_se", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"medium_slice_hound_sw", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain6", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain7", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"mountain8", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"monument", 740, 2510, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"monument_2", -7165, 135, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"mysterious_shrine", -2385, 6390, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"mysterious_shrine_2", 6300, 6685, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"north_central_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northeast_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northwest_forest", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northwest_mountain_peak", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northwest_mountains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"northwest_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"power_generator", -3611, -375, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"power_plant", 643, -435, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"rebel_hideout", -6530, 5967, {CIRCLE, 300}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"rebel_outpost", 4112, -1267, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"rhalers_bastion", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rier_let", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rier_vem", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_4", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_5", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"riverlands_6", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"rogue_corsec_base", 5210, 1590, {CIRCLE, 300}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruined_guard_tower", -5900, 4670, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"ruined_military_installation", -5330, 220, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"southeast_mountain_peak", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"southeast_mountain_range", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"southeast_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"southwest_forest", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"steam_geyser", 4520, 4329, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"stronghold", 4664, -5781, {CIRCLE, 220}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"suntir_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"swamp1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"thaos_mountains_1", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"thaos_mountains_2", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"thaos_mountains_3", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"three_walls", 1906, -3602, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"tyrena", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"tyrena_easy_newbie", -5236, -2553, {CIRCLE, 1750}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 256},
	{"tyrena_medium_newbie", -5236, -2553, {RING, 1750, 2500}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_medium"}, 384},
	{"vreni_island", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"vreni_island_easy_newbie", -5405, -6230, {CIRCLE, 600}, SPAWNAREA + NOWORLDSPAWNAREA, {"corellia_easy"}, 64},
	{"vreni_island_medium_newbie", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"wind_farm", 6270, 4395, {CIRCLE, 50}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"western_mountain_forest", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"western_plains", 0, 0, {CIRCLE, 0}, UNDEFINEDAREA},
	{"world_spawner", 0, 0, {CIRCLE, -1}, SPAWNAREA + WORLDSPAWNAREA, {"corellia_world", "global"}, 2048}
}
