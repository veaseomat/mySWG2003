/*
 * ForageManagerImplementation.cpp
 *
 *  Created on: Feb 20, 2011
 *      Author: Anakis
 */

#include "server/zone/managers/minigames/ForageManager.h"
#include "server/zone/managers/loot/LootManager.h"
#include "server/zone/managers/resource/ResourceManager.h"
#include "server/zone/managers/minigames/events/ForagingEvent.h"
#include "server/zone/objects/area/ForageAreaCollection.h"
#include "templates/params/creature/CreatureAttribute.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/planet/PlanetManager.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/skill/SkillManager.h"

void ForageManagerImplementation::startForaging(CreatureObject* player, int forageType) {
	if (player == nullptr)
		return;

	Locker playerLocker(player);

	int actionCostForage = 50;
	int mindCostShellfish = 100;
	int actionCostShellfish =  100;

	//Check if already foraging.
	Reference<Task*> pendingForage = player->getPendingTask("foraging");
	if (pendingForage != nullptr) {

		if (forageType == ForageManager::SHELLFISH)
			player->sendSystemMessage("@harvesting:busy");
		else
			player->sendSystemMessage("@skl_use:sys_forage_already"); //"You are already foraging."
		return;
	}

	// Check if mounted
	if (player->isRidingMount()) {
		player->sendSystemMessage("@error_message:survey_on_mount"); // You cannot perform that action while mounted on a creature or driving a vehicle.
		return;
	}

	Reference<PlayerObject*> pghost = player->getPlayerObject();
	Zone* nzone = player->getZone();

	if (!pghost->isJedi() && nzone->getZoneName() != "dantooine" && (player->getParentID() != 8535483 || player->getParentID() != 8535484 || player->getParentID() != 8535485 || player->getParentID() != 8535486 )) { //this allows foraging inside cave

	//Check if player is inside a structure.
	if (player->getParentID() != 0) {
		if (forageType == ForageManager::SHELLFISH)
			player->sendSystemMessage("@harvesting:inside");
		else
			player->sendSystemMessage("@skl_use:sys_forage_inside"); //"You can't forage inside a structure."
		return;
	}

	}

	//Check if a player is swimming for shellfish harvesting
	if (forageType == ForageManager::SHELLFISH && player->isSwimming()){
		player->sendSystemMessage("@harvesting:swimming");
		return;
	}

	//Check if player is in water for shellfish harvesting
	if (forageType == ForageManager::SHELLFISH && !player->isInWater()){
		player->sendSystemMessage("@harvesting:in_water");
		return;
	}
    //Check for action and deduct cost.

	if (forageType == ForageManager::SHELLFISH){

		//Adjust costs based upon player's Focus and Quickness
		int mindCost = player->calculateCostAdjustment(CreatureAttribute::FOCUS, mindCostShellfish);
		int actionCost = player->calculateCostAdjustment(CreatureAttribute::QUICKNESS, actionCostShellfish);

		if (player->getHAM(CreatureAttribute::MIND) < mindCost + 1 || player->getHAM(CreatureAttribute::ACTION) < actionCost + 1)
			return;
		else {
			player->inflictDamage(player, CreatureAttribute::MIND, mindCost, false, true);
			player->inflictDamage(player, CreatureAttribute::ACTION, actionCost, false, true);
		}
	}
	else {

		//Adjust action cost based upon a player's Quickness
		int actionCost = player->calculateCostAdjustment(CreatureAttribute::QUICKNESS, actionCostForage);

		if (player->getHAM(CreatureAttribute::ACTION) >= actionCost + 1)
			player->inflictDamage(player, CreatureAttribute::ACTION, actionCost, false, true);

		else {
			player->sendSystemMessage("@skl_use:sys_forage_attrib"); //"You need to rest before you can forage again."
			return;
		}
	}


	//Collect player's current position.
	float playerX = player->getPositionX();
	float playerY = player->getPositionY();
	ManagedReference<ZoneServer*> zoneServer = player->getZoneServer();

	//Queue the foraging task.
	Zone* zone = player->getZone();

	if (zone == nullptr)
		return;

	Reference<Task*> foragingEvent = new ForagingEvent(player, forageType, playerX, playerY, zone->getZoneName());
	player->addPendingTask("foraging", foragingEvent, 8500);

	if(forageType == ForageManager::LAIR){
		player->sendSystemMessage("You begin to search the lair for creatures"); //"You begin to search the lair for creatures."
	}
	else{
		player->sendSystemMessage("@skl_use:sys_forage_start"); //"You begin to search the area for goods."
	}
	player->doAnimation("forage");

}

