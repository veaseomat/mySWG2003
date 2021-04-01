--Copyright (C) 2007 <SWGEmu>

--This File is part of Core3.

--This program is free software; you can redistribute
--it and/or modify it under the terms of the GNU Lesser
--General Public License as published by the Free Software
--Foundation; either version 2 of the License,
--or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--See the GNU Lesser General Public License for
--more details.

--You should have received a copy of the GNU Lesser General
--Public License along with this program; if not, write to
--the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

--Linking Engine3 statically or dynamically with other modules
--is making a combined work based on Engine3.
--Thus, the terms and conditions of the GNU Lesser General Public License
--cover the whole combination.

--In addition, as a special exception, the copyright holders of Engine3
--give you permission to combine Engine3 program with free software
--programs or libraries that are released under the GNU LGPL and with
--code included in the standard release of Core3 under the GNU LGPL
--license (or modified versions of such code, with unchanged license).
--You may copy and distribute such a system following the terms of the
--GNU LGPL for Engine3 and the licenses of the other code concerned,
--provided that you include the source code of that other code when
--and as the GNU LGPL requires distribution of source code.

--Note that people who make modified versions of Engine3 are not obligated
--to grant this special exception for their modified versions;
--it is their choice whether to do so. The GNU Lesser General Public License
--gives permission to release a modified version without this exception;
--this exception also makes it possible to release a modified version
--which carries forward this exception.

--Determines how often exceptional and legendary items can drop.
yellowChance = 1000 -- 1 in 1,000
exceptionalChance = 100000 --1 in 100,000
legendaryChance = 1000000 --1 in 1,000,000
--yellowChance = 50 --1 in 50 for testing
--exceptionalChance = 100 --1 in 100 for testing
--legendaryChance = 1000 --1 in 1000 for testing

--Determines how much of an increase in the base stats will be applied to the object.
yellowModifier = 1.5
exceptionalModifier = 2.5
legendaryModifier = 5.0

--The chance for random skill mods to be on looted weapons/wearables
skillModChance = 5 -- 1 in 500

-- Value ranges for random dots on looted weapons (chance is set individually on the loot items)
randomDotAttribute = {0, 8} -- See CreatureAttributes.h in src for numbers.
randomDotStrength = {10, 200} -- Set for disease. Fire will be x1.5, poison x2.
randomDotDuration = {30, 240} -- Set for poison. Fire will be x1.5, disease x5.
randomDotPotency = {1, 100}
randomDotUses = {250, 9999}

-- Modifier applied to min/max junk values found in loot item lua
junkValueModifier = 5;

lootableArmorAttachmentStatMods = {
"heavy_flame_thrower_accuracy",
"heavy_flame_thrower_speed",
"heavy_rifle_acid_accuracy",
"heavy_rifle_acid_speed",
"unarmed_passive_defense",
--	"aim",
--	"alert",
--	"berserk",
	"blind_defense",
	"block",
--	"camouflage",
	"carbine_accuracy",
--	"carbine_aim",
--	"carbine_hit_while_moving",
	"carbine_speed",
	"combat_bleeding_defense",
	"counterattack",
--	"cover",
	"dizzy_defense",
	"dodge",
--	"droid_find_chance",
--	"droid_find_speed",
--	"droid_track_chance",
--	"droid_track_speed",
--	"foraging",
--	"group_slope_move",
	"heavy_rifle_lightning_accuracy",
	"heavy_rifle_lightning_speed",
	"heavyweapon_accuracy",
	"heavyweapon_speed",
--	"intimidate",
	"intimidate_defense",
--	"keep_creature",
	"knockdown_defense",
	"melee_defense",
	"onehandmelee_accuracy",
--	"onehandmelee_damage",
	"onehandmelee_speed",
	"pistol_accuracy",
--	"pistol_aim",
--	"pistol_hit_while_moving",
	"pistol_speed",
--	"pistol_accuracy_while_standing",
	"polearm_accuracy",
	"polearm_speed",
	"posture_change_down_defense",
--	"posture_change_up_defense",
	"ranged_defense",
--	"rescue",
--	"resistance_bleeding",
	"resistance_disease",
	"resistance_fire",
	"resistance_poison",
	"rifle_accuracy",
--	"rifle_aim",
--	"rifle_hit_while_moving",
	"rifle_speed",
	"slope_move",
--	"steadyaim",
--	"stored_pets",
	"stun_defense",
--	"take_cover",
--	"tame_aggro",
--	"tame_bonus",
--	"tame_non_aggro",
	"thrown_accuracy",
	"thrown_speed",
	"twohandmelee_accuracy",
--	"twohandmelee_damage",
	"twohandmelee_speed",
	"unarmed_accuracy",
--	"unarmed_damage",
	"unarmed_speed",
--	"volley",
--	"warcry"
}

