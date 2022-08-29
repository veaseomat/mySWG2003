local ObjectManager = require("managers.object.object_manager")
local QuestManager = require("managers.quest.quest_manager")

PVPFRSIntro = ScreenPlay:new {
	OLDMANWAIT = 1,
	OLDMANMEET = 2,
	SITHWAIT = 3,
	SITHATTACK = 4,
	USEDATAPADONE = 5,
	SITHTHEATER = 6,
	USEDATAPADTWO = 7,
	VILLAGE = 8,

	stepDelay = {
		[1] = { 1, 2 }, -- Old man visit, 12-36 hours
		[3] = { 1, 2 } -- Sith shadow attack, 1 hour to 12 hours
	}
}

function PVPFRSIntro:getCurrentStep(pPlayer)
	local curStep = readScreenPlayData(pPlayer, "VillageJediProgression", "PVPFRSIntroStep")

	if (curStep == "") then
		curStep = 1
		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
	end

	return tonumber(curStep)
end

function PVPFRSIntro:setCurrentStep(pPlayer, step)
	writeScreenPlayData(pPlayer, "VillageJediProgression", "PVPFRSIntroStep", step)
end

function PVPFRSIntro:isOnIntro(pPlayer)
	return VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING) and not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)
end

function PVPFRSIntro:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "VillageJediProgression", "PVPFRSIntroDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function PVPFRSIntro:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("PVPFRSIntro:startStepDelay, invalid step data.")
		return
	end

	self:setCurrentStep(pPlayer, step)
	local stepDelay = 60000

--	if QuestManager.hasActiveQuest(pPlayer, QuestManager.quests.TWO_MILITARY) then
--	--player beat boba /this quest was being used to track if player won
--		QuestManager.completeQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
--		--this would trip boba again
--		--stepDelay = (getRandomNumber(30, 180) * 60 * 1000) --30min - 3hr
--		return
--	else
	--player lost bh or first time
		stepDelay = (getRandomNumber(15, 480) * 60 * 1000) --2min - 720=12hr
--	end

	writeScreenPlayData(pPlayer, "VillageJediProgression", "PVPFRSIntroDelay", stepDelay + os.time())
	createEvent(stepDelay, "PVPFRSIntro", "doDelayedStep", pPlayer, "")
end

function PVPFRSIntro:doDelayedStep(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end
	
--delay for dead incap or not in good area
	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
		createEvent(getRandomNumber(15, 240) * 60 * 1000, "PVPFRSIntro", "doDelayedStep", pPlayer, "")
		return
	end
	
	
	if CreatureObject(pPlayer):hasSkill("force_rank_light_novice") then
		encounterResult = PVPLJKEncounter:start(pPlayer)	
		return

	else if CreatureObject(pPlayer):hasSkill("force_rank_dark_novice") then
		encounterResult = PVPDJKEncounter:start(pPlayer)	
		return
		

	else
	--chek overt again after
	--	createEvent(getRandomNumber(1, 1) * 1 * 1000, "PVPFRSIntro", "doDelayedStep", pPlayer, "")
		return
	end
		
	end
--this is the visibility threshold, vanilla is 1500
--	if PlayerObject(pGhost):getVisibility() >= 4000 then
--		encounterResult = SithShadowEncounter2:start(pPlayer)
--	else
--	--delay visibility check
--		createEvent(getRandomNumber(20, 720) * 60 * 1000, "PVPFRSIntro", "doDelayedStep", pPlayer, "")
--		return
--	end

end

function PVPFRSIntro:startPlayerOnIntro(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	self:startStepDelay(pPlayer, 1)
end

function PVPFRSIntro:onLoggedIn(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	-- Extra check in case the player's current step gets messed up
	if ((curStep == self.OLDMANWAIT or curStep == self.OLDMANMEET) and OldManIntroEncounter:hasForceCrystal(pPlayer)) then
		self:setCurrentStep(pPlayer, self.SITHWAIT)
		curStep = self.SITHWAIT
	end

	if (curStep ~= self.OLDMANWAIT and curStep ~= self.OLDMANMEET and not OldManIntroEncounter:hasForceCrystal(pPlayer) and not QuestManager.hasActiveQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)) then
		if (SithShadowIntroTheater:hasTaskStarted(pPlayer)) then
			SithShadowIntroTheater:finish(pPlayer)
		end

		QuestManager.resetQuest(pPlayer, QuestManager.quests.OLD_MAN_INITIAL)
		QuestManager.resetQuest(pPlayer, QuestManager.quests.OLD_MAN_FORCE_CRYSTAL)

		if (self:hasFirstDatapad(pPlayer)) then
			QuestManager.resetQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_1)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD)
			self:removeFirstDatapad(pPlayer)
		end

		if (self:hasSecondDatapad(pPlayer)) then
			QuestManager.resetQuest(pPlayer, QuestManager.quests.FS_THEATER_CAMP)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_2)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD_2)
			self:removeSecondDatapad(pPlayer)
		end

		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startOldMan", pPlayer, "")
		end

		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
		return
	end

	if (curStep == self.OLDMANWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startOldMan", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.OLDMANMEET) then
		QuestManager.resetQuest(pPlayer, QuestManager.quests.OLD_MAN_INITIAL)
		createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startOldMan", pPlayer, "")
	elseif (curStep == self.SITHWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startSithAttack", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.SITHATTACK) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startSithAttack", pPlayer, "")
	elseif (curStep == self.USEDATAPADONE) then
		if (not self:hasFirstDatapad(pPlayer)) then
			QuestManager.resetQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_1)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD)
			self:setCurrentStep(pPlayer, curStep - 1)
			createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startSithAttack", pPlayer, "")
		end
	elseif (curStep == self.SITHTHEATER) then
		if (SithShadowIntroTheater:hasTaskStarted(pPlayer)) then
			SithShadowIntroTheater:finish(pPlayer)
		end

		QuestManager.resetQuest(pPlayer, QuestManager.quests.FS_THEATER_CAMP)
		QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_2)
		QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD_2)
		SithShadowIntroTheater:start(pPlayer)
	elseif (curStep == self.USEDATAPADTWO) then
		if (not self:hasSecondDatapad(pPlayer)) then
			if (SithShadowIntroTheater:hasTaskStarted(pPlayer)) then
				SithShadowIntroTheater:finish(pPlayer)
			end

			QuestManager.resetQuest(pPlayer, QuestManager.quests.FS_THEATER_CAMP)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_2)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD_2)
			self:setCurrentStep(pPlayer, curStep - 1)
			SithShadowIntroTheater:start(pPlayer)
		end
	elseif (curStep == self.VILLAGE and not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)) then
		GoToDathomir:finish(pPlayer)
		GoToDathomir:start(pPlayer)
	end