void ForageManagerImplementation::finishForaging(CreatureObject* player, int forageType, float forageX, float forageY, const String& zoneName) {
	if (player == nullptr)
		return;

	Locker playerLocker(player);
	Locker forageAreasLocker(_this.getReferenceUnsafeStaticCast());

	player->removePendingTask("foraging");

	if (player->getZone() == nullptr)
		return;

	//Check if player moved.
	float playerX = player->getPositionX();
	float playerY = player->getPositionY();

	if ((fabs(playerX - forageX) > 2.0) || (fabs(playerY - forageY) > 2.0) || player->getZone()->getZoneName() != zoneName) {
		player->sendSystemMessage("@skl_use:sys_forage_movefail"); //"You fail to forage because you moved."
		return;
	}

	//Check if player is in combat.
	if (player->isInCombat()) {
		player->sendSystemMessage("@skl_use:sys_forage_combatfail"); //"Combat distracts you from your foraging attempt."
		return;
	}

	//Check if player is allowed to forage in this area.
	if (forageType != ForageManager::SHELLFISH) {

		Reference<ForageAreaCollection*> forageAreaCollection = forageAreas.get(player->getFirstName());

		if (forageAreaCollection != nullptr) { //Player has foraged before.
			if (!forageAreaCollection->checkForageAreas(forageX, forageY, zoneName, forageType)) {
				if( forageType == LAIR ){
					player->sendSystemMessage("There is nothing of interest remaining in the lair.");
				}
				else{
					player->sendSystemMessage("@skl_use:sys_forage_empty"); //"There is nothing in this area to forage."
				}
				return;
			}

		} else { //Player has not foraged before.
			forageAreaCollection = new ForageAreaCollection(player, forageX, forageY, zoneName, forageType);
			forageAreas.put(player->getFirstName(), forageAreaCollection);
		}
	}

	//Calculate the player's chance to find an item.
	int chance;
	int skillMod;

	switch(forageType) {
	case ForageManager::SCOUT:
	case ForageManager::LAIR:
		skillMod = player->getSkillMod("foraging");
		chance = (int)(15 + (skillMod * 0.8));
		break;
	case ForageManager::MEDICAL:
		skillMod = player->getSkillMod("medical_foraging");
		chance = (int)(15 + (skillMod * 0.6));
		break;
	default:
		skillMod = 20;
		chance = (int)(15 + (skillMod * 0.6));
		break;
	}

	//Determine if player finds an item.
	if (chance > 100) //There could possibly be +foraging skill tapes.
		chance = 100;

	if (System::random(80) > chance) {
		if (forageType == ForageManager::SHELLFISH)
			player->sendSystemMessage("@harvesting:found_nothing");
		else if (forageType == ForageManager::LAIR)
			player->sendSystemMessage("@lair_n:found_nothing");
		else
			player->sendSystemMessage("@skl_use:sys_forage_fail"); //"You failed to find anything worth foraging."

	} else {

		forageGiveItems(player, forageType, forageX, forageY, zoneName);

	}

	return;

}

