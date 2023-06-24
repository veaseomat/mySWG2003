/*
 * CombatManager.cpp
 *
 *  Created on: 24/02/2010
 *      Author: victor
 */

#include "CombatManager.h"
#include "CreatureAttackData.h"
#include "server/zone/objects/scene/variables/DeltaVector.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "templates/params/creature/CreatureState.h"
#include "server/zone/objects/creature/commands/CombatQueueCommand.h"
#include "templates/params/creature/CreatureAttribute.h"
#include "server/zone/packets/object/CombatSpam.h"
#include "server/zone/packets/object/CombatAction.h"
#include "server/zone/packets/tangible/UpdatePVPStatusMessage.h"
#include "server/zone/Zone.h"
#include "server/zone/managers/collision/CollisionManager.h"
#include "server/zone/managers/visibility/VisibilityManager.h"
#include "server/zone/managers/creature/LairObserver.h"
#include "server/zone/managers/reaction/ReactionManager.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/objects/installation/components/TurretDataComponent.h"
#include "server/zone/objects/creature/ai/AiAgent.h"
#include "server/zone/objects/installation/InstallationObject.h"
#include "server/zone/packets/object/ShowFlyText.h"
#include "server/zone/managers/frs/FrsManager.h"

#define COMBAT_SPAM_RANGE 85

bool CombatManager::startCombat(CreatureObject* attacker, TangibleObject* defender, bool lockDefender, bool allowIncapTarget) const {
	if (attacker == defender)
		return false;

	if (attacker->getZone() == nullptr || defender->getZone() == nullptr)
		return false;

	if (attacker->isRidingMount()) {
		ManagedReference<CreatureObject*> parent = attacker->getParent().get().castTo<CreatureObject*>();

		if (parent == nullptr || !parent->isMount())
			return false;

		if (parent->hasBuff(STRING_HASHCODE("gallop")))
			return false;
	}

	if (attacker->hasRidingCreature())
		return false;

	if (!defender->isAttackableBy(attacker))
		return false;

	if (attacker->isPlayerCreature() && attacker->getPlayerObject()->isAFK())
		return false;

	CreatureObject *creo = defender->asCreatureObject();
	if (creo != nullptr && creo->isIncapacitated() && creo->isFeigningDeath() == false) {
		if (allowIncapTarget) {
			attacker->clearState(CreatureState::PEACE);
			return true;
		}

		return false;
	}

	attacker->clearState(CreatureState::PEACE);

//	if (attacker->isPlayerCreature() && !attacker->hasDefender(defender)) {
//		ManagedReference<WeaponObject*> weapon = attacker->getWeapon();
//
////		if (weapon != nullptr && weapon->isJediWeapon())
////			VisibilityManager::instance()->increaseVisibility(attacker, 25);
//	}

	Locker clocker(defender, attacker);

//	if (creo != nullptr && creo->isPlayerCreature() && !creo->hasDefender(attacker)) {
//		ManagedReference<WeaponObject*> weapon = creo->getWeapon();
//
//		if (weapon != nullptr && weapon->isJediWeapon())
//			VisibilityManager::instance()->increaseVisibility(creo, 25);
//	}

	if (defender->isPlayerCreature() && creo->getWeapon()->isJediWeapon() && !creo->hasDefender(attacker)){
		VisibilityManager::instance()->increaseVisibility(creo, 25);
	}

	if (attacker->isPlayerCreature() && attacker->getWeapon()->isJediWeapon() && !attacker->hasDefender(defender)){
		VisibilityManager::instance()->increaseVisibility(attacker, 25);
	}

	attacker->setDefender(defender);
	defender->addDefender(attacker);

	return true;
}

bool CombatManager::attemptPeace(CreatureObject* attacker) const {
	const DeltaVector<ManagedReference<SceneObject*> >* defenderList = attacker->getDefenderList();

	for (int i = defenderList->size() - 1; i >= 0; --i) {
		try {
			ManagedReference<SceneObject*> object = defenderList->get(i);

			TangibleObject* defender = cast<TangibleObject*>( object.get());

			if (defender == nullptr)
				continue;

			try {
				Locker clocker(defender, attacker);

				if (defender->hasDefender(attacker)) {

					if (defender->isCreatureObject()) {
						CreatureObject* creature = defender->asCreatureObject();

						if (creature->getMainDefender() != attacker || creature->hasState(CreatureState::PEACE) || creature->isDead() || attacker->isDead() || !creature->isInRange(attacker, 128.f)) {
							attacker->removeDefender(defender);
							defender->removeDefender(attacker);
						}
					} else {
						attacker->removeDefender(defender);
						defender->removeDefender(attacker);
					}
				} else {
					attacker->removeDefender(defender);
				}

				clocker.release();

			} catch (Exception& e) {
				error(e.getMessage());
				e.printStackTrace();
			}
		} catch (ArrayIndexOutOfBoundsException& exc) {

		}
	}

	if (defenderList->size() != 0) {
		debug("defenderList not empty, trying to set Peace State");

		attacker->setState(CreatureState::PEACE);

		return false;
	} else {
		attacker->clearCombatState(false);

		// clearCombatState() (rightfully) does not automatically set peace, so set it
		attacker->setState(CreatureState::PEACE);

		return true;
	}
}

void CombatManager::forcePeace(CreatureObject* attacker) const {
	fatal(attacker->isLockedByCurrentThread(), "attacker must be locked");

	const DeltaVector<ManagedReference<SceneObject*> >* defenderList = attacker->getDefenderList();

	for (int i = 0; i < defenderList->size(); ++i) {
		ManagedReference<SceneObject*> object = defenderList->getSafe(i);

		if (object == nullptr || !object->isTangibleObject())
			continue;

		TangibleObject* defender = cast<TangibleObject*>( object.get());

		Locker clocker(defender, attacker);

		if (defender->hasDefender(attacker)) {
			attacker->removeDefender(defender);
			defender->removeDefender(attacker);
		} else {
			attacker->removeDefender(defender);
		}

		--i;

		clocker.release();
	}

	attacker->clearCombatState(false);
	attacker->setState(CreatureState::PEACE);
}

int CombatManager::doCombatAction(CreatureObject* attacker, WeaponObject* weapon, TangibleObject* defenderObject, const CreatureAttackData& data) const {
	debug("entering doCombat action with data");

	if (data.getCommand() == nullptr)
		return -3;

	if (!startCombat(attacker, defenderObject, true, data.getHitIncapTarget()))
		return -1;

	debug("past start combat");

	if (attacker->hasAttackDelay() || !attacker->checkPostureChangeDelay())
		return -3;

	debug("past delay");

	if (!applySpecialAttackCost(attacker, weapon, data))
		return -2;

	debug("past special attack cost");

	int damage = 0;
	bool shouldGcwCrackdownTef = false, shouldGcwTef = false, shouldBhTef = false;
	damage = doTargetCombatAction(attacker, weapon, defenderObject, data, &shouldGcwCrackdownTef, &shouldGcwTef, &shouldBhTef);

	if (data.getCommand()->isAreaAction() || data.getCommand()->isConeAction()) {
		Reference<SortedVector<ManagedReference<TangibleObject*> >* > areaDefenders = getAreaTargets(attacker, weapon, defenderObject, data);

		while (areaDefenders->size() > 0) {
			for (int i = areaDefenders->size()-1; i >= 0 ; i--) {
				TangibleObject* tano = areaDefenders->get(i);
				if (tano == attacker ||  tano == nullptr) {
					areaDefenders->remove(i);
					continue;
				}

				if (!tano->tryWLock()) {
					continue;
				}

				damage += doTargetCombatAction(attacker, weapon, areaDefenders->get(i), data, &shouldGcwCrackdownTef, &shouldGcwTef, &shouldBhTef);
				areaDefenders->remove(i);

				tano->unlock();
			}
			attacker->unlock();
			Thread::yield();
			attacker->wlock(true);
		}
	}

	if (damage > 0) {
		attacker->updateLastSuccessfulCombatAction();

		if (attacker->isPlayerCreature() && data.getCommandCRC() != STRING_HASHCODE("attack"))
			weapon->decay(attacker);

		// This method can be called multiple times for area attacks. Let the calling method decrease the powerup once
		if (!data.isForceAttack())
			weapon->decreasePowerupUses(attacker);
	}

	// Update PvP TEF Duration
	if (shouldGcwCrackdownTef || shouldGcwTef || shouldBhTef) {
		ManagedReference<CreatureObject*> attackingCreature = attacker->isPet() ? attacker->getLinkedCreature() : attacker;

		if (attackingCreature != nullptr) {
			PlayerObject* ghost = attackingCreature->getPlayerObject();

			if (ghost != nullptr) {
				Locker olocker(attackingCreature, attacker);
				ghost->updateLastCombatActionTimestamp(shouldGcwCrackdownTef, shouldGcwTef, shouldBhTef);
			}
		}
	}

//	if (defenderObject->isPlayerCreature()) {
//		CreatureObject *dcreo = defenderObject->asCreatureObject();
//
//		PlayerObject* dghost = dcreo->getPlayerObject();
//
//		if (dghost != nullptr) {
//			if (dcreo->isPlayerCreature() && (dcreo->getWeapon()->isJediWeapon() || dghost->hasBhTef())){
//				Locker olocker(dcreo, dcreo);
//				dghost->updateLastCombatActionTimestamp(false, false, true);
////				VisibilityManager::instance()->increaseVisibility(dcreo, 25);
//			}
//		}
//	}

	return damage;
}

int CombatManager::doCombatAction(TangibleObject* attacker, WeaponObject* weapon, TangibleObject* defender, const CombatQueueCommand* command) const {
	if (command == nullptr)
		return -3;

	const CreatureAttackData data = CreatureAttackData("", command, defender->getObjectID());
	int damage = 0;

	if (weapon != nullptr){
		damage = doTargetCombatAction(attacker, weapon, defender, data);

		if (data.getCommand()->isAreaAction() || data.getCommand()->isConeAction()) {
			Reference<SortedVector<ManagedReference<TangibleObject*> >* > areaDefenders = getAreaTargets(attacker, weapon, defender, data);

			for (int i=0; i<areaDefenders->size(); i++) {
				damage += doTargetCombatAction(attacker, weapon, areaDefenders->get(i), data);
			}
		}
	}

	return damage;
}

int CombatManager::doTargetCombatAction(CreatureObject* attacker, WeaponObject* weapon, TangibleObject* tano, const CreatureAttackData& data, bool* shouldGcwCrackdownTef, bool* shouldGcwTef, bool* shouldBhTef) const {
	int damage = 0;

	Locker clocker(tano, attacker);

	if (!tano->isAttackableBy(attacker))
		return 0;

	attacker->addDefender(tano);
	tano->addDefender(attacker);

	if (tano->isCreatureObject()) {
		CreatureObject* defender = tano->asCreatureObject();

		if (defender->getWeapon() == nullptr)
			return 0;

		damage = doTargetCombatAction(attacker, weapon, defender, data, shouldGcwCrackdownTef, shouldGcwTef, shouldBhTef);
	} else {
		int poolsToDamage = calculatePoolsToDamage(data.getPoolsToDamage());

		damage = applyDamage(attacker, weapon, tano, poolsToDamage, data);

		broadcastCombatAction(attacker, tano, weapon, data, damage, 0x01, 0);

		data.getCommand()->sendAttackCombatSpam(attacker, tano, HIT, damage, data);
	}

	if (damage > 0 && tano->isAiAgent()) {
		AiAgent* aiAgent = cast<AiAgent*>(tano);
		bool help = false;

		for (int i = 0; i < 9; i += 3) {
			if (aiAgent->getHAM(i) < (aiAgent->getMaxHAM(i) / 2)) {
				help = true;
				break;
			}
		}

		if (help)
			aiAgent->sendReactionChat(ReactionManager::HELP);
		else
			aiAgent->sendReactionChat(ReactionManager::HIT);
	}

	if (damage > 0 && attacker->isAiAgent()) {
		AiAgent* aiAgent = cast<AiAgent*>(attacker);
		aiAgent->sendReactionChat(ReactionManager::HITTARGET);
	}

	return damage;
}

int CombatManager::doTargetCombatAction(CreatureObject* attacker, WeaponObject* weapon, CreatureObject* defender, const CreatureAttackData& data, bool* shouldGcwCrackdownTef, bool* shouldGcwTef, bool* shouldBhTef) const {
	if (defender->isEntertaining())
		defender->stopEntertaining();

	int hitVal = HIT;
	uint8 hitLocation = 0;

	float damageMultiplier = (data.getDamageMultiplier() + 1) / 2;// - .7) * 1.2;// dammult

	if (!attacker->isPlayerCreature())
		damageMultiplier = 1.0;

	// need to calculate damage here to get proper client spam
	int damage = 0;

	if (damageMultiplier != 0)
		damage = calculateDamage(attacker, weapon, defender, data) * damageMultiplier;

	damageMultiplier = 1.0f;

	if (!data.isStateOnlyAttack()) {
		hitVal = getHitChance(attacker, defender, weapon, data, damage, data.getAccuracyBonus() + attacker->getSkillMod(data.getCommand()->getAccuracySkillMod()));

		//Send Attack Combat Spam. For state-only attacks, this is sent in applyStates().
		data.getCommand()->sendAttackCombatSpam(attacker, defender, hitVal, damage, data);
	}

	switch (hitVal) {
	case MISS:
		doMiss(attacker, weapon, defender, damage);
		broadcastCombatAction(attacker, defender, weapon, data, 0, hitVal, 0);
		checkForTefs(attacker, defender, shouldGcwCrackdownTef, shouldGcwTef, shouldBhTef);
		return 0;
		break;
	case BLOCK:
		doBlock(attacker, weapon, defender, damage);
		damageMultiplier = 0.5f;
		break;
	case DODGE:
		doDodge(attacker, weapon, defender, damage);
		damageMultiplier = 0.0f;
		break;
	case COUNTER: {
		doCounterAttack(attacker, weapon, defender, damage);
		if (!defender->hasState(CreatureState::PEACE))
			defender->executeObjectControllerAction(STRING_HASHCODE("attack"), attacker->getObjectID(), "");
		damageMultiplier = 0.0f;
		break;}
	case RICOCHET:
		doLightsaberBlock(attacker, weapon, defender, damage);
		damageMultiplier = 0.0f;
		break;
	default:
		break;
	}

	// Apply states first
	applyStates(attacker, defender, data);

	//if it's a state only attack (intimidate, warcry, wookiee roar) don't apply dots or break combat delays
	if (!data.isStateOnlyAttack()) {
		if (defender->hasAttackDelay())
			defender->removeAttackDelay();

		if (damageMultiplier != 0 && damage != 0) {
			int poolsToDamage = calculatePoolsToDamage(data.getPoolsToDamage()); // TODO: animations are probably determined by which pools are damaged (high, mid, low, combos, etc)
			int unmitDamage = damage;
			damage = applyDamage(attacker, weapon, defender, damage, damageMultiplier, poolsToDamage, hitLocation, data);

			if (!defender->isDead()) {
				applyDots(attacker, defender, data, damage, unmitDamage, poolsToDamage);
				applyWeaponDots(attacker, defender, weapon);
			}

		}
	}

	broadcastCombatAction(attacker, defender, weapon, data, damage, hitVal, hitLocation);

	checkForTefs(attacker, defender, shouldGcwCrackdownTef, shouldGcwTef, shouldBhTef);

	return damage;
}

int CombatManager::doTargetCombatAction(TangibleObject* attacker, WeaponObject* weapon, TangibleObject* tano, const CreatureAttackData& data) const {

	int damage = 0;

	Locker clocker(tano, attacker);

	if (tano->isCreatureObject()) {
		CreatureObject* defenderObject = tano->asCreatureObject();

		if (defenderObject->getWeapon() != nullptr)
			damage = doTargetCombatAction(attacker, weapon, defenderObject, data);
	} else {
		// TODO: implement, tano->tano damage
	}

	return damage;
}

