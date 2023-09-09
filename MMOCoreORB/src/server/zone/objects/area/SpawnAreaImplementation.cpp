/*
 * SpawnAreaImplementation.cpp
 *
 *  Created on: 11/12/2011
 *      Author: victor
 */

#include "server/zone/objects/area/SpawnArea.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/creature/CreatureManager.h"
#include "server/zone/managers/creature/CreatureTemplateManager.h"
#include "server/zone/managers/creature/SpawnGroup.h"
//#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/managers/planet/PlanetManager.h"
#include "server/zone/objects/area/SpawnAreaObserver.h"
#include "server/zone/objects/area/areashapes/AreaShape.h"
#include "server/ServerCore.h"
#include "events/RemoveNoSpawnAreaTask.h"

void SpawnAreaImplementation::buildSpawnList(Vector<uint32>* groupCRCs) {
	CreatureTemplateManager* ctm = CreatureTemplateManager::instance();

	for (int i = 0; i < groupCRCs->size(); i++) {
		SpawnGroup* group = ctm->getSpawnGroup(groupCRCs->get(i));

		const Vector<Reference<LairSpawn*> >& spawnList = group->getSpawnList();

		for (int j = 0; j < spawnList.size(); j++) {
			const auto& spawn = spawnList.get(j);

			possibleSpawns.emplace(spawn);

			totalWeighting += spawn->getWeighting();
		}
	}
}

Vector3 SpawnAreaImplementation::getRandomPosition(SceneObject* player) {
	Vector3 position;
	bool positionFound = false;
	int retries = 1;//10 is vanilla, seems to affect spawn SPEED, setting 0 nothing spawns

	const auto worldPosition = player->getWorldPosition();

	while (!positionFound && retries-- > 0) {
		position = areaShape->getRandomPosition(worldPosition, 160.0f, 320.0f);//this is how close to the player stuff can spawn min max //margin

		positionFound = true;

		//spawns on top of spawns without this lol
		for (int i = 0; i < noSpawnAreas.size(); ++i) {
			auto noSpawnArea = noSpawnAreas.get(i).get();

			if (noSpawnArea != nullptr && noSpawnArea->containsPoint(position.getX(), position.getY())) {
				positionFound = false;
				break;
			}
		}
	}

	if (!positionFound) {
		position.set(0, 0, 0);
	}

	return position;
}

int SpawnAreaImplementation::notifyObserverEvent(unsigned int eventType, Observable* observable, ManagedObject* arg1, int64 arg2) {
	if (eventType != ObserverEventType::OBJECTREMOVEDFROMZONE)
		return 0;

	SceneObject* sceno = dynamic_cast<SceneObject*>(observable);

	if (sceno == nullptr)
		return 1;

	Locker locker(_this.getReferenceUnsafeStaticCast());

	uint32 lairTemplate = spawnTypes.remove(sceno->getObjectID());

	if (lairTemplate != 0) {
		int currentSpawnCount = spawnCountByType.get(lairTemplate) - 1;

		if (currentSpawnCount < 1)
			spawnCountByType.remove(lairTemplate);
		else
			spawnCountByType.put(lairTemplate, currentSpawnCount);

		--totalSpawnCount;

		locker.release();

		Zone* thisZone = getZone();

		if (sceno->isLairObject() && thisZone != nullptr) {
			ManagedReference<ActiveArea*> area = (ServerCore::getZoneServer()->createObject(STRING_HASHCODE("object/active_area.iff"), 0)).castTo<ActiveArea*>();

			Locker locker(area);

			area->setRadius(16);//set no spawn radius? margin
			area->setNoSpawnArea(true);
			area->initializePosition(sceno->getPositionX(), sceno->getPositionZ(), sceno->getPositionY());

			thisZone->transferObject(area, -1, true);

			Reference<Task*> task = new RemoveNoSpawnAreaTask(area);
			task->schedule(600000);//timer for despawn? 60,000 = 1min, vanilla 300000
		}
	}

	return 1;
}

