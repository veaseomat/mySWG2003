/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef FORCEWEAKEN1COMMAND_H_
#define FORCEWEAKEN1COMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "ForcePowersQueueCommand.h"
#include "server/zone/objects/creature/buffs/ForceWeakenDebuff.h"

class ForceWeaken1Command : public ForcePowersQueueCommand {
public:

	ForceWeaken1Command(const String& name, ZoneProcessServer* server)
		: ForcePowersQueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (isWearingArmor(creature)) {
			return NOJEDIARMOR;
		}

		ManagedReference<SceneObject*> targetObject = server->getZoneServer()->getObject(target);

		if (targetObject == nullptr || !targetObject->isCreatureObject()) {
			return INVALIDTARGET;
		}

		CreatureObject* creatureTarget = targetObject.castTo<CreatureObject*>();

		if (creatureTarget->hasBuff(STRING_HASHCODE("forceweaken1")) || creatureTarget->hasBuff(STRING_HASHCODE("forceweaken2"))) {
			return ALREADYAFFECTEDJEDIPOWER;
		}

		int res = doCombatAction(creature, target);

		if (res == SUCCESS) {
			Locker clocker(creatureTarget, creature);

			int newhammax = (creatureTarget->getMaxHAM(CreatureAttribute::HEALTH) + creatureTarget->getMaxHAM(CreatureAttribute::ACTION) + creatureTarget->getMaxHAM(CreatureAttribute::MIND)) / 3;//avg max hams together

			float frsbuff = ((creature->getSkillMod("force_power_dark") + creature->getSkillMod("force_power_light")) / 600);//120/600=.2

			newhammax *= (.2 + frsbuff);//percent dbuff of average ham

			newhammax /= 5;//number of ticks

			ManagedReference<Buff*> buff = new ForceWeakenDebuff(creatureTarget, getNameCRC(), newhammax, 500, 90);

			Locker locker(buff);

			creatureTarget->addBuff(buff);

			CombatManager::instance()->broadcastCombatSpam(creature, creatureTarget, nullptr, 0, "cbt_spam", combatSpam + "_hit", 1);
		}

		return res;
	}

};

#endif //FORCEWEAKEN1COMMAND_H_
