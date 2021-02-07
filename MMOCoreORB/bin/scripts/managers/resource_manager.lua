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

buildInitialResourcesFromScript = 1 -- Use a script to build resource database when empty
  -- So that during wipes crafters can mantain spreadsheets with calculations

--  These indicate zone names where resources spawn
activeZones = "corellia,tatooine,lok,naboo,rori,endor,talus,yavin4,dathomir,dantooine"

averageShiftTime = 3600000 -- In milliseconds
  --  This is the time between each time the Resource Manager schedules
  --  itself to run again.
  --  *** Default is 2 hours (7200000) ***
  --  *** Good testing time is (15000) ***

aveduration = 43200 -- In seconds
  -- This is the modifier for how long spawns are in shift
  -- Organics are in shift between (6 * aveduration) and  (22 * aveduration)
  -- Inorganics are in shift between (6 * aveduration) and (11 * aveduration)
  -- JTL resources are in shift between (13 * aveduration) and (22 * aveduration)
  -- Set to 86400 for standard SOE behavior

spawnThrottling = 90 -- *** 10-90 ***
  -- This will add a throttle to the spawner so that 90% of
  -- resource stats will be less than x * maxGate. So if a
  -- resource stat has a range of 0-1000 and this is set
  -- at 70, there's a 90% chance that the stat will have
  -- a value of < 700 and a 10% chance it will be > 700.
  -- Set to 90 for standard SOE behavior

lowerGateOverride = 1000 -- 1-1000  
  -- This will manually set the lower gate to this 
  -- number if it has a lower gate greater than the
  -- number entered.  ex. if a resource has a SOE gate
  -- of 850-950, and the number is set at 300, it will
  -- change the gate to 300-950.  This allows for resource
  -- quality control, especially for resources with 
  -- very high gates.  
  -- Set to 1000 for standard SOE behavior.
  
maxSpawnQuantity = 0 
  -- This value specifies the quantity that a specific resource
  -- will spawn before automatically despawning.  This value
  -- is disabled (0) by default as it is NOT standard behavior, 
  -- but it is an option for admins to have more control over resources.
  -- Set to 0 for standard SOE behavior

--A function used to insert the JTL resources into a lua table.
function InsertJtlIntoTable(jtlString, tab)
	local jtlTable = { {} }

	for k in string.gmatch(jtlString, "[%a_]+") do
		table.insert(jtlTable, k)
	end

	for i = 2, #jtlTable do
		table.insert(tab, {jtlTable[i], 1})
	end
	return tab
end

--  Resources included in the JTL update
jtlresources = "steel_bicorbantium,steel_arveshian,aluminum_perovskitic,copper_borocarbitic,fiberplast_gravitonic,gas_reactive_organometallic,ore_siliclastic_fermionic,radioactive_polymetric"

  -- The minimum pool includes is a table of resources and occurrences. A resource will always be in spawn a number of times equal to it's occurrence.
  -- The minimum pool will never include the items in the excludes
