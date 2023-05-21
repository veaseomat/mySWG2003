/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.
 */

#include "server/zone/objects/creature/CreatureObject.h"

#include "SkillManager.h"
#include "SkillModManager.h"
#include "PerformanceManager.h"
#include "server/zone/objects/creature/variables/Skill.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/badges/Badge.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/jedi/JediManager.h"
#include "templates/manager/TemplateManager.h"
#include "templates/datatables/DataTableIff.h"
#include "templates/datatables/DataTableRow.h"
#include "server/zone/managers/crafting/schematicmap/SchematicMap.h"
#include "server/zone/packets/creature/CreatureObjectDeltaMessage4.h"
#include "server/zone/managers/mission/MissionManager.h"
#include "server/zone/managers/frs/FrsManager.h"

#include "server/zone/ZoneServer.h"
#include "server/chat/ChatManager.h"
#include "engine/engine.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/ZoneProcessServer.h"
#include "engine/core/ManagedService.h"
#include "server/zone/objects/player/sui/messagebox/SuiMessageBox.h"

SkillManager::SkillManager()
	: Logger("SkillManager") {

	zoneServer = ServerCore::getZoneServer();

	rootNode = new Skill();

	performanceManager = new PerformanceManager();

	apprenticeshipEnabled = false;
}

SkillManager::~SkillManager() {
	delete performanceManager;
}

int SkillManager::includeFile(lua_State* L) {
	String filename = Lua::getStringParameter(L);
	Lua::runFile("scripts/skills/" + filename, L);

	return 0;
}

int SkillManager::addSkill(lua_State* L) {
	LuaObject obj(L);
	SkillManager::instance()->loadSkill(&obj);
	obj.pop();

	return 0;
}

void SkillManager::loadLuaConfig() {
	Lua* lua = new Lua();
	lua->init();

	lua->runFile("scripts/managers/skill_manager.lua");

	apprenticeshipEnabled = lua->getGlobalByte("apprenticeshipEnabled");

	delete lua;
	lua = nullptr;
}

void SkillManager::loadClientData() {
	IffStream* iffStream = TemplateManager::instance()->openIffFile("datatables/skill/skills.iff");

	if (iffStream == nullptr) {
		error("Could not load skills.");
		return;
	}

	DataTableIff dtiff;
	dtiff.readObject(iffStream);

	delete iffStream;

	for (int i = 0; i < dtiff.getTotalRows(); ++i) {
		DataTableRow* row = dtiff.getRow(i);

		Reference<Skill*> skill = new Skill();
		skill->parseDataTableRow(row);

		Skill* parent = skillMap.get(skill->getParentName().hashCode());

		if (parent == nullptr)
			parent = rootNode;

		parent->addChild(skill);

		if (skillMap.put(skill->getSkillName().hashCode(), skill) != nullptr) {
			fatal("overwriting skill name");
		}

		//Load the abilities of the skill into the ability map.
		const auto& commands = skill->commands;

		for (int i = 0; i < commands.size(); ++i) {
			const auto& command = commands.get(i);

			if (!abilityMap.containsKey(command)) {
				abilityMap.put(command, new Ability(command));
			}
		}
	}

	loadFromLua();

	//If the admin ability isn't in the ability map, then we want to add it manually.
	if (!abilityMap.containsKey("admin"))
		abilityMap.put("admin", new Ability("admin"));

	// These are not listed in skills.iff and need to be added manually
	if (!abilityMap.containsKey("startMusic+western"))
		abilityMap.put("startMusic+western", new Ability("startMusic+western"));
	if (!abilityMap.containsKey("startDance+theatrical"))
		abilityMap.put("startDance+theatrical", new Ability("startDance+theatrical"));
	if (!abilityMap.containsKey("startDance+theatrical2"))
		abilityMap.put("startDance+theatrical2", new Ability("startDance+theatrical2"));

	loadXpLimits();

	info(true) << "Successfully loaded " << skillMap.size() <<
	       	" skills and " << abilityMap.size() << " abilities.";
}

void SkillManager::loadFromLua() {
	Lua* lua = new Lua();
	lua->init();
	lua->registerFunction("includeFile", &includeFile);
	lua->registerFunction("addSkill", &addSkill);

	lua->runFile("scripts/skills/serverobjects.lua");

	delete lua;
}

void SkillManager::loadSkill(LuaObject* luaSkill) {
	Reference<Skill*> skill = new Skill();
	skill->parseLuaObject(luaSkill);
	Skill* parent = skillMap.get(skill->getParentName().hashCode());

	if(parent == nullptr) {
		parent = rootNode;
	}

	parent->addChild(skill);
	skillMap.put(skill->getSkillName().hashCode(), skill);

	Vector<String> commands = skill->commands;

	for(int i = 0; i < commands.size(); ++i) {
		String command = commands.get(i);

		if(!abilityMap.containsKey(command)) {
			abilityMap.put(command, new Ability(command));
		}
	}

}

void SkillManager::loadXpLimits() {
	IffStream* iffStream = TemplateManager::instance()->openIffFile("datatables/skill/xp_limits.iff");

	if (iffStream == nullptr) {
		error("Could not load skills.");
		return;
	}

	DataTableIff dtiff;
	dtiff.readObject(iffStream);

	delete iffStream;

	for (int i = 0; i < dtiff.getTotalRows(); ++i) {
		DataTableRow* row = dtiff.getRow(i);

		String type;
		int value;
		row->getValue(0, type);
		row->getValue(1, value);
		defaultXpLimits.put(type, value);

		debug() << type << ": " << value;
	}
}

