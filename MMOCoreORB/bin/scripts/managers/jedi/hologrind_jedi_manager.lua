JediManager = require("managers.jedi.jedi_manager")
local ObjectManager = require("managers.object.object_manager")
local PlayerManager = require("managers.player_manager")

jediManagerName = "HologrindJediManager"

NUMBEROFPROFESSIONSTOMASTER = 5 --vanilla 6
MAXIMUMNUMBEROFPROFESSIONSTOSHOWWITHHOLOCRON = 2

HologrindJediManager = JediManager:new {
	screenplayName = jediManagerName,
	jediManagerName = jediManagerName,
	jediProgressionType = HOLOGRINDJEDIPROGRESSION,
	startingEvent = nil,
}

-- Return a list of all professions and their badge number that are available for the hologrind
-- @return a list of professions and their badge numbers.
function HologrindJediManager:getGrindableProfessionList()
	local grindableProfessions = {
		-- String Id, badge number, profession name
		{ "crafting_architect_master", 		CRAFTING_ARCHITECT_MASTER  },
		{ "crafting_armorsmith_master", 	CRAFTING_ARMORSMITH_MASTER  },
		{ "crafting_artisan_master", 		CRAFTING_ARTISAN_MASTER  },
		--{ "outdoors_bio_engineer_master", 	OUTDOORS_BIO_ENGINEER_MASTER  },
		{ "combat_bountyhunter_master", 	COMBAT_BOUNTYHUNTER_MASTER  },
		{ "combat_brawler_master", 		COMBAT_BRAWLER_MASTER  },
		{ "combat_carbine_master", 		COMBAT_CARBINE_MASTER  },
		{ "crafting_chef_master", 		CRAFTING_CHEF_MASTER  },
		--{ "science_combatmedic_master", 	SCIENCE_COMBATMEDIC_MASTER  },
		{ "combat_commando_master", 		COMBAT_COMMANDO_MASTER  },
		--{ "outdoors_creaturehandler_master", 	OUTDOORS_CREATUREHANDLER_MASTER  },
		{ "social_dancer_master", 		SOCIAL_DANCER_MASTER  },
		{ "science_doctor_master", 		SCIENCE_DOCTOR_MASTER  },
		{ "crafting_droidengineer_master", 	CRAFTING_DROIDENGINEER_MASTER  },
		{ "social_entertainer_master", 		SOCIAL_ENTERTAINER_MASTER  },
		{ "combat_1hsword_master", 		COMBAT_1HSWORD_MASTER  },
		{ "social_imagedesigner_master", 	SOCIAL_IMAGEDESIGNER_MASTER  },
		{ "combat_marksman_master", 		COMBAT_MARKSMAN_MASTER  },
		{ "science_medic_master", 		SCIENCE_MEDIC_MASTER  },
		{ "social_musician_master", 		SOCIAL_MUSICIAN_MASTER  },
		{ "combat_polearm_master", 		COMBAT_POLEARM_MASTER  },
		{ "combat_pistol_master", 		COMBAT_PISTOL_MASTER  },
		{ "outdoors_ranger_master", 		OUTDOORS_RANGER_MASTER  },
		{ "combat_rifleman_master", 		COMBAT_RIFLEMAN_MASTER  },
		{ "outdoors_scout_master", 		OUTDOORS_SCOUT_MASTER  },
		{ "combat_smuggler_master", 		COMBAT_SMUGGLER_MASTER  },
		--{ "outdoors_squadleader_master", 	OUTDOORS_SQUADLEADER_MASTER  },
		{ "combat_2hsword_master", 		COMBAT_2HSWORD_MASTER  },
		{ "crafting_tailor_master", 		CRAFTING_TAILOR_MASTER  },
		{ "crafting_weaponsmith_master", 	CRAFTING_WEAPONSMITH_MASTER  },
		{ "combat_unarmed_master", 		COMBAT_UNARMED_MASTER  },
	}
	return grindableProfessions
end

-- Handling of the onPlayerCreated event.
-- Hologrind professions will be generated for the player.
-- @param pCreatureObject pointer to the creature object of the created player.
function HologrindJediManager:onPlayerCreated(pCreatureObject)
--		local unlockluck = getRandomNumber(1, 10)
--		
--		writeScreenPlayData(pCreatureObject, "forcesensitivity", "unlock", unlockluck)