int CombatManager::doTargetCombatAction(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defenderObject, const CreatureAttackData& data) const {
	if(defenderObject == nullptr || !defenderObject->isAttackableBy(attacker))
		return 0;

	if (defenderObject->isEntertaining())
		defenderObject->stopEntertaining();

	attacker->addDefender(defenderObject);
	defenderObject->addDefender(attacker);

	float damageMultiplier = (data.getDamageMultiplier() + 1) / 2;// - .7) * 1.2;// dammult

	if (!attacker->isPlayerCreature())
		damageMultiplier = 1.0;

	// need to calculate damage here to get proper client spam
	int damage = 0;

	if (damageMultiplier != 0)
		damage = calculateDamage(attacker, weapon, defenderObject, data) * damageMultiplier;

	damageMultiplier = 1.0f;
	int hitVal = getHitChance(attacker, defenderObject, weapon, data, damage, data.getAccuracyBonus());

	uint8 hitLocation = 0;

	//Send Attack Combat Spam
	data.getCommand()->sendAttackCombatSpam(attacker, defenderObject, hitVal, damage, data);

	CombatAction* combatAction = nullptr;

	switch (hitVal) {
	case MISS:
		doMiss(attacker, weapon, defenderObject, damage);
		break;
	case HIT:
		break;
	case BLOCK:
		doBlock(attacker, weapon, defenderObject, damage);
		damageMultiplier = 0.5f;
		break;
	case DODGE:
		doDodge(attacker, weapon, defenderObject, damage);
		damageMultiplier = 0.0f;
		break;
	case COUNTER:
		doCounterAttack(attacker, weapon, defenderObject, damage);
		if (!defenderObject->hasState(CreatureState::PEACE))
			defenderObject->executeObjectControllerAction(STRING_HASHCODE("attack"), attacker->getObjectID(), "");
		damageMultiplier = 0.0f;
		break;
	case RICOCHET:
		doLightsaberBlock(attacker, weapon, defenderObject, damage);
		damageMultiplier = 0.0f;
		break;
	default:
		break;
	}

	if(hitVal != MISS) {
		int poolsToDamage = calculatePoolsToDamage(data.getPoolsToDamage());

		if (poolsToDamage == 0)
			return 0;

		if (defenderObject->hasAttackDelay())
			defenderObject->removeAttackDelay();

		if (damageMultiplier != 0 && damage != 0)
			damage = applyDamage(attacker, weapon, defenderObject, damage, damageMultiplier, poolsToDamage, hitLocation, data);
	} else {
		damage = 0;
	}

	defenderObject->updatePostures(false);

	uint32 animationCRC = data.getCommand()->getAnimation(attacker, defenderObject, weapon, hitLocation, damage).hashCode();

	combatAction = new CombatAction(attacker, defenderObject, animationCRC, hitVal, CombatManager::DEFAULTTRAIL);
	attacker->broadcastMessage(combatAction,true);

	return damage;
}

void CombatManager::applyDots(CreatureObject* attacker, CreatureObject* defender, const CreatureAttackData& data, int appliedDamage, int unmitDamage, int poolsToDamage) const {
	const Vector<DotEffect>* dotEffects = data.getDotEffects();

	if (defender->isInvulnerable())
		return;

	for (int i = 0; i < dotEffects->size(); i++) {
		const DotEffect& effect = dotEffects->get(i);

		if (defender->hasDotImmunity(effect.getDotType()) || effect.getDotDuration() == 0 || System::random(100) > effect.getDotChance())
			continue;

		const Vector<String>& defenseMods = effect.getDefenderStateDefenseModifers();
		int resist = 0;

		for (int j = 0; j < defenseMods.size(); j++)
			resist += defender->getSkillMod(defenseMods.get(j));

		int damageToApply = appliedDamage;
		uint32 dotType = effect.getDotType();

		if (effect.isDotDamageofHit()) {
			// determine if we should use unmitigated damage
			if (dotType != CreatureState::BLEEDING)
				damageToApply = unmitDamage;
		}

		int potency = effect.getDotPotency();

		if (potency == 0) {
			potency = 150;
		}

		uint8 pool = effect.getDotPool();

		if (pool == CreatureAttribute::UNKNOWN) {
			pool = getPoolForDot(dotType, poolsToDamage);
		}

		debug() << "entering addDotState with dotType:" << dotType;

		float damMod = attacker->isAiAgent() ? cast<AiAgent*>(attacker)->getSpecialDamageMult() : 1.f;
		defender->addDotState(attacker, dotType, data.getCommand()->getNameCRC(),
				effect.isDotDamageofHit() ? damageToApply * effect.getPrimaryPercent() / 100.0f
					: effect.getDotStrength() * damMod,
				pool, effect.getDotDuration(), potency, resist,
				effect.isDotDamageofHit() ? damageToApply * effect.getSecondaryPercent() / 100.0f
					: effect.getDotStrength() * damMod);
	}
}

void CombatManager::applyWeaponDots(CreatureObject* attacker, CreatureObject* defender, WeaponObject* weapon) const {
	if (defender->isInvulnerable())
		return;

	if (!weapon->isCertifiedFor(attacker))
		return;

	for (int i = 0; i < weapon->getNumberOfDots(); i++) {
		if (weapon->getDotUses(i) <= 0)
			continue;

		int type = 0;
		int resist = 0;
		// utilizing this switch-block for easier *functionality* , present & future
		// SOE strings only provide this ONE specific type of mod (combat_bleeding_defense) and
		// there's no evidence (yet) of other 3 WEAPON dot versions also being resistable.
		switch (weapon->getDotType(i)) {
		case 1: //POISON
			type = CreatureState::POISONED;
			//resist = defender->getSkillMod("resistance_poison");
			break;
		case 2: //DISEASE
			type = CreatureState::DISEASED;
			//resist = defender->getSkillMod("resistance_disease");
			break;
		case 3: //FIRE
			type = CreatureState::ONFIRE;
			//resist = defender->getSkillMod("resistance_fire");
			break;
		case 4: //BLEED
			type = CreatureState::BLEEDING;
			resist = defender->getSkillMod("combat_bleeding_defense");
			break;
		default:
			break;
		}

		if (defender->hasDotImmunity(type))
			continue;

		if (weapon->getDotPotency(i)*(1.f-resist/100.f) > System::random(100) &&
			defender->addDotState(attacker, type, weapon->getObjectID(), weapon->getDotStrength(i), weapon->getDotAttribute(i), weapon->getDotDuration(i), -1, 0, (int)(weapon->getDotStrength(i)/5.f)) > 0)
			if (weapon->getDotUses(i) > 0)
				weapon->setDotUses(weapon->getDotUses(i) - 1, i); // Unresisted despite mod, reduce use count.
	}
}

uint8 CombatManager::getPoolForDot(uint64 dotType, int poolsToDamage) const {
	uint8 pool = 0;

	switch (dotType) {
	case CreatureState::POISONED:
	case CreatureState::ONFIRE:
	case CreatureState::BLEEDING:
		if (poolsToDamage & HEALTH) {
			pool = CreatureAttribute::HEALTH;
		} else if (poolsToDamage & ACTION) {
			pool = CreatureAttribute::ACTION;
		} else if (poolsToDamage & MIND) {
			pool = CreatureAttribute::MIND;
		}
		break;
	case CreatureState::DISEASED:
		if (poolsToDamage & HEALTH) {
			pool = CreatureAttribute::HEALTH + System::random(2);
		} else if (poolsToDamage & ACTION) {
			pool = CreatureAttribute::ACTION + System::random(2);
		} else if (poolsToDamage & MIND) {
			pool = CreatureAttribute::MIND + System::random(2);
		}
		break;
	default:
		break;
	}

	return pool;
}

float CombatManager::getWeaponRangeModifier(float currentRange, WeaponObject* weapon) const {
	float minRange = 0;
	float idealRange = 2;
	float maxRange = 5;

	float smallMod = 7;
	float bigMod = 7;

	minRange = (float) weapon->getPointBlankRange();
	idealRange = (float) weapon->getIdealRange();
	maxRange = (float) weapon->getMaxRange();

	smallMod = (float) weapon->getPointBlankAccuracy();
	bigMod = (float) weapon->getIdealAccuracy();

	if (currentRange >= maxRange)
		return (float) weapon->getMaxRangeAccuracy();

	if (currentRange <= minRange)
		return smallMod;

	// this assumes that we are attacking somewhere between point blank and ideal range
	float smallRange = minRange;
	float bigRange = idealRange;

	// check that assumption and correct if it's not true
	if (currentRange > idealRange) {
		smallMod = (float) weapon->getIdealAccuracy();
		bigMod = (float) weapon->getMaxRangeAccuracy();

		smallRange = idealRange;
		bigRange = maxRange;
	}

	if (bigRange == smallRange) // if they are equal, we know at least one is ideal, so just return the ideal accuracy mod
		return weapon->getIdealAccuracy();

	return smallMod + ((currentRange - smallRange) / (bigRange - smallRange) * (bigMod - smallMod));
}

int CombatManager::calculatePostureModifier(CreatureObject* creature, WeaponObject* weapon) const {
	CreaturePosture* postureLookup = CreaturePosture::instance();

	uint8 locomotion = creature->getLocomotion();

	if (!weapon->isMeleeWeapon())
		return postureLookup->getRangedAttackMod(locomotion);
	else
		return postureLookup->getMeleeAttackMod(locomotion);
}

int CombatManager::calculateTargetPostureModifier(WeaponObject* weapon, CreatureObject* targetCreature) const {
	CreaturePosture* postureLookup = CreaturePosture::instance();

	uint8 locomotion = targetCreature->getLocomotion();

	if (!weapon->isMeleeWeapon())
		return postureLookup->getRangedDefenseMod(locomotion);
	else
		return postureLookup->getMeleeDefenseMod(locomotion);
}

int CombatManager::getAttackerAccuracyModifier(TangibleObject* attacker, CreatureObject* defender, WeaponObject* weapon) const {
	CreatureObject* creoAttacker = cast<CreatureObject*>(attacker);

	if (!attacker->isPlayerCreature()) {
		int npcacc = attacker->getLevel();// cast<AiAgent*>(attacker)->getChanceHit() * 100;

//		if (attacker->isAiAgent() && !attacker->isCreature()) {
////			if (weapon->isPistolWeapon())
////				npcacc = attacker->getLevel() * .95;
//			if (weapon->isCarbineWeapon())
//				npcacc = attacker->getLevel() * 1.3;
//			if (weapon->isRifleWeapon())
//				npcacc = attacker->getLevel() * 1.6;
//			if (weapon->isUnarmedWeapon())
//				npcacc = attacker->getLevel() * 2.05;
//			if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
//				npcacc = attacker->getLevel() * 1.5;
//			if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
//				npcacc = attacker->getLevel() * 1.3;
//			if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
//				npcacc = attacker->getLevel() * 1.5;
//			if (weapon->isLightningRifle())//4sec cap
//				npcacc = attacker->getLevel() * .7;
//			if (weapon->isFlameThrower())//4sec cap
//				npcacc = attacker->getLevel() * 1.1;
//			if (weapon->isHeavyAcidRifle())//4sec cap
//				npcacc = attacker->getLevel() * 1.1;
////			if (weapon->isJediWeapon())
////				npcacc = attacker->getLevel();
//		}

		if (creoAttacker->hasState(CreatureState::BLINDED)) {
			npcacc *= .5;
		}

		if (weapon->isMeleeWeapon() &! creoAttacker->isRunning()) {
			npcacc *= 1.1;
		}

	//	if (weapon->isRangedWeapon() && creoAttacker->isStanding()) {
	//		attackerAccuracy *= 1.25;
	//	}

		if (weapon->isRangedWeapon() && creoAttacker->isKneeling()) {
			npcacc *= 1.25;
		}

		if (weapon->isRangedWeapon() && creoAttacker->isProne()) {
			npcacc *= 1.5;
		}

		if (creoAttacker->isRunning()) {
			npcacc *= .5;
		}

		return npcacc;

	}

	int attackerAccuracy = 0;

	const auto creatureAccMods = weapon->getCreatureAccuracyModifiers();

	for (int i = 0; i < creatureAccMods->size(); ++i) {
		const String& mod = creatureAccMods->get(i);
		attackerAccuracy += creoAttacker->getSkillMod(mod);
		attackerAccuracy += creoAttacker->getSkillMod("private_" + mod);

		if (creoAttacker->isStanding()) {
			attackerAccuracy += creoAttacker->getSkillMod(mod + "_while_standing");
		}
	}

	float currentRange = attacker->getWorldPosition().distanceTo(defender->getWorldPosition()) - defender->getTemplateRadius() - attacker->getTemplateRadius();

	if (attacker->isPlayerCreature()) {
		if (weapon->isPistolWeapon()){
			//attackerAccuracy *= .84;
			if (currentRange > 32)	attackerAccuracy *= .8;
			if (currentRange > 48)	attackerAccuracy *= .8;
		}
		if (weapon->isCarbineWeapon()){
			//attackerAccuracy *= .65;
			if (currentRange < 16 || currentRange > 48)	attackerAccuracy *= .8;
		}
		if (weapon->isRifleWeapon()){
			//attackerAccuracy *= .55;
			if (currentRange < 32)	attackerAccuracy *= .8;
			if (currentRange < 16)	attackerAccuracy *= .8;
		}

//////		if (weapon->isRangedWeapon())
//////		attackerAccuracy *= 1.03f;
//		if (weapon->isUnarmedWeapon())
//		attackerAccuracy *= .44;
//		if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
//		attackerAccuracy *= .58;
//		if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
//		attackerAccuracy *= .65;
//		if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
//		attackerAccuracy *= .58;
//////		if (weapon->isMeleeWeapon())
//////		attackerAccuracy *= 1.1f;
//		if (weapon->isLightningRifle())
//		attackerAccuracy *= 1.06;
//		if (weapon->isFlameThrower())
//		attackerAccuracy *= .75;
//		if (weapon->isHeavyAcidRifle())
//		attackerAccuracy *= .75;
//////		if (weapon->isHeavyWeapon())
//////		attackerAccuracy *= 1.0f;
//		if (weapon->isThrownWeapon())
//		attackerAccuracy *= .91;
//		if (weapon->isSpecialHeavyWeapon()  &! (weapon->isHeavyAcidRifle() || weapon->isFlameThrower() || weapon->isLightningRifle() || weapon->isThrownWeapon()))
//		attackerAccuracy *= .8;
//////		if (weapon->isMineWeapon())
//////		attackerAccuracy *= .5f;
//		if (weapon->isJediOneHandedWeapon())
//		attackerAccuracy *= 1.15f;
//		if (weapon->isJediTwoHandedWeapon())
//		attackerAccuracy *= 1.2f;
//		if (weapon->isJediPolearmWeapon())
//		attackerAccuracy *= 1.1f;
////		if (weapon->isJediWeapon())
////		attackerAccuracy *= .8;
	}

	if (attackerAccuracy == 0) attackerAccuracy = -15; // unskilled penalty, TODO: this might be -50 or -125, do research

	attackerAccuracy += creoAttacker->getSkillMod("attack_accuracy") + creoAttacker->getSkillMod("dead_eye");

	// FS skill mods
	if (weapon->getAttackType() == SharedWeaponObjectTemplate::MELEEATTACK)
		attackerAccuracy += creoAttacker->getSkillMod("melee_accuracy");
	else if (weapon->getAttackType() == SharedWeaponObjectTemplate::RANGEDATTACK)
		attackerAccuracy += creoAttacker->getSkillMod("ranged_accuracy");

	// now apply overall weapon defense mods
//	if (weapon->isMeleeWeapon()) {
//		switch (defender->getWeapon()->getGameObjectType()) {
//		case SceneObjectType::PISTOL:
//			attackerAccuracy += 20.f;
//			/* no break */
//		case SceneObjectType::CARBINE:
//			attackerAccuracy += 55.f;
//			/* no break */
//		case SceneObjectType::RIFLE:
//		case SceneObjectType::MINE:
//		case SceneObjectType::SPECIALHEAVYWEAPON:
//		case SceneObjectType::HEAVYWEAPON:
//			attackerAccuracy += 25.f;
//		}
//	}

	if (attackerAccuracy > 200) attackerAccuracy = 200;

	if (creoAttacker->hasState(CreatureState::BLINDED)) {
		attackerAccuracy *= .5;
	}

	if (weapon->isMeleeWeapon() &! creoAttacker->isRunning()) {
		attackerAccuracy *= 1.1;
	}

//	if (weapon->isRangedWeapon() && creoAttacker->isStanding()) {
//		attackerAccuracy *= 1.25;
//	}

	if (weapon->isRangedWeapon() && creoAttacker->isKneeling()) {
		attackerAccuracy *= 1.25;
	}

	if (weapon->isRangedWeapon() && creoAttacker->isProne()) {
		attackerAccuracy *= 1.5;
	}

	if (creoAttacker->isRunning()) {
		attackerAccuracy *= .5;
	}

	return attackerAccuracy;
}

int CombatManager::getAttackerAccuracyBonus(CreatureObject* attacker, WeaponObject* weapon) const {
	int bonus = 0;

	bonus += attacker->getSkillMod("private_attack_accuracy");
	bonus += attacker->getSkillMod("private_accuracy_bonus");

	if (weapon->getAttackType() == SharedWeaponObjectTemplate::MELEEATTACK)
		bonus += attacker->getSkillMod("private_melee_accuracy_bonus");
	if (weapon->getAttackType() == SharedWeaponObjectTemplate::RANGEDATTACK)
		bonus += attacker->getSkillMod("private_ranged_accuracy_bonus");

	return bonus;
}