void SkillManager::addAbility(PlayerObject* ghost, const String& abilityName, bool notifyClient) {
	Ability* ability = abilityMap.get(abilityName);

	if (ability != nullptr)
		ghost->addAbility(ability, notifyClient);
}

void SkillManager::removeAbility(PlayerObject* ghost, const String& abilityName, bool notifyClient) {
	Ability* ability = abilityMap.get(abilityName);

	if (ability != nullptr)
		ghost->removeAbility(ability, notifyClient);
}

void SkillManager::addAbilities(PlayerObject* ghost, const Vector<String>& abilityNames, bool notifyClient) {
	Vector<Ability*> abilities;

	for (int i = 0; i < abilityNames.size(); ++i) {
		const String& abilityName = abilityNames.get(i);

		Ability* ability = abilityMap.get(abilityName);

		if (ability != nullptr && !ghost->hasAbility(abilityName))
			abilities.add(ability);
	}

	ghost->addAbilities(abilities, notifyClient);
}

void SkillManager::removeAbilities(PlayerObject* ghost, const Vector<String>& abilityNames, bool notifyClient) {
	Vector<Ability*> abilities;

	for (int i = 0; i < abilityNames.size(); ++i) {
		const String& abilityName = abilityNames.get(i);

		Ability* ability = abilityMap.get(abilityName);

		if (ability != nullptr && ghost->hasAbility(abilityName))
			abilities.add(ability);
	}

	ghost->removeAbilities(abilities, notifyClient);
}

/*bool SkillManager::checkPrerequisiteSkill(const String& skillName, CreatureObject* creature) {
	return true;
}*/

