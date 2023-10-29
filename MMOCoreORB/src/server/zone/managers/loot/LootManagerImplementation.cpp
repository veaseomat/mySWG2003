/*
 * LootManagerImplementation.cpp
 *
 *  Created on: Jun 20, 2011
 *      Author: Kyle
 */

#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/creature/ai/AiAgent.h"
#include "server/zone/objects/tangible/weapon/WeaponObject.h"
#include "server/zone/managers/crafting/CraftingManager.h"
#include "templates/LootItemTemplate.h"
#include "templates/LootGroupTemplate.h"
#include "server/zone/ZoneServer.h"
#include "LootGroupMap.h"
#include "server/zone/objects/tangible/component/lightsaber/LightsaberCrystalComponent.h"

void LootManagerImplementation::initialize() {
	info("Loading configuration.");

	if (!loadConfigData()) {

		loadDefaultConfig();

		info("Failed to load configuration values. Using default.");
	}

	lootGroupMap = LootGroupMap::instance();
	lootGroupMap->initialize();

	info("Loaded " + String::valueOf(lootableArmorAttachmentMods.size()) + " lootable armor attachment stat mods.");
	info("Loaded " + String::valueOf(lootableClothingAttachmentMods.size()) + " lootable clothing attachment stat mods.");
	info("Loaded " + String::valueOf(lootableArmorMods.size()) + " lootable armor stat mods.");
	info("Loaded " + String::valueOf(lootableClothingMods.size()) + " lootable clothing stat mods.");
	info("Loaded " + String::valueOf(lootableOneHandedMeleeMods.size()) + " lootable one handed melee stat mods.");
	info("Loaded " + String::valueOf(lootableTwoHandedMeleeMods.size()) + " lootable two handed melee stat mods.");
	info("Loaded " + String::valueOf(lootableUnarmedMods.size()) + " lootable unarmed stat mods.");
	info("Loaded " + String::valueOf(lootablePistolMods.size()) + " lootable pistol stat mods.");
	info("Loaded " + String::valueOf(lootableRifleMods.size()) + " lootable rifle stat mods.");
	info("Loaded " + String::valueOf(lootableCarbineMods.size()) + " lootable carbine stat mods.");
	info("Loaded " + String::valueOf(lootablePolearmMods.size()) + " lootable polearm stat mods.");
	info("Loaded " + String::valueOf(lootableHeavyWeaponMods.size()) + " lootable heavy weapon stat mods.");
	info("Loaded " + String::valueOf(lootGroupMap->countLootItemTemplates()) + " loot items.");
	info("Loaded " + String::valueOf(lootGroupMap->countLootGroupTemplates()) + " loot groups.");

	info("Initialized.", true);
}

void LootManagerImplementation::stop() {
	lootGroupMap = nullptr;
	craftingManager = nullptr;
	objectManager = nullptr;
	zoneServer = nullptr;
}