lootableClothingAttachmentStatMods = {
"heavy_flame_thrower_accuracy",
"heavy_flame_thrower_speed",
"heavy_rifle_acid_accuracy",
"heavy_rifle_acid_speed",
	"unarmed_passive_defense",
	"bio_engineer_assembly",
	"bio_engineer_experimentation",
	"saber_block",
	"jedi_saber_assembly",
	"jedi_saber_experimentation",
	"twohandlightsaber_accuracy",
	"twohandlightsaber_speed",
	"polearmlightsaber_accuracy",
	"polearmlightsaber_speed",
	"onehandlightsaber_accuracy",
	"onehandlightsaber_speed",
--	"aim",
--	"alert",
	"armor_assembly",
	"armor_experimentation",
--	"armor_repair",
--	"berserk",
	"blind_defense",
	"block",
--	"camouflage",
	"carbine_accuracy",
--	"carbine_aim",
--	"carbine_hit_while_moving",
	"carbine_speed",
--	"clothing_assembly",
--	"clothing_experimentation",
--	"clothing_repair",
	"combat_bleeding_defense",
--	"combat_healing_ability",
	"combat_medicine_assembly",
	"combat_medicine_experimentation",
	"counterattack",
--	"cover",
	"dizzy_defense",
	"dodge",
	"droid_assembly",
--	"droid_complexity",
--	"droid_customization",
	"droid_experimentation",
--	"droid_find_chance",
--	"droid_find_speed",
--	"droid_track_chance",
--	"droid_track_speed",
	"food_assembly",
	"food_experimentation",
--	"foraging",
	"general_assembly",
	"general_experimentation",
--	"grenade_assembly",
--	"grenade_experimentation",
--	"group_slope_move",
--	"healing_ability",
	"healing_dance_mind",
	"healing_dance_shock",
	"healing_dance_wound",
	"healing_injury_speed",
	"healing_injury_treatment",
	"healing_music_mind",
	"healing_music_shock",
	"healing_music_wound",
--	"healing_range",
	"healing_range_speed",
	"healing_wound_speed",
	"healing_wound_treatment",
	"heavy_rifle_lightning_accuracy",
	"heavy_rifle_lightning_speed",
	"heavyweapon_accuracy",
	"heavyweapon_speed",
--	"instrument_assembly",
--	"intimidate",
	"intimidate_defense",
--	"keep_creature",
	"knockdown_defense",
--	"medical_foraging",
	"medicine_assembly",
	"medicine_experimentation",
	"melee_defense",
	"onehandmelee_accuracy",
--	"onehandmelee_damage",
	"onehandmelee_speed",
	"pistol_accuracy",
--	"pistol_aim",
--	"pistol_hit_while_moving",
	"pistol_speed",
--	"pistol_accuracy_while_standing",
	"polearm_accuracy",
	"polearm_speed",
	"posture_change_down_defense",
--	"posture_change_up_defense",
	"ranged_defense",
--	"rescue",
--	"resistance_bleeding",
	"resistance_disease",
	"resistance_fire",
	"resistance_poison",
	"rifle_accuracy",
--	"rifle_aim",
--	"rifle_hit_while_moving",
	"rifle_speed",
	"slope_move",
--	"steadyaim",
--	"stored_pets",
	"structure_assembly",
--	"structure_complexity",
	"structure_experimentation",
	"stun_defense",
	"surveying",
--	"take_cover",
--	"tame_aggro",
--	"tame_bonus",
--	"tame_non_aggro",
	"thrown_accuracy",
	"thrown_speed",
	"twohandmelee_accuracy",
--	"twohandmelee_damage",
	"twohandmelee_speed",
	"unarmed_accuracy",
--	"unarmed_damage",
	"unarmed_speed",
--	"volley",
--	"warcry",
	"weapon_assembly",
	"weapon_experimentation",
--	"weapon_repair"
}