bool SkillManager::awardSkill(const String& skillName, CreatureObject* creature, bool notifyClient, bool awardRequiredSkills, bool noXpRequired) {
	auto skill = skillMap.get(skillName.hashCode());

	if (skill == nullptr)
		return false;

	if (skill->getSkillName() == "outdoors_creaturehandler_novice"
		|| creature->hasSkill("outdoors_bio_engineer_novice")
		|| creature->hasSkill("crafting_merchant_novice")
		|| creature->hasSkill("science_combatmedic_novice")
		|| creature->hasSkill("outdoors_squadleader_novice")
		|| creature->hasSkill("crafting_shipwright_novice")
	) {

			creature->sendSystemMessage("This skill is currently disabled in mySWG.");
		return false;
	}

//	if (skill->getSkillName() == "jedi_padawan_novice" && !creature->hasSkill("jedi_padawan_novice")) {
//		SkillManager::surrenderAllSkills(creature, true, false);
//	}

//	if (skill->getSkillName() == "jedi_dark_side_journeyman_novice" && creature->hasSkill("jedi_light_side_journeyman_novice")) {
//		creature->sendSystemMessage("You can only train light side or dark side.");
//		return false;
//	}
//
//	if (skill->getSkillName() == "jedi_light_side_journeyman_novice" && creature->hasSkill("jedi_dark_side_journeyman_novice")) {
//		creature->sendSystemMessage("You can only train light side or dark side.");
//		return false;
//	}

	Locker locker(creature);

	//Check for required skills.
	auto requiredSkills = skill->getSkillsRequired();
	for (int i = 0; i < requiredSkills->size(); ++i) {
		const String& requiredSkillName = requiredSkills->get(i);
		auto requiredSkill = skillMap.get(requiredSkillName.hashCode());

		if (requiredSkill == nullptr)
			continue;

		if (awardRequiredSkills)
			awardSkill(requiredSkillName, creature, notifyClient, awardRequiredSkills, noXpRequired);

		if (!creature->hasSkill(requiredSkillName))
			return false;
	}

	if (!canLearnSkill(skillName, creature, noXpRequired)) {
		return false;
	}

	//If they already have the skill, then return true.
	if (creature->hasSkill(skill->getSkillName()))
		return true;

	//this removes non jedi skills from existing jedi
//	if (creature->hasSkill("force_title_jedi_rank_02") && (creature->hasSkill("combat_marksman_novice") || creature->hasSkill("combat_brawler_novice") || creature->hasSkill("crafting_artisan_novice") || creature->hasSkill("science_medic_novice") || creature->hasSkill("outdoors_scout_novice") || creature->hasSkill("social_entertainer_novice"))) {
//		SkillManager::surrenderAllSkills(creature, true, false);
//	}

	ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

	if (ghost != nullptr) {
		//Withdraw skill points.
		ghost->addSkillPoints(-skill->getSkillPointsRequired());

		//only remove non jedi sp
//		if (!skill->getSkillName().contains("force_discipline")) {
//			ghost->addSkillPoints(-skill->getSkillPointsRequired());
//		}

		//Witdraw experience.
		if (!noXpRequired) {
			ghost->addExperience(skill->getXpType(), -skill->getXpCost(), true);
		}

		creature->addSkill(skill, notifyClient);

		//Add skill modifiers
		auto skillModifiers = skill->getSkillModifiers();

		for (int i = 0; i < skillModifiers->size(); ++i) {
			auto entry = &skillModifiers->elementAt(i);
			creature->addSkillMod(SkillModManager::SKILLBOX, entry->getKey(), entry->getValue(), notifyClient);

		}

		//Add abilities
		auto abilityNames = skill->getAbilities();
		addAbilities(ghost, *abilityNames, notifyClient);
		if (skill->isGodOnly()) {
			for (int i = 0; i < abilityNames->size(); ++i) {
				const String& ability = abilityNames->get(i);
				StringIdChatParameter params;
				params.setTU(ability);
				params.setStringId("ui", "skill_command_acquired_prose");

				creature->sendSystemMessage(params);
			}
		}

		//Add draft schematic groups
		auto schematicsGranted = skill->getSchematicsGranted();

//		if ((skill->getSkillName() == "force_discipline_light_saber_two_hand_02") || (skill->getSkillName() == "force_discipline_light_saber_polearm_02")) {
//			skillName == "force_discipline_light_saber_one_hand_02";
//			auto skill = skillMap.get(skillName.hashCode());
//			auto schematicsGranted = skill->getSchematicsGranted();
//			SchematicMap::instance()->addSchematics(ghost, *schematicsGranted, notifyClient);
////			auto schematicsGranted = "craftSaberOneHand2";
//		}
//
//		if ((skill->getSkillName() == "force_discipline_light_saber_two_hand_04") || (skill->getSkillName() == "force_discipline_light_saber_polearm_04")) {
//			skillName == "force_discipline_light_saber_one_hand_04";
//			auto skill = skillMap.get(skillName.hashCode());
//			auto schematicsGranted = skill->getSchematicsGranted();
//			SchematicMap::instance()->addSchematics(ghost, *schematicsGranted, notifyClient);
//			//SchematicMap::instance()->addSchematics(ghost, craftSaberOneHand3, notifyClient);
//		}

		SchematicMap::instance()->addSchematics(ghost, *schematicsGranted, notifyClient);

		//Update maximum experience.
		updateXpLimits(ghost);


		// Update Force Power Max.
		ghost->recalculateForcePower();

		ManagedReference<PlayerManager*> playerManager = creature->getZoneServer()->getPlayerManager();

		if (skillName.contains("master")) {
			if (playerManager != nullptr) {
				const Badge* badge = BadgeList::instance()->get(skillName);

				if (badge == nullptr && skillName == "crafting_shipwright_master") {
					badge = BadgeList::instance()->get("crafting_shipwright");
				}

				if (badge != nullptr) {
					//prof badges here
					playerManager->awardBadge(ghost, badge);
				}
			}
		}

//		const SkillList* list = creature->getSkillList();
//
//		int totalSkillPointsWasted = 250;
//
//		for (int i = 0; i < list->size(); ++i) {
//			Skill* skill = list->get(i);
//
//			totalSkillPointsWasted -= skill->getSkillPointsRequired();
//		}
//
//		if (ghost->getSkillPoints() != totalSkillPointsWasted) {
//			creature->error("skill points mismatch calculated: " + String::valueOf(totalSkillPointsWasted) + " found: " + String::valueOf(ghost->getSkillPoints()));
//			ghost->setSkillPoints(totalSkillPointsWasted);
//			SkillManager::surrenderAllSkills(creature, true, false);
//
//			ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
//			box->setPromptTitle("SKILLPOINT OVERLOAD");
//			box->setPromptText("Skill points now cap at 250. All of your skills have been removed, skill points reset and exp returned.");
//			ghost->addSuiBox(box);
//			creature->sendMessage(box->generateMessage());
//		}

		if (playerManager != nullptr) {
			creature->setLevel(playerManager->calculatePlayerLevel(creature));

			//playerManager->enhanceCharacter(creature);//LEVEL BUFFS IN 3 PLACES

		}
//this could be useful for quests
		if (skill->getSkillName().contains("force_sensitive") && skill->getSkillName().contains("_04"))
			JediManager::instance()->onFSTreeCompleted(creature, skill->getSkillName());

		MissionManager* missionManager = creature->getZoneServer()->getMissionManager();

		if (skill->getSkillName() == "force_title_jedi_rank_02") {
			if (missionManager != nullptr)
				missionManager->addPlayerToBountyList(creature->getObjectID(), ghost->calculateBhReward());
		} else if (skill->getSkillName().contains("force_discipline")) {
			if (missionManager != nullptr)
				missionManager->updatePlayerBountyReward(creature->getObjectID(), ghost->calculateBhReward());
		} else if (skill->getSkillName().contains("squadleader")) {
			Reference<GroupObject*> group = creature->getGroup();

			if (group != nullptr && group->getLeader() == creature) {
				Core::getTaskManager()->executeTask([group] () {
					Locker locker(group);

					group->removeGroupModifiers();
					group->addGroupModifiers();
				}, "UpdateGroupModsLambda");
			}
		}
	}

	/// Update client with new values for things like Terrain Negotiation
	CreatureObjectDeltaMessage4* msg4 = new CreatureObjectDeltaMessage4(creature);
	msg4->updateAccelerationMultiplierBase();
	msg4->updateAccelerationMultiplierMod();
	msg4->updateSpeedMultiplierBase();
	msg4->updateSpeedMultiplierMod();
	msg4->updateRunSpeed();
	msg4->updateTerrainNegotiation();
	msg4->close();
	creature->sendMessage(msg4);

	SkillModManager::instance()->verifySkillBoxSkillMods(creature);

	//works with frog not with trainer --now located in trainerconvohander
//	if (skill->getSkillName().contains("social_politician")) { //if (skill->getSkillName() == "social_politician_novice") {
//		awardSkill("social_politician_master", creature, true, true, true);
//	}

//	ZoneProcessServer* server;

	if (skill->getSkillName() == "force_title_jedi_rank_02") {

		creature->enqueueCommand(STRING_HASHCODE("findmytrainer"), 0, 0, "");

		ChatManager* chatManager = creature->getZoneServer()->getChatManager();
		ChatManager* chatManager2 = zoneServer.get()->getChatManager();
		ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
		String planet = ghost->getTrainerZoneName();

		box->setPromptTitle("Jedi Unlock");
		box->setPromptText("You begin to feel attuned with the power of the Force. Your Jedi skill trees have been unlocked! \n\n     A waypoint has been created to your Jedi skill trainer. First you need to craft a lightsaber and find a color crystal to begin training.\n\nCongratulations, good luck, and may the Force be with you... Jedi.");
		ghost->addSuiBox(box);
		creature->sendMessage(box->generateMessage());
//just create a fkn waypoint for the player, theyre too fucking stupid to figure out what to do.
		chatManager2->sendMail("mySWG", "JEDI UNLOCK", "Congratulations on unlocking Jedi on mySWG!\n\n     To begin training as a jedi you need to craft a lightsaber and find a color crystal.\n\nLIGHTSABER TEF\n\n		Using a lightsaber will make you attackable to ANYONE. Jedi in this time period are rare and in hiding!\n\nBOUNTY HUNTERS\n\n     Visibility is slightly more forgiving here but mostly unchanged. Using a lightsaber or any force powers within 32m of any player or humanoid NPC will raise your visibility for the Bounty Hunter terminals. NPC Bounty Hunters will start to come after you once you have enough visibility. As a new Jedi you should just RUN.\n\nJEDI KNIGHT\n\n     Jedi trials and FRS are currently disabled.", creature->getFirstName());

		chatManager->broadcastGalaxy("IMPERIAL COMMUNICATION FROM THE REGIONAL GOVERNOR:\n\nLord Vader has detected a vergence in the Force.\n\n     Be on the lookout for any suspicious persons displaying unique or odd abilities. Lord Vader authorizes all citizens to use deadly force to eliminate this threat to the Empire.", "imperial");
		}

//		if (skill->getSkillName() == "force_title_jedi_rank_01") {
//
//			//creature->enqueueCommand(STRING_HASHCODE("findmytrainer"), 0, 0, "");
//
//			ChatManager* chatManager = creature->getZoneServer()->getChatManager();
//			ChatManager* chatManager2 = zoneServer.get()->getChatManager();
//			ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
//			String planet = ghost->getTrainerZoneName();
//
//			box->setPromptTitle("Jedi Unlock");
//			box->setPromptText("You begin to feel attuned with the power of the Force. Your Jedi skill trees have been unlocked! \n\n     A waypoint has been created to the nearest jedi shrine, visit any jedi shrine to begin your jedi training. After you complete the Padawan trials all of your non jedi skills will be removed.\n\nCongratulations, good luck, and may the Force be with you... Jedi.");
//			ghost->addSuiBox(box);
//			creature->sendMessage(box->generateMessage());
////just create a fkn waypoint for the player, theyre too fucking stupid to figure out what to do.
//			chatManager2->sendMail("mySWG", "JEDI UNLOCK", "Congratulations on unlocking Jedi on mySWG!\n\n     To begin training as a jedi you first need to meditate at any Jedi shrine. If you do not want this character to be a jedi, do not start the trials.\n\nLIGHTSABER TEF\n\n		Using a lightsaber will make you attackable to ANYONE. Jedi in this time period are rare and in hiding!\n\nBOUNTY HUNTERS\n\n     Visibility is slightly more forgiving here but mostly unchanged. Using a lightsaber or any force powers within 32m of any player or humanoid NPC will raise your visibility for the Bounty Hunter terminals. NPC Bounty Hunters will start to come after you once you have enough visibility. As a new Jedi you should just RUN.\n\nJEDI KNIGHT\n\n     Jedi Knight trials will start when you have learned enough skills.", creature->getFirstName());
//
//			//chatManager->broadcastGalaxy("IMPERIAL COMMUNICATION FROM THE REGIONAL GOVERNOR:\n\nLord Vader has detected a vergence in the Force.\n\n     Be on the lookout for any suspicious persons displaying unique or odd abilities. Lord Vader authorizes all citizens to use deadly force to eliminate this threat to the Empire.", "imperial");
//		}
//
//		if (skill->getSkillName() == "force_title_jedi_rank_02") {
//
//			creature->enqueueCommand(STRING_HASHCODE("findmytrainer"), 0, 0, "");
//
//			ChatManager* chatManager = creature->getZoneServer()->getChatManager();
//			ChatManager* chatManager2 = zoneServer.get()->getChatManager();
//			ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
//			String planet = ghost->getTrainerZoneName();
//
//			box->setPromptTitle("Jedi Padawan");
//			box->setPromptText("A waypoint has been added to your datapad for your personal Jedi skill trainer.");
//			ghost->addSuiBox(box);
//			creature->sendMessage(box->generateMessage());
////just create a fkn waypoint for the player, theyre too fucking stupid to figure out what to do.
//			//chatManager2->sendMail("mySWG", "Jedi Guide", "Congratulations on unlocking Jedi on mySWG!\n\n     The command /findmytrainer will create a waypoint to your jedi skill trainer.\n\nPERMADEATH\n\n     Jedi on mySWG is permadeath. You have 3 lives, after you have died 3 times you will be PERMANENTLY DEAD. Deaths do not count until you have the rank of padawan.\n\nBOUNTY HUNTERS\n\n     Visibility is slightly more forgiving here but mostly unchanged. Using a lightsaber or any force powers within 32m of any player or humanoid NPC will raise your visibility for the Bounty Hunter terminals. NPC Bounty Hunters will start to come after you once you have enough visibility. As a new Jedi you should just RUN.\n\nJEDI KNIGHT\n\n     Jedi Knight trials will start when you have learned enough skills.", creature->getFirstName());
//
//			chatManager->broadcastGalaxy("IMPERIAL COMMUNICATION FROM THE REGIONAL GOVERNOR:\n\nLord Vader has detected a vergence in the Force.\n\n     Be on the lookout for any suspicious persons displaying unique or odd abilities. Lord Vader authorizes all citizens to use deadly force to eliminate this threat to the Empire.", "imperial");
//		}

	return true;
}