--		local canunlock = getRandomNumber(1, 9)
--		
--		if canunlock >= 7 then
--		writeScreenPlayData(pCreatureObject, "forcesensitivecharacter", "canunlock", 1)
--		end

	local skillList = self:getGrindableProfessionList()

	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	for i = 1, NUMBEROFPROFESSIONSTOMASTER, 1 do
		local numberOfSkillsInList = #skillList
		local skillNumber = getRandomNumber(1, numberOfSkillsInList)
		PlayerObject(pGhost):addHologrindProfession(skillList[skillNumber][2])
		table.remove(skillList, skillNumber)
	end
end

-- Check and count the number of mastered hologrind professions.
-- @param pCreatureObject pointer to the creature object of the player which should get its number of mastered professions counted.
-- @return the number of mastered hologrind professions.
function HologrindJediManager:getNumberOfMasteredProfessions(pCreatureObject)
	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

	if (pGhost == nil) then
		return 0
	end

	local professions = PlayerObject(pGhost):getHologrindProfessions()
	local masteredNumberOfProfessions = 0 --increasing this number is now how many of the selected professions you dont need to do
	for i = 1, #professions, 1 do
		if PlayerObject(pGhost):hasBadge(professions[i]) then
			masteredNumberOfProfessions = masteredNumberOfProfessions + 1
		end
	end
	return masteredNumberOfProfessions
end

-- Check if the player is jedi.
-- @param pCreatureObject pointer to the creature object of the player to check if he is jedi.
-- @return returns if the player is jedi or not.
function HologrindJediManager:isJedi(pCreatureObject)
	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):isJedi()
end

-- Sui window ok pressed callback function.
function HologrindJediManager:notifyOkPressed()
-- Do nothing.
end

-- Send a sui window to the player about unlocking jedi and award jedi status and force sensitive skill.
-- @param pCreatureObject pointer to the creature object of the player who unlocked jedi.
function HologrindJediManager:sendSuiWindow(pCreatureObject)
	local suiManager = LuaSuiManager()
	suiManager:sendMessageBox(pCreatureObject, pCreatureObject, "@quest/force_sensitive/intro:force_sensitive", "You begin to feel attuned with the power of the Force. Congratulations! This character is now a Jedi. First, you need to find a lightsaber color crystal and craft a lightsaber. You also have to find your Jedi trainer, it could be any stating profession trainer on any planet, converse with them to find yours. Using your Jedi abilities near NPCs or players will gain you visibility for player and NPC bounty hunters. May the force be with you...", "@ok", "HologrindJediManager", "notifyOkPressed")
end

-- Award skill and jedi status to the player.
-- @param pCreatureObject pointer to the creature object of the player who unlocked jedi.
function HologrindJediManager:awardJediStatusAndSkill(pCreatureObject)
	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

	if (pGhost == nil) then
		return
	end
	
			PlayerObject(pGhost):setJediState(2)
					
			awardSkill(pCreatureObject, "force_title_jedi_rank_02")
			
			--PadawanTrials:doPadawanTrialsSetup(pCreatureObject)
			
			CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
			CreatureObject(pCreatureObject):playMusicMessage("sound/music_become_jedi.snd")

			PVPBHIntro:startStepDelay(pCreatureObject, 3)
			
	
--	CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
--	
--	CreatureObject(pCreatureObject):playMusicMessage("sound/music_become_jedi.snd")
--	
--	PlayerObject(pGhost):setJediState(2)
--	
--	awardSkill(pCreatureObject, "force_title_jedi_rank_02")
--	
--	FsIntro:startStepDelay(pCreatureObject, 3)
--	
--	local pInventory = SceneObject(pCreatureObject):getSlottedObject("inventory")
--
--	if (pInventory == nil) then
--		return
--	end
--
--	giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_padawan.iff", -1)
	
end

-- Check if the player has mastered all hologrind professions and send sui window and award skills.
-- @param pCreatureObject pointer to the creature object of the player to check the jedi progression on.
function HologrindJediManager:checkIfProgressedToJedi(pCreatureObject)
	if self:getNumberOfMasteredProfessions(pCreatureObject) >= 5 and not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_02") then
		--self:sendSuiWindow(pCreatureObject)
		self:awardJediStatusAndSkill(pCreatureObject)
		return
	end
	
