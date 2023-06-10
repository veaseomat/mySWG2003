local ObjectManager = require("managers.object.object_manager")
local QuestManager = require("managers.quest.quest_manager")

PVPBHIntro = ScreenPlay:new {
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

function PVPBHIntro:getCurrentStep(pPlayer)
	local curStep = readScreenPlayData(pPlayer, "VillageJediProgression", "PVPBHIntroStep")

	if (curStep == "") then
		curStep = 1
		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
	end

	return tonumber(curStep)
end

function PVPBHIntro:setCurrentStep(pPlayer, step)
	writeScreenPlayData(pPlayer, "VillageJediProgression", "PVPBHIntroStep", step)
end

function PVPBHIntro:isOnIntro(pPlayer)
	return VillageJediManagerCommon.hasJediProgressionScreenPlayState(pPlayer, VILLAGE_JEDI_PROGRESSION_GLOWING) and not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests.FS_VILLAGE_ELDER)
end

function PVPBHIntro:hasDelayPassed(pPlayer)
	local stepDelay = tonumber(readScreenPlayData(pPlayer, "VillageJediProgression", "PVPBHIntroDelay"))

	if (stepDelay == nil or stepDelay == 0) then
		return true
	end

	return os.time() >= stepDelay
end

function PVPBHIntro:startStepDelay(pPlayer, step)
	local stepData = self.stepDelay[step]

	if (stepData == nil) then
		printLuaError("PVPBHIntro:startStepDelay, invalid step data.")
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
		stepDelay = (getRandomNumber(15, 45) * 60 * 1000) --mins 15, 240
--	end

	writeScreenPlayData(pPlayer, "VillageJediProgression", "PVPBHIntroDelay", stepDelay + os.time())
	createEvent(stepDelay, "PVPBHIntro", "doDelayedStep", pPlayer, "")
end

function PVPBHIntro:doDelayedStep(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end
	
	--encounter is for equipped saber or tef	
--	if (Encounter:isPlayerInNpcCity(pPlayer) and CreatureObject(pPlayer):isAttackableBy(pGhost)) then--CreatureObject(pPlayer):isjediovert()) then --(CreatureObject(pPlayer):getPvpStatusBitmask() == 8 or CreatureObject(pPlayer):isAttackableBy() == true)
--		encounterResult = PVPBHEncounter:start(pPlayer)
--		--createEvent(getRandomNumber(15, 120) * 60 * 1000, "PVPBHIntro", "doDelayedStep", pPlayer, "")
--		--return
--	end
	
	--delay for dead incap or not in good area
	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated() or not Encounter:isPlayerInPositionForEncounter(pPlayer)) then
		createEvent(getRandomNumber(15, 45) * 60 * 1000, "PVPBHIntro", "doDelayedStep", pPlayer, "")
		return
	end
	
	--this is the visibility threshold, vanilla is 1500
	if PlayerObject(pGhost):getVisibility() >= 3000 then--OR if lightsaber is equipped?
		encounterResult = PVPBHEncounter:start(pPlayer)
		return
	else
		createEvent(getRandomNumber(15, 45) * 60 * 1000, "PVPBHIntro", "doDelayedStep", pPlayer, "") -- 15, 60
		return
	end

end

function PVPBHIntro:startPlayerOnIntro(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	self:startStepDelay(pPlayer, 1)
end

function PVPBHIntro:onLoggedIn(pPlayer)
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
			createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startOldMan", pPlayer, "")
		end

		self:setCurrentStep(pPlayer, self.OLDMANWAIT)
		return
	end

	if (curStep == self.OLDMANWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startOldMan", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.OLDMANMEET) then
		QuestManager.resetQuest(pPlayer, QuestManager.quests.OLD_MAN_INITIAL)
		createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startOldMan", pPlayer, "")
	elseif (curStep == self.SITHWAIT) then
		if (self:hasDelayPassed(pPlayer)) then
			createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startSithAttack", pPlayer, "")
			self:setCurrentStep(pPlayer, curStep + 1)
		end
	elseif (curStep == self.SITHATTACK) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startSithAttack", pPlayer, "")
	elseif (curStep == self.USEDATAPADONE) then
		if (not self:hasFirstDatapad(pPlayer)) then
			QuestManager.resetQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.LOOT_DATAPAD_1)
			QuestManager.resetQuest(pPlayer, QuestManager.quests.GOT_DATAPAD)
			self:setCurrentStep(pPlayer, curStep - 1)
			createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startSithAttack", pPlayer, "")
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

function PVPBHIntro:onLoggedOut(pPlayer)
	if (not self:isOnIntro(pPlayer)) then
		return
	end

	local curStep = self:getCurrentStep(pPlayer)

	if (curStep == self.SITHTHEATER) then
		SithShadowIntroTheater:finish(pPlayer)
	end
end

function PVPBHIntro:hasFirstDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/waypoint_datapad.iff", true) ~= nil
end

function PVPBHIntro:hasSecondDatapad(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	return getContainerObjectByTemplate(pInventory, "object/tangible/loot/quest/force_sensitive/theater_datapad.iff", true) ~= nil
end

function PVPBHIntro:removeFirstDatapad(pPlayer)
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

function PVPBHIntro:removeSecondDatapad(pPlayer)
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

function PVPBHIntro:startOldMan(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = OldManIntroEncounter:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startOldMan", pPlayer, "")
		return
	end
end

function PVPBHIntro:startSithAttack(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline()) then
		return
	end

	local result = SithShadowEncounter:start(pPlayer)

	if (not result) then
		createEvent(getRandomNumber(1, 2) * 1000, "PVPBHIntro", "startSithAttack", pPlayer, "")
		return
	end
end

function PVPBHIntro:completeVillageIntroFrog(pPlayer)
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