bool ForageManagerImplementation::forageGiveItems(CreatureObject* player, int forageType, float forageX, float forageY, const String& planet) {
	if (player == nullptr)
		return false;

	Locker playerLocker(player);

	ManagedReference<LootManager*> lootManager = player->getZoneServer()->getLootManager();
	ManagedReference<SceneObject*> inventory = player->getSlottedObject("inventory");

	if (lootManager == nullptr || inventory == nullptr) {
		player->sendSystemMessage("@skl_use:sys_forage_fail");
		return false;
	}

	//Check if inventory is full.
	if (inventory->isContainerFullRecursive()) {
		player->sendSystemMessage("@skl_use:sys_forage_noroom"); //"Some foraged items were discarded, because your inventory is full."
		return false;
	}

	int itemCount = 1;
	//Determine how many items the player finds.
//	if (forageType == ForageManager::SCOUT) {
//		if (player->hasSkill("outdoors_scout_camp_03") && System::random(5) == 1)
//			itemCount += 1;
//		if (player->hasSkill("outdoors_scout_master") && System::random(5) == 1)
//			itemCount += 1;
//	}

	//Discard items if player's inventory does not have enough space.
	int inventorySpace = inventory->getContainerVolumeLimit() - inventory->getCountableObjectsRecursive();
	if (itemCount > inventorySpace) {
		itemCount = inventorySpace;
		player->sendSystemMessage("@skl_use:sys_forage_noroom"); //"Some foraged items were discarded, because your inventory is full."
	}

	//Determine what the player finds.
	int dice;
	int level = 1;
	String lootGroup = "";
	String resName = "";

	TransactionLog trx(TrxCode::FORAGED, player);

	if (forageType == ForageManager::SHELLFISH){
		bool mullosks = false;
		if (System::random(100) > 50) {
			resName = "seafood_mollusk";
			mullosks = true;
		}
		else
			resName = "seafood_crustacean";

		if(forageGiveResource(trx, player, forageX, forageY, planet, resName)) {
			if (mullosks)
				player->sendSystemMessage("@harvesting:found_mollusks");
			else
				player->sendSystemMessage("@harvesting:found_crustaceans");
			trx.commit(true);
			return true;
		}
		else {
			player->sendSystemMessage("@harvesting:found_nothing");
			trx.discard();
			return false;
		}

	}

	if (forageType == ForageManager::SCOUT) {

		for (int i = 0; i < itemCount; i++) {
			dice = System::random(200);
			level = 1;

			if (dice >= 0 && dice < 160) {
				lootGroup = "forage_food";
			} else if (dice > 159 && dice < 200) {
				lootGroup = "forage_bait";
			} else {
				lootGroup = "forage_rare";
			}

			Reference<PlayerObject*> pghost = player->getPlayerObject();
			Zone* zone = player->getZone();
			//ManagedReference<SceneObject*> obj = player->getParentRecursively(SceneObjectType::POIBUILDING);
			//SortedVector<ActiveArea*> activeAreas;
			//zone->getInRangeActiveAreas(forageX, forageY, &activeAreas, true);
			ManagedReference<PlanetManager*> planetManager = zone->getPlanetManager();
			//TangibleObject* tano = player->asTangibleObject();
			//uint64 parentID = 0;

//			if (player->isInRange(player, 128.f) && (player->getPositionX() >= 900 && player->getPositionX() <= 1100) ) {
//
//			}

			ZoneServer* server = player->getZoneServer();
			PlayerManager* pManager = server->getPlayerManager();
			//int plvl = pManager->calculatePlayerLevel(player) * 4;
			int skillboxes = SkillManager::instance()->getJediSkillCount(player, true);
			if (skillboxes > 36) skillboxes = 36;//36 is 2 full skill trees worth
			skillboxes *= 2.78;//36 * 2.78 = 100

			if (pghost->isJedi() && zone->getZoneName() == "dantooine" && (player->getParentID() == 8535483 || player->getParentID() == 8535484 || player->getParentID() == 8535485 || player->getParentID() == 8535486 )) { //(player->getPositionX() >= 900 && player->getPositionX() <= 1100) && (player->getPositionY() >= 1900 && player->getPositionY() <= 2100)
				lootGroup = "color_crystals";
				level = System::random(skillboxes) + 1;
				//lootManager->createLoot(trx, inventory, lootGroup, level);
			}

//			if (zone->getZoneName() == "dantooine" && planetManager->isInRangeWithPoi(forageX, forageY, 100) && System::random(20) == 20) { //pghost->isJedi() &&   // && obj != nullptr
//				lootGroup = "color_crystals";
//				level = System::random(10);
//				//lootManager->createLoot(trx, inventory, lootGroup, level);
//			}

			lootManager->createLoot(trx, inventory, lootGroup, level);
		}

	} else if (forageType == ForageManager::MEDICAL) { //Medical Forage
		dice = System::random(200);
		level = 1;

		if (dice >= 0 && dice < 40) { //Forage food.
			lootGroup = "forage_food";

		} else if (dice > 39 && dice < 110) { //Resources.
			if(forageGiveResource(trx, player, forageX, forageY, planet, resName)) {
				player->sendSystemMessage("@skl_use:sys_forage_success");
				trx.commit(true);
				return true;
			} else {
				player->sendSystemMessage("@skl_use:sys_forage_fail");
				trx.discard();
				return false;
			}
		} else if (dice > 109 && dice < 170) { //Average components.
			lootGroup = "forage_medical_component";
			level = 1;
		} else if (dice > 169 && dice < 200) { //Good components.
			lootGroup = "forage_medical_component";
			level = 60;
		} else { //Exceptional Components
			lootGroup = "forage_medical_component";
			level = 200;
		}

		lootManager->createLoot(trx, inventory, lootGroup, level);

	} else if (forageType == ForageManager::LAIR) { //Lair Search
		dice = System::random(109);
		level = 1;

		if (dice >= 0 && dice < 40) { // Live Creatures
			lootGroup = "forage_live_creatures";
		}
		else if (dice > 39 && dice < 110) { // Eggs
			resName = "meat_egg";
			if(forageGiveResource(trx, player, forageX, forageY, planet, resName)) {
				player->sendSystemMessage("@lair_n:found_eggs");
				trx.commit(true);
				return true;
			} else {
				player->sendSystemMessage("@lair_n:found_nothing");
				trx.discard();
				return false;
			}
		}

		if(!lootManager->createLoot(trx, inventory, lootGroup, level)) {
			player->sendSystemMessage("Unable to create loot for lootgroup " + lootGroup);
			trx.abort() << "Unabled to create loot for lootgroup " << lootGroup;
			return false;
		}

		player->sendSystemMessage("@lair_n:found_bugs");
		trx.commit(true);
		return true;
	}

	player->sendSystemMessage("@skl_use:sys_forage_success");
	trx.commit(true);
	return true;
}