--	if self:getNumberOfMasteredProfessions(pCreatureObject) >= 1 and not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_02") then
--		local pGhost = CreatureObject(pCreatureObject):getPlayerObject()
--
--		if (pGhost == nil) then
--			return
--		end
--
--		local professions = PlayerObject(pGhost):getHologrindProfessions()
--		for i = 1, #professions, 1 do
--			if not PlayerObject(pGhost):hasBadge(professions[i]) then
--				local professionText = self:getProfessionStringIdFromBadgeNumber(professions[i])
--				CreatureObject(pCreatureObject):sendSystemMessageWithTO("@jedi_spam:holocron_light_information", "@skl_n:" .. professionText)
--				break
--			end
--		end
--
--	end
	
end

-- Event handler for the BADGEAWARDED event.
-- @param pCreatureObject pointer to the creature object of the player who was awarded with a badge.
-- @param pCreatureObject2 pointer to the creature object of the player who was awarded with a badge.
-- @param badgeNumber the badge number that was awarded.
-- @return 0 to keep the observer active.
function HologrindJediManager:badgeAwardedEventHandler(pCreatureObject, pCreatureObject2, badgeNumber)
	if (pCreatureObject == nil) then
		return 0
	end
		
--	if getRandomNumber(1, 28) >= 28 then
--				self:awardFSpoint(pCreatureObject)
--	end

	self:checkIfProgressedToJedi(pCreatureObject)

	return 0
end

-- Register observer on the player for observing badge awards.
-- @param pCreatureObject pointer to the creature object of the player to register observers on.
function HologrindJediManager:registerObservers(pCreatureObject)
	createObserver(BADGEAWARDED, "HologrindJediManager", "badgeAwardedEventHandler", pCreatureObject)
end

-- Handling of the onPlayerLoggedIn event. The progression of the player will be checked and observers will be registered.
-- @param pCreatureObject pointer to the creature object of the player who logged in.
function HologrindJediManager:onPlayerLoggedIn(pCreatureObject)
	if (pCreatureObject == nil) then
		return
	end
	
	--CreatureObject(pCreatureObject):enhanceCharacter()
	
	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

	if (pGhost == nil) then
		return
	end

--	local professions = PlayerObject(pGhost):getHologrindProfessions()
--	
--	if #professions < 4 then
--		local skillList = self:getGrindableProfessionList()
--
--		for i = 1, NUMBEROFPROFESSIONSTOMASTER, 1 do
--			local numberOfSkillsInList = #skillList
--			local skillNumber = getRandomNumber(1, numberOfSkillsInList)
--			PlayerObject(pGhost):addHologrindProfession(skillList[skillNumber][2])
--			table.remove(skillList, skillNumber)
--		end
--	end
	
--	self:checkIfProgressedToJedi(pCreatureObject)
	self:registerObservers(pCreatureObject)
	
	PVPFactionIntro:startStepDelay(pCreatureObject, 3)--faction encoutners
	