bool LootManagerImplementation::loadConfigData() {
	Lua* lua = new Lua();
	lua->init();

	if (!lua->runFile("scripts/managers/loot_manager.lua")) {
		delete lua;
		return false;
	}

	yellowChance = lua->getGlobalFloat("yellowChance");
	yellowModifier = lua->getGlobalFloat("yellowModifier");
	exceptionalChance = lua->getGlobalFloat("exceptionalChance");
	exceptionalModifier = lua->getGlobalFloat("exceptionalModifier");
	legendaryChance = lua->getGlobalFloat("legendaryChance");
	legendaryModifier = lua->getGlobalFloat("legendaryModifier");
	skillModChance = lua->getGlobalFloat("skillModChance");
	junkValueModifier = lua->getGlobalFloat("junkValueModifier");

	LuaObject dotAttributeTable = lua->getGlobalObject("randomDotAttribute");

	if (dotAttributeTable.isValidTable() && dotAttributeTable.getTableSize() > 0) {
		for (int i = 1; i <= dotAttributeTable.getTableSize(); ++i) {
			int value = dotAttributeTable.getIntAt(i);
			randomDotAttribute.put(value);
		}
		dotAttributeTable.pop();
	}

	LuaObject dotStrengthTable = lua->getGlobalObject("randomDotStrength");

	if (dotStrengthTable.isValidTable() && dotStrengthTable.getTableSize() > 0) {
		for (int i = 1; i <= dotStrengthTable.getTableSize(); ++i) {
			int value = dotStrengthTable.getIntAt(i);
			randomDotStrength.put(value);
		}
		dotStrengthTable.pop();
	}

	LuaObject dotDurationTable = lua->getGlobalObject("randomDotDuration");

	if (dotDurationTable.isValidTable() && dotDurationTable.getTableSize() > 0) {
		for (int i = 1; i <= dotDurationTable.getTableSize(); ++i) {
			int value = dotDurationTable.getIntAt(i);
			randomDotDuration.put(value);
		}
		dotDurationTable.pop();
	}

	LuaObject dotPotencyTable = lua->getGlobalObject("randomDotPotency");

	if (dotPotencyTable.isValidTable() && dotPotencyTable.getTableSize() > 0) {
		for (int i = 1; i <= dotPotencyTable.getTableSize(); ++i) {
			int value = dotPotencyTable.getIntAt(i);
			randomDotPotency.put(value);
		}
		dotPotencyTable.pop();
	}

	LuaObject dotUsesTable = lua->getGlobalObject("randomDotUses");

	if (dotUsesTable.isValidTable() && dotUsesTable.getTableSize() > 0) {
		for (int i = 1; i <= dotUsesTable.getTableSize(); ++i) {
			int value = dotUsesTable.getIntAt(i);
			randomDotUses.put(value);
		}
		dotUsesTable.pop();
	}

	LuaObject modsTable = lua->getGlobalObject("lootableArmorAttachmentStatMods");
	loadLootableMods( &modsTable, &lootableArmorAttachmentMods );

	modsTable = lua->getGlobalObject("lootableClothingAttachmentStatMods");
	loadLootableMods( &modsTable, &lootableClothingAttachmentMods );

	modsTable = lua->getGlobalObject("lootableArmorStatMods");
	loadLootableMods( &modsTable, &lootableArmorMods );

	modsTable = lua->getGlobalObject("lootableClothingStatMods");
	loadLootableMods( &modsTable, &lootableClothingMods );

	modsTable = lua->getGlobalObject("lootableOneHandedMeleeStatMods");
	loadLootableMods( &modsTable, &lootableOneHandedMeleeMods );

	modsTable = lua->getGlobalObject("lootableTwoHandedMeleeStatMods");
	loadLootableMods( &modsTable, &lootableTwoHandedMeleeMods );

	modsTable = lua->getGlobalObject("lootableUnarmedStatMods");
	loadLootableMods( &modsTable, &lootableUnarmedMods );

	modsTable = lua->getGlobalObject("lootablePistolStatMods");
	loadLootableMods( &modsTable, &lootablePistolMods );

	modsTable = lua->getGlobalObject("lootableRifleStatMods");
	loadLootableMods( &modsTable, &lootableRifleMods );

	modsTable = lua->getGlobalObject("lootableCarbineStatMods");
	loadLootableMods( &modsTable, &lootableCarbineMods );

	modsTable = lua->getGlobalObject("lootablePolearmStatMods");
	loadLootableMods( &modsTable, &lootablePolearmMods );

	modsTable = lua->getGlobalObject("lootableHeavyWeaponStatMods");
	loadLootableMods( &modsTable, &lootableHeavyWeaponMods );

	LuaObject luaObject = lua->getGlobalObject("jediCrystalStats");
	LuaObject crystalTable = luaObject.getObjectField("lightsaber_module_force_crystal");
	CrystalData* crystal = new CrystalData();
	crystal->readObject(&crystalTable);
	crystalData.put("lightsaber_module_force_crystal", crystal);
	crystalTable.pop();

	crystalTable = luaObject.getObjectField("lightsaber_module_krayt_dragon_pearl");
	crystal = new CrystalData();
	crystal->readObject(&crystalTable);
	crystalData.put("lightsaber_module_krayt_dragon_pearl", crystal);
	crystalTable.pop();
	luaObject.pop();

	delete lua;

	return true;
}

void LootManagerImplementation::loadLootableMods(LuaObject* modsTable, SortedVector<String>* mods) {

	if (!modsTable->isValidTable())
		return;

	for (int i = 1; i <= modsTable->getTableSize(); ++i) {
		String mod = modsTable->getStringAt(i);
		mods->put(mod);
	}

	modsTable->pop();

}

void LootManagerImplementation::loadDefaultConfig() {

}

void LootManagerImplementation::setInitialObjectStats(const LootItemTemplate* templateObject, CraftingValues* craftingValues, TangibleObject* prototype) {
	SharedTangibleObjectTemplate* tanoTemplate = dynamic_cast<SharedTangibleObjectTemplate*>(prototype->getObjectTemplate());

	if (tanoTemplate != nullptr) {
		const auto titles = tanoTemplate->getExperimentalGroupTitles();
		const auto props = tanoTemplate->getExperimentalSubGroupTitles();
		const auto mins = tanoTemplate->getExperimentalMin();
		const auto  maxs = tanoTemplate->getExperimentalMax();
		const auto prec = tanoTemplate->getExperimentalPrecision();

		for (int i = 0; i < props->size(); ++i) {
			const String& title = titles->get(i);
			const String& property = props->get(i);

			if (craftingValues->hasProperty(property))
				continue;

			craftingValues->addExperimentalProperty(property, property, mins->get(i), maxs->get(i), prec->get(i), false, ValuesMap::LINEARCOMBINE);
			if (title == "null")
				craftingValues->setHidden(property);
		}
	}

	const Vector<String>* customizationData = templateObject->getCustomizationStringNames();
	const Vector<Vector<int> >* customizationValues = templateObject->getCustomizationValues();

	for (int i = 0; i < customizationData->size(); ++i) {
		const String& customizationString = customizationData->get(i);
		Vector<int>* values = &customizationValues->get(i);

		if (values->size() > 0) {
			int randomValue = values->get(System::random(values->size() - 1));

			prototype->setCustomizationVariable(customizationString, randomValue, false);
		}
	}
}

void LootManagerImplementation::setCustomObjectName(TangibleObject* object, const LootItemTemplate* templateObject) {
	const String& customName = templateObject->getCustomObjectName();

	if (!customName.isEmpty()) {
		if (customName.charAt(0) == '@') {
			StringId stringId(customName);

			object->setObjectName(stringId, false);
		} else {
			object->setCustomObjectName(customName, false);
		}
	}
}

int LootManagerImplementation::calculateLootCredits(int level) {
	int maxcredits = (int) round((.03f * level * level) + (3 * level) + 50);
	int mincredits = (int) round((((float) maxcredits) * .5f) + (2.0f * level));

//	int credits = mincredits + System::random(maxcredits - mincredits) * 2;

	int credits = (level * 100) + System::random(level * 100) + System::random(5000);

	return credits;
}

