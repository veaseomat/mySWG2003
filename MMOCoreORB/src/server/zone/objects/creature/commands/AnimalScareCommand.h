/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef ANIMALSCARECOMMAND_H_
#define ANIMALSCARECOMMAND_H_

#include "server/zone/objects/creature/commands/JediQueueCommand.h"

class AnimalScareCommand : public JediQueueCommand {
public:

	AnimalScareCommand(const String& name, ZoneProcessServer* server)
		: JediQueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

//		if (!checkStateMask(creature))
//			return INVALIDSTATE;
//
//		if (!checkInvalidLocomotions(creature))
//			return INVALIDLOCOMOTION;
//
//		return SUCCESS;
		creature->sendSystemMessage("This skill has been removed."); //"You do not have enough Force Power to peform that action.
		return GENERALERROR;
	}

};

#endif //ANIMALSCARECOMMAND_H_