int CombatManager::getDefenderDefenseModifier(CreatureObject* defender, WeaponObject* weapon, TangibleObject* attacker) const {
	int targetDefense = 0;

	ManagedReference<WeaponObject*> defweapon = defender->getWeapon();
	Reference<PlayerObject*> ghostdef = defender->getPlayerObject();

//	if (defweapon->isJediWeapon() || ghostdef->hasBhTef()){
//		//VisibilityManager::instance()->increaseVisibility(defender, 25); // Give visibility to defender
//		ghostdef->updateLastCombatActionTimestamp(false, false, true);
//	}

	if (attacker->isAiAgent())
		targetDefense = defender->getLevel();


	const auto defenseAccMods = weapon->getDefenderDefenseModifiers();

	for (int i = 0; i < defenseAccMods->size(); ++i) {
		const String& mod = defenseAccMods->get(i);
		targetDefense += defender->getSkillMod(mod);
		targetDefense += defender->getSkillMod("private_" + mod);
	}

	debug() << "Base target defense is " << targetDefense;

	// defense hardcap
//	if (targetDefense > 200)
//		targetDefense = 200;

	if (attacker->isPlayerCreature())
		targetDefense += defender->getSkillMod("private_defense");

	// SL bonuses go on top of hardcap
	for (int i = 0; i < defenseAccMods->size(); ++i) {
		const String& mod = defenseAccMods->get(i);
		targetDefense += defender->getSkillMod("private_group_" + mod);
	}

	if (targetDefense > 150)
		targetDefense = 150;

	// food bonus goes on top as well
	targetDefense += defender->getSkillMod("dodge_attack");
	targetDefense += defender->getSkillMod("private_dodge_attack");

	if (defender->hasState(CreatureState::INTIMIDATED)) {
		targetDefense *= .5;
	}

	debug() << "Target defense after state affects and cap is " << targetDefense;

	return targetDefense;
}

int CombatManager::getDefenderSecondaryDefenseModifier(CreatureObject* defender) const {
	if (defender->isBerserked() || defender->isVehicleObject()) return 0; //defender->isIntimidated() ||
	int targetDefense = defender->isPlayerCreature() ? 0 : defender->getLevel();
	ManagedReference<WeaponObject*> weapon = defender->getWeapon();

	const auto defenseAccMods = weapon->getDefenderSecondaryDefenseModifiers();

	for (int i = 0; i < defenseAccMods->size(); ++i) {
		const String& mod = defenseAccMods->get(i);
		targetDefense += defender->getSkillMod(mod);
		targetDefense += defender->getSkillMod("private_" + mod);
	}

//	if (targetDefense > 200)
//		targetDefense = 200;

//	if (defender->hasState(CreatureState::INTIMIDATED)) {
//		targetDefense *= .5;
//	}

	if (targetDefense > 150)
		targetDefense = 150;

	if (defender->isKnockedDown())
		targetDefense *= .5;

	return targetDefense;
}

float CombatManager::getDefenderToughnessModifier(CreatureObject* defender, int attackType, int damType, float damage) const {
	ManagedReference<WeaponObject*> weapon = defender->getWeapon();

	const auto defenseToughMods = weapon->getDefenderToughnessModifiers();

	if (attackType == weapon->getAttackType()) {
		for (int i = 0; i < defenseToughMods->size(); ++i) {
			int toughMod = defender->getSkillMod(defenseToughMods->get(i));

			ZoneServer* server = defender->getZoneServer();
			PlayerManager* pManager = server->getPlayerManager();
			int playerLevel = pManager->calculatePlayerLevel(defender);

			if (defender->isPlayerCreature()) {
				int newplayertough = playerLevel * 4;
				if (newplayertough > 100) newplayertough = 100;

				if (weapon->isPistolWeapon())
					newplayertough *= .35;
				if (weapon->isCarbineWeapon())
					newplayertough *= .3;
				if (weapon->isRifleWeapon())
					newplayertough *= .2;
			//		if (weapon->isRangedWeapon())
			//		newplayertough *= 1.03f;
				if (weapon->isUnarmedWeapon())
					newplayertough = 0;
				if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
					newplayertough = 0;
				if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
					newplayertough = 0;
				if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
					newplayertough = 0;
			//		if (weapon->isMeleeWeapon())
			//		newplayertough *= 1.1f;
				if (weapon->isLightningRifle())
					newplayertough *= .3;
				if (weapon->isFlameThrower())
					newplayertough *= .3;
				if (weapon->isHeavyAcidRifle())
					newplayertough *= .3;
			//		if (weapon->isMineWeapon())
			//		newplayertough *= .5f;
//					if (weapon->isJediOneHandedWeapon())
//					newplayertough *= .15f;
//					if (weapon->isJediTwoHandedWeapon())
//					newplayertough *= .2f;
//					if (weapon->isJediPolearmWeapon())
//					newplayertough *= .1f;
				if (weapon->isJediWeapon())
					newplayertough = 0;

				if (newplayertough > 0)
					toughMod += newplayertough;
			}

			if (defender->isAiAgent() && defender->isCreature()) {
				toughMod = defender->getLevel();
				if (toughMod > 100) toughMod = 100;
				toughMod *= .5;//50 toughness
			}
			if (defender->isAiAgent() && !defender->isCreature()) {
				toughMod = defender->getLevel();
				if (toughMod > 100) toughMod = 100;

				if (weapon->isPistolWeapon())
					toughMod *= .4;
				if (weapon->isCarbineWeapon())
					toughMod *= .35;
				if (weapon->isRifleWeapon())
					toughMod *= .3;
				if (weapon->isUnarmedWeapon())
					toughMod *= .57;
				if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
					toughMod *= .32;
				if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
					toughMod *= .43;
				if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
					toughMod *= .26;
				if (weapon->isJediOneHandedWeapon())
					toughMod *= .75;
				if (weapon->isJediTwoHandedWeapon())
					toughMod *= .75;
				if (weapon->isJediPolearmWeapon())
					toughMod *= .75;
				if (weapon->isLightningRifle())
					toughMod *= .3;
				if (weapon->isFlameThrower())
					toughMod *= .3;
				if (weapon->isHeavyAcidRifle())
					toughMod *= .3;
			}

			if (toughMod > 0) damage *= 1.f - (toughMod / 100.f);
		}
	}

	int jediToughness = defender->getSkillMod("jedi_toughness");
	if (jediToughness > 0)
		damage *= 1.f - (jediToughness / 100.f);

	return damage < 0 ? 0 : damage;
}

float CombatManager::hitChanceEquation(float attackerAccuracy, float attackerRoll, float targetDefense, float defenderRoll) const {
	float roll = (attackerRoll - defenderRoll)/50;
	int8 rollSign = (roll > 0) - (roll < 0);

	float accTotal = 75.f + (float)roll;

	for (int i = 1; i <= 4; i++) {
		if (roll*rollSign > i) {
			accTotal += (float)rollSign*25.f;
			roll -= rollSign*i;
		} else {
			accTotal += roll/((float)i)*25.f;
			break;
		}
	}

	accTotal += attackerAccuracy - targetDefense;

	debug() << "HitChance\n"
		<< "\tTarget Defense " << targetDefense << "\n"
		<< "\tAccTotal " << accTotal << "\n";

	return accTotal;
}

int CombatManager::calculateDamageRange(TangibleObject* attacker, CreatureObject* defender, WeaponObject* weapon) const {
	int attackType = weapon->getAttackType();
	int damageMitigation = 0;
	float minDamage = weapon->getMinDamage(), maxDamage = weapon->getMaxDamage();

	if (attacker->isPlayerCreature() && weapon == nullptr && weapon->isUnarmedWeapon()){
		minDamage = 10, maxDamage = 50;//this is to fix old players with 20-90 player unarmed
	}

	// restrict damage if a player is not certified (don't worry about mobs)
	if (attacker->isPlayerCreature() && !weapon->isCertifiedFor(cast<CreatureObject*>(attacker))) {
		minDamage = 5;
		maxDamage = 10;
	}

	debug() << "attacker base damage is " << minDamage << "-" << maxDamage;

	PlayerObject* defenderGhost = defender->getPlayerObject();

	// this is for damage mitigation
	if (defenderGhost != nullptr) {
		String mitString;
		switch (attackType){
		case SharedWeaponObjectTemplate::MELEEATTACK:
			mitString = "melee_damage_mitigation_";
			break;
		case SharedWeaponObjectTemplate::RANGEDATTACK:
			mitString = "ranged_damage_mitigation_";
			break;
		default:
			break;
		}

		for (int i = 3; i > 0; i--) {
			if (defenderGhost->hasAbility(mitString + i)) {
				damageMitigation = i;
				break;
			}
		}

		if (damageMitigation > 0)
			maxDamage = minDamage + (maxDamage - minDamage) * (1 - (0.2 * damageMitigation));
	}

	float range = maxDamage - minDamage;

	debug() << "attacker weapon damage mod is " << maxDamage;

	return range < 0 ? 0 : (int)range;
}

float CombatManager::applyDamageModifiers(CreatureObject* attacker, WeaponObject* weapon, float damage, const CreatureAttackData& data) const {
	if (!data.isForceAttack()) {
		const auto weaponDamageMods = weapon->getDamageModifiers();

		for (int i = 0; i < weaponDamageMods->size(); ++i) {
			damage += attacker->getSkillMod(weaponDamageMods->get(i));
		}

		if (weapon->getAttackType() == SharedWeaponObjectTemplate::MELEEATTACK)
			damage += attacker->getSkillMod("private_melee_damage_bonus");
		if (weapon->getAttackType() == SharedWeaponObjectTemplate::RANGEDATTACK)
			damage += attacker->getSkillMod("private_ranged_damage_bonus");
	}

	damage += attacker->getSkillMod("private_damage_bonus");

	int damageMultiplier = attacker->getSkillMod("private_damage_multiplier");

	if (damageMultiplier != 0)
		damage *= damageMultiplier;

	int damageDivisor = attacker->getSkillMod("private_damage_divisor");

	if (damageDivisor != 0)
		damage /= damageDivisor;

	return damage;
}

int CombatManager::getSpeedModifier(CreatureObject* attacker, WeaponObject* weapon) const {
	int speedMods = 0;

	const auto weaponSpeedMods = weapon->getSpeedModifiers();

	for (int i = 0; i < weaponSpeedMods->size(); ++i) {
		speedMods += attacker->getSkillMod(weaponSpeedMods->get(i));
	}

	//jedi speed
	speedMods += attacker->getSkillMod("combat_haste");

	//	ManagedReference<WeaponObject*> attweapon = creoAttacker->getWeapon();

//	if (weapon->isJediWeapon()) {
//		speedMods +=  attacker->getSkillMod("twohandlightsaber_speed");
//		speedMods +=  attacker->getSkillMod("polearmlightsaber_speed");
//	}

	ZoneServer* server = attacker->getZoneServer();
	PlayerManager* pManager = server->getPlayerManager();
	float  playerLevel = pManager->calculatePlayerLevel(attacker);

	speedMods += playerLevel;

	if (speedMods < 0) speedMods = 0;

	if (speedMods > 100) speedMods = 100;

	return speedMods;
}



int CombatManager::getArmorObjectReduction(ArmorObject* armor, int damageType) const {
	float resist = 0;

	switch (damageType) {
	case SharedWeaponObjectTemplate::KINETIC:
		resist = armor->getKinetic();
		break;
	case SharedWeaponObjectTemplate::ENERGY:
		resist = armor->getEnergy();
		break;
	case SharedWeaponObjectTemplate::ELECTRICITY:
		resist = armor->getElectricity();
		break;
	case SharedWeaponObjectTemplate::STUN:
		resist = armor->getStun();
		if (resist > 50) resist = 50;
		break;
	case SharedWeaponObjectTemplate::BLAST:
		resist = armor->getBlast();
		break;
	case SharedWeaponObjectTemplate::HEAT:
		resist = armor->getHeat();
		break;
	case SharedWeaponObjectTemplate::COLD:
		resist = armor->getCold();
		break;
	case SharedWeaponObjectTemplate::ACID:
		resist = armor->getAcid();
		break;
	case SharedWeaponObjectTemplate::LIGHTSABER:
		resist = armor->getLightSaber();
		//if (resist > 25) resist = 25;
		break;
	}

	if (resist > 80) resist = 80;

	return Math::max(0, (int)resist);
}

ArmorObject* CombatManager::getArmorObject(CreatureObject* defender, uint8 hitLocation) const {
	Vector<ManagedReference<ArmorObject*> > armor = defender->getWearablesDeltaVector()->getArmorAtHitLocation(hitLocation);

	if(armor.isEmpty())
		return nullptr;

	return armor.get(System::random(armor.size()-1));
}

ArmorObject* CombatManager::getPSGArmor(CreatureObject* defender) const {
	SceneObject* psg = defender->getSlottedObject("utility_belt");

	if (psg != nullptr && psg->isPsgArmorObject())
		return cast<ArmorObject*>(psg);

	return nullptr;
}

int CombatManager::getArmorNpcReduction(AiAgent* defender, int damageType) const {
	float resist = 0;

	switch (damageType) {
	case SharedWeaponObjectTemplate::KINETIC:
		resist = defender->getKinetic();
		break;
	case SharedWeaponObjectTemplate::ENERGY:
		resist = defender->getEnergy();
		break;
	case SharedWeaponObjectTemplate::ELECTRICITY:
		resist = defender->getElectricity();
		break;
	case SharedWeaponObjectTemplate::STUN:
		resist = defender->getStun();
		if (resist > 50) resist = 50;
		break;
	case SharedWeaponObjectTemplate::BLAST:
		resist = defender->getBlast();
		break;
	case SharedWeaponObjectTemplate::HEAT:
		resist = defender->getHeat();
		break;
	case SharedWeaponObjectTemplate::COLD:
		resist = defender->getCold();
		break;
	case SharedWeaponObjectTemplate::ACID:
		resist = defender->getAcid();
		break;
	case SharedWeaponObjectTemplate::LIGHTSABER:
		resist = defender->getLightSaber();
		//if (resist > 25) resist = 25;
		break;
	}

	if (resist > 80) resist = 80;

	return (int)resist;
}

int CombatManager::getArmorVehicleReduction(VehicleObject* defender, int damageType) const {
	float resist = 0;

	switch (damageType) {
	case SharedWeaponObjectTemplate::KINETIC:
		resist = defender->getKinetic();
		break;
	case SharedWeaponObjectTemplate::ENERGY:
		resist = defender->getEnergy();
		break;
	case SharedWeaponObjectTemplate::ELECTRICITY:
		resist = defender->getElectricity();
		break;
	case SharedWeaponObjectTemplate::STUN:
		resist = defender->getStun();
		if (resist > 50) resist = 50;
		break;
	case SharedWeaponObjectTemplate::BLAST:
		resist = defender->getBlast();
		break;
	case SharedWeaponObjectTemplate::HEAT:
		resist = defender->getHeat();
		break;
	case SharedWeaponObjectTemplate::COLD:
		resist = defender->getCold();
		break;
	case SharedWeaponObjectTemplate::ACID:
		resist = defender->getAcid();
		break;
	case SharedWeaponObjectTemplate::LIGHTSABER:
		resist = defender->getLightSaber();
		//if (resist > 25) resist = 25;
		break;
	}

	if (resist > 80) resist = 80;

	return (int)resist;
}