TangibleObject* LootManagerImplementation::createLootObject(const LootItemTemplate* templateObject, int level, bool maxCondition) {
	int uncappedLevel = level;

	if(level < 1)
		level = 1;

	if(level > 100)
		level = 100;

	level *= 5;//3.5 + (System::random(150) * .01);

	if(level > 500)
		level = 500;

//	level *= (System::random(50) * .01) + .50;

//	int maxlvl = templateObject->getnewmaximumLevel();
//	if (maxlvl == 1) {
//		level = 0;
//		excMod = 1.0;
//	}

	const String& directTemplateObject = templateObject->getDirectObjectTemplate();

	ManagedReference<TangibleObject*> prototype = zoneServer->createObject(directTemplateObject.hashCode(), 2).castTo<TangibleObject*>();

	if (prototype == nullptr) {
		error("could not create loot object: " + directTemplateObject);
		return nullptr;
	}

	Locker objLocker(prototype);

	prototype->createChildObjects();

	//Disable serial number generation on looted items that require no s/n
	//removing this to try and disable loot item sn... did it cause loot items to not work in crafting slots??? yes. it has to be disabled in crafting manager and this left on to work
	if (!templateObject->getSuppressSerialNumber()) {
		String serial = craftingManager->generateSerial();
		prototype->setSerialNumber(serial);
	}

	prototype->setJunkDealerNeeded(1);//templateObject->getJunkDealerTypeNeeded());
	float junkMinValue = templateObject->getJunkMinValue() * junkValueModifier;
	float junkMaxValue = templateObject->getJunkMaxValue() * junkValueModifier;
	float fJunkValue = junkMinValue+System::random(junkMaxValue-junkMinValue) * 2;

	if (level>0 && templateObject->getJunkDealerTypeNeeded()>1){
		fJunkValue = fJunkValue + (fJunkValue * ((float)level / 100)) * 2; // This is the loot value calculation if the item has a level
	}

	ValuesMap valuesMap = templateObject->getValuesMapCopy();
	CraftingValues* craftingValues = new CraftingValues(valuesMap);

	setInitialObjectStats(templateObject, craftingValues, prototype);

	setCustomObjectName(prototype, templateObject);

	// this thing exponentially ruins the variance
	float excMod = 1.0;//.70 + (System::random(300) * .001);

//	if (prototype->isWeaponObject()) excMod = 1.1;
//	if (prototype->isArmorObject()) excMod = 1.5;
//	if (prototype->isComponent()) excMod = 2;
//	if (prototype->isLightsaberCrystalObject()) excMod = 2.0 + (System::random(200) * .01);

//	if (prototype->isWeaponObject()) level *= .1 + (System::random(40) * .1);//System::random(level);//(System::random(33) * .1);
//	if (prototype->isArmorObject()) level *= 1.5;// + (System::random(20) * .1);//4;
//	if (prototype->isComponent()) level *= 2;
//	if (prototype->isLightsaberCrystalObject()) level *= 2;

	int leggy = 0;

//	ManagedReference<ZoneClientSession*> client = getClient();
//
//	int accID = client->getAccountID();
//
//	if (accID == 1)	{
//
//	}

	if (System::random(24) >= 24 && (prototype->isComponent() || prototype->isLightsaberCrystalObject() || prototype->isArmorObject() || prototype->isWeaponObject())) {// && prototype->isArmorObject() || prototype->isWeaponObject() || !prototype->isLightsaberCrystalObject()) {//probably needs to be an elseif to avoid double exceptional/legendary
		UnicodeString newName = prototype->getDisplayedName() + " (Legendary)";
		prototype->setCustomObjectName(newName, false);

		excMod = 5;
		if (prototype->isWeaponObject()) excMod = 4;
		leggy = 1;

		prototype->addMagicBit(false);



		//craftingValues->setCurrentValue("noTrade", 1);
		//craftingValues->addExperimentalProperty("notrade", "notrade", 1, 1, 0, false, ValuesMap::LINEARCOMBINE);



		//legendaryLooted.increment();
	}

//	CreatureTemplate* creoTempl = creatureTemplateManager->getTemplate(templateCRC);
//
//	if (creoTempl == nullptr)
//		return nullptr;

//	AiAgent* aicre = cast<AiAgent*>(creature);
//
////	Locker locker(creature);
//
//	creature->loadTemplateData(aicre);

	//|| aicre->getElite() >= 1

//	if (leggy == 0 && (System::random(1) >= 1 ) && (prototype->isComponent() || prototype->isLightsaberCrystalObject() || prototype->isArmorObject() || prototype->isWeaponObject())) {//})  && !prototype->isLightsaberCrystalObject()) {
//		UnicodeString newName = prototype->getDisplayedName() + " (Exceptional)";
//		prototype->setCustomObjectName(newName, false);
//
//		excMod = 2.5;// + (System::random(50) * .01);
//		if (prototype->isWeaponObject()) excMod = 2;
//
//		prototype->addMagicBit(false);
//
//		//exceptionalLooted.increment();
//	}

//	if (prototype->isLightsaberCrystalObject()) {
//		LightsaberCrystalComponent* crystal = cast<LightsaberCrystalComponent*> (prototype.get());
//
//		if (crystal != nullptr)
//			crystal->setItemLevel(uncappedLevel);
//	}

	String subtitle;
	bool yellow = false;

	//change dmg type not working
//	if (subtitle == "damageType" && prototype->isWeaponObject()) {
//		int typeroll = System::random(7) + 1;
//		int newtype = 1;
//
//		if (typeroll == 1) newtype = 1;
//		if (typeroll == 2) newtype = 2;
//		if (typeroll == 3) newtype = 4;
//		if (typeroll == 4) newtype = 256;
//		if (typeroll == 5) newtype = 32;
//		if (typeroll == 6) newtype = 64;
//		if (typeroll == 7) newtype = 128;
//		if (typeroll == 8) newtype = 8;
//
//		craftingValues->setCurrentValue(subtitle, newtype);
//		//continue;
//	}

	for (int i = 0; i < craftingValues->getExperimentalPropertySubtitleSize(); ++i) {
		subtitle = craftingValues->getExperimentalPropertySubtitle(i);

		if (subtitle == "hitpoints" && !prototype->isComponent()) {
			continue;
		}

		float min = craftingValues->getMinValue(subtitle);
		float max = craftingValues->getMaxValue(subtitle);

		if (min == max)
			continue;

//		if (subtitle == "armor_health_encumbrance" || subtitle == "armor_action_encumbrance" || subtitle == "armor_mind_encumbrance") {
//			//craftingValues->setMaxValue(subtitle, max / 4);//attempt to increase looted armor encumb
//			min *= 4;
//			max *= 4;
//		}

		float percentage = level / 500;//System::random(10000) / 10000.f;//.7 + ((level / 350) * .2) + (System::random(200) * .001);//((level / 350) * .90) + (System::random(2000) * .0001);//System::random(10000) / 10000.f;;//System::random(1500) * .001;//(level * .01) * (System::random(150) * .01);//System::random(10000) / 10000.f;//this is where the variance happens
		percentage *= .7 + (System::random(300) / 1000);

		if (percentage > 1.0) percentage = 1.0;
		if (percentage < 0.01) percentage = 0.01;

		// If the attribute is represented by an integer (useCount, maxDamage,
		// range mods, etc), we need to base the percentage on a random roll
		// of possible values (min -> max), otherwise only an exact roll of
		// 10000 will result in the top of the range being chosen.
		// (Mantis #7869)
		int precision = craftingValues->getPrecision(subtitle);
		if (precision == (int)ValuesMap::VALUENOTFOUND) {
			error ("No precision found for " + subtitle);
		}
		else if (precision == 0) {//this part ruins all crafting values with 0 at the end, ie. {"useCount",3,11,0}
			int range = abs(max-min);
			int randomValue = System::random(range);
			percentage = (float)randomValue / (float)(range);
			//percentage *= 1.3;
		}

		if (percentage > 1.0) percentage = 1.0;


		if (subtitle == "useCount") {
			//craftingValues->setMaxValue(subtitle, min * 2);
			//craftingValues->setMaxValue(subtitle, max * 2);

			int range = abs(max-min);
			int randomValue = System::random(range);
			percentage = (float)randomValue / (float)(range);
		}

		if (subtitle == "color") {
			int ncolor = System::random(5);//color max set in loot color crystal lua file

			if (System::random(3) >= 3){//&& level >= 85//lvl 25 x 3.5 loot mult = 87
				ncolor = System::random(6) + 5;//color crystals will be yellow,purp,orange
			}
			if (System::random(10) >= 10 && level >= 300){
				ncolor = System::random(19) + 11;//color crystals will be special named colors
			}

			craftingValues->setCurrentValue(subtitle, ncolor);
			continue;
		}


//		if (subtitle == "forcecost") {
//			int nfc = (level / 3.5) / 100 * 10;
//
//			craftingValues->setCurrentValue(subtitle, nfc);
//			continue;
//		}

		//percentage = level / 100;//this will be good for the next interation

		craftingValues->setCurrentPercentage(subtitle, percentage);

		if (subtitle == "maxrange" || subtitle == "midrange" || subtitle == "zerorangemod" || subtitle == "maxrangemod" || subtitle == "forcecost") {
			continue;
		}

		if (subtitle == "midrangemod" && !prototype->isComponent()) {
			continue;
		}

		if (subtitle == "useCount" || subtitle == "quantity" || subtitle == "charges" || subtitle == "uses" || subtitle == "charge") {
			craftingValues->setMinValue(subtitle, min * 2);
			craftingValues->setMaxValue(subtitle, max * 2);
			continue;
		}

		//remove all this crap next iteration
		float minMod = (max > min) ? 2000.f : -2000.f;
		float maxMod = (max > min) ? 500.f : -500.f;

		if (max > min && min >= 0) { // Both max and min non-negative, max is higher
			min = ((min * level / minMod) + min) * excMod;
			max = ((max * level / maxMod) + max) * excMod;
//			min = min * ((level / 3.5) * .01) * excMod;
//			max = max * ((level / 3.5) * .01) * excMod;

		} else if (max > min && max <= 0) { // Both max and min are non-positive, max is higher
			minMod *= -1;
			maxMod *= -1;
			min = ((min * level / minMod) + min) / excMod;
			max = ((max * level / maxMod) + max) / excMod;
//			min = min * ((level / 3.5) * .01) / excMod * -1;
//			max = max * ((level / 3.5) * .01) / excMod * -1;

		} else if (max > min) { // max is positive, min is negative
			minMod *= -1;
			min = ((min * level / minMod) + min) / excMod;
			max = ((max * level / maxMod) + max) * excMod;
//			min = min * ((level / 3.5) * .01) / excMod * -1;
//			max = max * ((level / 3.5) * .01) * excMod;

		} else if (max < min && max >= 0) { // Both max and min are non-negative, min is higher
			min = ((min * level / minMod) + min) / excMod;
			max = ((max * level / maxMod) + max) / excMod;
//			min = min * ((level / 3.5) * .01) / excMod;
//			max = max * ((level / 3.5) * .01) / excMod;

		} else if (max < min && min <= 0) { // Both max and min are non-positive, min is higher
			minMod *= -1;
			maxMod *= -1;
			min = ((min * level / minMod) + min) * excMod;
			max = ((max * level / maxMod) + max) * excMod;
//			min = min * ((level / 3.5) * .01) * excMod * -1;
//			max = max * ((level / 3.5) * .01) * excMod * -1;

		} else { // max is negative, min is positive
			maxMod *= -1;
			min = ((min * level / minMod) + min) / excMod;
			max = ((max * level / maxMod) + max) * excMod;
//			min = min * ((level / 3.5) * .01) / excMod;
//			max = max * ((level / 3.5) * .01) * excMod * -1;
		}

		craftingValues->setMinValue(subtitle, min);
		craftingValues->setMaxValue(subtitle, max);
	}

//	if (yellow) {
//		prototype->addMagicBit(false);
//		prototype->setJunkValue((int)(fJunkValue * 1.25));
//	} else {
	prototype->setJunkValue((int)(level * 5 * excMod));
//	}

	// Use percentages to recalculate the values
	craftingValues->recalculateValues(false);

	craftingValues->addExperimentalProperty("creatureLevel", "creatureLevel", level, level, 0, false, ValuesMap::LINEARCOMBINE);
	craftingValues->setHidden("creatureLevel");

	//check weapons and weapon components for min damage > max damage
	if (prototype->isComponent() || prototype->isWeaponObject()) {
		if (craftingValues->hasProperty("mindamage") && craftingValues->hasProperty("maxdamage")) {
			float oldMin = craftingValues->getCurrentValue("mindamage");
			float oldMax = craftingValues->getCurrentValue("maxdamage");

			if (oldMin > oldMax) {
				craftingValues->setCurrentValue("mindamage", oldMax);
				craftingValues->setCurrentValue("maxdamage", oldMin);
			}

		}
	}

	// Add Dots to weapon objects.
	addStaticDots(prototype, templateObject, level);
	addRandomDots(prototype, templateObject, level, excMod);

	setSkillMods(prototype, templateObject, level, excMod);


	if (System::random(3) == 3)// || prototype->isRobeObject())
		setSockets(prototype, craftingValues);

	// Update the Tano with new values
	prototype->updateCraftingValues(craftingValues, true);

	//add some condition damage where appropriate
	if (!maxCondition)
		addConditionDamage(prototype, craftingValues);

	delete craftingValues;

	return prototype;
}

