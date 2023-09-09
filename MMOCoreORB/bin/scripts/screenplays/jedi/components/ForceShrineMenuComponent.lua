ForceShrineMenuComponent = {}

function ForceShrineMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)

--	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		menuResponse:addRadialMenuItem(120, 3, "@jedi_trials:meditate") -- Meditate
--	end

	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		menuResponse:addRadialMenuItem(121, 3, "@force_rank:recover_jedi_items") -- Recover Jedi Items
	end
	
--	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")) then
--		menuResponse:addRadialMenuItem(122, 3, "Spawn FRS Encounter (3hr timer)")
--	end

end

function ForceShrineMenuComponent:handleObjectMenuSelect(pObject, pPlayer, selectedID)
	if (pPlayer == nil or pObject == nil) then
		return 0
	end
	
	if (selectedID == 120 and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		if (CreatureObject(pPlayer):getPosture() ~= CROUCHED) then
			CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:show_respect") -- Must respect
		else
			CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
		end
	end

	if (selectedID == 120 and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		if (CreatureObject(pPlayer):getPosture() ~= CROUCHED) then
			CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:show_respect") -- Must respect
		else

		local pGhost = CreatureObject(pPlayer):getPlayerObject()

		if (pGhost == nil) then
			return
		end

--		local professions = PlayerObject(pGhost):getHologrindProfessions()
--		for i = 1, #professions, 1 do
--			if not PlayerObject(pGhost):hasBadge(professions[i]) then
--				local professionText = HologrindJediManager:getProfessionStringIdFromBadgeNumber(professions[i])
--				CreatureObject(pPlayer):sendSystemMessageWithTO("@jedi_spam:holocron_light_information", "@skl_n:" .. professionText)
--				break
--			end
--		end

		HologrindJediManager:checkIfProgressedToJedi(pPlayer)
			
		end
		
	end
		
	if (selectedID == 121 and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02")) then
		self:recoverRobe(pPlayer)
	end
		
--	if (selectedID == 122) and VillageJediManagerHolocron.canUseHolocron(pPlayer) then 
--	--and VillageJediManagerHolocron.canUseHolocron(pPlayer)
--	
----	local encounter = 0;
----	local count = 1;
--
--		CreatureObject(pPlayer):addCooldown("used_holocron", 3 * 60 * 60 * 1000)
--
--		if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_10") then
--			PVPDJKEncounter4:start(pPlayer)	
--			return
--		end
--		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_10") then
--			PVPLJKEncounter4:start(pPlayer)	
--			return
--		end
--	
--		if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_08") then
--			PVPDJKEncounter3:start(pPlayer)	
--			return
--		end
--		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_08") then
--			PVPLJKEncounter3:start(pPlayer)	
--			return
--		end
--		
--		if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_05") then
--			PVPDJKEncounter2:start(pPlayer)	
--			return
--		end
--		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_05") then
--			PVPLJKEncounter2:start(pPlayer)	
--			return
--		end
--		
--		if CreatureObject(pPlayer):hasSkill("force_rank_light_novice") then
--			PVPDJKEncounter:start(pPlayer)	
--			return
--		end
--		if CreatureObject(pPlayer):hasSkill("force_rank_dark_novice") then
--			PVPLJKEncounter:start(pPlayer)
--			return
--		end
--		
----		if encounter == 1 then
----		
----		end
--
--	else
--	--CreatureObject(pPlayer):sendSystemMessage("You can only spawn an encounter once every 3 hours.")
--		
--	end

	return 0
end

function ForceShrineMenuComponent:doMeditate(pObject, pPlayer)
--	if (tonumber(readScreenPlayData(pPlayer, "KnightTrials", "completedTrials")) == 1 and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03")) then
--		KnightTrials:resetCompletedTrialsToStart(pPlayer)
--	end

--not working
--	if (JediTrials:isOnPadawanTrials(pPlayer)) then
--		local pTrainerPlanet =	PlayerObject(pPlayer):getTrainerZoneName()
--		CreatureObject(pPlayer):sendSystemMessage("You must go to the planet " .. pTrainerPlanet .. ". There you will find your Jedi skill trainer.")
--	end

	if not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") then
		local currentTrial = JediTrials:getCurrentTrial(pPlayer)

		if (not JediTrials:isOnPadawanTrials(pPlayer)) then
			PadawanTrials:startPadawanTrials(pObject, pPlayer)
		elseif (currentTrial == 0) then
			PadawanTrials:startNextPadawanTrial(pObject, pPlayer)
		else
			PadawanTrials:showCurrentTrial(pObject, pPlayer)
		end
	end

	
	if (JediTrials:isOnKnightTrials(pPlayer)) then
		local pPlayerShrine = KnightTrials:getTrialShrine(pPlayer)

		if (pPlayerShrine ~= nil and pObject ~= pPlayerShrine) then
			local correctShrineZone = SceneObject(pPlayerShrine):getZoneName()
			if (correctShrineZone ~= SceneObject(pObject):getZoneName()) then
				local messageString = LuaStringIdChatParameter("@jedi_trials:knight_shrine_reminder")
				messageString:setTO(getStringId("@jedi_trials:" .. correctShrineZone))
				CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
			else
				CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:knight_shrine_wrong")
			end
			return
		end

		local currentTrial = JediTrials:getCurrentTrial(pPlayer)
		local trialsCompleted = JediTrials:getTrialsCompleted(pPlayer)

		if (currentTrial == 0 and trialsCompleted == 0) then
			local sui = SuiMessageBox.new("KnightTrials", "startNextKnightTrial")
			sui.setTitle("@jedi_trials:knight_trials_title")
			sui.setPrompt("@jedi_trials:knight_trials_start_query")
			sui.setOkButtonText("@jedi_trials:button_yes")
			sui.setCancelButtonText("@jedi_trials:button_no")
			sui.sendTo(pPlayer)
		else
--			KnightTrials:resetCompletedTrialsToStart(pPlayer)
			KnightTrials:showCurrentTrial(pPlayer)
		end
	else
		CreatureObject(pPlayer):sendSystemMessage("@jedi_trials:force_shrine_wisdom_" .. getRandomNumber(1, 15))
	end
end

function ForceShrineMenuComponent:recoverRobe(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	if (SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("@jedi_spam:inventory_full_jedi_robe")
		return
	end

	if CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_padawan.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_dark_novice") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_dark_s01.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_light_novice") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_light_s01.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_01") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_dark_s02.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_01") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_light_s02.iff", -1)
	end
		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_05") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_dark_s03.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_05") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_light_s03.iff", -1)
	end
		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_08") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_dark_s04.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_08") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_light_s04.iff", -1)
	end
		if CreatureObject(pPlayer):hasSkill("force_rank_dark_rank_10") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_dark_s05.iff", -1)
	end
	if CreatureObject(pPlayer):hasSkill("force_rank_light_rank_10") then
				giveItem(pInventory, "object/tangible/wearables/robe/robe_jedi_light_s05.iff", -1)
	end

	--giveItem(pInventory, robeTemplate, -1)
	CreatureObject(pPlayer):sendSystemMessage("@force_rank:items_recovered")
end
