--Should all created players start with God Mode? 1 = yes, 0 = no
freeGodMode = 0;
--How many cash credits new characters start with after creating a character (changed during test phase, normal value is 100)
startingCash = 2000
--startingCash = 100000
--How many bank credits new characters start with after creating a character (changed during test phase, normal value is 1000)
startingBank = 15000
--startingBank = 100000
--How many skill points a new characters start with
skillPoints = 250

professions = {
	"combat_brawler",
	"combat_marksman",
	"crafting_artisan",
	"jedi",
	"outdoors_scout",
	"science_medic",
	"social_entertainer"
}

marksmanPistol = "object/weapon/ranged/pistol/pistol_d18.iff"
	
marksmanRifle = "object/weapon/ranged/rifle/rifle_dlt20.iff"

marksmanCarbine = "object/weapon/ranged/carbine/carbine_dh17.iff"

brawlerOneHander = "object/weapon/melee/sword/sword_01.iff"

brawlerTwoHander = "object/weapon/melee/2h_sword/2h_sword_battleaxe.iff"

brawlerPolearm = "object/weapon/melee/polearm/lance_staff_wood_s2.iff"

survivalKnife = "object/weapon/melee/knife/knife_survival.iff"

genericTool = "object/tangible/crafting/station/generic_tool.iff"

foodTool = "object/tangible/crafting/station/food_tool.iff"

mineralTool = "object/tangible/survey_tool/survey_tool_mineral.iff"

chemicalTool = "object/tangible/survey_tool/survey_tool_liquid.iff"

slitherhorn = "object/tangible/instrument/slitherhorn.iff"

marojMelon = "object/tangible/food/foraged/foraged_fruit_s1.iff"

x31Speeder = "object/tangible/deed/vehicle_deed/landspeeder_x31_deed.iff"


Speeder = "object/tangible/deed/vehicle_deed/speederbike_deed.iff"

professionSpecificItems = {
	combat_brawler = { brawlerOneHander, brawlerTwoHander, brawlerPolearm },
	combat_marksman = { marksmanPistol, marksmanCarbine, marksmanRifle },
	crafting_artisan = { genericTool, mineralTool, chemicalTool },
	jedi = { },
	outdoors_scout = { genericTool },
	science_medic = { foodTool },
	social_entertainer = { slitherhorn }
}

commonStartingItems = { marojMelon, survivalKnife, Speeder }