void LootManagerImplementation::addConditionDamage(TangibleObject* loot, CraftingValues* craftingValues) {
	if (!loot->isWeaponObject() && !loot->isArmorObject())
		return;

	float min = 0;

	if(loot->isWeaponObject())
		min = craftingValues->getMinValue("hitpoints");

	if(loot->isArmorObject())
		min = craftingValues->getMinValue("armor_integrity");

	float damage = (float) System::random(min / 3);

	loot->setConditionDamage(damage);
}

void LootManagerImplementation::setSkillMods(TangibleObject* object, const LootItemTemplate* templateObject, int level, float excMod) {
	return;//disable sea

	if (!object->isWearableObject())//only clothing/armor get sea
		return;

	const VectorMap<String, int>* skillMods = templateObject->getSkillMods();
	VectorMap<String, int> additionalMods;

	bool yellow = false;
	float modSqr = excMod * excMod;

	if (System::random(900) + level >= 900) {//(System::random(skillModChance / modSqr) == 0) {
		// if it has a skillmod the name will be yellow
		yellow = true;
		int modCount = 1;
		int roll = System::random(100);

		if(roll > 25)
			modCount += 1;
		if(roll > 50)
			modCount += 1;
		if(roll > 75)
			modCount += 1;

//		if(roll > (100 - modSqr))
//			modCount += 2;
//
//		if(roll < (5 + modSqr))
//			modCount += 1;

		for(int i = 0; i < modCount; ++i) {
			//Mods can't be lower than -1 or greater than 25
			int max = (int) Math::max(-1.f, Math::min(25.f, (float) round(0.1f * level + 3)));
			int min = (int) Math::max(-1.f, Math::min(25.f, (float) round(0.075f * level - 1)));

			int mod = System::random(max - min) + min;

			if(mod == 0)
				mod = 1;

			String modName = getRandomLootableMod( object->getGameObjectType() );
			if( !modName.isEmpty() )
				additionalMods.put(modName, mod);
		}
	}

	if (object->isWearableObject()) {
		ManagedReference<TangibleObject*> item = cast<TangibleObject*>(object);

		if(additionalMods.size() > 0)
			yellow = true;

		for (int i = 0; i < additionalMods.size(); i++) {
			item->addSkillMod(SkillModManager::WEARABLE, additionalMods.elementAt(i).getKey(), additionalMods.elementAt(i).getValue());
		}

		for (int i = 0; i < skillMods->size(); i++) {
			item->addSkillMod(SkillModManager::WEARABLE, skillMods->elementAt(i).getKey(), skillMods->elementAt(i).getValue());
		}
	}

	if (yellow)
		object->addMagicBit(false);
}