void SkillManager::removeSkillRelatedMissions(CreatureObject* creature, Skill* skill) {
	if(skill->getSkillName().hashCode() == STRING_HASHCODE("combat_bountyhunter_investigation_03")) {
		ManagedReference<ZoneServer*> zoneServer = creature->getZoneServer();
		if(zoneServer != nullptr) {
			ManagedReference<MissionManager*> missionManager = zoneServer->getMissionManager();
			if(missionManager != nullptr) {
				missionManager->failPlayerBountyMission(creature->getObjectID());
			}
		}
	}
}

bool SkillManager::surrenderSkill(const String& skillName, CreatureObject* creature, bool notifyClient, bool checkFrs) {
	Skill* skill = skillMap.get(skillName.hashCode());
//	creature->sendSystemMessage("You can not surrender skills.");
//	return false;//no skill can be surrendered

	if (skill == nullptr)
		return false;

	Locker locker(creature);

	//If they have already surrendered the skill, then return true.
	if (!creature->hasSkill(skill->getSkillName()))
		return true;

	const SkillList* skillList = creature->getSkillList();

	for (int i = 0; i < skillList->size(); ++i) {
		Skill* checkSkill = skillList->get(i);

		if (checkSkill->isRequiredSkillOf(skill))
			return false;
	}

	if (skillName.beginsWith("force_") && !(JediManager::instance()->canSurrenderSkill(creature, skillName)))
		return false;

	//this prevents learning both frs trees
	if ((skill->getSkillName() == "force_title_jedi_rank_03") && (creature->hasSkill("force_rank_light_novice") || creature->hasSkill("force_rank_dark_novice"))){
		return false;
	}

	removeSkillRelatedMissions(creature, skill);

	creature->removeSkill(skill, notifyClient);

	//Remove skill modifiers
	auto skillModifiers = skill->getSkillModifiers();

	ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

	for (int i = 0; i < skillModifiers->size(); ++i) {
		auto entry = &skillModifiers->elementAt(i);
		creature->removeSkillMod(SkillModManager::SKILLBOX, entry->getKey(), entry->getValue(), notifyClient);

	}

	if (ghost != nullptr) {
		//Give the player the used skill points back.
		ghost->addSkillPoints(skill->getSkillPointsRequired());

		//only return non jedi sp
//		if (!skill->getSkillName().contains("force_discipline")) {
//			ghost->addSkillPoints(skill->getSkillPointsRequired());
//		}


		//return xp from surender

		if (skill->getXpCost() > 0) {
			ghost->addExperience(skill->getXpType(), skill->getXpCost(), true);
		}

		//Remove abilities but only if the creature doesn't still have a skill that grants the
		//ability.  Some abilities are granted by multiple skills. For example Dazzle for dancers
		//and musicians.
		auto skillAbilities = skill->getAbilities();
		if (skillAbilities->size() > 0) {
			SortedVector<String> abilitiesLost;
			for (int i = 0; i < skillAbilities->size(); i++) {
				abilitiesLost.put(skillAbilities->get(i));
			}
			for (int i = 0; i < skillList->size(); i++) {
				Skill* remainingSkill = skillList->get(i);
				auto remainingAbilities = remainingSkill->getAbilities();
				for(int j = 0; j < remainingAbilities->size(); j++) {
					if (abilitiesLost.contains(remainingAbilities->get(j))) {
						abilitiesLost.drop(remainingAbilities->get(j));
						if (abilitiesLost.size() == 0) {
							break;
						}
					}
				}
			}
			if (abilitiesLost.size() > 0) {
				removeAbilities(ghost, abilitiesLost, notifyClient);
			}
		}

		//Remove draft schematic groups
		auto schematicsGranted = skill->getSchematicsGranted();
		SchematicMap::instance()->removeSchematics(ghost, *schematicsGranted, notifyClient);

		//Update maximum experience.
		updateXpLimits(ghost);

		FrsManager* frsManager = creature->getZoneServer()->getFrsManager();

		if (checkFrs && frsManager->isFrsEnabled()) {
			frsManager->handleSkillRevoked(creature, skillName);
		}

		/// Update Force Power Max
		ghost->recalculateForcePower();

//		const SkillList* list = creature->getSkillList();
//
//		int totalSkillPointsWasted = 250;
//
//		for (int i = 0; i < list->size(); ++i) {
//			Skill* skill = list->get(i);
//
//			totalSkillPointsWasted -= skill->getSkillPointsRequired();
//		}
//
//		if (ghost->getSkillPoints() != totalSkillPointsWasted) {
//			creature->error("skill points mismatch calculated: " + String::valueOf(totalSkillPointsWasted) + " found: " + String::valueOf(ghost->getSkillPoints()));
//			ghost->setSkillPoints(totalSkillPointsWasted);
//			SkillManager::surrenderAllSkills(creature, true, false);
//
//			ManagedReference<SuiMessageBox*> box = new SuiMessageBox(creature, SuiWindowType::NONE);
//			box->setPromptTitle("SKILLPOINT OVERLOAD");
//			box->setPromptText("Skill points now cap at 250. All of your skills have been removed, skill points reset and exp returned.");
//			ghost->addSuiBox(box);
//			creature->sendMessage(box->generateMessage());
//		}

		ManagedReference<PlayerManager*> playerManager = creature->getZoneServer()->getPlayerManager();
		if (playerManager != nullptr) {
			creature->setLevel(playerManager->calculatePlayerLevel(creature));

			//playerManager->enhanceCharacter(creature);//LEVEL BUFFS IN 3 PLACES

		}

		MissionManager* missionManager = creature->getZoneServer()->getMissionManager();

		if (skill->getSkillName() == "force_title_jedi_rank_02") {
			if (missionManager != nullptr)
				missionManager->removePlayerFromBountyList(creature->getObjectID());
		} else if (skill->getSkillName().contains("force_discipline")) {
			if (missionManager != nullptr)
				missionManager->updatePlayerBountyReward(creature->getObjectID(), ghost->calculateBhReward());
		} else if (skill->getSkillName().contains("squadleader")) {
			Reference<GroupObject*> group = creature->getGroup();

			if (group != nullptr && group->getLeader() == creature) {
				Core::getTaskManager()->executeTask([group] () {
					Locker locker(group);

					group->removeGroupModifiers();

					if (group->hasSquadLeader())
						group->addGroupModifiers();
				}, "UpdateGroupModsLambda2");
			}
		}
	}

	/// Update client with new values for things like Terrain Negotiation
	CreatureObjectDeltaMessage4* msg4 = new CreatureObjectDeltaMessage4(creature);
	msg4->updateAccelerationMultiplierBase();
	msg4->updateAccelerationMultiplierMod();
	msg4->updateSpeedMultiplierBase();
	msg4->updateSpeedMultiplierMod();
	msg4->updateRunSpeed();
	msg4->updateTerrainNegotiation();
	msg4->close();
	creature->sendMessage(msg4);

	SkillModManager::instance()->verifySkillBoxSkillMods(creature);
	JediManager::instance()->onSkillRevoked(creature, skill);

	return true;
}