void SpawnAreaImplementation::tryToSpawn(SceneObject* object) {
	ReadLocker _readlocker(_this.getReferenceUnsafeStaticCast());

	Zone* zone = getZone();

	if (zone == nullptr) {
		warning("zone is nullptr");
		return;
	}

	if (totalSpawnCount >= maxSpawnLimit)
		return;

//	if (lastSpawn.miliDifference() < MINSPAWNINTERVAL)
//		return;

	int choice = System::random(totalWeighting - 1);
	int counter = 0;

	LairSpawn* finalSpawn = nullptr;

	for (int i = 0; i < possibleSpawns.size(); i++) {
		LairSpawn* spawn = possibleSpawns.get(i);

		counter += spawn->getWeighting() * 10;

		if (choice < counter) {
			finalSpawn = spawn;
			break;
		}
	}

	if (finalSpawn == nullptr)
		return;

	ManagedReference<PlanetManager*> planetManager = zone->getPlanetManager();

	Vector3 randomPosition = getRandomPosition(object);

	if (randomPosition.getX() == 0 && randomPosition.getY() == 0) {
		return;
	}

	if (!zone->isWithinBoundaries(randomPosition)) {
		return;
	}

	float spawnZ = zone->getHeight(randomPosition.getX(), randomPosition.getY());

	randomPosition.setZ(spawnZ);

	//lets check if we intersect with some object (buildings, etc..)
	//if (CollisionManager::checkSphereCollision(randomPosition, 64.f + finalSpawn->getSize(), zone))
	//	return;

	// Check the spot to see if spawning is allowed
	if (!planetManager->isSpawningPermittedAt(randomPosition.getX(), randomPosition.getY(), 16)) {//finalSpawn->getSize() + 32.f //this is spawn density, was set to 0 prior //margin
		return;
	}

	int spawnLimit = -1;//finalSpawn->getSpawnLimit();//untested

	String lairTemplate = finalSpawn->getLairTemplateName();
	uint32 lairHashCode = lairTemplate.hashCode();

	int currentSpawnCount = spawnCountByType.get(lairHashCode);

	if (spawnLimit != -1) {
		if (currentSpawnCount >= spawnLimit)
			return;
	}

	int maxDiff = finalSpawn->getMaxDifficulty();
	int minDiff = finalSpawn->getMinDifficulty();
	int difficultyLevel = System::random(maxDiff - minDiff) + minDiff;
	int difficulty = (float)(difficultyLevel - minDiff) / ((maxDiff > (minDiff + 5) ? (float)(maxDiff - minDiff) : 5.f) / 5.f);

	if (difficulty >= 5)
		difficulty = 4;

	_readlocker.release();

	CreatureManager* creatureManager = zone->getCreatureManager();

	ManagedReference<SceneObject*> obj = creatureManager->spawn(lairHashCode, difficultyLevel, difficulty, randomPosition.getX(), spawnZ, randomPosition.getY(), finalSpawn->getSize());

	if (obj != nullptr) {
		obj->debug() << "lair spawned at " << obj->getPositionX() << " " << obj->getPositionY();
	} else {
		error("could not spawn lair " + lairTemplate);

		return;
	}

	Locker _locker2(_this.getReferenceUnsafeStaticCast());

	lastSpawn.updateToCurrentTime();

	if (exitObserver == nullptr) {
		exitObserver = new SpawnAreaObserver(_this.getReferenceUnsafeStaticCast());
		exitObserver->deploy();
	}

	spawnTypes.put(obj->getObjectID(), lairHashCode);

	Locker clocker(obj, _this.getReferenceUnsafeStaticCast());

	obj->registerObserver(ObserverEventType::OBJECTREMOVEDFROMZONE, exitObserver);

	++totalSpawnCount;

	spawnCountByType.put(lairTemplate.hashCode(), currentSpawnCount);

	return;
}
