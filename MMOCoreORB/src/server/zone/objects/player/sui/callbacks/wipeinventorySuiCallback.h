/*
 * wipeinventorySuiCallback.h
 *
 *  Created on: Aug 14, 2011
 *      Author: crush
 */

#ifndef WIPEINVENTORYSUICALLBACK_H_
#define WIPEINVENTORYSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/sui/callbacks/wipeinventoryConfirmSuiCallback.h"

class wipeinventorySuiCallback : public SuiCallback {
public:
	wipeinventorySuiCallback(ZoneServer* serv) : SuiCallback(serv) {
	}

	void run(CreatureObject* creature, SuiBox* sui, uint32 eventIndex, Vector<UnicodeString>* args) {
		bool cancelPressed = (eventIndex == 1);

		if (!sui->isMessageBox() || cancelPressed)
			return;

		//Send another confirmation just to be sure.
		sui->setPromptText("Again, this command will delete every item that is not equipped in your inventory. Objects destroyed in this manner are not reimbursable. Are you really sure you want to do this?"); //Again, this command will delete every object in your house. Objects destroyed in this manner are not reimbursable. Are you really sure you want to do this?
		sui->setCallback(new wipeinventoryConfirmSuiCallback(server));

		ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

		if (ghost != nullptr) {
			creature->sendMessage(sui->generateMessage());
			ghost->addSuiBox(sui);
		}
	}
};

#endif /* WIPEINVENTORYSUICALLBACK_H_ */