void SkillManager::surrenderAllSkills(CreatureObject* creature, bool notifyClient, bool removeForceProgression) {
	ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

	const SkillList* skillList = creature->getSkillList();

	Vector<String> listOfNames;
	skillList->getStringList(listOfNames);
	SkillList copyOfList;

	copyOfList.loadFromNames(listOfNames);

	for (int i = 0; i < copyOfList.size(); i++) {
		Skill* skill = copyOfList.get(i);

		if (skill->getSkillPointsRequired() > 0) {
//			if (!removeForceProgression and skill->getSkillName().contains("force_"))
//				continue;

//		if (skill->getSkillName().contains("force_")){
//			if (!removeForceProgression and skill->getSkillName().contains("force_"))
//				continue;

//			if (!skill->getSkillName().beginsWith("combat_")){
//				continue;
//			}

//			if (!skill->getSkillName().contains("science_combatmedic")){
//				continue;
//			}

			removeSkillRelatedMissions(creature, skill);

			creature->removeSkill(skill, notifyClient);

			//Remove skill modifiers
			auto skillModifiers = skill->getSkillModifiers();

			for (int i = 0; i < skillModifiers->size(); ++i) {
				auto entry = &skillModifiers->elementAt(i);
				creature->removeSkillMod(SkillModManager::SKILLBOX, entry->getKey(), entry->getValue(), notifyClient);
			}

			if (ghost != nullptr) {
				//Give the player the used skill points back.
				ghost->addSkillPoints(skill->getSkillPointsRequired());

				int xpcost = skill->getXpCost();
				int curExp = ghost->getExperience(skill->getXpType());

				if (xpcost > 0) {
					ghost->addExperience(skill->getXpType(), curExp + xpcost, true);
				}

				//Remove abilities
				auto abilityNames = skill->getAbilities();
				removeAbilities(ghost, *abilityNames, notifyClient);

				//Remove draft schematic groups
				auto schematicsGranted = skill->getSchematicsGranted();
				SchematicMap::instance()->removeSchematics(ghost, *schematicsGranted, notifyClient);
				JediManager::instance()->onSkillRevoked(creature, skill);
			}
		}
	}

	SkillModManager::instance()->verifySkillBoxSkillMods(creature);

	if (ghost != nullptr) {
		//Update maximum experience.
		updateXpLimits(ghost);

		/// update force
		ghost->recalculateForcePower();
	}

	ManagedReference<PlayerManager*> playerManager = creature->getZoneServer()->getPlayerManager();
	if (playerManager != nullptr) {
		creature->setLevel(playerManager->calculatePlayerLevel(creature));

		//playerManager->enhanceCharacter(creature);//LEVEL BUFFS IN 3 PLACES

	}

	MissionManager* missionManager = creature->getZoneServer()->getMissionManager();
	if (missionManager != nullptr)
		missionManager->removePlayerFromBountyList(creature->getObjectID());

	Reference<GroupObject*> group = creature->getGroup();

	if (group != nullptr && group->getLeader() == creature) {
		Core::getTaskManager()->executeTask([group] () {
			Locker locker(group);

			group->removeGroupModifiers();
		}, "UpdateGroupModsLambda3");
	}
}

