local ObjectManager = require("managers.object.object_manager")
local QuestManager = require("managers.quest.quest_manager")

UnlockIntro = ScreenPlay:new {
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

function UnlockIntro:getCurrentStep(pPlayer)
	local curStep = readScreenPlayData(pPlayer, "VillageJediProgression", "UnlockIntroStep")

	if (curStep == "") then
		curStep = 1
		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
	end

	return tonumber(curStep)
end

function UnlockIntro:setCurrentStep(pPlayer, step)
	writeScreenPlayData(pPlayer, "VillageJediProgression", "UnlockIntroStep", step)
end

function UnlockIntro:isOnIntro(pPlayer)
	return VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING) and not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)
end

function UnlockIntro:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "VillageJediProgression", "UnlockIntroDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function UnlockIntro:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("UnlockIntro:startStepDelay, invalid step data.")
		return
	end

	self:setCurrentStep(pPlayer, step)
	local stepDelay = getRandomNumber(1, 12) * 60 * 60 * 1000 --hr/min/sec

	
--		stepDelay = (getRandomNumber(15, 480) * 60 * 1000) --2min - 720=12hr


	writeScreenPlayData(pPlayer, "VillageJediProgression", "UnlockIntroDelay", stepDelay + os.time())
	createEvent(stepDelay, "UnlockIntro", "doDelayedStep", pPlayer, "")
end

function UnlockIntro:doDelayedStep(pPlayer)
--	if (pPlayer == nil) then
--		return
--	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

--	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
--		return
--	end
	
--delay for dead incap or not in good area
--	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
--		createEvent(getRandomNumber(15, 240) * 60 * 1000, "UnlockIntro", "doDelayedStep", pPlayer, "")
--		return
--	end
	
	local unlockluck = readScreenPlayData(pPlayer, "forcesensitivity", "unlock")
	local learnedBranches = VillageJediManagerCommon.getLearnedForceSensitiveBranches(pPlayer)
		
	if unlockluck >= 20 then--if getRandomNumber(1, 7199) + unlockluck >= 7200 then--1 week to 10 weeks 1680.  7200 =30day-10mo
	
		if not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice") then
			PlayerObject(pGhost):setJediState(2)
					
			awardSkill(pPlayer, "force_title_jedi_novice")
			PadawanTrials:doPadawanTrialsSetup(pPlayer)
			
--			PadawanTrials:startPadawanTrials(pPlayer, pPlayer)
		
--			writeScreenPlayData(pPlayer, "PadawanTrials", "startedTrials", 1)		
			
			CreatureObject(pPlayer):playEffect("clienteffect/trap_electric_01.cef", "")
			CreatureObject(pPlayer):playMusicMessage("sound/music_become_jedi.snd")

			PVPBHIntro:startStepDelay(pPlayer, 3)
		end
	
	end
	
	local stepDelay = getRandomNumber(1, 12) * 60 * 60 * 1000
		
	createEvent(stepDelay, "UnlockIntro", "doDelayedStep", pPlayer, "")

end

function UnlockIntro:startPlayerOnIntro(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	self:startStepDelay(pPlayer, 1)
end

function UnlockIntro:onLoggedIn(pPlayer)
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
			createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startOldMan", pPlayer, "")
		end

		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
		return
	end

	if (curStep == self.OLDMANWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startOldMan", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.OLDMANMEET) then
		QuestManager.resetQuest(pPlayer, QuestManager.quests.OLD_MAN_INITIAL)
		createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startOldMan", pPlayer, "")
	elseif (curStep == self.SITHWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startSithAttack", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.SITHATTACK) then
		createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startSithAttack", pPlayer, "")
	elseif (curStep == self.USEDATAPADONE) then
		if (not self:hasFirstDatapad(pPlayer)) then
			QuestManager.resetQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_1)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD)
			self:setCurrentStep(pPlayer, curStep - 1)
			createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startSithAttack", pPlayer, "")
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

function UnlockIntro:onLoggedOut(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	if (curStep == self.SITHTHEATER) then
		SithShadowIntroTheater:finish(pPlayer)
	end
end

function UnlockIntro:hasFirstDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/waypoint_datapad.iff", true) ~= nil
end

function UnlockIntro:hasSecondDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/theater_datapad.iff", true) ~= nil
end

function UnlockIntro:removeFirstDatapad(pPlayer)
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

function UnlockIntro:removeSecondDatapad(pPlayer)
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

function UnlockIntro:startOldMan(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = OldManIntroEncounter:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startOldMan", pPlayer, "")
		return
	end
end

function UnlockIntro:startSithAttack(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = sithshadowencounter2:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "UnlockIntro", "startSithAttack", pPlayer, "")
		return
	end
end

function UnlockIntro:completeVillageIntroFrog(pPlayer)
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
