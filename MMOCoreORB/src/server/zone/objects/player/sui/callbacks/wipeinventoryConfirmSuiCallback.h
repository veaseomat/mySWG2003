/*
 * wipeinventoryConfirmSuiCallback.h
 *
 *  Created on: Aug 14, 2011
 *      Author: crush
 */

#ifndef WIPEINVENTORYCONFIRMSUICALLBACK_H_
#define WIPEINVENTORYCONFIRMSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/transaction/TransactionLog.h"

class wipeinventoryConfirmSuiCallback : public SuiCallback {
public:
	wipeinventoryConfirmSuiCallback(ZoneServer* serv) : SuiCallback(serv) {
	}

	void run(CreatureObject* creature, SuiBox* sui, uint32 eventIndex, Vector<UnicodeString>* args) {
		bool cancelPressed = (eventIndex == 1);

		if (!sui->isMessageBox() || cancelPressed)
			return;

		Locker clocker(creature, creature);

		SceneObject* inventory = creature->getSlottedObject("inventory");

		if (inventory == nullptr)
			return;

		while (inventory->getContainerObjectsSize() > 0)
		{
			ManagedReference<SceneObject*> object = inventory->getContainerObject(0);
			Locker sceneObjectLocker(object);
			object->destroyObjectFromWorld(true);
			object->destroyObjectFromDatabase(true);
		}

		creature->sendSystemMessage("Your inventory has been wiped.");

//		ManagedReference<SceneObject*> obj = sui->getUsingObject().get();
//
//		if (obj == nullptr || !obj->isBuildingObject())
//			return;
//
//		BuildingObject* building = cast<BuildingObject*>( obj.get());
//
//		Locker _lock(building, creature);
//
//		TransactionLog trx(TrxCode::PLAYERMISCACTION, creature, building);
//
//		if (trx.isVerbose()) {
//			// Force a synchronous export because the objects will be deleted before we can export them!
//			trx.addRelatedObject(building, true);
//			trx.setExportRelatedObjects(true);
//			trx.exportRelated();
//		}
//
//		building->destroyAllPlayerItems();
//
//		creature->sendSystemMessage("@player_structure:items_deleted"); //All of the objects in your house have been deleted.
	}
};

#endif /* WIPEINVENTORYCONFIRMSUICALLBACK_H_ */