lootableArmorStatMods = {
"heavy_flame_thrower_accuracy",
"heavy_flame_thrower_speed",
"heavy_rifle_acid_accuracy",
"heavy_rifle_acid_speed",
	"unarmed_passive_defense",
--	"aim",
--	"alert",
--	"berserk",
	"blind_defense",
	"block",
--	"camouflage",
	"carbine_accuracy",
--	"carbine_aim",
--	"carbine_hit_while_moving",
	"carbine_speed",
	"combat_bleeding_defense",
	"counterattack",
--	"cover",
	"dizzy_defense",
	"dodge",
--	"droid_find_chance",
--	"droid_find_speed",
--	"droid_track_chance",
--	"droid_track_speed",
--	"foraging",
--	"group_slope_move",
	"heavy_rifle_lightning_accuracy",
	"heavy_rifle_lightning_speed",
	"heavyweapon_accuracy",
	"heavyweapon_speed",
--	"intimidate",
	"intimidate_defense",
--	"keep_creature",
	"knockdown_defense",
	"melee_defense",
	"onehandmelee_accuracy",
--	"onehandmelee_damage",
	"onehandmelee_speed",
	"pistol_accuracy",
--	"pistol_aim",
--	"pistol_hit_while_moving",
	"pistol_speed",
--	"pistol_accuracy_while_standing",
	"polearm_accuracy",
	"polearm_speed",
	"posture_change_down_defense",
--	"posture_change_up_defense",
	"ranged_defense",
--	"rescue",
--	"resistance_bleeding",
	"resistance_disease",
	"resistance_fire",
	"resistance_poison",
	"rifle_accuracy",
--	"rifle_aim",
--	"rifle_hit_while_moving",
	"rifle_speed",
	"slope_move",
--	"steadyaim",
--	"stored_pets",
	"stun_defense",
--	"take_cover",
--	"tame_aggro",
--	"tame_bonus",
--	"tame_non_aggro",
	"thrown_accuracy",
	"thrown_speed",
	"twohandmelee_accuracy",
--	"twohandmelee_damage",
	"twohandmelee_speed",
	"unarmed_accuracy",
--	"unarmed_damage",
	"unarmed_speed",
--	"volley",
--	"warcry"
}

