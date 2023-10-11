/*
 * AttachmentImplementation.cpp
 *
 *  Created on: Mar 10, 2011
 *      Author: polonel
 */

#include "server/zone/objects/tangible/attachment/Attachment.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/ZoneProcessServer.h"
#include "server/zone/packets/scene/AttributeListMessage.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/managers/loot/LootManager.h"

void AttachmentImplementation::initializeTransientMembers() {
	TangibleObjectImplementation::initializeTransientMembers();

	setLoggingName("AttachmentObject");

}

void AttachmentImplementation::updateCraftingValues(CraftingValues* values, bool firstUpdate) {
	int level = values->getMaxValue("creatureLevel");
	//int roll = System::random(100);
	int modCount = 1;


	// if(false && roll > 99)
	// 	modCount += 2;
	//
	// if(false && roll < 5)
	// 	modCount += 1;

	for(int i = 0; i < modCount; ++i) {
		//Mods can't be lower than -1 or greater than 25
//		int max = (int) Math::max(-1.f, Math::min(50.f, (float) round(0.1f * level + 3)));
//		int min = (int) Math::max(-1.f, Math::min(50.f, (float) round(0.075f * level - 1)));
//
//		int mod = System::random(max - min) + min;

		int max = (level / 10);
		int min = (level / 10) / 2;

		int mod = System::random(min) + max;

		// mod += System::random(10);

		//int nlvl = (level / 7) / 2;//max lvl 350 lootmanag

		//int mod = System::random(nlvl) + nlvl;

		if(mod > 50)
			mod = 50;

		if(mod < 1)
			mod = 1;

		String modName = server->getZoneServer()->getLootManager()->getRandomLootableMod(gameObjectType);

		skillModMap.put(modName, mod);
	}
}

void AttachmentImplementation::initializeMembers() {
	if (gameObjectType == SceneObjectType::CLOTHINGATTACHMENT) {
		setOptionsBitmask(32, true);
		attachmentType = CLOTHINGTYPE;

	} else if (gameObjectType == SceneObjectType::ARMORATTACHMENT) {
		setOptionsBitmask(32, true);
		attachmentType = ARMORTYPE;

	}

}

void AttachmentImplementation::fillAttributeList(AttributeListMessage* msg, CreatureObject* object) {
	TangibleObjectImplementation::fillAttributeList(msg, object);

	StringBuffer name;

	HashTableIterator<String, int> iterator = skillModMap.iterator();

	String key = "";
	int value = 0;

	for(int i = 0; i < skillModMap.size(); ++i) {

		iterator.getNextKeyAndValue(key, value);

		name << "cat_skill_mod_bonus.@stat_n:" << key;

		msg->insertAttribute(name.toString(), value);

		if (customName.isEmpty()){

			StringId SEAName;

			SEAName.setStringId("stat_n", key);

			setCustomObjectName("", false);

			setObjectName(SEAName, false);

			setCustomObjectName(getDisplayedName() + " +" + String::valueOf(value), true);

			StringId originalName;

			if (isArmorAttachment())
				originalName.setStringId("item_n", "socket_gem_armor");

			else
				originalName.setStringId("item_n", "socket_gem_clothing");

			setObjectName(originalName, true);
		}

		name.deleteAll();
	}

}