end

function PVPFRSIntro:onLoggedOut(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	if (curStep == self.SITHTHEATER) then
		SithShadowIntroTheater:finish(pPlayer)
	end
end

function PVPFRSIntro:hasFirstDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/waypoint_datapad.iff", true) ~= nil
end

function PVPFRSIntro:hasSecondDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/theater_datapad.iff", true) ~= nil
end

function PVPFRSIntro:removeFirstDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local pDatapad = getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/waypoint_datapad.iff", true)

	if (pDatapad ~= nil) then
		SceneObject(pDatapad):destroyObjectFromWorld()
		SceneObject(pDatapad):destroyObjectFromDatabase()
	end
end

function PVPFRSIntro:removeSecondDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local pDatapad = getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/theater_datapad.iff", true)

	if (pDatapad ~= nil) then
		SceneObject(pDatapad):destroyObjectFromWorld()
		SceneObject(pDatapad):destroyObjectFromDatabase()
	end
end

function PVPFRSIntro:startOldMan(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = OldManIntroEncounter:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startOldMan", pPlayer, "")
		return
	end
end

function PVPFRSIntro:startSithAttack(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = sithshadowencounter2:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPFRSIntro", "startSithAttack", pPlayer, "")
		return
	end
end

function PVPFRSIntro:completeVillageIntroFrog(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING)

	QuestManager.completeQuest(pPlayer, QuestManager.quests.OLD_MAN_INITIAL)

	giveItem(pInventory, "object/tangible/loot/quest/force_sensitive/force_crystal.iff", -1)

	QuestManager.completeQuest(pPlayer, QuestManager.quests.OLD_MAN_FORCE_CRYSTAL)

	VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_HAS_CRYSTAL)

	QuestManager.completeQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
	QuestManager.completeQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_1)
	QuestManager.completeQuest(pPlayer, QuestManager.quests.GOT_DATAPAD)
	QuestManager.completeQuest(pPlayer, QuestManager.quests.FS_THEATER_CAMP)
	QuestManager.completeQuest(pPlayer, QuestManager.quests.GOT_DATAPAD_2)
	QuestManager.completeQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_2)

	QuestManager.completeQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)

	VillageJediManagerCommon.setJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_HAS_VILLAGE_ACCESS)

	if (not PlayerObject(pGhost):isJedi()) then
		PlayerObject(pGhost):setJediState(1)
	end

	awardSkill(pPlayer, "force_title_jedi_novice")
end
