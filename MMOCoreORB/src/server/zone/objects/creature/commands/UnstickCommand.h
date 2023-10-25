/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef UNSTICKCOMMAND_H_
#define UNSTICKCOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"

class UnstickCommand : public QueueCommand {
public:

	UnstickCommand(const String& name, ZoneProcessServer* server)
		: QueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (creature->isInCombat())
			return INVALIDSTATE;

		CreatureObject* player = cast<CreatureObject*>(creature);
		Zone* zone = player->getZone();

		if(zone == NULL){
			return GENERALERROR;
		}

		if (player->isDead() || player->isIncapacitated()){
			player->sendSystemMessage("You cant unstick now");
			return GENERALERROR;
		}

		if (player->isRidingMount()) {
			player->sendSystemMessage("You cannot unstick while mounted.");
			return GENERALERROR;
		}

		if (player->hasState(CreatureState::PILOTINGSHIP)) {
			player->sendSystemMessage("You cant unstick while in a ship");
			return GENERALERROR;
			}

		if (!player->checkCooldownRecovery("used_unstick")) {
//			StringIdChatParameter stringId;
//
//			Time* cdTime = player->getCooldownTime("used_unstick");
//
//
//			int timeLeft = floor((float)cdTime->miliDifference() / 1000) *-1;
//
//			stringId.setStringId("You must waiting....");
//			stringId.setDI(timeLeft);
			player->sendSystemMessage("Unstick is on a 5 minute cooldown.");
			return 0;
		}

		player->initializePosition(player->getPositionX() + 10, player->getPositionZ() + 10, player->getPositionY() + 10);

		zone->transferObject(player, 1, true);

		player->setPosture(CreaturePosture::UPRIGHT);
		player->addCooldown("used_unstick", 5 * 60 * 1000);
		player->sendSystemMessage("You have been teleported to a safe spot. Wait 15 seconds for recalibration.");

	return SUCCESS;
	}
};

#endif //UNSTICKCOMMAND_H_