String LootManagerImplementation::getRandomLootableMod( unsigned int sceneObjectType ) {
	if( sceneObjectType == SceneObjectType::ARMORATTACHMENT ){
		return lootableArmorAttachmentMods.get(System::random(lootableArmorAttachmentMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::CLOTHINGATTACHMENT ){
		return lootableClothingAttachmentMods.get(System::random(lootableClothingAttachmentMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::ARMOR || sceneObjectType == SceneObjectType::BODYARMOR ||
			 sceneObjectType == SceneObjectType::HEADARMOR || sceneObjectType == SceneObjectType::MISCARMOR ||
			 sceneObjectType == SceneObjectType::LEGARMOR || sceneObjectType == SceneObjectType::ARMARMOR ||
			 sceneObjectType == SceneObjectType::HANDARMOR || sceneObjectType == SceneObjectType::FOOTARMOR ){
		return lootableArmorMods.get(System::random(lootableArmorMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::CLOTHING || sceneObjectType == SceneObjectType::BANDOLIER ||
			 sceneObjectType == SceneObjectType::BELT || sceneObjectType == SceneObjectType::BODYSUIT ||
		     sceneObjectType == SceneObjectType::CAPE || sceneObjectType == SceneObjectType::CLOAK ||
			 sceneObjectType == SceneObjectType::FOOTWEAR || sceneObjectType == SceneObjectType::DRESS ||
			 sceneObjectType == SceneObjectType::HANDWEAR || sceneObjectType == SceneObjectType::EYEWEAR ||
			 sceneObjectType == SceneObjectType::HEADWEAR || sceneObjectType == SceneObjectType::JACKET ||
			 sceneObjectType == SceneObjectType::PANTS || sceneObjectType == SceneObjectType::ROBE ||
			 sceneObjectType == SceneObjectType::SHIRT || sceneObjectType == SceneObjectType::VEST ||
			 sceneObjectType == SceneObjectType::WOOKIEGARB || sceneObjectType == SceneObjectType::MISCCLOTHING ||
			 sceneObjectType == SceneObjectType::SKIRT || sceneObjectType == SceneObjectType::WEARABLECONTAINER ||
			 sceneObjectType == SceneObjectType::JEWELRY || sceneObjectType == SceneObjectType::RING ||
			 sceneObjectType == SceneObjectType::BRACELET || sceneObjectType == SceneObjectType::NECKLACE ||
			 sceneObjectType == SceneObjectType::EARRING ){
		return lootableClothingMods.get(System::random(lootableClothingMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::ONEHANDMELEEWEAPON ){
		return lootableOneHandedMeleeMods.get(System::random(lootableOneHandedMeleeMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::TWOHANDMELEEWEAPON ){
		return lootableTwoHandedMeleeMods.get(System::random(lootableTwoHandedMeleeMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::MELEEWEAPON ){
		return lootableUnarmedMods.get(System::random(lootableUnarmedMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::PISTOL ){
		return lootablePistolMods.get(System::random(lootablePistolMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::RIFLE ){
		return lootableRifleMods.get(System::random(lootableRifleMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::CARBINE ){
		return lootableCarbineMods.get(System::random(lootableCarbineMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::POLEARM ){
		return lootablePolearmMods.get(System::random(lootablePolearmMods.size() - 1));
	}
	else if( sceneObjectType == SceneObjectType::SPECIALHEAVYWEAPON ){
		return lootableHeavyWeaponMods.get(System::random(lootableHeavyWeaponMods.size() - 1));
	}
	else{
		return "";
	}

}

void LootManagerImplementation::setSockets(TangibleObject* object, CraftingValues* craftingValues) {
	if (object->isWearableObject()) { // && craftingValues->hasProperty("sockets")
		ManagedReference<WearableObject*> wearableObject = cast<WearableObject*>(object);

	//	int level = craftingValues->getMaxValue("creatureLevel");
		// Round number of sockets to closes integer.

//		if (object->isRobeObject())
//			wearableObject->setMaxSockets(8);
//		else
		wearableObject->setMaxSockets(System::random(8));// craftingValues->getCurrentValue("sockets") + 0.5);
	}
}

bool LootManagerImplementation::createLoot(TransactionLog& trx, SceneObject* container, AiAgent* creature) {
	auto lootCollection = creature->getLootGroups();

	if (lootCollection == nullptr)
		return false;

	return createLootFromCollection(trx, container, lootCollection, creature->getLevel());
}

bool LootManagerImplementation::createLootFromCollection(TransactionLog& trx, SceneObject* container, const LootGroupCollection* lootCollection, int level) {
	for (int i = 0; i < lootCollection->count(); ++i) {
		const LootGroupCollectionEntry* entry = lootCollection->get(i);
		int lootChance = entry->getLootChance() * 1.5; //using a multiplier gives less empty corpses 1.5x is helpful, 2x significant

		//random holocron creation (only drops on mobs that have loot lists)
		int holochance = 350;
		if (System::random(holochance) >= holochance){
			createLoot(trx, container, "holocron_3", level);
		}


		if (lootChance <= 0)
			continue;

//		int roll = System::random(100);
//
//		if (roll <= 40)//%chance not to drop
//			continue;

		int roll = System::random(10000000);

//		if (roll > lootChance)
//			continue;

		int tempChance = 0; //Start at 0.

		const LootGroups* lootGroups = entry->getLootGroups();

		//Now we do the second roll to determine loot group.
		roll = System::random(10000000);

		//Select the loot group to use.
		for (int i = 0; i < lootGroups->count(); ++i) {
			const LootGroupEntry* entry = lootGroups->get(i);

			tempChance += entry->getLootChance();

			//Is this entry lower than the roll? If yes, then we want to try the next entry.
			if (tempChance < roll)
				continue;

//			if (System::random(100) > 80)
//				level = System::random(300);

			createLoot(trx, container, entry->getLootGroupName(), level);

			break;
		}

		//double loot

//		ManagedReference<CreatureObject*> player = container->getParent();
//		ManagedReference<ZoneClientSession*> client = player->getClient();
//
//		int accID = client->getAccountID();
//
//		if (accID == 1 || accID == 83)	{
//		//Now we do the second roll to determine loot group.
//		roll = System::random(10000000);
//
//		if (System::random(100) > 50){
//		//Select the loot group to use.
//		for (int i = 0; i < lootGroups->count(); ++i) {
//			const LootGroupEntry* entry = lootGroups->get(i);
//
//			tempChance += entry->getLootChance();
//
//			//Is this entry lower than the roll? If yes, then we want to try the next entry.
//			if (tempChance < roll)
//				continue;
//
////			if (System::random(100) > 80)
////				level = System::random(300);
//
//			createLoot(trx, container, entry->getLootGroupName(), level);
//
//			break;
//		}
//		}
//		}

//		//triple loot
//		//Now we do the second roll to determine loot group.
//		roll = System::random(10000000);
//
//		//Select the loot group to use.
//		for (int i = 0; i < lootGroups->count(); ++i) {
//			const LootGroupEntry* entry = lootGroups->get(i);
//
//			tempChance += entry->getLootChance();
//
//			//Is this entry lower than the roll? If yes, then we want to try the next entry.
//			if (tempChance < roll)
//				continue;
//
//			if (System::random(100) > 80)
//				level = System::random(300);
//
//			createLoot(trx, container, entry->getLootGroupName(), level);
//
//			break;
//		}
	}

	return true;
}

bool LootManagerImplementation::createLoot(TransactionLog& trx, SceneObject* container, const String& lootGroup, int level, bool maxCondition) {
	Reference<const LootGroupTemplate*> group = lootGroupMap->getLootGroupTemplate(lootGroup);

	if (group == nullptr) {
		warning("Loot group template requested does not exist: " + lootGroup);
		return false;
	}

	//Now we do the third roll for the item out of the group.
	int roll = System::random(10000000);

	String selection = group->getLootGroupEntryForRoll(roll);

	//Check to see if the group entry is another group
	if (lootGroupMap->lootGroupExists(selection))
		return createLoot(trx, container, selection, level, maxCondition);

	//Entry wasn't another group, it should be a loot item
	Reference<const LootItemTemplate*> itemTemplate = lootGroupMap->getLootItemTemplate(selection);

	if (itemTemplate == nullptr) {
		warning("Loot item template requested does not exist: " + group->getLootGroupEntryForRoll(roll) + " for templateName: " + group->getTemplateName());
		return false;
	}

	TangibleObject* obj = createLootObject(itemTemplate, level, maxCondition);

	if (obj == nullptr)
		return false;

	trx.setSubject(obj);
	trx.addState("lootGroup", lootGroup);
	trx.addState("lootLevel", level);
	trx.addState("lootMaxCondition", maxCondition);

	if (container->transferObject(obj, -1, false, true)) {
		container->broadcastObject(obj, true);
	} else {
		obj->destroyObjectFromDatabase(true);
		trx.errorMessage() << "failed to transferObject to container.";
		return false;
	}

	return true;
}

bool LootManagerImplementation::createLootSet(TransactionLog& trx, SceneObject* container, const String& lootGroup, int level, bool maxCondition, int setSize) {
	Reference<const LootGroupTemplate*> group = lootGroupMap->getLootGroupTemplate(lootGroup);

	if (group == nullptr) {
		warning("Loot group template requested does not exist: " + lootGroup);
		return false;
	}
	//Roll for the item out of the group.
	int roll = System::random(10000000);

	int lootGroupEntryIndex = group->getLootGroupIntEntryForRoll(roll);

	for(int q = 0; q < setSize; q++) {
		String selection = group->getLootGroupEntryAt(lootGroupEntryIndex+q);
		Reference<const LootItemTemplate*> itemTemplate = lootGroupMap->getLootItemTemplate(selection);

		if (itemTemplate == nullptr) {
			warning("Loot item template requested does not exist: " + group->getLootGroupEntryForRoll(roll) + " for templateName: " + group->getTemplateName());
			return false;
		}

		TangibleObject* obj = createLootObject(itemTemplate, level, maxCondition);

		if (obj == nullptr)
			return false;

		trx.addRelatedObject(obj);

		if (container->transferObject(obj, -1, false, true)) {
			container->broadcastObject(obj, true);
		} else {
			trx.errorMessage() << "failed to transferObject " << obj->getObjectID() << " to container.";
			obj->destroyObjectFromDatabase(true);
			return false;
		}
	}

	return true;
}

void LootManagerImplementation::addStaticDots(TangibleObject* object, const LootItemTemplate* templateObject, int level) {
	//disable dot loot
	//return;

	if (object == nullptr)
		return;

	if (!object->isWeaponObject())
		return;

	ManagedReference<WeaponObject*> weapon = cast<WeaponObject*>(object);

	bool shouldGenerateDots = false;

	float dotChance = templateObject->getStaticDotChance();

	if (dotChance < 0)
		return;

	// Apply the Dot if the chance roll equals the number or is zero.
	if (dotChance == 0 || System::random(dotChance) == 0) { // Defined in loot item script.
		shouldGenerateDots = true;
	}

	if (shouldGenerateDots) {

		int dotType = templateObject->getStaticDotType();

		if (dotType < 1 || dotType > 4)
			return;

		const VectorMap<String, SortedVector<int> >* dotValues = templateObject->getStaticDotValues();
		int size = dotValues->size();

		// Check if they specified correct vals.
		if (size > 0) {
			weapon->addDotType(dotType);

			for (int i = 0; i < size; i++) {

				const String& property = dotValues->elementAt(i).getKey();
				const SortedVector<int>& theseValues = dotValues->elementAt(i).getValue();
				int min = theseValues.elementAt(0);
				int max = theseValues.elementAt(1);
				float value = 0;

				if (max != min) {
					value = calculateDotValue(min, max, level);
				}
				else { value = max; }

				if(property == "attribute") {
					if (min != max)
						value = System::random(max - min) + min;

					if (dotType != 2 && (value != 0 && value != 3 && value != 6)) {
						int numbers[] = { 0, 3, 6 }; // The main pool attributes.
						int choose = System::random(2);
						value = numbers[choose];
					}

					weapon->addDotAttribute(value);
				} else if (property == "strength") {
					weapon->addDotStrength(value);
				} else if (property == "duration") {
					weapon->addDotDuration(value);
				} else if (property == "potency") {
					weapon->addDotPotency(value);
				} else if (property == "uses") {
					weapon->addDotUses(value);
				}
			}

			weapon->addMagicBit(false);
		}
	}
}

void LootManagerImplementation::addRandomDots(TangibleObject* object, const LootItemTemplate* templateObject, int level, float excMod) {
	//disable dot loot
	//return;

	if (object == nullptr)
		return;

	if (!object->isWeaponObject())
		return;

	ManagedReference<WeaponObject*> weapon = cast<WeaponObject*>(object);

	bool shouldGenerateDots = false;

	float dotChance = templateObject->getRandomDotChance();

	if (dotChance < 0)
		return;

//	float modSqr = excMod * excMod;

	// Apply the Dot if the chance roll equals the number or is zero.
	if (System::random(10) == 10) { // Defined in loot item script.//not anymore
		shouldGenerateDots = true;
	}

	if (shouldGenerateDots) {

		int number = 1;

//		if (System::random(250 / modSqr) == 0)
//			number = 2;//no double dots

		for (int i = 0; i < number; i++) {
			int dotType = System::random(2) + 1;

			weapon->addDotType(dotType);

			int attMin = randomDotAttribute.elementAt(0);
			int attMax = randomDotAttribute.elementAt(1);
			float att = 0;

			if (attMin != attMax)
				att= System::random(attMax - attMin) + attMin;

			if (dotType != 2 && (att != 0 && att != 3 && att != 6)) {
				int numbers[] = { 0, 3, 6 }; // The main pool attributes.
				int choose = System::random(2);
				att = numbers[choose];
			}

			weapon->addDotAttribute(att);

			int strMin = randomDotStrength.elementAt(0);
			int strMax = randomDotStrength.elementAt(1);
			float str = 0;

			if (strMax != strMin)
				str = calculateDotValue(strMin, strMax, level);
			else
				str = strMax;

//			if (excMod == 1.0 && (yellowChance == 0 || System::random(yellowChance) == 0)) {
//				str *= yellowModifier;
//			}

			if (dotType == 1)
				str = str * 2;
			else if (dotType == 3)
				str = str * 1.5;

			weapon->addDotStrength(str * excMod);

			int durMin = randomDotDuration.elementAt(0);
			int durMax = randomDotDuration.elementAt(1);
			float dur = 0;

			if (durMax != durMin)
				dur = calculateDotValue(durMin, durMax, level);
			else
				dur = durMax;

//			if (excMod == 1.0 && (yellowChance == 0 || System::random(yellowChance) == 0)) {
//				dur *= yellowModifier;
//			}

			if (dotType == 2)
				dur = dur * 5;
			else if (dotType == 3)
				dur = dur * 1.5;

			weapon->addDotDuration(dur * excMod);

			int potMin = randomDotPotency.elementAt(0);
			int potMax = randomDotPotency.elementAt(1);
			float pot = 0;

			if (potMax != potMin)
				pot = calculateDotValue(potMin, potMax, level);
			else
				pot = potMax;

//			if (excMod == 1.0 && (yellowChance == 0 || System::random(yellowChance) == 0)) {
//				pot *= yellowModifier;
//			}

			weapon->addDotPotency(pot * excMod);

			int useMin = randomDotUses.elementAt(0);
			int useMax = randomDotUses.elementAt(1);
			float use = 0;

			if (useMax != useMin)
				use = calculateDotValue(useMin, useMax, level);
			else
				use = useMax;

//			if (excMod == 1.0 && (yellowChance == 0 || System::random(yellowChance) == 0)) {
//				use *= yellowModifier;
//			}

			weapon->addDotUses(use * excMod);
		}

		weapon->addMagicBit(false);
	}
}

float LootManagerImplementation::calculateDotValue(float min, float max, float level) {
	float randVal = (float)System::random(max - min);
	float value = Math::max(min, Math::min(max, randVal * (1 + (level / 1000)))); // Used for Str, Pot, Dur, Uses.

	if (value < min) {
		value = min;
	}

	return value;
}