int CombatManager::getArmorReduction(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, float damage, int hitLocation, const CreatureAttackData& data) const {
	int damageType = 0, armorPiercing = 1;

	if (!data.isForceAttack()) {
		damageType = weapon->getDamageType();
		armorPiercing = weapon->getArmorPiercing();

		if (weapon->isBroken())
			armorPiercing = 0;
	} else {
		damageType = 8;//change powers to stun dmg//data.getDamageType();
	}

	if (defender->isAiAgent()) {
		float armorReduction = getArmorNpcReduction(cast<AiAgent*>(defender), damageType);

		if (armorReduction >= 0)
			damage *= getArmorPiercing(cast<AiAgent*>(defender), armorPiercing);

		if (armorReduction > 0) damage *= (1.f - (armorReduction / 100.f));

		return damage;
	} else if (defender->isVehicleObject()) {
		float armorReduction = getArmorVehicleReduction(cast<VehicleObject*>(defender), damageType);

		if (armorReduction >= 0)
			damage *= getArmorPiercing(cast<VehicleObject*>(defender), armorPiercing);

		if (armorReduction > 0) damage *= (1.f - (armorReduction / 100.f));

		return damage;
	}

	ManagedReference<ArmorObject*> armor = nullptr;

	armor = getArmorObject(defender, hitLocation);

//	if ((armor != nullptr)) {
//
//		defender->removeBuff(BuffCRC::JEDI_FORCE_ABSORB_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_ABSORB_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_ARMOR_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_ARMOR_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_FEEDBACK_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_FEEDBACK_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_SHIELD_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_SHIELD_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_RUN_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_RUN_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_RUN_3);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_SPEED_1);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_SPEED_2);
//		defender->removeBuff(BuffCRC::JEDI_FORCE_PROTECTION_1);
//		defender->removeBuff(BuffCRC::JEDI_RESIST_DISEASE);
//		defender->removeBuff(BuffCRC::JEDI_RESIST_POISON);
//		defender->removeBuff(BuffCRC::JEDI_RESIST_BLEEDING);
//		defender->removeBuff(BuffCRC::JEDI_RESIST_STATES);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION_1);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION_2);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION_3);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION_4);
//		defender->removeBuff(BuffCRC::JEDI_AVOID_INCAPACITATION_5);
//	}

	if (!data.isForceAttack()) {
		// Force Armor
		float rawDamage = damage;

		int forceArmor = defender->getSkillMod("force_armor");

		if (forceArmor > 0) {

			for (int i = 0; i < defender->getSlottedObjectsSize(); ++i) {
				SceneObject* item = defender->getSlottedObject(i);
				if (item != nullptr && item->isArmorObject()){
					forceArmor *= .85;
				}
			}

			//put wearing armor force cost increase here?
//			bool jarmor = false;
//			for (int i = 0; i < defender->getSlottedObjectsSize(); ++i) {
//				SceneObject* item = defender->getSlottedObject(i);
//				if (item != nullptr && item->isArmorObject()){
//					jarmor = true;
//				}
//			}
//			if (jarmor == true) forceArmor *= .5;

			float dmgAbsorbed = rawDamage - (damage *= 1.f - (forceArmor / 100.f));
			defender->notifyObservers(ObserverEventType::FORCEARMOR, attacker, dmgAbsorbed);
			sendMitigationCombatSpam(defender, nullptr, (int)dmgAbsorbed, FORCEARMOR);
		}
	} else {
		float jediBuffDamage = 0;
		float rawDamage = damage;

		// Force Shield
		int forceShield = defender->getSkillMod("force_shield");
		if (forceShield > 0) {
			jediBuffDamage = rawDamage - (damage *= 1.f - (forceShield / 100.f));
			defender->notifyObservers(ObserverEventType::FORCESHIELD, attacker, jediBuffDamage);
			sendMitigationCombatSpam(defender, nullptr, (int)jediBuffDamage, FORCESHIELD);
		}

		// Force Feedback
		int forceFeedback = defender->getSkillMod("force_feedback");

		if (forceFeedback > 0 && (defender->hasBuff(BuffCRC::JEDI_FORCE_FEEDBACK_1) || defender->hasBuff(BuffCRC::JEDI_FORCE_FEEDBACK_2))) {
			float feedbackDmg = rawDamage * (forceFeedback / 100.f);

			int forceDefense = defender->getSkillMod("force_defense");

			if (forceDefense > 0)
				feedbackDmg *= 1.f / (1.f + ((float)forceDefense / 100.f));

			float splitDmg = feedbackDmg / 3;

			attacker->inflictDamage(defender, CreatureAttribute::HEALTH, splitDmg, true, true, true);
			attacker->inflictDamage(defender, CreatureAttribute::ACTION, splitDmg, true, true, true);
			attacker->inflictDamage(defender, CreatureAttribute::MIND, splitDmg, true, true, true);
			broadcastCombatSpam(defender, attacker, nullptr, feedbackDmg, "cbt_spam", "forcefeedback_hit", 1);
			defender->notifyObservers(ObserverEventType::FORCEFEEDBACK, attacker, jediBuffDamage);
			defender->playEffect("clienteffect/pl_force_feedback_block.cef", "");
		}

		// Force Absorb
		if (defender->getSkillMod("force_absorb") > 0 && defender->isPlayerCreature()) {
			defender->notifyObservers(ObserverEventType::FORCEABSORB, attacker, data.getForceCost());
		}
	}

	// PSG
	ManagedReference<ArmorObject*> psg = getPSGArmor(defender);

	if (psg != nullptr && !psg->isVulnerable(damageType)) {
		float armorReduction =  getArmorObjectReduction(psg, damageType);
		float dmgAbsorbed = damage;

		damage *= getArmorPiercing(psg, armorPiercing);

        if (armorReduction > 0) damage *= 1.f - (armorReduction / 100.f);

		dmgAbsorbed -= damage;
		if (dmgAbsorbed > 0)
			sendMitigationCombatSpam(defender, psg, (int)dmgAbsorbed, PSG);

		Locker plocker(psg);

		psg->inflictDamage(psg, 0, damage * 0.2, true, true);

	}

	// Standard Armor
//	ManagedReference<ArmorObject*> armor = nullptr;
//
//	armor = getArmorObject(defender, hitLocation);

	if (armor != nullptr && !armor->isVulnerable(damageType)) {
		float armorReduction = getArmorObjectReduction(armor, damageType);
		float dmgAbsorbed = damage;

		// use only the damage applied to the armor for piercing (after the PSG takes some off)
		damage *= getArmorPiercing(armor, armorPiercing);

		if (armorReduction > 0) {
			damage *= (1.f - (armorReduction / 100.f));
			dmgAbsorbed -= damage;
			sendMitigationCombatSpam(defender, armor, (int)dmgAbsorbed, ARMOR);
		}

		// inflict condition damage
		Locker alocker(armor);

		armor->inflictDamage(armor, 0, damage * 0.2, true, true);
	}

	return damage;
}

float CombatManager::getArmorPiercing(TangibleObject* defender, int armorPiercing) const {
	return 1.0;
	int armorReduction = 0;

	if (defender->isAiAgent()) {
		AiAgent* aiDefender = cast<AiAgent*>(defender);
		armorReduction = aiDefender->getArmor();
		//if (aiDefender->getWeapon()->isJediWeapon()) armorReduction = 1;
		 if (!defender->isCreature()) {
			 if (armorReduction > 1) armorReduction = 1;
		 }

	} else if (defender->isArmorObject()) {
		ArmorObject* armorDefender = cast<ArmorObject*>(defender);

		if (armorDefender != nullptr && !armorDefender->isBroken())
			armorReduction = armorDefender->getRating();
	} else if (defender->isVehicleObject()) {
		VehicleObject* vehicleDefender = cast<VehicleObject*>(defender);
		armorReduction = vehicleDefender->getArmor();
	} else {
		DataObjectComponentReference* data = defender->getDataObjectComponent();

		if (data != nullptr) {
			TurretDataComponent* turretData = cast<TurretDataComponent*>(data->get());

			if(turretData != nullptr) {
				armorReduction = turretData->getArmorRating();
			}
		}
	}

	if (armorPiercing > armorReduction)
		return pow(1.25, armorPiercing - armorReduction);
    else
        return pow(0.50, armorReduction - armorPiercing);
}

float CombatManager::calculateDamage(CreatureObject* attacker, WeaponObject* weapon, TangibleObject* defender, const CreatureAttackData& data) const {
	float damage = 0;
	int diff = 0;

	if (data.getMinDamage() > 0 && data.getMaxDamage() > 0) { // this is a special attack (force, etc)
		float minDmg = data.getMinDamage();
		float maxDmg = data.getMaxDamage();

		if (data.isForceAttack() && attacker->isPlayerCreature())
			getFrsModifiedForceAttackDamage(attacker, minDmg, maxDmg, data);

		float mod = attacker->isAiAgent() ? cast<AiAgent*>(attacker)->getSpecialDamageMult() : 1.f;
		damage = minDmg * mod;
		diff = (maxDmg * mod) - damage;
	} else {
		float minDamage = weapon->getMinDamage(), maxDamage = weapon->getMaxDamage();

		if (attacker->isPlayerCreature() && weapon == nullptr && weapon->isUnarmedWeapon()){
			minDamage = 10, maxDamage = 50;//this is to fix old players with 20-90 player unarmed
		}

		if (attacker->isPlayerCreature() && !weapon->isCertifiedFor(attacker)) {
			minDamage = 5.f;
			maxDamage = 10.f;
		}

		damage = minDamage;
		diff = maxDamage - minDamage;
	}

	if (diff > 0)
		damage += System::random(diff);

	damage = applyDamageModifiers(attacker, weapon, damage, data);

//	if (attacker->isPlayerCreature())
//		damage *= 1.5;
//
//	if (!data.isForceAttack() && weapon->getAttackType() == SharedWeaponObjectTemplate::MELEEATTACK)
//		damage *= 1.25;

	debug() << "damage to be dealt is " << damage;

	ManagedReference<LairObserver*> lairObserver = nullptr;
	SortedVector<ManagedReference<Observer*> > observers = defender->getObservers(ObserverEventType::OBJECTDESTRUCTION);

	for (int i = 0; i < observers.size(); i++) {
		lairObserver = cast<LairObserver*>(observers.get(i).get());
		if (lairObserver != nullptr)
			break;
	}

	if (lairObserver && lairObserver->getSpawnNumber() > 2)
		damage *= 3.5;

	return damage;
}

float CombatManager::doDroidDetonation(CreatureObject* droid, CreatureObject* defender, float damage) const {
	if (defender->isInvulnerable()) {
		return 0;
	}
	if (defender->isCreatureObject()) {
		if (defender->isPlayerCreature())
			damage *= 0.25;
		// pikc a pool to target
		int pool = calculatePoolsToDamage(RANDOM);
		// we now have damage to use lets apply it
		float healthDamage = 0.f, actionDamage = 0.f, mindDamage = 0.f;
		// need to check armor reduction with just defender, blast and their AR + resists
		if(defender->isVehicleObject()) {
			int ar = cast<VehicleObject*>(defender)->getBlast();
			if ( ar > 0)
				damage *= (1.f - (ar / 100.f));
			healthDamage = damage;
			actionDamage = damage;
			mindDamage = damage;
		} else if (defender->isAiAgent()) {
			int ar = cast<AiAgent*>(defender)->getBlast();
			if ( ar > 0)
				damage *= (1.f - (ar / 100.f));
			healthDamage = damage;
			actionDamage = damage;
			mindDamage = damage;

		} else {
			// player
			static uint8 bodyHitLocations[] = {HIT_BODY, HIT_BODY, HIT_LARM, HIT_RARM};

			ArmorObject* healthArmor = getArmorObject(defender, bodyHitLocations[System::random(3)]);
			ArmorObject* mindArmor = getArmorObject(defender, HIT_HEAD);
			ArmorObject* actionArmor = getArmorObject(defender, HIT_LLEG); // This hits both the pants and feet regardless
			ArmorObject* psgArmor = getPSGArmor(defender);
			if (psgArmor != nullptr && !psgArmor->isVulnerable(SharedWeaponObjectTemplate::BLAST)) {
				float armorReduction =  psgArmor->getBlast();
				if (armorReduction > 0) damage *= (1.f - (armorReduction / 100.f));

				Locker plocker(psgArmor);

				psgArmor->inflictDamage(psgArmor, 0, damage * 0.1, true, true);
			}
			// reduced by psg not check each spot for damage
			healthDamage = damage;
			actionDamage = damage;
			mindDamage = damage;
			if (healthArmor != nullptr && !healthArmor->isVulnerable(SharedWeaponObjectTemplate::BLAST) && (pool & HEALTH)) {
				float armorReduction = healthArmor->getBlast();
				if (armorReduction > 0)
					healthDamage *= (1.f - (armorReduction / 100.f));

				Locker hlocker(healthArmor);

				healthArmor->inflictDamage(healthArmor, 0, healthDamage * 0.1, true, true);
				return (int)healthDamage * 0.1;
			}
			if (mindArmor != nullptr && !mindArmor->isVulnerable(SharedWeaponObjectTemplate::BLAST) && (pool & MIND)) {
				float armorReduction = mindArmor->getBlast();
				if (armorReduction > 0)
					mindDamage *= (1.f - (armorReduction / 100.f));

				Locker mlocker(mindArmor);

				mindArmor->inflictDamage(mindArmor, 0, mindDamage * 0.1, true, true);
				return (int)mindDamage * 0.1;
			}
			if (actionArmor != nullptr && !actionArmor->isVulnerable(SharedWeaponObjectTemplate::BLAST) && (pool & ACTION)) {
				float armorReduction = actionArmor->getBlast();
				if (armorReduction > 0)
					actionDamage *= (1.f - (armorReduction / 100.f));

				Locker alocker(actionArmor);

				actionArmor->inflictDamage(actionArmor, 0, actionDamage * 0.1, true, true);
				return (int)actionDamage * 0.1;
			}
		}
		if((pool & ACTION)){
			defender->inflictDamage(droid, CreatureAttribute::ACTION, (int)actionDamage, true, true, false);
			return (int)actionDamage;
		}
		if((pool & HEALTH)) {
			defender->inflictDamage(droid, CreatureAttribute::HEALTH, (int)healthDamage, true, true, false);
			return (int)healthDamage;
		}
		if((pool & MIND)) {
			defender->inflictDamage(droid, CreatureAttribute::MIND, (int)mindDamage, true, true, false);
			return (int)mindDamage;
		}
		return 0;
	} else {
		return 0;
	}
}

void CombatManager::getFrsModifiedForceAttackDamage(CreatureObject* attacker, float& minDmg, float& maxDmg, const CreatureAttackData& data) const {
	ManagedReference<PlayerObject*> ghost = attacker->getPlayerObject();

	if (ghost == nullptr)
		return;

	FrsData* playerData = ghost->getFrsData();
	int councilType = playerData->getCouncilType();

	float minMod = 0, maxMod = 0;
	int powerModifier = 0;

	if (councilType == FrsManager::COUNCIL_LIGHT) {
		powerModifier = attacker->getSkillMod("force_power_light");
		minMod = data.getFrsLightMinDamageModifier();
		maxMod = data.getFrsLightMaxDamageModifier();
	} else if (councilType == FrsManager::COUNCIL_DARK) {
		powerModifier = attacker->getSkillMod("force_power_dark");
		minMod = data.getFrsDarkMinDamageModifier();
		maxMod = data.getFrsDarkMaxDamageModifier();
	}

	if (powerModifier > 0) {
		if (minMod > 0)
			minDmg += (int)((powerModifier * minMod) + 0.5);

		if (maxMod > 0)
			maxDmg += (int)((powerModifier * maxMod) + 0.5);
	}
}

float CombatManager::calculateDamage(CreatureObject* attacker, WeaponObject* weapon, CreatureObject* defender, const CreatureAttackData& data) const {
	float damage = 0;
	int diff = 0;

	if (data.getMinDamage() > 0 && data.getMaxDamage() > 0) { // this is a special attack (force, etc)
		float minDmg = data.getMinDamage();
		float maxDmg = data.getMaxDamage();

		if (data.isForceAttack() && attacker->isPlayerCreature())
			getFrsModifiedForceAttackDamage(attacker, minDmg, maxDmg, data);

		float mod = attacker->isAiAgent() ? cast<AiAgent*>(attacker)->getSpecialDamageMult() : 1.f;
		damage = minDmg * mod;
		diff = (maxDmg * mod) - damage;
	} else {
		diff = calculateDamageRange(attacker, defender, weapon);
		float minDamage = weapon->getMinDamage();

		if (attacker->isPlayerCreature() && weapon == nullptr && weapon->isUnarmedWeapon()){
			minDamage = 10;//this is to fix old players with 20-90 player unarmed
		}

		if (attacker->isPlayerCreature() && !weapon->isCertifiedFor(attacker))
			minDamage = 5;

		damage = minDamage;
	}

	if (diff > 0)
		damage += System::random(diff);

	damage = applyDamageModifiers(attacker, weapon, damage, data);

	damage += defender->getSkillMod("private_damage_susceptibility");

//	if (attacker->isPlayerCreature()) {
//		if (data.isForceAttack() && !defender->isPlayerCreature())
//			damage *= 2 + System::random(1);
//		else if (!data.isForceAttack())
//			damage *= 1.5;
//	}

//	if (!data.isForceAttack() && weapon->getAttackType() == SharedWeaponObjectTemplate::MELEEATTACK)
//		damage *= 1.25;
//
//	if (defender->isKnockedDown()) {
//		damage *= 1.5f;
//	} else if (data.isForceAttack() && data.getCommandName().hashCode() == STRING_HASHCODE("forcechoke")) {
//		if  (defender->isProne())
//			damage *= 1.5f;
//		else if (defender->isKneeling())
//			damage *= 1.25f;
//	}

	// Toughness reduction
	if (data.isForceAttack())
		damage = getDefenderToughnessModifier(defender, SharedWeaponObjectTemplate::FORCEATTACK, data.getDamageType(), damage);
	else
		damage = getDefenderToughnessModifier(defender, weapon->getAttackType(), weapon->getDamageType(), damage);

	// Force Defense skillmod damage reduction
	if (data.isForceAttack()) {
		int forceDefense = defender->getSkillMod("force_defense");

		if (forceDefense > 0)
			damage *= 1.f / (1.f + ((float)forceDefense / 100.f));
	}

	ZoneServer* server = attacker->getZoneServer();
	PlayerManager* pManager = server->getPlayerManager();
	float  playerLevel = pManager->calculatePlayerLevel(attacker) * 4;
	if (playerLevel > 100) playerLevel = 100;
	playerLevel /= 100;//max is now 1.0

//// mySWG balancing the profs based on highest dmg weapon and special for that class
		if (attacker->isPlayerCreature() && !data.isForceAttack()) {
			if (weapon->isPistolWeapon())
				damage *= 1.0 + (playerLevel * 1.6);
			if (weapon->isCarbineWeapon())
				damage *= 1.0 + (playerLevel * 1.8);
			if (weapon->isRifleWeapon())
				damage *= 1.0 + (playerLevel * 1.9);
//			if (weapon->isRangedWeapon())
//			damage *= 1.03f;
//			if (weapon->isMeleeWeapon())
//			damage *= 1.25;
			if (weapon->isUnarmedWeapon())
				damage *= .6;//needs nerf
			if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
				damage *= 1.0 + (playerLevel * .8);
			if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
				damage *= 1.0 + (playerLevel * .7);
			if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
				damage *= 1.0 + (playerLevel * 1.0);
			if (weapon->isLightningRifle())
				damage *= 1.0;
			if (weapon->isFlameThrower())
				damage *= .7;
			if (weapon->isHeavyAcidRifle())
				damage *= .9;
//			if (weapon->isHeavyWeapon() &! (weapon->isHeavyAcidRifle() || weapon->isFlameThrower() || weapon->isLightningRifle() || weapon->isThrownWeapon()))
//			damage *= .3;
//			if (weapon->isThrownWeapon())// 4sec
//			damage *= .4;
//			if (weapon->isSpecialHeavyWeapon() &! weapon->isHeavyAcidRifle() &! weapon->isFlameThrower() &! weapon->isLightningRifle())// 4 sec rocket launcher
//			damage *= .001;
	//		if (weapon->isMineWeapon())
	//		damage *= 1.0f;
//			if (weapon->isJediOneHandedWeapon())
//			damage *= .7;
//			if (weapon->isJediTwoHandedWeapon())
//			damage *= .8;
//			if (weapon->isJediPolearmWeapon())
//			damage *= .9;
//			if (weapon->isJediWeapon())
//			damage *= .3;//
		}

		if (data.isForceAttack()) {
			damage *= 3;
		}

		int damagetype = weapon->getDamageType();

		//using this to unbalance the NPCs
		if (attacker->isAiAgent() && !attacker->isCreature()) {
			if (weapon->isPistolWeapon())
				damage *= .7;
			if (weapon->isCarbineWeapon())
				damage *= .8;
			if (weapon->isRifleWeapon())
				damage *= 1.0;
//			if (weapon->isRangedWeapon())
//				speedMods *= 1.03f;
			if (weapon->isUnarmedWeapon())
				damage *= .6;
			if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon())
				damage *= .7;
			if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon())
				damage *= .8;
			if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon())
				damage *= .9;