void SkillManager::awardDraftSchematics(Skill* skill, PlayerObject* ghost, bool notifyClient) {
	if (ghost != nullptr) {
		//Add draft schematic groups
		auto schematicsGranted = skill->getSchematicsGranted();
		SchematicMap::instance()->addSchematics(ghost, *schematicsGranted, notifyClient);

//	if (skill->getSkillName().contains("force_discipline")) {
//		return;
//	}

//	if ((ghost != nullptr)){

	}

//		SchematicMap::instance()->removeSchematics(ghost, craftSaberPoleArm2, notifyClient);
}

void SkillManager::updateXpLimits(PlayerObject* ghost) {
	return;//xp cap located in playerobjectimplementation under addexperience

	if (ghost == nullptr || !ghost->isPlayerObject()) {
		return;
	}

	VectorMap<String, int>* xpTypeCapList = ghost->getXpTypeCapList();

	//Clear all xp limits to the default limits.
	for (int i = 0; i < defaultXpLimits.size(); ++i) {
		String xpType = defaultXpLimits.elementAt(i).getKey();
		int xpLimit = defaultXpLimits.elementAt(i).getValue();

		if (xpTypeCapList->contains(xpType)) {
			xpTypeCapList->get(xpType) = xpLimit;
		} else {
			xpTypeCapList->put(xpType, xpLimit);
		}
	}

	//Iterate over the player skills and update xp limits accordingly.
	ManagedReference<CreatureObject*> player = ghost->getParentRecursively(SceneObjectType::PLAYERCREATURE).castTo<CreatureObject*>();

	if(player == nullptr)
		return;

	const SkillList* playerSkillBoxList = player->getSkillList();

	for(int i = 0; i < playerSkillBoxList->size(); ++i) {
		Skill* skillBox = playerSkillBoxList->get(i);

		if (skillBox == nullptr)
			continue;
//remove this for no xp cap
//		if (xpTypeCapList->contains(skillBox->getXpType()) && (xpTypeCapList->get(skillBox->getXpType()) < skillBox->getXpCap())) {
//			xpTypeCapList->get(skillBox->getXpType()) = skillBox->getXpCap();
//		}
	}

	//Iterate over the player xp types and cap all xp types to the limits.
	DeltaVectorMap<String, int>* experienceList = ghost->getExperienceList();

	for (int i = 0; i < experienceList->size(); ++i) {
		String xpType = experienceList->getKeyAt(i);
//remove this for no xp cap
//		if (experienceList->get(xpType) > xpTypeCapList->get(xpType)) {
//			ghost->addExperience(xpType, xpTypeCapList->get(xpType) - experienceList->get(xpType), true);
//		}
	}
}

