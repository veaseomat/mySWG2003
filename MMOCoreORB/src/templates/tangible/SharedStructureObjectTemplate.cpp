/*
 * SharedStructureObjectTemplate.cpp
 *
 *  Created on: May 22, 2010
 *      Author: crush
 */


#include "SharedStructureObjectTemplate.h"


void SharedStructureObjectTemplate::readObject(LuaObject* templateData) {
	SharedTangibleObjectTemplate::readObject(templateData);

	lotSize = templateData->getByteField("lotSize");

	baseMaintenanceRate = templateData->getIntField("baseMaintenanceRate") / 50;

	basePowerRate = templateData->getIntField("basePowerRate") / 50;

	allowedZones = {"corellia", "talus", "dathomir", "endor", "lok", "naboo", "rori", "tatooine", "yavin4", "dantooine"},

	cityRankRequired = templateData->getByteField("cityRankRequired");

	constructionMarkerTemplate = templateData->getStringField("constructionMarker");

//	abilityRequired = templateData->getStringField("abilityRequired");

	uniqueStructure = templateData->getBooleanField("uniqueStructure");

	cityMaintenanceBase = templateData->getIntField("cityMaintenanceBase") / 50;

	cityMaintenanceRate = templateData->getIntField("cityMaintenanceRate") / 50;
}