--	if not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_01") then	
--		UnlockIntro:startStepDelay(pCreatureObject, 3)
--		self:registerObservers(pCreatureObject)
--	end

	if CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_02") then	
		PVPBHIntro:startStepDelay(pCreatureObject, 3)
		
		if tonumber(readScreenPlayData(pCreatureObject, "PadawanTrials", "completedTrials")) ~= 1 then
			writeScreenPlayData(pCreatureObject, "PadawanTrials", "startedTrials", 1)
			JediTrials:setTrialsCompleted(pCreatureObject, #padawanTrialQuests)
		end
		
	end

--	if CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_01") then	
--		PlayerObject(pCreatureObject):findmytrainer()
--	end
	
	if CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_03") then	
		PVPFRSIntro:startStepDelay(pCreatureObject, 3)
	end

	if JediTrials:isOnKnightTrials(pCreatureObject) then	
		--KnightTrials:showCurrentTrial(pCreatureObject) --DOES NOT FIX
		
		--KnightTrials:startNextKnightTrial(pCreatureObject)--this FIXES KNIGHT TRIAL!!!! well sort of its a workaround that resets current trial every logout or server rest.

--100% fix for knight trial progress
		local trialNumber = JediTrials:getCurrentTrial(pCreatureObject)
		local trialData = knightTrialQuests[trialNumber]

		if (trialData.trialType == TRIAL_HUNT or trialData.trialType == TRIAL_HUNT_FACTION) then
			createObserver(KILLEDCREATURE, "KnightTrials", "notifyKilledHuntTarget", pCreatureObject)
		end
		
	end
	
end

-- Get the profession name from the badge number.
-- @param badgeNumber the badge number to find the profession name for.
-- @return the profession name associated with the badge number, Unknown profession returned if the badge number isn't found.
function HologrindJediManager:getProfessionStringIdFromBadgeNumber(badgeNumber)
	local skillList = self:getGrindableProfessionList()
	for i = 1, #skillList, 1 do
		if skillList[i][2] == badgeNumber then
			return skillList[i][1]
		end
	end
	return "Unknown profession"
end

-- Find out and send the response from the holocron to the player
-- @param pCreatureObject pointer to the creature object of the player who used the holocron.
function HologrindJediManager:sendHolocronMessage(pCreatureObject)
	if self:getNumberOfMasteredProfessions(pCreatureObject) >= 2 then--this number is how many profs need to be done
		-- The Holocron is quiet. The ancients' knowledge of the Force will no longer assist you on your journey. You must continue seeking on your own.
		--CreatureObject(pCreatureObject):sendSystemMessage("@jedi_spam:holocron_quiet")
		return true
	else
		local pGhost = CreatureObject(pCreatureObject):getPlayerObject()

		if (pGhost == nil) then
			return false
		end

		local professions = PlayerObject(pGhost):getHologrindProfessions()
		for i = 1, #professions, 1 do
			if not PlayerObject(pGhost):hasBadge(professions[i]) then
				local professionText = self:getProfessionStringIdFromBadgeNumber(professions[i])
				CreatureObject(pCreatureObject):sendSystemMessageWithTO("@jedi_spam:holocron_light_information", "@skl_n:" .. professionText)
				break
			end
		end

		return false
	end
	
--		local pGhost = CreatureObject(pCreatureObject):getPlayerObject()
--
--		if (pGhost == nil) then
--			return false
--		end
--	if self:getNumberOfMasteredProfessions(pCreatureObject) >= MAXIMUMNUMBEROFPROFESSIONSTOSHOWWITHHOLOCRON then
--		-- The Holocron is quiet. The ancients' knowledge of the Force will no longer assist you on your journey. You must continue seeking on your own.
----this is holocrons replenish force
----		if self:isJedi(pCreatureObject) then
----			if	PlayerObject(pGhost):getForcePower() < PlayerObject(pGhost):getForcePowerMax() then
----				PlayerObject(pGhost):setForcePower(PlayerObject(pGhost):getForcePowerMax());
----				CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
----				CreatureObject(pCreatureObject):sendSystemMessage("The holocron hums softly as you feel your Force power replenish.")
----				return false
----			else
----				CreatureObject(pCreatureObject):sendSystemMessage("@jedi_spam:holocron_force_max")
----				return true
----			end
----		end
--		CreatureObject(pCreatureObject):sendSystemMessage("@jedi_spam:holocron_quiet")
--		return true
--	else
--
--		local professions = PlayerObject(pGhost):getHologrindProfessions()
--		for i = 1, #professions, 1 do
--			if not PlayerObject(pGhost):hasBadge(professions[i]) then
--				local professionText = self:getProfessionStringIdFromBadgeNumber(professions[i])
--				CreatureObject(pCreatureObject):sendSystemMessageWithTO("@jedi_spam:holocron_light_information", "@skl_n:" .. professionText)
--				CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
--				break
--			end
--		end
--
--		return false
--	end
end

-- Handling of the useItem event.
-- @param pSceneObject pointer to the item object.
-- @param itemType the type of item that is used.
-- @param pCreatureObject pointer to the creature object that used the item.
function HologrindJediManager:useItem(pSceneObject, itemType, pCreatureObject)
	if (pCreatureObject == nil or pSceneObject == nil) then
		return
	end

	if itemType == ITEMHOLOCRON then
	
		if CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_02") then
			--ForceShrineMenuComponent:doMeditate(pSceneObject, pCreatureObject)
			--CreatureObject(pCreatureObject):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
			VillageJediManagerHolocron.useHolocron(pSceneObject, pCreatureObject)
			return
		end
	
		local isSilent = self:sendHolocronMessage(pCreatureObject)
		if isSilent then
			self:awardJediStatusAndSkill(pCreatureObject)
			SceneObject(pSceneObject):destroyObjectFromWorld()
			SceneObject(pSceneObject):destroyObjectFromDatabase()
			--return
		else
			SceneObject(pSceneObject):destroyObjectFromWorld()
			SceneObject(pSceneObject):destroyObjectFromDatabase()
		end
	end
--	local pGhost = CreatureObject(pCreatureObject):getPlayerObject()
--
--	if (pGhost == nil) then
--		return false
--	end
--	
--	if (pCreatureObject == nil or pSceneObject == nil) then
--		return
--	end
--
--	if itemType == ITEMHOLOCRON then
----		local isSilent = self:sendHolocronMessage(pCreatureObject)
----
----		if isSilent then
----			return
----		else
--
----		local skillManager = LuaSkillManager()
----
----		CreatureObject(pCreatureObject):addSkillMod(SkillModManager::PERMANENTMOD, "saber_block", 50, true)--notworking
--
--		if CreatureObject(pCreatureObject):hasSkill("force_title_jedi_novice") then
--			--ForceShrineMenuComponent:doMeditate(pSceneObject, pCreatureObject)
--			CreatureObject(pCreatureObject):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
--			VillageJediManagerHolocron.useHolocron(pSceneObject, pCreatureObject)
--			return
--		end
--		
----		local unlockluck = readScreenPlayData(pCreatureObject, "forcesensitivity", "unlock")
----		
----		CreatureObject(pCreatureObject):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
----		
----		writeScreenPlayData(pCreatureObject, "forcesensitivity", "unlock", unlockluck + 4)
--		
--		--self:awardFSpoint(pCreatureObject)
--		
--		CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
--		
--		SceneObject(pSceneObject):destroyObjectFromWorld()
--		SceneObject(pSceneObject):destroyObjectFromDatabase()
--
--		--this was unlock
----		if not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_rank_01") then
----			PlayerObject(pGhost):setJediState(2)
----					
----			awardSkill(pCreatureObject, "force_title_jedi_rank_01")
----		
----			writeScreenPlayData(pCreatureObject, "PadawanTrials", "startedTrials", 1)		
----			
----			CreatureObject(pCreatureObject):playEffect("clienteffect/trap_electric_01.cef", "")
----			CreatureObject(pCreatureObject):playMusicMessage("sound/music_become_jedi.snd")
----
----			FsIntro:startStepDelay(pCreatureObject, 3)
--			---
--			
--			
--			
----			local suiManager = LuaSuiManager()		
----			suiManager:sendMessageBox(pCreatureObject, pCreatureObject, "Jedi Unlock", "You begin to feel attuned with the power of the Force. Your Jedi skill trees have been unlocked! \n\nYou have been sent mail with a guide to Jedi on mySWG. First you will need to find your Jedi skill trainer! it could be any starting profession trainer in the galaxy, talk to each one until you find yours.\n\nJedi on mySWG is PERMADEATH with only 3 lives! After you find your trainer you will only have 3 lives, after that all of you Jedi skills will be removed. \n\nCongratulations, good luck, and may the Force be with you... Jedi.", "@ok", "HologrindJediManager", "notifyOkPressed")
--		
----			sendMail("mySWG", "Jedi Guide", "\n\nCongratulations on unlocking Jedi on mySWG!" 
----			.. "\n\nTo get started you first need to find your trainer, the command /findmytrainer does not work, finding your personal Jedi trainer is part of the quest. Your Jedi trainer could be any starting profession trainer in the galaxy, you will need to talk to each once until you find the correct one. Next you will need to craft a lightsaber crafting tool, then you will need to craft refined crystal packs for jedi exp until you have enough for novice lightsaber, there is no training saber on myswg." 
----			.. "\n\nAfter you have trained novice lightsaber you are ready to craft your first lightsaber. You will need to loot a color crystal to use your lightsaber. Color crystals and refined crystal packs can be looted from any npc that normally drops crystals. To craft 2nd, 3rd, and 4th generation lightsabers you will need to loot refined crystal packs in stacks of 2,3,4 respectively, they will not take crafted RCP. In mySWG all lightsaber types have the same damage and can use any lightsaber special, the most powerful specials all have the same stats but different animations, this is for balance and to increase variety. 3 saber types x 3 dfferent animations = 9 MLS animation spam options."
----			.."Lightsabers deal energy damage and decay like normal weapons, pearls and power crystals are now lootable refined crystal packs to be used in crafting 2nd 3rd and 4th generation lightsabers. All lightsabers have 1 slot for a color crystal only, color crystals do NOT decay and are not tradable. A Jedi must find his own color crystal."
----			.."\n\nJEDI CAN WEAR ARMOR! Yes, Jedi can wear armor here like pre-9. Also, Lightsaber toughness and Jedi toughness are now innate armor but only while a lightsaber is equipped. Lightsaber toughness and Jedi toughness stack on top of all armor resists for a maximum of 80%. So if your armor has 20% stun and you have 40 lightsaber toughness and 10 Jedi toughness, you actually have 70% stun armor as long as your lightsaber is equipped."
----			.."\n\n**PERMADEATH!**"
----			.."\nYes, Jedi on mySWG is permadeath. You have 3 lives, after you have died 3 times you will have all of your jedi skill boxes REMOVED. Player kills do not count to avoid any griefing and to allow for safe duels. When killed by a non player character you will receive a pop up upon death informing you that you have lost a life, revives of any kind will not save you and do not affect your death count. Your death counter will show up in experience as 'jedi_deaths'. It is possible to unlock again."
----			.."\n\nVisibility is slightly more forgiving here but mostly unchanged. Using a lightsaber or any force powers within 32m of any player or humanoid NPC will raise your visibility for the Bounty Hunter terminals. NPC Bounty Hunters will start to come after you once you have enough visibility. As a new Jedi you should just RUN."
----			.."\n\nJedi Knight trials will start when you have learned enough skills. FRS has been removed, instead the Jedi knight skill box grants hidden skill mods. Jedi Knight is not tied to any faction, you do not have to be rebel or imperial and there is no light or dark side, there is just Jedi Knight."
----			, CreatureObject(pCreatureObject):getFirstName())
--			
--			
--			
----			SceneObject(pSceneObject):destroyObjectFromWorld()
----			SceneObject(pSceneObject):destroyObjectFromDatabase()
----		end
--	end
end

function HologrindJediManager:checkForceStatusCommand(pPlayer)
	if (pPlayer == nil) then
		return
	end
	
--	local unlockluck = readScreenPlayData(pPlayer, "forcesensitivity", "unlock")

--	CreatureObject(pPlayer):sendSystemMessage(progress)
	
	--CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
	
--	CreatureObject(pPlayer):sendSystemMessage("...")
	

--	
--	if self.canCheckForce(pPlayer) then
--	
----		local unlockodds = (1680 / unlockluck) / 24;
----	
----		CreatureObject(pPlayer):sendSystemMessage("the odds are 1 in " .. unlockodds)
----		
----		CreatureObject(pPlayer):sendSystemMessage("your current force sensitivity is " .. unlockluck)
--		
--		CreatureObject(pPlayer):addCooldown("checked_force", 24 * 60 * 60 * 1000)
--		
--		local progress = "@jedi_spam:fs_progress_" .. unlockluck
--
--		CreatureObject(pPlayer):sendSystemMessage(progress)
--	else
--	
--		CreatureObject(pPlayer):sendSystemMessage("you can only check your force sensitivity once every 24 hours.")
--	end

end

function HologrindJediManager.canCheckForce(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	return CreatureObject(pPlayer):checkCooldownRecovery("checked_force")
end

function HologrindJediManager:canLearnSkill(pPlayer, skillName)
	return true
end

function HologrindJediManager:canSurrenderSkill(pPlayer, skillName)

	if skillName == "force_title_jedi_rank_02" or skillName == "force_title_jedi_rank_01" or skillName == "force_title_jedi_novice" then
		CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:revoke_force_title")
		return false
	end

--	if string.find(skillName, "force_sensitive_") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and CreatureObject(pPlayer):getForceSensitiveSkillCount(false) <= 24 then
--		CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:revoke_force_sensitive")
--		return false
--	end

	if string.find(skillName, "force_discipline_") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and not CreatureObject(pPlayer):villageKnightPrereqsMet(skillName) then
		return false
	end

	return true
end

function HologrindJediManager:awardFSpoint(pCreatureObject)
--	local unlockluck = readScreenPlayData(pCreatureObject, "forcesensitivity", "unlock")
--	
--	if not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_novice") then
--		writeScreenPlayData(pCreatureObject, "forcesensitivity", "unlock", unlockluck + 1)
--		CreatureObject(pCreatureObject):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
--	end

end

function HologrindJediManager:removeFSpoint(pCreatureObject)
--	local unlockluck = readScreenPlayData(pCreatureObject, "forcesensitivity", "unlock")
--	
--	if not CreatureObject(pCreatureObject):hasSkill("force_title_jedi_novice") and unlockluck > 1 then
--		writeScreenPlayData(pCreatureObject, "forcesensitivity", "unlock", unlockluck - 1)
--	--	CreatureObject(pCreatureObject):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
--	end

end

registerScreenPlay("HologrindJediManager", true)

return HologrindJediManager