//			if (weapon->isMeleeWeapon())
//				speedMods *= 1.1f;
//			if (weapon->isLightningRifle())//4sec cap
//				damage *= 1.0;
//			if (weapon->isFlameThrower())//4sec cap
//				damage *= 1.4;
//			if (weapon->isHeavyAcidRifle())//4sec cap
//				damage *= 1.3;
//			if (weapon->isHeavyWeapon() &! (weapon->isHeavyAcidRifle() || weapon->isFlameThrower() || weapon->isLightningRifle() || weapon->isThrownWeapon()))
//				damage *= 1.3;
//			if (weapon->isThrownWeapon())// 4sec
//				damage *= 1.2;
//			if (weapon->isHeavyWeapon())
//				speedMods *= 1.0f;
//			if (weapon->isSpecialHeavyWeapon())
//				speedMods *= .5f;
//			if (weapon->isMineWeapon())
//				speedMods *= .5f;
			if (weapon->isJediWeapon())
				damage *= 2;
//			if (weapon->isJediOneHandedWeapon())
//				damage *= .7;
//			if (weapon->isJediTwoHandedWeapon())
//				damage *= .8;
//			if (weapon->isJediPolearmWeapon())
//				damage *= .9;

			if (damagetype == 8  && !weapon->isJediWeapon())	damage *= .4;//nerf npc stun dmg
			//if (damagetype == 16)	damage *= .5;//nerf npc saber dmg
		}

		//frsdamage
		float lightDamage = attacker->getSkillMod("force_manipulation_light") * 0.3;

		if (lightDamage > 0) {
			lightDamage += 5;
			damage *= 1.f + (lightDamage / 100.f);
		}

		float darkDamage = attacker->getSkillMod("force_manipulation_dark") * 0.4;

		if (darkDamage > 0) {
			darkDamage += 10;
			damage *= 1.f + (darkDamage / 100.f);
		}

		//frsarmor
		float lightarmor = defender->getSkillMod("force_manipulation_light") * 0.4;
		if (defender->getWeapon()->isJediWeapon() && defender->isAiAgent()) lightarmor = defender->getLevel() * .3;

		if (lightarmor > 0) {
			lightarmor += 10;
			damage *= 1.f - (lightarmor / 100.f);
		}

		float darkarmor = defender->getSkillMod("force_manipulation_dark") * 0.3;

		if (darkarmor > 0) {
			lightarmor += 5;
			damage *= 1.f - (darkarmor / 100.f);
		}

// PvP Damage Reduction
	if (attacker->isPlayerCreature() && defender->isPlayerCreature())
		damage *= .5;//vanilla .25

// PVE
	if (attacker->isPlayerCreature() && !defender->isPlayerCreature())
		damage *= 2.0;//.25 + (playerLevel * .0075);

// PVE
	if (attacker->isPlayerCreature() && !defender->isPlayerCreature())
		damage *= 1.0 - (defender->getLevel() * .005);//this nerfs pve dmg down to .25 at creature lvl 100 like pvp .25 mult

// EVP
	if (!attacker->isPlayerCreature() && defender->isPlayerCreature())
		damage *= .45;

// EVE
	if (!attacker->isPlayerCreature() && !defender->isPlayerCreature())
		damage *= .45;

	if (damage < 1) damage = 1;

	debug() << "damage to be dealt is " << damage;

	return damage;
}

float CombatManager::calculateDamage(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, const CreatureAttackData& data) const {
	float damage = 0;

	int diff = calculateDamageRange(attacker, defender, weapon);
	float minDamage = weapon->getMinDamage();

	if (attacker->isPlayerCreature() && weapon == nullptr && weapon->isUnarmedWeapon()){
		minDamage = 10;//this is to fix old players with 20-90 player unarmed
	}

	if (diff > 0)
		damage = System::random(diff) + (int)minDamage;

	damage += defender->getSkillMod("private_damage_susceptibility");

//	if (defender->isKnockedDown())
//		damage *= 1.5f;

	// Toughness reduction
	damage = getDefenderToughnessModifier(defender, weapon->getAttackType(), weapon->getDamageType(), damage);

	return damage;
}

int CombatManager::getHitChance(TangibleObject* attacker, CreatureObject* targetCreature, WeaponObject* weapon, const CreatureAttackData& data, int damage, int accuracyBonus) const {
	int hitChance = 0;
	int attackType = weapon->getAttackType();
	CreatureObject* creoAttacker = nullptr;

	if (attacker->isCreatureObject()) {
		creoAttacker = attacker->asCreatureObject();

		if (creoAttacker != nullptr && data.isForceAttack()) {
			int attackerAccuracy = creoAttacker->getSkillMod(data.getCommand()->getAccuracySkillMod());
			int targetDefense = targetCreature->getSkillMod("force_defense");

			float attackerRoll = (float)System::random(249) + 1.f;
			float defenderRoll = (float)System::random(150) + 25.f;

			float accTotal = hitChanceEquation(attackerAccuracy, attackerRoll, targetDefense, defenderRoll);

			if (System::random(100) > accTotal)
				return MISS;
			else
				return HIT;
		}
	}

	ManagedReference<WeaponObject*> defweapon = targetCreature->getWeapon();
	Reference<PlayerObject*> ghostdef = targetCreature->getPlayerObject();
//	Reference<PlayerObject*> ghostatt = creoAttacker->getPlayerObject();

//	if (defweapon->isJediWeapon() || ghostdef->hasBhTef()){
////		VisibilityManager::instance()->increaseVisibility(targetCreature, 10); // Give visibility to defender
//		ghostdef->updateLastCombatActionTimestamp(false, false, true);
//	}

//	if (weapon->isJediWeapon() || ghostatt->hasBhTef()){
//		VisibilityManager::instance()->increaseVisibility(creoAttacker, 10); // Give visibility to attacker
//	}


	debug() << "Calculating hit chance for " << attacker->getObjectID()
		<< " Attacker accuracy bonus is " << accuracyBonus;
	float weaponAccuracy = 0.0f;
	// Get the weapon mods for range and add the mods for stance

	weaponAccuracy = getWeaponRangeModifier(attacker->getWorldPosition().distanceTo(targetCreature->getWorldPosition()) - targetCreature->getTemplateRadius() - attacker->getTemplateRadius(), weapon);
	// accounts for steadyaim, general aim, and specific weapon aim, these buffs will clear after a completed combat action

	if (creoAttacker != nullptr && weapon->getAttackType() == SharedWeaponObjectTemplate::RANGEDATTACK)
		weaponAccuracy += creoAttacker->getSkillMod("private_aim");

	debug() << "Attacker weapon accuracy is " << weaponAccuracy;

	int attackerAccuracy = getAttackerAccuracyModifier(attacker, targetCreature, weapon);
	debug() << "Base attacker accuracy is " << attackerAccuracy;

	// need to also add in general attack accuracy (mostly gotten from posture and states)

	int bonusAccuracy = 0;

	if (creoAttacker != nullptr)
		bonusAccuracy = getAttackerAccuracyBonus(creoAttacker, weapon);

	// this is the scout/ranger creature hit bonus that only works against creatures (not NPCS)
	if (targetCreature->isCreature() && creoAttacker != nullptr)
		bonusAccuracy += creoAttacker->getSkillMod("creature_hit_bonus");

	debug() << "Attacker total bonus is " << bonusAccuracy;

	int postureAccuracy = 0;

	if (creoAttacker != nullptr)
		postureAccuracy = calculatePostureModifier(creoAttacker, weapon);

	debug() << "Attacker posture accuracy is " << postureAccuracy;

	int targetDefense = getDefenderDefenseModifier(targetCreature, weapon, attacker);
	debug() << "Defender defense is " << targetDefense;

	int postureDefense = calculateTargetPostureModifier(weapon, targetCreature);

	debug() << "Defender posture defense is " << postureDefense;
	float attackerRoll = (float)System::random(249) + 1.f;
	float defenderRoll = (float)System::random(150) + 25.f;

	// TODO (dannuic): add the trapmods in here somewhere (defense down trapmods)
	float accTotal = hitChanceEquation(attackerAccuracy + weaponAccuracy + accuracyBonus + postureAccuracy + bonusAccuracy, attackerRoll, targetDefense + postureDefense, defenderRoll);

	debug() << "Final hit chance is " << accTotal;

	if (System::random(100) > accTotal) // miss, just return MISS
		return MISS;

	debug() << "Attack hit successfully";

	// now we have a successful hit, so calculate secondary defenses if there is a damage component
	if (damage > 0) {
		ManagedReference<WeaponObject*> targetWeapon = targetCreature->getWeapon();
		const auto defenseAccMods = targetWeapon->getDefenderSecondaryDefenseModifiers();
		const String& def = defenseAccMods->get(0); // FIXME: this is hacky, but a lot faster than using contains()

		//FRS DODGE SYSTEM
		float frsdodge = (targetCreature->getSkillMod("force_manipulation_light") + targetCreature->getSkillMod("force_manipulation_dark")) * .4;
		if (targetWeapon->isJediWeapon() && targetCreature->isAiAgent()) frsdodge = targetCreature->getLevel() * .15;

		if (frsdodge > 0) {
			frsdodge += 10;
			if (frsdodge > System::random(100))
				return MISS;

		}

		// saber block is special because it's just a % chance to block based on the skillmod
		if (targetWeapon->isJediWeapon()) {
			int saberblockmod = targetCreature->getSkillMod("saber_block");
			if (targetCreature->isAiAgent()) saberblockmod = targetCreature->getLevel() * .85;
			if (targetCreature->isKnockedDown())
				saberblockmod *= .5;

//			if (weapon->isJediWeapon() && (System::random(100) < saberblockmod))
//				return MISS;
			if (!(attacker->isTurret() || weapon->isThrownWeapon()) && ((weapon->isHeavyWeapon() || weapon->isSpecialHeavyWeapon() || (weapon->getAttackType() == SharedWeaponObjectTemplate::RANGEDATTACK)) && ((System::random(100)) < targetCreature->getSkillMod(def))))
				return RICOCHET;
			else return HIT;
		}

		targetDefense = getDefenderSecondaryDefenseModifier(targetCreature);

		debug() << "Secondary defenses are " << targetDefense;

		if (targetDefense <= 0)
			return HIT; // no secondary defenses

		// add in a random roll
		targetDefense += System::random(199) + 1;

		//TODO: posture defense (or a simplified version thereof: +10 standing, -20 prone, 0 crouching) might be added in to this calculation, research this
		//TODO: dodge and counterattack might get a  +25 bonus (even when triggered via DA), research this

		int cobMod = targetCreature->getSkillMod("private_center_of_being");
		debug() << "Center of Being mod is " << cobMod;

		targetDefense += cobMod;
		debug() << "Final modified secondary defense is " << targetDefense;

		if (targetDefense > 50 + attackerAccuracy + weaponAccuracy + accuracyBonus + postureAccuracy + bonusAccuracy + attackerRoll) { // successful secondary defense, return type of defense

			debug() << "Secondaries defenses prevailed";
			// defense acuity returns random: case 0 BLOCK, case 1 DODGE or default COUNTER
			if (targetWeapon == nullptr || def == "unarmed_passive_defense") {
				int randRoll = System::random(2);
				switch (randRoll) {
				case 0: return BLOCK;
				case 1: return DODGE;
				case 2:
				default: return COUNTER;
				}
			}

			if (def == "block")
				return BLOCK;
			else if (def == "dodge")
				return DODGE;
			else if (def == "counterattack")
				return COUNTER;
			else // shouldn't get here
				return HIT; // no secondary defenses available on this weapon
		}
	}

	return HIT;
}

float CombatManager::calculateWeaponAttackSpeed(CreatureObject* attacker, WeaponObject* weapon, float skillSpeedRatio) const {
	if (attacker->isAiAgent()){
		float npcspeed = (5.0 - ((attacker->getLevel() * 4) * .01));

		if (attacker->hasState(CreatureState::STUNNED)) {
			npcspeed *= 1.5;
		}

		return npcspeed;//weapon->getAttackSpeed();
	}

//	int speedMod = getSpeedModifier(attacker, weapon);
//	float jediSpeed = attacker->getSkillMod("combat_haste") / 100.0f;
//
//	float attackSpeed = (1.0f - ((float) speedMod / 100.0f)) * skillSpeedRatio * weapon->getAttackSpeed();
//
//	if (jediSpeed > 0)
//		attackSpeed = attackSpeed - (attackSpeed * jediSpeed);
//
//	if (attacker->hasState(CreatureState::STUNNED)) {
//		attackSpeed *= 1.5;
//	}
//
//	return Math::max(attackSpeed, 1.0f);

	float speedMod = getSpeedModifier(attacker, weapon);

	if (speedMod > 100) speedMod = 100;
	speedMod *= .01;

	float attackSpeed = weapon->getAttackSpeed();//(1.0f - ((float) speedMod / 100.0f)) * skillSpeedRatio * weapon->getAttackSpeed();

//	float jediSpeed = attacker->getSkillMod("combat_haste") / 100.0f;
//	if (jediSpeed > 0)	attackSpeed = attackSpeed - (attackSpeed * jediSpeed);

	float speedcap = 1.0;

	float diff = attackSpeed - speedcap;

	attackSpeed -= (diff * speedMod);

	if (attackSpeed < 1.0) attackSpeed = 1.0;

	if (attacker->hasState(CreatureState::STUNNED)) {
		attackSpeed *= 1.5;
	}

	return attackSpeed;//Math::max(attackSpeed, 1.0f);
}

void CombatManager::doMiss(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage) const {
	defender->showFlyText("combat_effects", "miss", 0xFF, 0xFF, 0xFF);

}

void CombatManager::doCounterAttack(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage) const {
	defender->showFlyText("combat_effects", "counterattack", 0, 0xFF, 0);
	//defender->doCombatAnimation(defender, STRING_HASHCODE("dodge"), 0);

}

void CombatManager::doBlock(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage) const {
	defender->showFlyText("combat_effects", "block", 0, 0xFF, 0);

	//defender->doCombatAnimation(defender, STRING_HASHCODE("dodge"), 0);

}

void CombatManager::doLightsaberBlock(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage) const {
	// No Fly Text.

	//creature->doCombatAnimation(defender, STRING_HASHCODE("test_sword_ricochet"), 0);

}

void CombatManager::showHitLocationFlyText(CreatureObject *attacker, CreatureObject *defender, uint8 location) const {
	return;
	if (defender->isVehicleObject())
		return;

	ShowFlyText* fly = nullptr;
	switch(location) {
	case HIT_HEAD:
		fly = new ShowFlyText(defender, "combat_effects", "hit_head", 0, 0, 0xFF, 1.0f);
		break;
	case HIT_BODY:
		fly = new ShowFlyText(defender, "combat_effects", "hit_body", 0xFF, 0, 0, 1.0f);
		break;
	case HIT_LARM:
		fly = new ShowFlyText(defender, "combat_effects", "hit_larm", 0xFF, 0, 0, 1.0f);
		break;
	case HIT_RARM:
		fly = new ShowFlyText(defender, "combat_effects", "hit_rarm", 0xFF, 0, 0, 1.0f);
		break;
	case HIT_LLEG:
		fly = new ShowFlyText(defender, "combat_effects", "hit_lleg", 0, 0xFF, 0, 1.0f);
		break;
	case HIT_RLEG:
		fly = new ShowFlyText(defender, "combat_effects", "hit_rleg", 0, 0xFF, 0, 1.0f);
		break;
	}

	if(fly != nullptr)
		attacker->sendMessage(fly);
}