bool SkillManager::canLearnSkill(const String& skillName, CreatureObject* creature, bool noXpRequired) {
	Skill* skill = skillMap.get(skillName.hashCode());

	if (skill == nullptr) {
		return false;
	}

	//If they already have the skill, then return false.
	if (creature->hasSkill(skillName)) {
		return false;
	}

	if (!fulfillsSkillPrerequisites(skillName, creature)) {
		return false;
	}

	//jedi can not have other combat skills
//	if (creature->hasSkill("force_title_jedi_rank_02") && !skillName.beginsWith("force_")) {// && skillName.beginsWith("combat_")) {
//		creature->sendSystemMessage("Jedi can not learn non Jedi skills.");
//		return false;
//	}

	ManagedReference<PlayerObject* > ghost = creature->getPlayerObject();
	if (ghost != nullptr) {
		//Check if player has enough xp to learn the skill.
		if (!noXpRequired) {
			if (ghost->getExperience(skill->getXpType()) < skill->getXpCost()) {
				return false;
			}
		}
//remove for inf sp
		//Check if player has enough skill points to learn the skill.
		if (ghost->getSkillPoints() < skill->getSkillPointsRequired()) {
			return false;
		}
	} else {
		//Could not retrieve player object.
		return false;
	}


	return true;
}

