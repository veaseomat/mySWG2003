local QuestManager = require("managers.quest.quest_manager")
local ObjectManager = require("managers.object.object_manager")
local SpawnMobiles = require("utils.spawn_mobiles")
local Logger = require("utils.logger")

SITH_SHADOW_THREATEN_STRING = "@quest/force_sensitive/intro:military_threaten"
SITH_SHADOW_MILITARY_TAKE_CRYSTAL = "@quest/force_sensitive/intro:military_take_crystal"
local READ_DISK_1_STRING = "@quest/force_sensitive/intro:read_disk1"
local READ_DISK_ERROR_STRING = "@quest/force_sensitive/intro:read_disk_error"

SithShadowEncounter = Encounter:new {
	-- Task properties
	taskName = "SithShadowEncounter",
	-- Encounter properties
	encounterDespawnTime = 1 * 30 * 1000, -- 10 sec
	spawnObjectList = {
		{ template = "boba_fett2", minimumDistance = 64, maximumDistance = 96, referencePoint = 0, followPlayer = true, setNotAttackable = false, runOnDespawn = true },
	},
	onEncounterSpawned = nil,
	isEncounterFinished = nil,
	onEncounterInRange = nil,
	inRangeValue = 32,
}

-- Check if the sith shadow is the first one spawned for the player.
-- @param pSithShadow pointer to the sith shadow.
-- @param pPlayer pointer to the creature object of the player.
-- @return true if the sith shadow is the first one spawned for the player.
function SithShadowEncounter:isTheFirstSithShadowOfThePlayer(pSithShadow, pPlayer)
	local spawnedSithShadows = SpawnMobiles.getSpawnedMobiles(pPlayer, self.taskName)

	return spawnedSithShadows ~= nil and spawnedSithShadows[1] ~= nil and CreatureObject(spawnedSithShadows[1]):getObjectID() == CreatureObject(pSithShadow):getObjectID()
end

-- Event handler for the LOOTCREATURE event on one of the sith shadows.
-- @param pLootedCreature pointer to the sith shadow creature that is being looted.
-- @param pLooter pointer to the creature object of the looter.
-- @param nothing unused variable for the default footprint of event handlers.
-- @return 1 if the correct player looted the creature to remove the observer, 0 otherwise to keep the observer.
function SithShadowEncounter:onLoot(pLootedCreature, pLooter, nothing)
	if (pLootedCreature == nil or pLooter == nil) then
	
		return 0
	end

	Logger:log("Looting the sith shadow.", LT_INFO)
	
	CreatureObject(pLooter):awardExperience("jedi_general", 50000, true)		
		
	if CreatureObject(pLooter):hasSkill("force_rank_light_novice") or CreatureObject(pLooter):hasSkill("force_rank_dark_novice") then	
		CreatureObject(pLooter):awardExperience("force_rank_xp", 500, true)	
	end	
--	if QuestManager.hasActiveQuest(pLooter, QuestManager.quests.TWO_MILITARY) then
--		if self:isTheFirstSithShadowOfThePlayer(pLootedCreature, pLooter) then
--
--			return 1
--		end
--	end

	return 0
end

-- Handle the event PLAYERKILLED.
-- @param pPlayer pointer to the creature object of the killed player.
-- @param pKiller pointer to the creature object of the killer.
-- @param noting unused variable for the default footprint of event handlers.
-- @return 1 if the player was killed by one of the sith shadows, otherwise 0 to keep the observer.
function SithShadowEncounter:onPlayerKilled(pPlayer, pKiller, nothing)
	if (pPlayer == nil or pKiller == nil) then
		return 0
	end
	
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	Logger:log("Player was killed.", LT_INFO)
	if SpawnMobiles.isFromSpawn(pPlayer, SithShadowEncounter.taskName, pKiller) then
--		spatialChat(pKiller, "Pathetic...")
		--i use this to track if player won or not
--		QuestManager.completeQuest(pPlayer, QuestManager.quests.TWO_MILITARY)
		PlayerObject(pGhost):setVisibility(1)
		return 0
	end

	return 0
end

-- Handling of the encounter spawned event.
-- Register observer for looting one of the sith shadows.
-- @param pPlayer pointer to the creature object of the player who has this encounter.
-- @param spawnedObject list of pointers to the spawned sith shadows.
function SithShadowEncounter:onEncounterSpawned(pPlayer, spawnedObjects)
	if (pPlayer == nil or spawnedObjects == nil or spawnedObjects[1] == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	local pInventory = SceneObject(spawnedObjects[1]):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("You sense a disturbance in the force...")

	SceneObject(pInventory):setContainerOwnerID(playerID)


--	createObserver(LOOTCREATURE, self.taskName, "onLoot", spawnedObjects[1])
	createObserver(OBJECTDESTRUCTION, self.taskName, "onPlayerKilled", pPlayer)
	createObserver(OBJECTDESTRUCTION, self.taskName, "onLoot", spawnedObjects[1])
	
--	QuestManager.activateQuest(pPlayer, QuestManager.quests.TWO_MILITARY)

end

-- Handling of the encounter in range event.
-- Send a spatial chat from the first sith shadow.
-- @param pPlayer pointer to the creature object of the player who has this encounter.
-- @param spawnedObjects list of pointers to the spawned sith shadows.
function SithShadowEncounter:onEncounterInRange(pPlayer, spawnedObjects)
	if (pPlayer == nil or spawnedObjects == nil or spawnedObjects[1] == nil) then
		return
	end

	Logger:log("Sending threaten string.", LT_INFO)
	local threatenString = LuaStringIdChatParameter(SITH_SHADOW_THREATEN_STRING)
	threatenString:setTT(CreatureObject(pPlayer):getFirstName())
	spatialChat(spawnedObjects[1], "Fight me Jedi!")


	foreach(spawnedObjects, function(pMobile)
		if (pMobile ~= nil) then
			AiAgent(pMobile):setDefender(pPlayer)
			
			--AiAgent(pMobile):setFollowObject(pPlayer) --nottested yet
			
			CreatureObject(pMobile):engageCombat(pPlayer)
			--setSpawnedObjectsToFollow(pMobile, pPlayer)
		--AiAgent(spawnedObjects):setAiTemplate("follow")
		--AiAgent(spawnedObjects):setFollowState(3)--not tested
		end
	end)
end

-- Check if the sith shadow encounter is finished or not.
-- @param pPlayer pointer to the creature object of the player.
-- @return true if the encounter is finished. I.e. the player has access to the village or lost the crystal.
function SithShadowEncounter:isEncounterFinished(pPlayer)
	if (pPlayer == nil) then
		return false
	end

end

-- Handling of the activation of the looted datapad.
-- @param pSceneObject pointer to the datapad object.
-- @param pPlayer pointer to the creature object who activated the datapad.
function SithShadowEncounter:useWaypointDatapad(pSceneObject, pPlayer)
	

end

function SithShadowEncounter:taskFinish(pPlayer)
	if (pPlayer == nil) then
		return true
	end
		FsIntro:startStepDelay(pPlayer, 3)
	return true
end

return SithShadowEncounter