lootableClothingStatMods = {
"heavy_flame_thrower_accuracy",
"heavy_flame_thrower_speed",
"heavy_rifle_acid_accuracy",
"heavy_rifle_acid_speed",
	"unarmed_passive_defense",
	"bio_engineer_assembly",
	"bio_engineer_experimentation",
	"saber_block",
	"jedi_saber_assembly",
	"jedi_saber_experimentation",
	"twohandlightsaber_accuracy",
	"twohandlightsaber_speed",
	"polearmlightsaber_accuracy",
	"polearmlightsaber_speed",
	"onehandlightsaber_accuracy",
	"onehandlightsaber_speed",
--	"aim",
--	"alert",
	"armor_assembly",
	"armor_experimentation",
--	"armor_repair",
--	"berserk",
	"blind_defense",
	"block",
--	"camouflage",
	"carbine_accuracy",
--	"carbine_aim",
--	"carbine_hit_while_moving",
	"carbine_speed",
--	"clothing_assembly",
--	"clothing_experimentation",
--	"clothing_repair",
	"combat_bleeding_defense",
--	"combat_healing_ability",
	"combat_medicine_assembly",
	"combat_medicine_experimentation",
	"counterattack",
--	"cover",
	"dizzy_defense",
	"dodge",
	"droid_assembly",
--	"droid_complexity",
--	"droid_customization",
	"droid_experimentation",
--	"droid_find_chance",
--	"droid_find_speed",
--	"droid_track_chance",
--	"droid_track_speed",
	"food_assembly",
	"food_experimentation",
--	"foraging",
	"general_assembly",
	"general_experimentation",
--	"grenade_assembly",
--	"grenade_experimentation",
--	"group_slope_move",
	"healing_ability",
	"healing_dance_mind",
	"healing_dance_shock",
	"healing_dance_wound",
	"healing_injury_speed",
	"healing_injury_treatment",
	"healing_music_mind",
	"healing_music_shock",
	"healing_music_wound",
--	"healing_range",
	"healing_range_speed",
	"healing_wound_speed",
	"healing_wound_treatment",
	"heavy_rifle_lightning_accuracy",
	"heavy_rifle_lightning_speed",
	"heavyweapon_accuracy",
	"heavyweapon_speed",
--	"instrument_assembly",
--	"intimidate",
	"intimidate_defense",
--	"keep_creature",
	"knockdown_defense",
--	"medical_foraging",
	"medicine_assembly",
	"medicine_experimentation",
	"melee_defense",
	"onehandmelee_accuracy",
--	"onehandmelee_damage",
	"onehandmelee_speed",
	"pistol_accuracy",
--	"pistol_aim",
--	"pistol_hit_while_moving",
	"pistol_speed",
--	"pistol_accuracy_while_standing",
	"polearm_accuracy",
	"polearm_speed",
	"posture_change_down_defense",
--	"posture_change_up_defense",
	"ranged_defense",
--	"rescue",
--	"resistance_bleeding",
	"resistance_disease",
	"resistance_fire",
	"resistance_poison",
	"rifle_accuracy",
--	"rifle_aim",
--	"rifle_hit_while_moving",
	"rifle_speed",
	"slope_move",
--	"steadyaim",
--	"stored_pets",
	"structure_assembly",
--	"structure_complexity",
	"structure_experimentation",
	"stun_defense",
	"surveying",
--	"take_cover",
--	"tame_aggro",
--	"tame_bonus",
--	"tame_non_aggro",
	"thrown_accuracy",
	"thrown_speed",
	"twohandmelee_accuracy",
--	"twohandmelee_damage",
	"twohandmelee_speed",
	"unarmed_accuracy",
--	"unarmed_damage",
	"unarmed_speed",
--	"volley",
--	"warcry",
	"weapon_assembly",
	"weapon_experimentation",
--	"weapon_repair"
}

lootableOneHandedMeleeStatMods = {

}

lootableTwoHandedMeleeStatMods = {

}

lootableUnarmedStatMods = {

}

lootablePistolStatMods = {

}

lootableRifleStatMods = {

}

lootableCarbineStatMods = {

}

lootablePolearmStatMods = {

}

lootableHeavyWeaponStatMods = {

}

-- Values used to generate lightsaber crystal stats
jediCrystalStats = {
	lightsaber_module_force_crystal = {
		minDamage = 1,
		maxDamage = 100,
		minHitpoints = 700,
		maxHitpoints = 1400,
		minHealthSac = -3,
		maxHealthSac = -9,
		minActionSac = -3,
		maxActionSac = -9,
		minMindSac = -3,
		maxMindSac = -9,
		minAttackSpeed = -0.1,
		maxAttackSpeed = -0.6,
		minForceCost = -5.5,
		maxForceCost = -9.9,
		minWoundChance = 1,
		maxWoundChance = 4,
	},
	lightsaber_module_krayt_dragon_pearl = {
		minDamage = 20,
		maxDamage = 100,
		minHitpoints = 900,
		maxHitpoints = 1400,
		minHealthSac = -6,
		maxHealthSac = -9,
		minActionSac = -6,
		maxActionSac = -9,
		minMindSac = -6,
		maxMindSac = -9,
		minAttackSpeed = -0.3,
		maxAttackSpeed = -0.6,
		minForceCost = -8.5,
		maxForceCost = -9.9,
		minWoundChance = 2,
		maxWoundChance = 4,
	}
}
