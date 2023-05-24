/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef DRAINFORCECOMMAND_H_
#define DRAINFORCECOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "CombatQueueCommand.h"

class DrainForceCommand : public CombatQueueCommand {
public:

	DrainForceCommand(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		creature->sendSystemMessage("This ability is disabled.");
		return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		if (creature->hasAttackDelay() || !creature->checkPostureChangeDelay())
			return GENERALERROR;

		if (isWearingArmor(creature)) {
			return NOJEDIARMOR;
		}

		// Fail if target is not a player...

		ManagedReference<SceneObject*> object = server->getZoneServer()->getObject(target);

		if (object == nullptr)
			return INVALIDTARGET;

		CreatureObject* targetCreature = cast<CreatureObject*>( object.get());

		if (targetCreature == nullptr || targetCreature->isDead() || (targetCreature->isIncapacitated() && !targetCreature->isFeigningDeath()) || !targetCreature->isAttackableBy(creature))
			return INVALIDTARGET;

		if(!checkDistance(creature, targetCreature, range))
			return TOOFAR;

		if (!CollisionManager::checkLineOfSight(creature, targetCreature)) {
			creature->sendSystemMessage("@combat_effects:cansee_fail");//You cannot see your target.
			return GENERALERROR;
		}

		Locker clocker(targetCreature, creature);

		ManagedReference<PlayerObject*> targetGhost = targetCreature->getPlayerObject();
		ManagedReference<PlayerObject*> playerGhost = creature->getPlayerObject();

		if (targetGhost == nullptr || playerGhost == nullptr)
			return GENERALERROR;

		CombatManager* manager = CombatManager::instance();

		if (manager->startCombat(creature, targetCreature, false)) { //lockDefender = false because already locked above.
			int forceSpace = playerGhost->getForcePowerMax() - playerGhost->getForcePower();
			if (forceSpace <= 0) //Cannot Force Drain if attacker can't hold any more Force.
				return GENERALERROR;

			if (playerGhost->getForcePower() < forceCost) {
				creature->sendSystemMessage("@jedi_spam:no_force_power"); //You do not have sufficient Force power to perform that action.
				return GENERALERROR;
			}

			int drain = System::random(maxDamage);//+frs control

			float frsbuff = 1.0 + ((creature->getSkillMod("force_manipulation_dark") + creature->getSkillMod("force_manipulation_light")) * .005);

			int newforce = (targetCreature->getHAM(CreatureAttribute::HEALTH) * .1) + (targetCreature->getHAM(CreatureAttribute::ACTION) * .1) + (targetCreature->getHAM(CreatureAttribute::MIND) * .1);

			int targetForce = targetGhost->getForcePower();

			if (targetForce <= 0 && targetCreature->isPlayerCreature()) {
				creature->sendSystemMessage("@jedi_spam:target_no_force"); //That target does not have any Force Power.
				return GENERALERROR;
			}

			int forceDrain = targetForce >= drain ? drain : targetForce; //Drain whatever Force the target has, up to max.

			if (forceDrain > forceSpace)
				forceDrain = forceSpace; //Drain only what attacker can hold in their own Force pool.

			if (targetCreature->isPlayerCreature()) {
			playerGhost->setForcePower(playerGhost->getForcePower() + ((forceDrain * frsbuff) - forceCost));


			targetGhost->setForcePower(targetGhost->getForcePower() - forceDrain);
			}

			if (!targetCreature->isPlayerCreature()) {
				playerGhost->setForcePower(playerGhost->getForcePower() + ((newforce * frsbuff) - forceCost));
			}

			uint32 animCRC = getAnimationString().hashCode();
			creature->doCombatAnimation(targetCreature, animCRC, 0x1, 0xFF);
			manager->broadcastCombatSpam(creature, targetCreature, nullptr, forceDrain, "cbt_spam", combatSpam, 1);

			VisibilityManager::instance()->increaseVisibility(creature, visMod);

			return SUCCESS;

		}

		return GENERALERROR;

	}

	float getCommandDuration(CreatureObject* object, const UnicodeString& arguments) const {
		float baseDuration = defaultTime * 3.0;
		float combatHaste = object->getSkillMod("combat_haste");

		if (combatHaste > 0) {
			return baseDuration * (1.f - (combatHaste / 100.f));
		} else {
			return baseDuration;
		}
	}

};

#endif //DRAINFORCECOMMAND_H_