bool ForageManagerImplementation::forageGiveResource(TransactionLog& trx, CreatureObject* player, float forageX, float forageY, const String& planet, String& resType) {
	if (player == nullptr)
		return false;

	ManagedReference<ResourceManager*> resourceManager = player->getZoneServer()->getResourceManager();

	if (resourceManager == nullptr)
		return false;

	ManagedReference<ResourceSpawn*> resource = nullptr;

	if(resType.isEmpty()) {
		//Get a list of the flora on the planet.
		Vector<ManagedReference<ResourceSpawn*> > resources;
		resourceManager->getResourceListByType(resources, 3, planet);
		if (resources.size() < 1)
			return false;

		while (resources.size() > 0) {
			int key = System::random(resources.size() - 1);
			float density = resources.get(key)->getDensityAt(planet, forageX, forageY);

			if (density <= 0.0 && resources.size() > 1) { //No concentration of this resource near the player.
				resources.remove(key); //Remove and pick another one.

			} else { //If there is only one left, we give them that one even if density is 0.
				resource = resources.get(key);
				break;
			}
		}
	} else {
		if(player->getZone() == nullptr)
			return false;

		resType = resType + "_" + player->getZone()->getZoneName();
		resource = resourceManager->getCurrentSpawn(resType, player->getZone()->getZoneName());

		if(resource == nullptr) {
			StringBuffer message;
			message << "Resource type not available: " << resType << " on " << player->getZone()->getZoneName();
			warning(message.toString());
			return false;
		}
	}

	int quantity = System::random(30) + 10;
	resourceManager->harvestResourceToPlayer(trx, player, resource, quantity);
	return true;
}