bool SkillManager::fulfillsSkillPrerequisitesAndXp(const String& skillName, CreatureObject* creature) {
	if (!fulfillsSkillPrerequisites(skillName, creature)) {
		return false;
	}

	Skill* skill = skillMap.get(skillName.hashCode());

	if (skill == nullptr) {
		return false;
	}

	ManagedReference<PlayerObject* > ghost = creature->getPlayerObject();
	if (ghost != nullptr) {
		//Check if player has enough xp to learn the skill.
		if (skill->getXpCost() > 0 && ghost->getExperience(skill->getXpType()) < skill->getXpCost()) {
			return false;
		}
	}

	return true;
}

bool SkillManager::fulfillsSkillPrerequisites(const String& skillName, CreatureObject* creature) {
	Skill* skill = skillMap.get(skillName.hashCode());

	if (skill == nullptr) {
		return false;
	}

	if (skillName.contains("admin_") && !(creature->getPlayerObject()->getAdminLevel() > 0)) {
		return false;
	}

	auto requiredSpecies = skill->getSpeciesRequired();
	if (requiredSpecies->size() > 0) {
		bool foundSpecies = false;
		for (int i = 0; i < requiredSpecies->size(); i++) {
			if (creature->getSpeciesName() == requiredSpecies->get(i)) {
				foundSpecies = true;
				break;
			}
		}
		if (!foundSpecies) {
			return false;
		}
	}

	//Check for required skills.
	auto requiredSkills = skill->getSkillsRequired();
	for (int i = 0; i < requiredSkills->size(); ++i) {
		const String& requiredSkillName = requiredSkills->get(i);
		Skill* requiredSkill = skillMap.get(requiredSkillName.hashCode());

		if (requiredSkill == nullptr) {
			continue;
		}

		if (!creature->hasSkill(requiredSkillName)) {
			return false;
		}
	}

	PlayerObject* ghost = creature->getPlayerObject();
	if (ghost == nullptr || ghost->getJediState() < skill->getJediStateRequired()) {
		return false;
	}

	if (ghost->isPrivileged())
		return true;

	if (skillName.beginsWith("force_")) {
		return JediManager::instance()->canLearnSkill(creature, skillName);
	}

	return true;
}

int SkillManager::getForceSensitiveSkillCount(CreatureObject* creature, bool includeNoviceMasterBoxes) {
	const SkillList* skills =  creature->getSkillList();
	int forceSensitiveSkillCount = 0;

	for (int i = 0; i < skills->size(); ++i) {
		const String& skillName = skills->get(i)->getSkillName();
		if (skillName.contains("force_sensitive") && (includeNoviceMasterBoxes || skillName.indexOf("0") != -1)) {
			forceSensitiveSkillCount++;
		}
	}

	return forceSensitiveSkillCount;
}

bool SkillManager::villageKnightPrereqsMet(CreatureObject* creature, const String& skillToDrop) {
	const SkillList* skillList = creature->getSkillList();

	int fullTrees = 0;
	int totalJediPoints = 0;

	for (int i = 0; i < skillList->size(); ++i) {
		Skill* skill = skillList->get(i);

		String skillName = skill->getSkillName();
		if (skillName.contains("force_discipline_") &&
			(skillName.indexOf("0") != -1 || skillName.contains("novice") || skillName.contains("master") )) {
			totalJediPoints += skill->getSkillPointsRequired();

			if (skillName.indexOf("4") != -1) {
				fullTrees++;
			}
		}
	}

	if (!skillToDrop.isEmpty()) {
		Skill* skillBeingDropped = skillMap.get(skillToDrop.hashCode());

		if (skillToDrop.indexOf("4") != -1) {
			fullTrees--;
		}

		totalJediPoints -= skillBeingDropped->getSkillPointsRequired();
	}

	return fullTrees >= 2 && totalJediPoints >= 206;
}

bool SkillManager::jediPrereqsMet(CreatureObject* creature, const String& skillToDrop) {
	const SkillList* skillList = creature->getSkillList();

	int fullTrees = 0;
	int totalJediPoints = 0;

	for (int i = 0; i < skillList->size(); ++i) {
		Skill* skill = skillList->get(i);

		String skillName = skill->getSkillName();
		if ((skillName.indexOf("0") != -1 || skillName.contains("novice") || skillName.contains("master") )) {
			totalJediPoints += skill->getSkillPointsRequired();

			if (skillName.indexOf("4") != -1) {
				fullTrees++;
			}
		}
	}

	if (!skillToDrop.isEmpty()) {
		Skill* skillBeingDropped = skillMap.get(skillToDrop.hashCode());

		if (skillToDrop.indexOf("4") != -1) {
			fullTrees--;
		}

		totalJediPoints -= skillBeingDropped->getSkillPointsRequired();
	}

	return totalJediPoints >= 206;
}

int SkillManager::getJediSkillCount(CreatureObject* creature, bool includeNoviceMasterBoxes) {
	const SkillList* skills =  creature->getSkillList();
	int JediSkillCount = 0;

	for (int i = 0; i < skills->size(); ++i) {
		const String& skillName = skills->get(i)->getSkillName();
		if (skillName.contains("force_discipline_") && (includeNoviceMasterBoxes || skillName.indexOf("0") != -1)) {
			JediSkillCount++;
		}
	}

	return JediSkillCount;
}