void CombatManager::doDodge(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage) const {
	defender->showFlyText("combat_effects", "dodge", 0, 0xFF, 0);

	//defender->doCombatAnimation(defender, STRING_HASHCODE("dodge"), 0);

}

bool CombatManager::applySpecialAttackCost(CreatureObject* attacker, WeaponObject* weapon, const CreatureAttackData& data) const {
	if (attacker->isAiAgent() || data.isForceAttack())
		return true;

	float force = weapon->getForceCost() * data.getForceCostMultiplier();
//	Reference<PlayerObject*> ghostdef = defender->getPlayerObject();
//
//	if (weapon->isJediWeapon() || ghostdef->hasBhTef()){
//		VisibilityManager::instance()->increaseVisibility(attacker, 25); // Give visibility
//	}

	if (force > 0) { // Need Force check first otherwise it can be spammed.

		for (int i = 0; i < attacker->getSlottedObjectsSize(); ++i) {
			SceneObject* item = attacker->getSlottedObject(i);
			if (item != nullptr && item->isArmorObject()){
				force *= 1.1;
			}
		}

		//put wearing armor force cost increase here?
//		bool jarmor = false;
//		for (int i = 0; i < attacker->getSlottedObjectsSize(); ++i) {
//			SceneObject* item = attacker->getSlottedObject(i);
//			if (item != nullptr && item->isArmorObject()){
//				jarmor = true;
//			}
//		}
//		if (jarmor == true) force *= 1.5;

		ManagedReference<PlayerObject*> playerObject = attacker->getPlayerObject();
		if (playerObject != nullptr) {
			if (playerObject->getForcePower() <= force) {
				attacker->sendSystemMessage("@jedi_spam:no_force_power");
				return false;
			} else {
				playerObject->setForcePower(playerObject->getForcePower() - force);
				//VisibilityManager::instance()->increaseVisibility(attacker, data.getCommand()->getVisMod()); // Give visibility

				ZoneServer* server = attacker->getZoneServer();
				PlayerManager* pManager = server->getPlayerManager();
				pManager->awardExperience(attacker, "jedi_general", force * 5, true, 1.0, false);
			}
		}
	}

	float health = weapon->getHealthAttackCost() * data.getHealthCostMultiplier();
	float action = weapon->getActionAttackCost() * data.getActionCostMultiplier();
	float mind = weapon->getMindAttackCost() * data.getMindCostMultiplier();

	health = attacker->calculateCostAdjustment(CreatureAttribute::STRENGTH, health);
	action = attacker->calculateCostAdjustment(CreatureAttribute::QUICKNESS, action);
	mind = attacker->calculateCostAdjustment(CreatureAttribute::FOCUS, mind);

	if (attacker->getHAM(CreatureAttribute::HEALTH) <= health)
		return false;

	if (attacker->getHAM(CreatureAttribute::ACTION) <= action)
		return false;

	if (attacker->getHAM(CreatureAttribute::MIND) <= mind)
		return false;

	if (health > 0)
		attacker->inflictDamage(attacker, CreatureAttribute::HEALTH, health, true, true, true);

	if (action > 0)
		attacker->inflictDamage(attacker, CreatureAttribute::ACTION, action, true, true, true);

	if (mind > 0)
		attacker->inflictDamage(attacker, CreatureAttribute::MIND, mind, true, true, true);

	return true;
}

void CombatManager::applyStates(CreatureObject* creature, CreatureObject* targetCreature, const CreatureAttackData& data) const {
	const VectorMap<uint8, StateEffect>* stateEffects = data.getStateEffects();
	int stateAccuracyBonus = data.getStateAccuracyBonus();

	if (targetCreature->isInvulnerable())
		return;

	int playerLevel = 0;
	if (targetCreature->isPlayerCreature()) {
		ZoneServer* server = targetCreature->getZoneServer();
		if (server != nullptr) {
			PlayerManager* pManager = server->getPlayerManager();
			if (pManager != nullptr) {
				playerLevel = pManager->calculatePlayerLevel(targetCreature) - 5;
			}
		}
	}

	// loop through all the states in the command
	for (int i = 0; i < stateEffects->size(); i++) {
		const StateEffect& effect = stateEffects->get(i);
		bool failed = false;
		uint8 effectType = effect.getEffectType();

		float accuracyMod = effect.getStateChance() + stateAccuracyBonus;
		if (data.isStateOnlyAttack())
			accuracyMod += creature->getSkillMod(data.getCommand()->getAccuracySkillMod());

		//Check for state immunity.
		if (targetCreature->hasEffectImmunity(effectType))
			failed = true;

		if(!failed) {
			const Vector<String>& exclusionTimers = effect.getDefenderExclusionTimers();
			// loop through any exclusion timers
			for (int j = 0; j < exclusionTimers.size(); j++)
				if (!targetCreature->checkCooldownRecovery(exclusionTimers.get(j))) failed = true;
		}

		float targetDefense = 0.f;

		// if recovery timer conditions aren't satisfied, it won't matter
		if (!failed) {
			const Vector<String>& defenseMods = effect.getDefenderStateDefenseModifiers();
			// add up all defenses against the state the target has
			for (int j = 0; j < defenseMods.size(); j++)
				targetDefense += targetCreature->getSkillMod(defenseMods.get(j));

			targetDefense /= 1.5;
			targetDefense += playerLevel;

			if (targetCreature->isAiAgent()) targetDefense = targetCreature->getLevel() / 2;

			if (targetDefense > 90)
				targetDefense = 90.f;

			if (System::random(100) > accuracyMod - targetDefense)
				failed = true;

			// no reason to apply jedi defenses if primary defense was successful
			// and only perform extra rolls if the character is a Jedi
			if (!failed && targetCreature->isPlayerCreature() && targetCreature->getPlayerObject()->isJedi()) {
				const Vector<String>& jediMods = effect.getDefenderJediStateDefenseModifiers();
				// second chance for jedi, roll against their special defenses jedi_state_defense & resistance_states
				for (int j = 0; j < jediMods.size(); j++) {
					targetDefense = targetCreature->getSkillMod(jediMods.get(j));

					targetDefense /= 1.5;
					targetDefense += playerLevel;

					if (targetDefense > 90)
						targetDefense = 90.f;

					if (System::random(100) > accuracyMod - targetDefense) {
						failed = true;
						break;
					}
				}
			}
		}

		if (!failed) {
			if (effectType == CommandEffect::NEXTATTACKDELAY) {
				StringIdChatParameter stringId("combat_effects", "delay_applied_other");
				stringId.setTT(targetCreature->getObjectID());
				stringId.setDI(effect.getStateLength());
				creature->sendSystemMessage(stringId);
			}

			data.getCommand()->applyEffect(creature, targetCreature, effectType, effect.getStateStrength() + stateAccuracyBonus);
		}

		// can move this to scripts, but only these states have fail messages
		if (failed) {
			switch (effectType) {
			case CommandEffect::KNOCKDOWN:
				if (!targetCreature->checkKnockdownRecovery() && targetCreature->getPosture() != CreaturePosture::UPRIGHT)
					targetCreature->setPosture(CreaturePosture::UPRIGHT);
				creature->sendSystemMessage("@cbt_spam:knockdown_fail");
				break;
			case CommandEffect::POSTUREDOWN:
				if (!targetCreature->checkPostureDownRecovery() && targetCreature->getPosture() != CreaturePosture::UPRIGHT)
					targetCreature->setPosture(CreaturePosture::UPRIGHT);
				creature->sendSystemMessage("@cbt_spam:posture_change_fail");
				break;
			case CommandEffect::POSTUREUP:
				if (!targetCreature->checkPostureUpRecovery() && targetCreature->getPosture() != CreaturePosture::UPRIGHT)
					targetCreature->setPosture(CreaturePosture::UPRIGHT);
				creature->sendSystemMessage("@cbt_spam:posture_change_fail");
				break;
			case CommandEffect::NEXTATTACKDELAY:
				targetCreature->showFlyText("combat_effects", "warcry_miss", 0xFF, 0, 0 );
				break;
			case CommandEffect::INTIMIDATE:
				targetCreature->showFlyText("combat_effects", "intimidated_miss", 0xFF, 0, 0 );
				break;
			default:
				break;
			}
		}

		// now check combat equilibrium
		//TODO: This should eventually be moved to happen AFTER the CombatAction is broadcast to "fix" it's animation (Mantis #4832)
		if (!failed && (effectType == CommandEffect::KNOCKDOWN || effectType == CommandEffect::POSTUREDOWN || effectType == CommandEffect::POSTUREUP)) {
			int combatEquil = targetCreature->getSkillMod("combat_equillibrium");

			if (combatEquil > 100)
				combatEquil = 100;

			if ((combatEquil >> 1) > (int) System::random(100) && !targetCreature->isDead() && !targetCreature->isIntimidated())
				targetCreature->setPosture(CreaturePosture::UPRIGHT, false);
		}

		//Send Combat Spam for state-only attacks.
		if (data.isStateOnlyAttack()) {
			if (failed)
				data.getCommand()->sendAttackCombatSpam(creature, targetCreature, MISS, 0, data);
			else
				data.getCommand()->sendAttackCombatSpam(creature, targetCreature, HIT, 0, data);
		}
	}

}

int CombatManager::calculatePoolsToDamage(int poolsToDamage) const {
	if (poolsToDamage & RANDOM) {
		int rand = System::random(100);

		if (rand < 50) {
			poolsToDamage = HEALTH;
		} else if (rand < 85) {
			poolsToDamage = ACTION;
		} else {
			poolsToDamage = MIND;
		}
	}

	return poolsToDamage;
}

int CombatManager::applyDamage(TangibleObject* attacker, WeaponObject* weapon, CreatureObject* defender, int damage,
		float damageMultiplier, int poolsToDamage, uint8& hitLocation, const CreatureAttackData& data) const {
	if (poolsToDamage == 0 || damageMultiplier == 0)
		return 0;


	float healthDamage = 0.f, actionDamage = 0.f, mindDamage = 0.f;

	if (defender->isInvulnerable()) {
		return 0;
	}

if (!attacker->isTurret()) {

	int aiquick = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::QUICKNESS);//70+r30
	int aifocus = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::FOCUS);//70/10
	int aistrength = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::STRENGTH);//70r30

	if (attacker->isAiAgent() && !attacker->isCreature() && attacker->getLevel() > 10 && aifocus > aiquick) { // 1/3 on npc get this
		if (weapon->isPistolWeapon()){
			poolsToDamage = HEALTH;
			damage *= .6;
		}
		if (weapon->isCarbineWeapon()){
			poolsToDamage = ACTION;
			damage *= .6;
		}
		if (weapon->isRifleWeapon()){
			poolsToDamage = MIND;
			damage *= .6;
		}
//			if (weapon->isRangedWeapon())
//			damage *= 1.03f;
		if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon()){
			poolsToDamage = HEALTH;
			damage *= .6;
		}
		if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon()){
			poolsToDamage = MIND;
			damage *= .6;
		}
		if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon()){
			poolsToDamage = ACTION;
			damage *= .6;
		}
		if (weapon->isUnarmedWeapon() && attacker->getLevel() > 20){
			poolsToDamage = MIND;
			damage *= .6;
		}
		if (weapon->isLightningRifle()){

		}
		if (weapon->isFlameThrower()){

		}
		if (weapon->isHeavyAcidRifle()){

		}
//			if (weapon->isMeleeWeapon())
//			damage *= 1.1f;
//			if (weapon->isHeavyWeapon())
//			damage *= 1.0f;
//		if (weapon->isThrownWeapon())
//		damage *= .1;
//			if (weapon->isSpecialHeavyWeapon())
//			damage *= 0;
//			if (weapon->isMineWeapon())
//			damage *= 0;
		if (weapon->isJediOneHandedWeapon()){
			poolsToDamage = MIND;
			damage *= .6;
		}
		if (weapon->isJediTwoHandedWeapon()){
			poolsToDamage = HEALTH;
			damage *= .6;
		}
		if (weapon->isJediPolearmWeapon()){
			poolsToDamage = ACTION;
			damage *= .6;
		}
//			if (weapon->isJediWeapon())
//			damage *= 1.1f;

	}

	if (attacker->isAiAgent() && !attacker->isCreature() && attacker->getLevel() > 10 && aiquick > aifocus) {// 2/3 on npc get this
		if (weapon->isPistolWeapon()){

		}
		if (weapon->isCarbineWeapon()){

		}
		if (weapon->isRifleWeapon()){

		}
//			if (weapon->isRangedWeapon())

		if (weapon->isOneHandMeleeWeapon() && !weapon->isJediWeapon() && attacker->getLevel() > 10){

		}
		if (weapon->isTwoHandMeleeWeapon() && !weapon->isJediWeapon() && attacker->getLevel() > 10){

		}
		if (weapon->isPolearmWeaponObject() && !weapon->isJediWeapon() && attacker->getLevel() > 10){

		}
		if (weapon->isUnarmedWeapon()){

		}
		if (weapon->isLightningRifle()){

		}
		if (weapon->isFlameThrower()){

		}
		if (weapon->isHeavyAcidRifle()){

		}
//			if (weapon->isMeleeWeapon())

//			if (weapon->isHeavyWeapon())

//			if (weapon->isThrownWeapon())

//			if (weapon->isSpecialHeavyWeapon())

//			if (weapon->isMineWeapon())

		if (weapon->isJediOneHandedWeapon()){

		}
		if (weapon->isJediTwoHandedWeapon()){

		}
		if (weapon->isJediPolearmWeapon()){

		}
//			if (weapon->isJediWeapon())

	}