minimumpoolincludes = { {"petrochem_fuel_liquid_type1", 1}, {"petrochem_fuel_liquid_type2", 1}, {"petrochem_fuel_liquid_type3", 1}, {"petrochem_fuel_liquid_type4", 1}, {"petrochem_fuel_liquid_type5", 1}, {"petrochem_fuel_liquid_type6", 1}, {"petrochem_fuel_liquid_type7", 1}, {"petrochem_fuel_liquid_unknown", 1}, {"petrochem_inert_lubricating_oil", 1}, {"petrochem_inert_polymer", 1}, {"petrochem_fuel_solid_unknown", 1}, {"petrochem_fuel_solid_type1", 1}, {"petrochem_fuel_solid_type2", 1}, {"petrochem_fuel_solid_type3", 1}, {"petrochem_fuel_solid_type4", 1}, {"petrochem_fuel_solid_type5", 1}, {"petrochem_fuel_solid_type6", 1}, {"petrochem_fuel_solid_type7", 1}, {"radioactive_unknown", 1}, {"radioactive_type1", 1}, {"radioactive_type2", 1}, {"radioactive_type3", 1}, {"radioactive_type4", 1}, {"radioactive_type5", 1}, {"radioactive_type6", 1}, {"radioactive_type7", 1}, {"radioactive_polymetric", 1}, {"metal_ferrous_unknown", 1}, {"steel_smelted", 1}, {"steel_rhodium", 1}, {"steel_kiirium", 1}, {"steel_cubirian", 1}, {"steel_thoranium", 1}, {"steel_neutronium", 1}, {"steel_duranium", 1}, {"steel_ditanium", 1}, {"steel_quadranium", 1}, {"steel_carbonite", 1}, {"steel_arveshian", 1}, {"steel_bicorbantium", 1}, {"steel_duralloy", 1}, {"iron_smelted", 1}, {"iron_plumbum", 1}, {"iron_polonium", 1}, {"iron_axidite", 1}, {"iron_bronzium", 1}, {"iron_colat", 1}, {"iron_dolovite", 1}, {"iron_doonium", 1}, {"iron_kammris", 1}, {"metal_nonferrous_unknown", 1}, {"aluminum_smelted", 1}, {"aluminum_titanium", 1}, {"aluminum_agrinium", 1}, {"aluminum_chromium", 1}, {"aluminum_duralumin", 1}, {"aluminum_linksteel", 1}, {"aluminum_perovskitic", 1}, {"aluminum_phrik", 1}, {"copper_smelted", 1}, {"copper_desh", 1}, {"copper_thallium", 1}, {"copper_beyrllius", 1}, {"copper_codoan", 1}, {"copper_diatium", 1}, {"copper_kelsh", 1}, {"copper_mythra", 1}, {"copper_platinite", 1}, {"copper_polysteel", 1}, {"copper_borocarbitic", 1}, {"ore_igneous_unknown", 1}, {"ore_extrusive_bene", 1}, {"ore_extrusive_chronamite", 1}, {"ore_extrusive_ilimium", 1}, {"ore_extrusive_kalonterium", 1}, {"ore_extrusive_keschel", 1}, {"ore_extrusive_lidium", 1}, {"ore_extrusive_maranium", 1}, {"ore_extrusive_pholokite", 1}, {"ore_extrusive_quadrenium", 1}, {"ore_extrusive_vintrium", 1}, {"ore_intrusive_berubium", 1}, {"ore_intrusive_chanlon", 1}, {"ore_intrusive_corintium", 1}, {"ore_intrusive_derillium", 1}, {"ore_intrusive_oridium", 1}, {"ore_intrusive_dylinium", 1}, {"ore_intrusive_hollinium", 1}, {"ore_intrusive_ionite", 1}, {"ore_intrusive_katrium", 1}, {"ore_sedimentary_unknown", 1}, {"ore_carbonate_alantium", 1}, {"ore_carbonate_barthierium", 1}, {"ore_carbonate_chromite", 1}, {"ore_carbonate_frasium", 1}, {"ore_carbonate_lommite", 1}, {"ore_carbonate_ostrine", 1}, {"ore_carbonate_varium", 1}, {"ore_carbonate_zinsiam", 1}, {"ore_siliclastic_low_grade", 1}, {"ore_siliclastic_ardanium", 1}, {"ore_siliclastic_cortosis", 1}, {"ore_siliclastic_crism", 1}, {"ore_siliclastic_malab", 1}, {"ore_siliclastic_robindun", 1}, {"ore_siliclastic_fermionic", 1}, {"ore_siliclastic_tertian", 1}, {"gemstone_unknown", 1}, {"armophous_bospridium", 1}, {"armophous_baradium", 1}, {"armophous_regvis", 1}, {"armophous_plexite", 1}, {"armophous_rudic", 1}, {"armophous_ryll", 1}, {"armophous_sedrellium", 1}, {"armophous_stygium", 1}, {"armophous_vendusii", 1}, {"armophous_baltaran", 1}, {"crystalline_byrothsis", 1}, {"crystalline_gallinorian", 1}, {"crystalline_green_diamond", 1}, {"crystalline_kerol_firegem", 1}, {"crystalline_seafah_jewel", 1}, {"crystalline_sormahil_firegem", 1}, {"crystalline_laboi_mineral_crystal", 1}, {"crystalline_vertex", 1}, {"gas_reactive_unknown", 1}, {"gas_reactive_mixed", 1}, {"gas_reactive_eleton", 1}, {"gas_reactive_irolunn", 1}, {"gas_reactive_methane", 1}, {"gas_reactive_orveth", 1}, {"gas_reactive_sig", 1}, {"gas_reactive_skevon", 1}, {"gas_reactive_organometallic", 1}, {"gas_reactive_tolium", 1}, {"gas_inert_unknown", 1}, {"gas_inert_mixed", 1}, {"gas_inert_hydron3", 1}, {"gas_inert_malium", 1}, {"gas_inert_bilal", 1}, {"gas_inert_corthel", 1}, {"gas_inert_dioxis", 1}, {"gas_inert_hurlothrombic", 1}, {"gas_inert_kaylon", 1}, {"gas_inert_korfaise", 1}, {"gas_inert_methanagen", 1}, {"gas_inert_mirth", 1}, {"gas_inert_obah", 1}, {"gas_inert_rethin", 1}, {"gas_inert_culsion", 1} }
minimumpoolexcludes = ""

-- The random pool includes is a table of resources and weights. The higher the weight, the more likely the resource is to be chosen when a random pool resource shifts.
  -- The random pool will never include the items in the excludes
  -- The random pool spawns a total number of resources equal to the size
randompoolincludes = { {"metal", 10}, {"ore", 10}, {"radioactive", 10}, {"gemstone", 10}, {"gas", 10}, {"water", 10} }
randompoolexcludes = ""
randompoolsize = 54

  -- The fixed pool is a table of resources and occurrences. A resource will always be in spawn a number of times equal to it's occurrence. The function call inserts each JTL resource into the table with an occurrence of 1.
fixedpoolincludes = ""
fixedpoolexcludes = ""

  -- The native pool will have one of each of the items listed in the includes spawned on each planet at all times, but planet restricted.
nativepoolincludes = "milk_domesticated,milk_wild,meat_domesticated,meat_wild,meat_herbivore,meat_carnivore,meat_reptilian,meat_avian,meat_egg,meat_insect,seafood_fish,seafood_crustacean,seafood_mollusk,bone_mammal,bone_avian,bone_horn,hide_wooly,hide_bristley,hide_leathery,hide_scaley,corn_domesticated,corn_wild,rice_domesticated,rice_wild,oats_domesticated,oats_wild,wheat_domesticated,wheat_wild,vegetable_greens,vegetable_beans,vegetable_tubers,vegetable_fungi,fruit_fruits,fruit_berries,fruit_flowers,wood_deciduous,softwood_conifer,softwood_evergreen,energy_renewable_unlimited_solar,energy_renewable_unlimited_wind,fiberplast,water_vapor"
nativepoolexcludes = ""

