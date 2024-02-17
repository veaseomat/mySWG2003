#include "server/zone/objects/tangible/pharmaceutical/EnhancePack.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/managers/skill/SkillModManager.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/player/FactionStatus.h"

uint32 EnhancePackImplementation::calculatePower(CreatureObject* healer, CreatureObject* patient, bool applyBattleFatigue) {
		float power = getEffectiveness();

		if (applyBattleFatigue)
			power *= patient->calculateBFRatio();

//		int droidBuff = healer->getSkillModOfType("private_medical_rating",SkillModManager::DROID);
//		int bldBuff = healer->getSkillModOfType("private_medical_rating", SkillModManager::STRUCTURE);
//		int mod = healer->getSkillModOfType("private_medical_rating", SkillModManager::CITY);
//		mod +=  droidBuff > bldBuff ? droidBuff : bldBuff;
//
//		int factionPerk = healer->getSkillMod("private_faction_medical_rating");
//
//		ManagedReference<BuildingObject*> building = cast<BuildingObject*>(healer->getRootParent());
//
//		if (building != nullptr && factionPerk > 0 && building->isPlayerRegisteredWithin(healer->getObjectID())) {
//			unsigned int buildingFaction = building->getFaction();
//			unsigned int healerFaction = healer->getFaction();
//
//			if (healerFaction != 0 && healerFaction == buildingFaction && healer->getFactionStatus() == FactionStatus::OVERT) {
//				mod += factionPerk;
//			}
//		}
//
//		float modEnvironment = ((float) mod / 100);

		float modSkill = (float) healer->getSkillMod("healing_wound_treatment") / 100;

		modSkill *= .1;

//		if (modSkill > 1.0) {
//			float tapes = modSkill - 1.0;
//			tapes *= .1;
//			modSkill = 1.0 + tapes;
//		}

		return power + (power * modSkill);//* modEnvironment * (100 + modSkill) / 100;
}

void EnhancePackImplementation::fillAttributeList(AttributeListMessage* alm, CreatureObject* object) {
	PharmaceuticalObjectImplementation::fillAttributeList(alm, object);

	//super.fillAttributeList(msg, object);

//	string attributeName = BuffAttribute.getName(attribute);
//	string enhace = "examine_enhance_" + attributeName;
//	string durationStr = "examine_duration_" + attributeName;

	//StringBuffer buffratio;

	//float newbuff = Math.getPrecision(effectiveness, 0) / 1000;

	//buffratio << newbuff << "x (base HAM multiplier)";

	//msg.insertAttribute(enhace, buffratio); //Math.getPrecision(effectiveness, 0));


	String attributeName = BuffAttribute::getName(attribute);
	String enhace = "examine_enhance_" + attributeName;
	String durationStr = "examine_duration_" + attributeName;

	StringBuffer buffratio;
	float newbuff = Math::getPrecision(effectiveness, 0) / 10;
	buffratio << newbuff << "% (base HAM)";
	alm->insertAttribute(enhace, buffratio); //Math.getPrecision(effectiveness, 0));

	StringBuffer newdur;
	float dursec = Math::getPrecision(duration, 0) * 2 / 60 / 60;
	newdur << dursec << " hours";
	alm->insertAttribute(durationStr, newdur);

	alm->insertAttribute("healing_ability", PharmaceuticalObjectImplementation::medicineUseRequired);

	if (absorption > 0)
		alm->insertAttribute("absorption", Math::getPrecision(absorption, 0));


}