//	int phealth = defender->asCreatureObject()->getHAM(CreatureAttribute::HEALTH);
//	int paction = defender->asCreatureObject()->getHAM(CreatureAttribute::ACTION);
//	int pmind = defender->asCreatureObject()->getHAM(CreatureAttribute::MIND);
//
//	if (!attacker->isPlayerCreature() && (aifocus > aistrength)) {
//		if (phealth < pmind && phealth < paction) {
//			poolsToDamage = HEALTH;
//			damage *= .6;
//		}
//		if (paction < pmind && paction < phealth) {
//			poolsToDamage = ACTION;
//			damage *= .6;
//		}
//		if (pmind < phealth && pmind < paction) {
//			poolsToDamage = MIND;
//			damage *= .6;
//		}
//	}

	int aihealth = attacker->asCreatureObject()->getHAM(CreatureAttribute::HEALTH);
	int aiaction = attacker->asCreatureObject()->getHAM(CreatureAttribute::ACTION);
	int aimind = attacker->asCreatureObject()->getHAM(CreatureAttribute::MIND);

	int aihealthmax = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::HEALTH);
	int aiactionmax = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::ACTION);
	int aimindmax = attacker->asCreatureObject()->getMaxHAM(CreatureAttribute::MIND);

	if (attacker->isAiAgent() && !attacker->isCreature()) {

		if (aistrength > aiquick && !weapon->isJediWeapon() && (aihealth < (aihealthmax * .7) || aiaction < (aiactionmax * .7)) && System::random(15) >= 15) {

			int healammount = 100;

			if (attacker->getLevel() > 10) healammount = 250;

			if (attacker->getLevel() > 30) healammount = 500;

			if (attacker->getLevel() > 50) healammount = 1000;

			attacker->asCreatureObject()->healDamage(attacker->asCreatureObject(), CreatureAttribute::HEALTH, healammount, true);
			attacker->asCreatureObject()->healDamage(attacker->asCreatureObject(), CreatureAttribute::ACTION, healammount, true);

			attacker->asCreatureObject()->doAnimation("heal_self");
			attacker->asCreatureObject()->playEffect("clienteffect/healing_healdamage.cef", "");

			attacker->asCreatureObject()->addCooldown("nextAttackDelay", 8000);

//			int maxstims = 25;
//
//			if (creoAttacker->hasBuff(BuffCRC::SPICE_NEUTRON_PIXEY_DOWN)) {
//				maxstims = -1;
//			}

			poolsToDamage = NONE;
			damage = 0;

			return 0;
		}

		if (weapon->isJediWeapon() && System::random(5) >= 5 && (aihealth < (aihealthmax * .7) || aiaction < (aiactionmax * .7) || aimind < (aimindmax * .7))) {

			int jedhealammount = 500;

			if (attacker->getLevel() > 50) jedhealammount = 1500;

			attacker->asCreatureObject()->healDamage(attacker->asCreatureObject(), CreatureAttribute::HEALTH, jedhealammount, true);
			attacker->asCreatureObject()->healDamage(attacker->asCreatureObject(), CreatureAttribute::ACTION, jedhealammount, true);
			attacker->asCreatureObject()->healDamage(attacker->asCreatureObject(), CreatureAttribute::MIND, jedhealammount, true);

			attacker->asCreatureObject()->doAnimation("force_healing_1");
			attacker->asCreatureObject()->playEffect("clienteffect/pl_force_heal_self.cef", "");

			//attacker->asCreatureObject()->addPendingTask("injuryTreatment", task, 3000);

			//attacker->asCreatureObject()->setNextAttackDelay(0, 3000);

			attacker->asCreatureObject()->addCooldown("nextAttackDelay", 6000);//not sure if working? sometimes working?

			poolsToDamage = NONE;
			damage = 0;

			return 0;
		}
	}
	
	}

	String xpType;
	if (data.isForceAttack())
		xpType = "jedi_general";
	else if (attacker->isPet())
		xpType = "creaturehandler";
	else
		xpType = weapon->getXpType();

	bool healthDamaged = (!!(poolsToDamage & HEALTH) && data.getHealthDamageMultiplier() > 0.0f);
	bool actionDamaged = (!!(poolsToDamage & ACTION) && data.getActionDamageMultiplier() > 0.0f);
	bool mindDamaged   = (!!(poolsToDamage & MIND)   && data.getMindDamageMultiplier()   > 0.0f);

	int numberOfPoolsDamaged = (healthDamaged ? 1 : 0) + (actionDamaged ? 1 : 0) + (mindDamaged ? 1 : 0);
	Vector<int> poolsToWound;

	int numSpillOverPools = 3 - numberOfPoolsDamaged;

	float spillMultPerPool = (0.1f * numSpillOverPools) / Math::max(numberOfPoolsDamaged, 1);
	int totalSpillOver = 0; // Accumulate our total spill damage

	// from screenshots, it appears that food mitigation and armor mitigation were independently calculated
	// and then added together.
	int foodBonus = defender->getSkillMod("mitigate_damage");
	int totalFoodMit = 0;

	if (healthDamaged) {
		static const uint8 bodyLocations[] = {HIT_BODY, HIT_BODY, HIT_LARM, HIT_RARM};
		hitLocation = bodyLocations[System::random(3)];

		healthDamage = getArmorReduction(attacker, weapon, defender, damage * data.getHealthDamageMultiplier(), hitLocation, data) * damageMultiplier;

		int foodMitigation = 0;

		if (foodBonus > 0) {
			foodMitigation = (int)(healthDamage * foodBonus / 100.f);
			foodMitigation = Math::min(healthDamage, foodMitigation * data.getHealthDamageMultiplier());
		}

		healthDamage -= foodMitigation;
		totalFoodMit += foodMitigation;

		int spilledDamage = (int)(healthDamage*spillMultPerPool); // Cut our damage by the spill percentage
		healthDamage -= spilledDamage; // subtract spill damage from total damage
		totalSpillOver += spilledDamage;  // accumulate spill damage

		defender->inflictDamage(attacker, CreatureAttribute::HEALTH, (int)healthDamage, true, xpType, true, true);

		poolsToWound.add(CreatureAttribute::HEALTH);
	}

	if (actionDamaged) {
		static const uint8 legLocations[] = {HIT_LLEG, HIT_RLEG};
		hitLocation = legLocations[System::random(1)];

		actionDamage = getArmorReduction(attacker, weapon, defender, damage * data.getActionDamageMultiplier(), hitLocation, data) * damageMultiplier;

		int foodMitigation = 0;

		if (foodBonus > 0) {
			foodMitigation = (int)(actionDamage * foodBonus / 100.f);
			foodMitigation = Math::min(actionDamage, foodMitigation * data.getActionDamageMultiplier());
		}

		actionDamage -= foodMitigation;
		totalFoodMit += foodMitigation;

		int spilledDamage = (int)(actionDamage*spillMultPerPool);
		actionDamage -= spilledDamage;
		totalSpillOver += spilledDamage;

		defender->inflictDamage(attacker, CreatureAttribute::ACTION, (int)actionDamage, true, xpType, true, true);

		poolsToWound.add(CreatureAttribute::ACTION);
	}

	if (mindDamaged) {
		hitLocation = HIT_HEAD;
		mindDamage = getArmorReduction(attacker, weapon, defender, damage * data.getMindDamageMultiplier(), hitLocation, data) * damageMultiplier;

		int foodMitigation = 0;

		if (foodBonus > 0) {
			foodMitigation = (int)(mindDamage * foodBonus / 100.f);
			foodMitigation = Math::min(mindDamage, foodMitigation * data.getMindDamageMultiplier());
		}

		mindDamage -= foodMitigation;
		totalFoodMit += foodMitigation;

		int spilledDamage = (int)(mindDamage*spillMultPerPool);
		mindDamage -= spilledDamage;
		totalSpillOver += spilledDamage;

		defender->inflictDamage(attacker, CreatureAttribute::MIND, (int)mindDamage, true, xpType, true, true);

		poolsToWound.add(CreatureAttribute::MIND);
	}

	if (numSpillOverPools > 0) {
		int spillDamagePerPool = (int)(totalSpillOver / numSpillOverPools); // Split the spill over damage between the pools damaged

		int spillOverRemainder = (totalSpillOver % numSpillOverPools) + spillDamagePerPool;

		if ((poolsToDamage ^ 0x7) & HEALTH)
			defender->inflictDamage(attacker, CreatureAttribute::HEALTH, (numSpillOverPools-- > 1 ? spillDamagePerPool : spillOverRemainder), true, xpType, true, true);
		if ((poolsToDamage ^ 0x7) & ACTION)
			defender->inflictDamage(attacker, CreatureAttribute::ACTION, (numSpillOverPools-- > 1 ? spillDamagePerPool : spillOverRemainder), true, xpType, true, true);
		if ((poolsToDamage ^ 0x7) & MIND)
			defender->inflictDamage(attacker, CreatureAttribute::MIND, (numSpillOverPools-- > 1 ? spillDamagePerPool : spillOverRemainder), true, xpType, true, true);
	}

	int totalDamage =  (int) (healthDamage + actionDamage + mindDamage);
	defender->notifyObservers(ObserverEventType::DAMAGERECEIVED, attacker, totalDamage);

	float ratio = weapon->getWoundsRatio();
	if (attacker->isAiAgent())
		ratio = attacker->getLevel() / 3;
	if (ratio > 50) ratio = 50;
	if (poolsToWound.size() > 0 && System::random(100) < ratio) {
		int poolToWound = poolsToWound.get(System::random(poolsToWound.size() - 1));
		defender->addWounds(poolToWound,     1, true);
		defender->addWounds(poolToWound + 1, 1, true);
		defender->addWounds(poolToWound + 2, 1, true);
	}

	if(attacker->isPlayerCreature())
		showHitLocationFlyText(attacker->asCreatureObject(), defender, hitLocation);

	//Send defensive buff combat spam last.
	if (totalFoodMit > 0)
		sendMitigationCombatSpam(defender, weapon, totalFoodMit, FOOD);

	return totalDamage;
}

int CombatManager::applyDamage(CreatureObject* attacker, WeaponObject* weapon, TangibleObject* defender, int poolsToDamage, const CreatureAttackData& data) const {
	if (poolsToDamage == 0)
		return 0;

	if (defender->getPvpStatusBitmask() == CreatureFlag::NONE) {
		return 0;
	}

	int damage = calculateDamage(attacker, weapon, defender, data);

	float damageMultiplier = (data.getDamageMultiplier() + 1) / 2;// - .7) * 1.2;// dammult

	if (!attacker->isPlayerCreature())
		damageMultiplier = 1.0;

	if (damageMultiplier != 0)
		damage *= damageMultiplier;

	String xpType;
	if (data.isForceAttack())
		xpType = "jedi_general";
	else if (attacker->isPet())
		xpType = "creaturehandler";
	else
		xpType = weapon->getXpType();

	if (defender->isTurret()) {
		int damageType = 0, armorPiercing = 1;

		if (!data.isForceAttack()) {
			damageType = weapon->getDamageType();
			armorPiercing = weapon->getArmorPiercing();

			if (weapon->isBroken())
				armorPiercing = 0;
		} else {
			damageType = 8;//data.getDamageType();
		}

		int armorReduction = getArmorTurretReduction(attacker, defender, damageType);

		if (armorReduction >= 0)
			damage *= getArmorPiercing(defender, armorPiercing);

		damage *= (1.f - (armorReduction / 100.f));
	}

	defender->inflictDamage(attacker, 0, damage, true, xpType, true, true);

	defender->notifyObservers(ObserverEventType::DAMAGERECEIVED, attacker, damage);

	return damage;
}

void CombatManager::sendMitigationCombatSpam(CreatureObject* defender, TangibleObject* item, uint32 damage, int type) const {
	if (defender == nullptr || !defender->isPlayerCreature())
			return;

	int color = 0; //text color
	String file = "";
	String stringName = "";

	switch (type) {
	case PSG:
		color = 1; //green, confirmed
		file = "cbt_spam";
		stringName = "shield_damaged";
		break;
	case FORCESHIELD:
		color = 1; //green, unconfirmed
		file = "cbt_spam";
		stringName = "forceshield_hit";
		item = nullptr;
		break;
	case FORCEFEEDBACK:
		color = 2; //red, confirmed
		file = "cbt_spam";
		stringName = "forcefeedback_hit";
		item = nullptr;
		break;
	case FORCEABSORB:
		color = 0; //white, unconfirmed
		file = "cbt_spam";
		stringName = "forceabsorb_hit";
		item = nullptr;
		break;
	case FORCEARMOR:
		color = 1; //green, confirmed
		file = "cbt_spam";
		stringName = "forcearmor_hit";
		item = nullptr;
		break;
	case ARMOR:
		color = 1; //green, confirmed
		file = "cbt_spam";
		stringName = "armor_damaged";
		break;
	case FOOD:
		color = 0; //white, confirmed
		file = "combat_effects";
		stringName = "mitigate_damage";
		item = nullptr;
		break;
	default:
		break;
	}

	CombatSpam* spam = new CombatSpam(defender, nullptr, defender, item, damage, file, stringName, color);
	defender->sendMessage(spam);
}

void CombatManager::broadcastCombatSpam(TangibleObject* attacker, TangibleObject* defender, TangibleObject* item,
		int damage, const String& file, const String& stringName, byte color) const {
	if (attacker == nullptr)
		return;

	Zone* zone = attacker->getZone();
	if (zone == nullptr)
		return;

	CloseObjectsVector* vec = (CloseObjectsVector*) attacker->getCloseObjects();
	SortedVector<QuadTreeEntry*> closeObjects;

	if (vec != nullptr) {
		closeObjects.removeAll(vec->size(), 10);
		vec->safeCopyReceiversTo(closeObjects, CloseObjectsVector::PLAYERTYPE);
	} else {
#ifdef COV_DEBUG
		info("Null closeobjects vector in CombatManager::broadcastCombatSpam", true);
#endif
		zone->getInRangeObjects(attacker->getWorldPositionX(), attacker->getWorldPositionY(), COMBAT_SPAM_RANGE, &closeObjects, true);
	}

	for (int i = 0; i < closeObjects.size(); ++i) {
		SceneObject* object = static_cast<SceneObject*>( closeObjects.get(i));

		if (object->isPlayerCreature() && attacker->isInRange(object, COMBAT_SPAM_RANGE)) {
			CreatureObject* receiver = static_cast<CreatureObject*>( object);
			CombatSpam* spam = new CombatSpam(attacker, defender, receiver, item, damage, file, stringName, color);
			receiver->sendMessage(spam);
		}
	}
}

void CombatManager::broadcastCombatAction(CreatureObject * attacker, TangibleObject * defenderObject,
		WeaponObject* weapon, const CreatureAttackData & data, int damage, uint8 hit, uint8 hitLocation) const {
	const String& animation = data.getCommand()->getAnimation(attacker, defenderObject, weapon, hitLocation, damage);

	uint32 animationCRC = 0;

	if (!animation.isEmpty())
		animationCRC = animation.hashCode();

	fatal(animationCRC != 0, "animationCRC is 0");

	uint64 weaponID = weapon->getObjectID();

	CreatureObject *dcreo = defenderObject->asCreatureObject();
	if (dcreo != nullptr) { // All of this funkiness only applies to creo targets, tano's don't animate hits or posture changes

		dcreo->updatePostures(false); // Commit pending posture changes to the client and notify observers

		if (data.getPrimaryTarget() != defenderObject->getObjectID()){ // Check if we should play the default animation or one of several reaction animations

			if (hit == HIT) {

				if (data.changesDefenderPosture() && (!dcreo->isIncapacitated() && !dcreo->isDead())) {
					dcreo->doCombatAnimation(STRING_HASHCODE("change_posture")); // We're not the primary target, but we are the victim of a posture change attack
				} else {
					dcreo->doCombatAnimation(STRING_HASHCODE("get_hit_medium")); // We're not the primary target but were hit - play the got hit animation
				}

			} else if (hit == RICOCHET) { // Not a hit but also not the primary target - play a dodge animation
				//creature->doCombatAnimation(defender, STRING_HASHCODE("test_sword_ricochet"), 0);
				dcreo->doCombatAnimation(STRING_HASHCODE("test_sword_ricochet"));
			}	else { // Not a hit but also not the primary target - play a dodge animation
				dcreo->doCombatAnimation(STRING_HASHCODE("dodge"));//remove ANNOYING DODGE ANIMATION/sidestep/jump
			}

		} else { // Primary target attack - play default animation
			attacker->doCombatAnimation(dcreo, animationCRC, hit, data.getTrails(), weaponID);
		}

	} else {
		if(data.getPrimaryTarget() == defenderObject->getObjectID()){ // Tano target attack - play default animation
			attacker->doCombatAnimation(defenderObject, animationCRC, hit, data.getTrails(), weaponID);
		}
	}

	if(data.changesAttackerPosture())
		attacker->updatePostures(false);

	const String& effect = data.getCommand()->getEffectString();

	if (!effect.isEmpty())
		attacker->playEffect(effect);
}

void CombatManager::requestDuel(CreatureObject* player, CreatureObject* targetPlayer) const {
	/* Pre: player != targetPlayer and not nullptr; player is locked
	 * Post: player requests duel to targetPlayer
	 */

	Locker clocker(targetPlayer, player);

	PlayerObject* ghost = player->getPlayerObject();
	PlayerObject* targetGhost = targetPlayer->getPlayerObject();

	if (ghost->requestedDuelTo(targetPlayer)) {
		StringIdChatParameter stringId("duel", "already_challenged");
		stringId.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId);

		return;
	}

	player->debug() << "requesting duel with " << targetPlayer->getObjectID();

	ghost->addToDuelList(targetPlayer);

	if (targetGhost->requestedDuelTo(player)) {
		BaseMessage* pvpstat = new UpdatePVPStatusMessage(targetPlayer, player,
				targetPlayer->getPvpStatusBitmask()
				| CreatureFlag::ATTACKABLE
				| CreatureFlag::AGGRESSIVE);
		player->sendMessage(pvpstat);

		for (int i = 0; i < targetGhost->getActivePetsSize(); i++) {
			ManagedReference<AiAgent*> pet = targetGhost->getActivePet(i);

			if (pet != nullptr) {
				BaseMessage* petpvpstat = new UpdatePVPStatusMessage(pet, player,
						pet->getPvpStatusBitmask()
						| CreatureFlag::ATTACKABLE
						| CreatureFlag::AGGRESSIVE);
				player->sendMessage(petpvpstat);
			}
		}

		StringIdChatParameter stringId("duel", "accept_self");
		stringId.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId);

		BaseMessage* pvpstat2 = new UpdatePVPStatusMessage(player, targetPlayer,
				player->getPvpStatusBitmask() | CreatureFlag::ATTACKABLE
				| CreatureFlag::AGGRESSIVE);
		targetPlayer->sendMessage(pvpstat2);

		for (int i = 0; i < ghost->getActivePetsSize(); i++) {
			ManagedReference<AiAgent*> pet = ghost->getActivePet(i);

			if (pet != nullptr) {
				BaseMessage* petpvpstat = new UpdatePVPStatusMessage(pet, targetPlayer,
						pet->getPvpStatusBitmask()
						| CreatureFlag::ATTACKABLE
						| CreatureFlag::AGGRESSIVE);
				targetPlayer->sendMessage(petpvpstat);
			}
		}

		StringIdChatParameter stringId2("duel", "accept_target");
		stringId2.setTT(player->getObjectID());
		targetPlayer->sendSystemMessage(stringId2);
	} else {
		StringIdChatParameter stringId3("duel", "challenge_self");
		stringId3.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId3);

		StringIdChatParameter stringId4("duel", "challenge_target");
		stringId4.setTT(player->getObjectID());
		targetPlayer->sendSystemMessage(stringId4);
	}
}

