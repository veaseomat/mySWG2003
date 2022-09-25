/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef SABERTHROW2COMMAND_H_
#define SABERTHROW2COMMAND_H_

#include "JediCombatQueueCommand.h"

class SaberThrow2Command : public JediCombatQueueCommand {
public:

	SaberThrow2Command(const String& name, ZoneProcessServer* server)
		: JediCombatQueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (isWearingArmor(creature)) {
			return NOJEDIARMOR;
		}

		return doCombatAction(creature, target);
	}

//	float getCommandDuration(CreatureObject *object, const UnicodeString& arguments) const {
//		float combatHaste = object->getSkillMod("combat_haste");
//
//		if (combatHaste > 0)
//			return speed * (1.f - (combatHaste / 100.f));
//		else
//			return speed;
//	}

};

#endif //SABERTHROW2COMMAND_H_
