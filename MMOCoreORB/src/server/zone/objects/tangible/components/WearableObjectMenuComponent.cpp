/*
 * WearableObjectMenuComponent.cpp
 *
 *  Created on: 10/30/2011
 *      Author: kyle
 */

#include "server/zone/objects/creature/CreatureObject.h"
#include "WearableObjectMenuComponent.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"

#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/building/BuildingObject.h"
#include "server/zone/objects/player/sui/colorbox/SuiColorBox.h"
#include "ArmorObjectMenuComponent.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/player/sui/callbacks/ColorArmorSuiCallback.h"
#include "server/zone/ZoneServer.h"
#include "templates/customization/AssetCustomizationManagerTemplate.h"

void WearableObjectMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	if (!sceneObject->isTangibleObject())
		return;

	TangibleObject* tano = cast<TangibleObject*>(sceneObject);
	if (tano == nullptr)
		return;

	if (tano->getConditionDamage() > 0 && tano->canRepair(player)) {
		menuResponse->addRadialMenuItem(70, 3, "@sui:repair"); // Slice
	}

	String text = "Color Change";
	menuResponse->addRadialMenuItem(81, 3, text);

	TangibleObjectMenuComponent::fillObjectMenuResponse(sceneObject, menuResponse, player);

}

int WearableObjectMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	if (!sceneObject->isASubChildOf(player))
		return 0;

	if (selectedID == 70) {
		if(!sceneObject->isTangibleObject())
			return 0;

		TangibleObject* tano = cast<TangibleObject*>(sceneObject);
		if(tano == nullptr)
			return 0;

		tano->repair(player);

		return 1;
	}

	if (selectedID == 81) {

		ManagedReference<SceneObject*> parent = sceneObject->getParent().get();

		if (parent == nullptr)
			return 0;

		if (parent->isPlayerCreature()) {
			player->sendSystemMessage("@armor_rehue:equipped");
			return 0;
		}

		if (parent->isCellObject()) {
			ManagedReference<SceneObject*> obj = parent->getParent().get();

			if (obj != nullptr && obj->isBuildingObject()) {
				ManagedReference<BuildingObject*> buio = cast<BuildingObject*>(obj.get());

				if (!buio->isOnAdminList(player))
					return 0;
			}
		}
		else
		{
			if (!sceneObject->isASubChildOf(player))
				return 0;
		}

		ZoneServer* server = player->getZoneServer();

		if (server != nullptr) {

		// The color index.
		String appearanceFilename = sceneObject->getObjectTemplate()->getAppearanceFilename();
		VectorMap<String, Reference<CustomizationVariable*> > variables;
		AssetCustomizationManagerTemplate::instance()->getCustomizationVariables(appearanceFilename.hashCode(), variables, false);

		// The Sui Box.
		ManagedReference<SuiColorBox*> cbox = new SuiColorBox(player, SuiWindowType::COLOR_ARMOR);
		cbox->setCallback(new ColorArmorSuiCallback(server));
		cbox->setColorPalette(variables.elementAt(1).getKey()); // First one seems to be the frame of it? Skip to 2nd.
		cbox->setUsingObject(sceneObject);

		// Add to player.
		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		ghost->addSuiBox(cbox);
		player->sendMessage(cbox->generateMessage());
		}

		if (server != nullptr) {

		// The color index.
		String appearanceFilename = sceneObject->getObjectTemplate()->getAppearanceFilename();
		VectorMap<String, Reference<CustomizationVariable*> > variables;
		AssetCustomizationManagerTemplate::instance()->getCustomizationVariables(appearanceFilename.hashCode(), variables, false);

		// The Sui Box.
		ManagedReference<SuiColorBox*> cbox = new SuiColorBox(player, SuiWindowType::COLOR_ARMOR);
		cbox->setCallback(new ColorArmorSuiCallback(server));
		cbox->setColorPalette(variables.elementAt(0).getKey()); // First one seems to be the frame of it? Skip to 2nd.
		cbox->setUsingObject(sceneObject);

		// Add to player.
		ManagedReference<PlayerObject*> ghost = player->getPlayerObject();
		ghost->addSuiBox(cbox);
		player->sendMessage(cbox->generateMessage());
		}

	}

	return TangibleObjectMenuComponent::handleObjectMenuSelect(sceneObject, player, selectedID);
}