void CombatManager::requestEndDuel(CreatureObject* player, CreatureObject* targetPlayer) const {
	/* Pre: player != targetPlayer and not nullptr; player is locked
	 * Post: player requested to end the duel with targetPlayer
	 */

	Locker clocker(targetPlayer, player);

	PlayerObject* ghost = player->getPlayerObject();
	PlayerObject* targetGhost = targetPlayer->getPlayerObject();

	if (!ghost->requestedDuelTo(targetPlayer)) {
		StringIdChatParameter stringId("duel", "not_dueling");
		stringId.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId);

		return;
	}

	player->debug() << "ending duel with " << targetPlayer->getObjectID();

	ghost->removeFromDuelList(targetPlayer);
	player->removeDefender(targetPlayer);

	if (targetGhost->requestedDuelTo(player)) {
		targetGhost->removeFromDuelList(player);
		targetPlayer->removeDefender(player);

		player->sendPvpStatusTo(targetPlayer);

		for (int i = 0; i < ghost->getActivePetsSize(); i++) {
			ManagedReference<AiAgent*> pet = ghost->getActivePet(i);

			if (pet != nullptr) {
				targetPlayer->removeDefender(pet);
				pet->sendPvpStatusTo(targetPlayer);

				ManagedReference<CreatureObject*> target = targetPlayer;

				Core::getTaskManager()->executeTask([=] () {
					Locker locker(pet);

					pet->removeDefender(target);
				}, "PetRemoveDefenderLambda");
			}
		}

		StringIdChatParameter stringId("duel", "end_self");
		stringId.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId);

		targetPlayer->sendPvpStatusTo(player);

		for (int i = 0; i < targetGhost->getActivePetsSize(); i++) {
			ManagedReference<AiAgent*> pet = targetGhost->getActivePet(i);

			if (pet != nullptr) {
				player->removeDefender(pet);
				pet->sendPvpStatusTo(player);

				ManagedReference<CreatureObject*> play = player;

				Core::getTaskManager()->executeTask([=] () {
					Locker locker(pet);

					pet->removeDefender(play);
				}, "PetRemoveDefenderLambda2");
			}
		}

		StringIdChatParameter stringId2("duel", "end_target");
		stringId2.setTT(player->getObjectID());
		targetPlayer->sendSystemMessage(stringId2);
	}
}

void CombatManager::freeDuelList(CreatureObject* player, bool spam) const {
	/* Pre: player not nullptr and is locked
	 * Post: player removed and warned all of the objects from its duel list
	 */
	PlayerObject* ghost = player->getPlayerObject();

	if (ghost == nullptr || ghost->isDuelListEmpty())
		return;

	player->debug("freeing duel list");

	while (ghost->getDuelListSize() != 0) {
		ManagedReference<CreatureObject*> targetPlayer = ghost->getDuelListObject(0);
		PlayerObject* targetGhost = targetPlayer->getPlayerObject();

		if (targetPlayer != nullptr && targetGhost != nullptr && targetPlayer.get() != player) {
			try {
				Locker clocker(targetPlayer, player);

				ghost->removeFromDuelList(targetPlayer);
				player->removeDefender(targetPlayer);

				if (targetGhost->requestedDuelTo(player)) {
					targetGhost->removeFromDuelList(player);
					targetPlayer->removeDefender(player);

					player->sendPvpStatusTo(targetPlayer);

					for (int i = 0; i < ghost->getActivePetsSize(); i++) {
						ManagedReference<AiAgent*> pet = ghost->getActivePet(i);

						if (pet != nullptr) {
							targetPlayer->removeDefender(pet);
							pet->sendPvpStatusTo(targetPlayer);

							Core::getTaskManager()->executeTask([=] () {
								Locker locker(pet);

								pet->removeDefender(targetPlayer);
							}, "PetRemoveDefenderLambda3");
						}
					}

					if (spam) {
						StringIdChatParameter stringId("duel", "end_self");
						stringId.setTT(targetPlayer->getObjectID());
						player->sendSystemMessage(stringId);
					}

					targetPlayer->sendPvpStatusTo(player);

					for (int i = 0; i < targetGhost->getActivePetsSize(); i++) {
						ManagedReference<AiAgent*> pet = targetGhost->getActivePet(i);

						if (pet != nullptr) {
							player->removeDefender(pet);
							pet->sendPvpStatusTo(player);

							ManagedReference<CreatureObject*> play = player;

							Core::getTaskManager()->executeTask([=] () {
								Locker locker(pet);

								pet->removeDefender(play);
							}, "PetRemoveDefenderLambda4");
						}
					}

					if (spam) {
						StringIdChatParameter stringId2("duel", "end_target");
						stringId2.setTT(player->getObjectID());
						targetPlayer->sendSystemMessage(stringId2);
					}
				}


			} catch (ObjectNotDeployedException& e) {
				ghost->removeFromDuelList(targetPlayer);

				System::out << "Exception on CombatManager::freeDuelList()\n"
						<< e.getMessage() << "\n";
			}
		}
	}
}

void CombatManager::declineDuel(CreatureObject* player, CreatureObject* targetPlayer) const {
	/* Pre: player != targetPlayer and not nullptr; player is locked
	 * Post: player declined Duel to targetPlayer
	 */

	Locker clocker(targetPlayer, player);

	PlayerObject* ghost = player->getPlayerObject();
	PlayerObject* targetGhost = targetPlayer->getPlayerObject();

	if (targetGhost->requestedDuelTo(player)) {
		targetGhost->removeFromDuelList(player);

		StringIdChatParameter stringId("duel", "cancel_self");
		stringId.setTT(targetPlayer->getObjectID());
		player->sendSystemMessage(stringId);

		StringIdChatParameter stringId2("duel", "cancel_target");
		stringId2.setTT(player->getObjectID());
		targetPlayer->sendSystemMessage(stringId2);

		player->debug() << "declined duel with " << targetPlayer->getObjectID();
	}
}

bool CombatManager::areInDuel(CreatureObject* player1, CreatureObject* player2) const {
	PlayerObject* ghost1 = player1->getPlayerObject().get();
	PlayerObject* ghost2 = player2->getPlayerObject().get();

	if (ghost1 != nullptr && ghost2 != nullptr) {
		if (ghost1->requestedDuelTo(player2) && ghost2->requestedDuelTo(player1))
			return true;
	}

	return false;
}

bool CombatManager::checkConeAngle(SceneObject* target, float angle,
		float creatureVectorX, float creatureVectorY, float directionVectorX,
		float directionVectorY) const {
	float Target1 = target->getPositionX() - creatureVectorX;
	float Target2 = target->getPositionY() - creatureVectorY;

	float resAngle = atan2(Target2, Target1) - atan2(directionVectorY, directionVectorX);
	float degrees = resAngle * 180 / M_PI;

	float coneAngle = angle / 2;

	if (degrees > coneAngle || degrees < -coneAngle) {
		return false;
	}

	return true;
}


Reference<SortedVector<ManagedReference<TangibleObject*> >* > CombatManager::getAreaTargets(TangibleObject* attacker,
		WeaponObject* weapon, TangibleObject* defenderObject, const CreatureAttackData& data) const {
	float creatureVectorX = attacker->getPositionX();
	float creatureVectorY = attacker->getPositionY();

	float directionVectorX = defenderObject->getPositionX() - creatureVectorX;
	float directionVectorY = defenderObject->getPositionY() - creatureVectorY;

	Reference<SortedVector<ManagedReference<TangibleObject*> >* > defenders = new SortedVector<ManagedReference<TangibleObject*> >();

	Zone* zone = attacker->getZone();

	if (zone == nullptr)
		return defenders;

	PlayerManager* playerManager = zone->getZoneServer()->getPlayerManager();

	int damage = 0;

	int range = data.getAreaRange();

	if (data.getCommand()->isConeAction()) {
		int coneRange = data.getConeRange();

		if(coneRange > -1) {
			range = coneRange;
		} else {
			range = data.getRange();
		}
	}

	if (range < 0) {
		range = weapon->getMaxRange();
	}

	if (weapon->isMeleeWeapon()) {
		range = weapon->getMaxRange();
	}

	if (data.isSplashDamage())
		range += data.getRange();

	if (weapon->isThrownWeapon() || weapon->isHeavyWeapon())
		range = weapon->getMaxRange() + data.getAreaRange();

	try {
		//zone->rlock();

		CloseObjectsVector* vec =  (CloseObjectsVector*)attacker->getCloseObjects();

		SortedVector<QuadTreeEntry*> closeObjects;

		if (vec != nullptr) {
			closeObjects.removeAll(vec->size(), 10);
			vec->safeCopyTo(closeObjects);
		} else {
#ifdef COV_DEBUG
			attacker->info("Null closeobjects vector in CombatManager::getAreaTargets", true);
#endif
			zone->getInRangeObjects(attacker->getWorldPositionX(), attacker->getWorldPositionY(), 128, &closeObjects, true);
		}

		for (int i = 0; i < closeObjects.size(); ++i) {
			SceneObject* object = static_cast<SceneObject*>(closeObjects.get(i));

			TangibleObject* tano = object->asTangibleObject();
			CreatureObject* creo = object->asCreatureObject();

			if (tano == nullptr) {
				continue;
			}

			if (object == attacker || object == defenderObject) {
				//error("object is attacker");
				continue;
			}

			if (!tano->isAttackableBy(attacker)) {
				//error("object is not attackable");
				continue;
			}

			if (attacker->isPlayerCreature() && object->getParentID() != 0 && attacker->getParentID() != object->getParentID()) {
				Reference<CellObject*> targetCell = object->getParent().get().castTo<CellObject*>();
				CreatureObject* aggressor = attacker->asCreatureObject();

				if (targetCell != nullptr) {
					if (!object->isPlayerCreature()) {
						auto perms = targetCell->getContainerPermissions();

						if (!perms->hasInheritPermissionsFromParent()) {
							if (targetCell->checkContainerPermission(aggressor, ContainerPermissions::WALKIN))
								continue;
						}
					}

					ManagedReference<SceneObject*> parentSceneObject = targetCell->getParent().get();

					if (parentSceneObject != nullptr) {
						BuildingObject* buildingObject = parentSceneObject->asBuildingObject();

						if (buildingObject != nullptr && !buildingObject->isAllowedEntry(aggressor))
							continue;
					}
				}
			}

			if (attacker->getWorldPosition().distanceTo(object->getWorldPosition()) - attacker->getTemplateRadius() - object->getTemplateRadius() > range) {
				//error("not in range " + String::valueOf(range));
				continue;
			}

			if (data.isSplashDamage() || weapon->isThrownWeapon() || weapon->isHeavyWeapon()) {
				if (defenderObject->getWorldPosition().distanceTo(tano->getWorldPosition()) - tano->getTemplateRadius() > data.getAreaRange() )
					continue;
			}

			if (creo != nullptr && creo->isFeigningDeath() == false && creo->isIncapacitated()) {
				//error("object is incapacitated");
				continue;
			}

			if (data.getCommand()->isConeAction() && !checkConeAngle(tano, data.getConeAngle(), creatureVectorX, creatureVectorY, directionVectorX, directionVectorY)) {
				//error("object is not in cone angle");
				continue;
			}

			//			zone->runlock();

			try {
				if (!(weapon->isThrownWeapon()) && !(data.isSplashDamage()) && !(weapon->isHeavyWeapon())) {
					if (CollisionManager::checkLineOfSight(object, attacker)) {
						defenders->put(tano);
					}
				} else {
					if (CollisionManager::checkLineOfSight(object, defenderObject)) {
						defenders->put(tano);
					}
				}
			} catch (Exception& e) {
				error(e.getMessage());
			} catch (...) {
				//zone->rlock();

				throw;
			}

			//			zone->rlock();
		}

		//		zone->runlock();
	} catch (...) {
		//		zone->runlock();

		throw;
	}

	return defenders;
}

int CombatManager::getArmorTurretReduction(CreatureObject* attacker, TangibleObject* defender, int damageType) const {
	int resist = 0;

	if (defender != nullptr && defender->isTurret()) {
		DataObjectComponentReference* data = defender->getDataObjectComponent();

		if (data != nullptr) {

			TurretDataComponent* turretData = cast<TurretDataComponent*>(data->get());

			if (turretData != nullptr) {

				switch (damageType) {
				case SharedWeaponObjectTemplate::KINETIC:
					resist = turretData->getKinetic();
					break;
				case SharedWeaponObjectTemplate::ENERGY:
					resist = turretData->getEnergy();
					break;
				case SharedWeaponObjectTemplate::ELECTRICITY:
					resist = turretData->getElectricity();
					break;
				case SharedWeaponObjectTemplate::STUN:
					resist = turretData->getStun();
					if (resist > 50) resist = 50;
					break;
				case SharedWeaponObjectTemplate::BLAST:
					resist = turretData->getBlast();
					break;
				case SharedWeaponObjectTemplate::HEAT:
					resist = turretData->getHeat();
					break;
				case SharedWeaponObjectTemplate::COLD:
					resist = turretData->getCold();
					break;
				case SharedWeaponObjectTemplate::ACID:
					resist = turretData->getAcid();
					break;
				case SharedWeaponObjectTemplate::LIGHTSABER:
					resist = turretData->getLightSaber();
					//if (resist > 25) resist = 25;
					break;
				}
			}
		}
	}

	if (resist > 80) resist = 80;

	return resist;
}

void CombatManager::initializeDefaultAttacks() {

	defaultRangedAttacks.add(STRING_HASHCODE("fire_1_single_light"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_1_single_medium"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_1_single_light_face"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_1_single_medium_face"));

	defaultRangedAttacks.add(STRING_HASHCODE("fire_3_single_light"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_3_single_medium"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_3_single_light_face"));
	defaultRangedAttacks.add(STRING_HASHCODE("fire_3_single_medium_face"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_light_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_light_0"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_medium_0"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_medium_0"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_light_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_light_1"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_medium_1"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_medium_1"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_light_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_light_2"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_medium_2"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_medium_2"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_light_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_light_3"));

	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_left_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_center_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_high_right_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_left_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_center_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_mid_right_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_left_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_right_medium_3"));
	defaultMeleeAttacks.add(STRING_HASHCODE("attack_low_center_medium_3"));
}

void CombatManager::checkForTefs(CreatureObject* attacker, CreatureObject* defender, bool* shouldGcwCrackdownTef, bool* shouldGcwTef, bool* shouldBhTef) const {
	return; // disable tef
	if (*shouldGcwCrackdownTef && *shouldGcwTef && *shouldBhTef) {
		return;
	}

	ManagedReference<CreatureObject*> attackingCreature = attacker->isPet() ? attacker->getLinkedCreature() : attacker;
	ManagedReference<CreatureObject*> targetCreature = defender->isPet() || defender->isVehicleObject() ? defender->getLinkedCreature() : defender;

	Reference<PlayerObject*> ghostdef = defender->getPlayerObject();
	Reference<PlayerObject*> ghostatt = attacker->getPlayerObject();

	TangibleObject* deftano = defender->asTangibleObject();

	PlayerObject* newghostd = defender->getPlayerObject();

	if ((attackingCreature != nullptr && targetCreature != nullptr) && (attacker->isPlayerCreature())) {

		if (!(*shouldGcwTef)) {
		if (((attackingCreature->isRebel() && targetCreature->isImperial()) || (attackingCreature->isImperial() && targetCreature->isRebel())) //&& !attackingCreature->isNeutral() && !targetCreature->isNeutral()
				&& attackingCreature->getFactionStatus() >= FactionStatus::COVERT) {//&& !attackingCreature->isNeutral()
			*shouldGcwTef = true;
		}
		}

		if (!(*shouldBhTef)) {

		if ((attacker->getWeapon()->isJediWeapon())
				//||	(defender->getWeapon()->isJediWeapon() && defender->isPlayerCreature())// && targetCreature->isPlayerCreature() && attackingCreature->isPlayerCreature())
				//|| (ghostdef->hasBhTef() && defender->isPlayerCreature())// && !ghostatt->hasBhTef()) && (ghostdef != nullptr && ghostatt != nullptr)
				//||	(deftano->getPvpStatusBitmask() == CreatureFlag::TEF  && defender->isPlayerCreature())
				)	{
			*shouldBhTef = true;
		}

		if (defender->isPlayerCreature()//ghostdef->hasTef() && defender->isPlayerCreature() && (ghostdef != nullptr)
				//||	(defender->getWeapon()->isJediWeapon() && defender->isPlayerCreature())// && targetCreature->isPlayerCreature() && attackingCreature->isPlayerCreature())
				//|| (ghostdef->hasBhTef() && defender->isPlayerCreature())// && !ghostatt->hasBhTef()) && (ghostdef != nullptr && ghostatt != nullptr)
				//||	(deftano->getPvpStatusBitmask() == CreatureFlag::TEF  && defender->isPlayerCreature())
				)	{
			if (ghostdef->hasBhTef() || defender->getWeapon()->isJediWeapon()){
			*shouldBhTef = true;//need to figure out how to add tef to jedi defender that doesnt attack back, since this section only applies to the ATTACKER
			}
		}

		}

	}
}
