trainerConvHandler = conv_handler:new {}

function trainerConvHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local trainerType = SkillTrainer:getTrainerType(pPlayer, pNpc, pConvTemplate)
	local prereqSkills = SkillTrainer:getPrerequisiteTrainerSkills(trainerType)

	if (trainerType == "") then
		return convoTemplate:getScreen("trainer_unknown")
	elseif (not SkillTrainer:hasAllPrereqSkills(pPlayer, trainerType)) then
		return convoTemplate:getScreen("no_qualify")
	elseif (SkillTrainer:hasSurpassedTrainer(pPlayer, trainerType)) then
		return convoTemplate:getScreen("topped_out")
	end

	return convoTemplate:getScreen("intro")
end

function trainerConvHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local trainerType = SkillTrainer:getTrainerType(pPlayer, pNpc, pConvTemplate)
	local playerID = SceneObject(pPlayer):getObjectID()
	local stringTable = "@skill_teacher:"
	local isJediTrainer = false

	if (trainerType == "trainer_jedi") then
		isJediTrainer = true
		stringTable = "@jedi_trainer:"
	end

	if (screenID == "intro") then
		local pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		if (isJediTrainer) then
			clonedConversation:setDialogTextStringId(stringTable .. "greeting")		
			
		else
			clonedConversation:setDialogTextStringId(stringTable .. trainerType)
		end

		clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
		clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

		return pConvScreen
	end

	local skillList

	if (screenID == "msg2_1") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)

		if (#skillList == 0) then
			clonedConversation:setDialogTextStringId(stringTable .. "msg3_1")
			clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
			clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")
			
				if isJediTrainer and (not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and JediTrials:isEligibleForKnightTrials(pPlayer) and not JediTrials:isOnKnightTrials(pPlayer)) then
					KnightTrials:startKnightTrials(pPlayer)
				end
			
		else
			clonedConversation:setDialogTextStringId(stringTable .. screenID)
			pConvScreen = self:addSkillResponses(pConvScreen, skillList, stringTable, "learn")
		end
	elseif (screenID == "msg2_2") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. screenID)
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, false)
		pConvScreen = self:addSkillResponses(pConvScreen, skillList, stringTable, "info")
	elseif (screenID == "cancel_learn") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. "msg_no")
		deleteData(playerID .. ":trainerTeachSkill")
	elseif (screenID == "topped_out") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		clonedConversation:setDialogTextStringId(stringTable .. "topped_out")
	elseif (screenID == "no_qualify") then
	
			if isJediTrainer and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01") then			
				awardSkill(pPlayer, "force_title_jedi_rank_02")
				JediTrials:setTrialsCompleted(pPlayer, #padawanTrialQuests)
				writeScreenPlayData(pPlayer, "PadawanTrials", "completedTrials", 1)
				
				CreatureObject(pPlayer):playEffect("clienteffect/trap_electric_01.cef", "")
				CreatureObject(pPlayer):playMusicMessage("sound/music_become_jedi.snd")
			
				local suiManager = LuaSuiManager()		
				suiManager:sendMessageBox(pPlayer, pPlayer, "Jedi Padawan", "Well done! this is your personal Jedi skill trainer, they will teach you all of your Jedi skills.", "@ok", "HologrindJediManager", "notifyOkPressed")
				
				local pGhost = CreatureObject(pPlayer):getPlayerObject()				
				local zoneName = SceneObject(pNpc):getZoneName()
				PlayerObject(pGhost):addWaypoint(zoneName, "Jedi Skill Trainer", "", SceneObject(pNpc):getWorldPositionX(), SceneObject(pNpc):getWorldPositionY(), WAYPOINTYELLOW, true, true, 0)
				
			end		
	
		if not isJediTrainer then
			pConvScreen = screen:cloneScreen()
			local clonedConversation = LuaConversationScreen(pConvScreen)

			clonedConversation:setDialogTextStringId(stringTable .. "no_qualify")

			SkillTrainer:sendPrereqSui(pPlayer, pNpc, trainerType)
		end
	elseif (screenID == "nsf_skill_points") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = readData(playerID .. ":trainerTeachSkill")

		pConvScreen = self:handleNsfSkillPointsScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "confirm_learn") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = readData(playerID .. ":trainerTeachSkill")

		pConvScreen = self:handleConfirmLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "learn") then
		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, true)
		local skillNum = math.floor(selectedOption + 1)

		pConvScreen = self:handleLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	elseif (screenID == "info") then
		pConvScreen = screen:cloneScreen()
		local clonedConversation = LuaConversationScreen(pConvScreen)

		skillList = SkillTrainer:getTeachableSkills(pPlayer, trainerType, false)
		local skillNum = math.floor(selectedOption + 1)
		local skillName = skillList[skillNum]

		clonedConversation:setDialogTextStringId(stringTable .. "msg3_3")
		clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
		clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")
		SkillTrainer:sendSkillInfoSui(pPlayer, pNpc, skillName)
	end

	return pConvScreen
end

function trainerConvHandler:addSkillResponses(pConvScreen, skillList, stringTable, optionTag)
	local clonedConversation = LuaConversationScreen(pConvScreen)

	for i = 1, #skillList, 1 do
		clonedConversation:addOption("@skl_n:" .. skillList[i], optionTag)
	end

	clonedConversation:addOption("@skill_teacher:back", "intro")

	return pConvScreen
end

function trainerConvHandler:handleLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]
	local skillManager = LuaSkillManager()

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillStringId = getStringId("@skl_n:" .. skillName)
	local skillObject = LuaSkill(pSkill)

	local moneyRequired = skillObject:getMoneyRequired()
	local persuasion = CreatureObject(pPlayer):getSkillMod("force_persuade")

	if (persuasion > 0) then
		moneyRequired = moneyRequired - ((moneyRequired * persuasion) / 100)
	end

	clonedConversation:setDialogTextStringId(stringTable .. "prose_cost")
	clonedConversation:setDialogTextDI(moneyRequired)
	clonedConversation:setDialogTextTO(skillStringId)

	writeData(SceneObject(pPlayer):getObjectID() .. ":trainerTeachSkill", skillNum)
	clonedConversation:addOption("@skill_teacher:yes", "confirm_learn")
	clonedConversation:addOption("@skill_teacher:no", "cancel_learn")

	return pConvScreen
end

function trainerConvHandler:handleConfirmLearnScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleConfirmLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleConfirmLearnScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]
	local skillManager = LuaSkillManager()

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillStringId = getStringId("@skl_n:" .. skillName)
	local skillObject = LuaSkill(pSkill)

	local moneyRequired = skillObject:getMoneyRequired()
	local persuasion = CreatureObject(pPlayer):getSkillMod("force_persuade")

	if (persuasion > 0) then
		moneyRequired = moneyRequired - ((moneyRequired * persuasion) / 100)
	end

	local cashCredits = CreatureObject(pPlayer):getCashCredits()
	local bankCredits = CreatureObject(pPlayer):getBankCredits()
	local playerCredits = cashCredits + bankCredits

	if playerCredits < moneyRequired then
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_nsf")
		messageString:setDI(moneyRequired)
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())

		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		pConvScreen = convoTemplate:getScreen("intro")
		return self:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	end

	if (not skillManager:canLearnSkill(pPlayer, skillName, true)) then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)
		pConvScreen = convoTemplate:getScreen("nsf_skill_points")
		return self:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	end
	
--	if (skillName == "social_politician_novice") then
--	awardSkill("social_politician_master", creature, notifyClient, awardRequiredSkills, noXpRequired);
--		skillName = "social_politician_master"
--		skillManager:awardSkill(pPlayer, "social_politician_master")
--	end

	local success = skillManager:awardSkill(pPlayer, skillName)

	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (success) then
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_pay")
		messageString:setDI(moneyRequired)
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())

		if (moneyRequired <= cashCredits) then
			CreatureObject(pPlayer):subtractCashCredits(moneyRequired)
		else
			bankRequired = moneyRequired - cashCredits
			CreatureObject(pPlayer):subtractCashCredits(cashCredits)
			CreatureObject(pPlayer):subtractBankCredits(bankRequired)
		end

		local messageString = LuaStringIdChatParameter(stringTable .. "prose_skill_learned")
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
		clonedConversation:setDialogTextStringId(stringTable .. "msg3_2")
	  
		local pGhost = CreatureObject(pPlayer):getPlayerObject()
		
--		--540 skills enabled in myswg, chance to unlock every time you train a skill, its possible to not unlock -- disabled for new version below
--		if (pGhost ~= nil and getRandomNumber(1, 500) >= 500 and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_02") and JediTrials:isEligibleForJedi(pPlayer)) then
--			

--jedi unlock has to be an elite master and a random 1/72 chance. 24 profs so only a 1/3 chance to unlock for each caracter
--		if (pGhost ~= nil and 
--	getRandomNumber(1, 7) >= 7 and
--	JediTrials:isEligibleForJedi(pPlayer) and
--	(
--	skillName == "crafting_architect_master" or
--	skillName == "crafting_armorsmith_master" or
--	skillName == "outdoors_bio_engineer_master" or
--	skillName == "combat_bountyhunter_master" or
--	skillName == "combat_carbine_master" or
--	skillName == "crafting_chef_master" or
--	skillName == "science_combatmedic_master" or
--	skillName == "combat_commando_master" or
--	skillName == "outdoors_creaturehandler_master" or
--	skillName == "social_dancer_master" or
--	skillName == "science_doctor_master" or
--	skillName == "crafting_droidengineer_master" or
--	skillName == "combat_1hsword_master" or
--	skillName == "social_imagedesigner_master" or
--	skillName == "social_musician_master" or
--	skillName == "combat_polearm_master" or
--	skillName == "combat_pistol_master" or
--	skillName == "outdoors_ranger_master" or
--	skillName == "combat_rifleman_master" or
--	skillName == "combat_smuggler_master" or
--	skillName == "combat_2hsword_master" or
--	skillName == "crafting_tailor_master" or
--	skillName == "crafting_weaponsmith_master" or
--	skillName == "combat_unarmed_master"))
--	then
--
--			PlayerObject(pGhost):setJediState(2)
--					
--			awardSkill(pPlayer, "force_title_jedi_rank_01")
--		
--			writeScreenPlayData(pPlayer, "PadawanTrials", "startedTrials", 1)		
--			
--			CreatureObject(pPlayer):playEffect("clienteffect/trap_electric_01.cef", "")
--			CreatureObject(pPlayer):playMusicMessage("sound/music_become_jedi.snd")
--
--			FsIntro:startStepDelay(pPlayer, 3)
			
--moved to skillmanager			
--			local suiManager = LuaSuiManager()		
--			suiManager:sendMessageBox(pPlayer, pPlayer, "Jedi Unlock", "You begin to feel attuned with the power of the Force. Your Jedi skill trees have been unlocked! \n\nYou have been sent mail with a guide to Jedi on mySWG. First you will need to find your Jedi skill trainer! it could be any starting profession trainer in the galaxy, talk to each one until you find yours.\n\nJedi on mySWG is PERMADEATH with only 3 lives! After you find your trainer you will only have 3 lives, after that all of you Jedi skills will be removed. \n\nCongratulations, good luck, and may the Force be with you... Jedi.", "@ok", "HologrindJediManager", "notifyOkPressed")

--			sendMail("mySWG", "Jedi Guide", "\n\nCongratulations on unlocking Jedi on mySWG!" 
--			.. "\n\nTo get started you first need to find your trainer, the command /findmytrainer does not work, finding your personal Jedi trainer is part of the quest. Your Jedi trainer could be any starting profession trainer in the galaxy, you will need to talk to each once until you find the correct one. Next you will need to craft a lightsaber crafting tool, then you will need to craft refined crystal packs for jedi exp until you have enough for novice lightsaber, there is no training saber on myswg." 
--			.. "\n\nAfter you have trained novice lightsaber you are ready to craft your first lightsaber. You will need to loot a color crystal to use your lightsaber. Color crystals and refined crystal packs can be looted from any npc that normally drops crystals. To craft 2nd, 3rd, and 4th generation lightsabers you will need to loot refined crystal packs in stacks of 2,3,4 respectively, they will not take crafted RCP. In mySWG all lightsaber types have the same damage and can use any lightsaber special, the most powerful specials all have the same stats but different animations, this is for balance and to increase variety. 3 saber types x 3 dfferent animations = 9 MLS animation spam options."
--			.."Lightsabers deal energy damage and decay like normal weapons, pearls and power crystals are now lootable refined crystal packs to be used in crafting 2nd 3rd and 4th generation lightsabers. All lightsabers have 1 slot for a color crystal only, color crystals do NOT decay and are not tradable. A Jedi must find his own color crystal."
--			.."\n\nJEDI CAN WEAR ARMOR! Yes, Jedi can wear armor here like pre-9. Also, Lightsaber toughness and Jedi toughness are now innate armor but only while a lightsaber is equipped. Lightsaber toughness and Jedi toughness stack on top of all armor resists for a maximum of 80%. So if your armor has 20% stun and you have 40 lightsaber toughness and 10 Jedi toughness, you actually have 70% stun armor as long as your lightsaber is equipped."
--			.."\n\n**PERMADEATH!**"
--			.."\nYes, Jedi on mySWG is permadeath. You have 3 lives, after you have died 3 times you will have all of your jedi skill boxes REMOVED. Player kills do not count to avoid any griefing and to allow for safe duels. When killed by a non player character you will receive a pop up upon death informing you that you have lost a life, revives of any kind will not save you and do not affect your death count. Your death counter will show up in experience as 'jedi_deaths'. It is possible to unlock again."
--			.."\n\nVisibility is slightly more forgiving here but mostly unchanged. Using a lightsaber or any force powers within 32m of any player or humanoid NPC will raise your visibility for the Bounty Hunter terminals. NPC Bounty Hunters will start to come after you once you have enough visibility. As a new Jedi you should just RUN."
--			.."\n\nJedi Knight trials will start when you have learned enough skills. FRS has been removed, instead the Jedi knight skill box grants hidden skill mods. Jedi Knight is not tied to any faction, you do not have to be rebel or imperial and there is no light or dark side, there is just Jedi Knight."
--			, CreatureObject(pPlayer):getFirstName())
			
			--***** message located in skillmanager.ccp
--			self:broadcastToPlayers(pGhost, "IMPERIAL COMMUNICATION FROM THE REGIONAL GOVERNOR: Lord Vader has detected a vergence in the Force.\r\rBe on the lookout for any suspicious persons displaying unique or odd abilities. Lord Vader authorizes all citizens to use deadly force to eliminate this threat to the Empire.")
			--playerObject(pGhost):broadcastGalaxy("IMPERIAL COMMUNICATION FROM THE REGIONAL GOVERNOR: Lord Vader has detected a vergence in the Force.\r\rBe on the lookout for any suspicious persons displaying unique or odd abilities. Lord Vader authorizes all citizens to use deadly force to eliminate this threat to the Empire.")			

--		end

		if (pGhost ~= nil and not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_03") and JediTrials:isEligibleForKnightTrials(pPlayer)) then

--			awardSkill(pPlayer, "force_title_jedi_rank_03")	
--			
--			CreatureObject(pPlayer):playEffect("clienteffect/trap_electric_01.cef", "")
--			CreatureObject(pPlayer):playMusicMessage("sound/music_become_jedi.snd")		
--			
--			local suiManager = LuaSuiManager()
--			suiManager:sendMessageBox(pPlayer, pPlayer, "Jedi Knight", "Your hard work has paid off and you are now worthy of the title Jedi Knight! \nJedi Knight gives you a hidden +25 Lightsaber Toughness, Lightsaber toughness is innate armor on mySWG. A Jedi Knight with master lightsaber has 80% innate armor when no armor is equipped, if a Jedi equips armor it removes the lightsaber toughness armor. There is no need for a MLS/Knight to wear armor. Congratulations! You are among the most powerful in the universe.", "@ok", "HologrindJediManager", "notifyOkPressed")
--			
			KnightTrials:startKnightTrials(pPlayer)
			
--			local sui = SuiMessageBox.new("KnightTrials", "startNextKnightTrial")
--			sui.setTitle("Jedi Knight Unlock")
--			sui.setPrompt("Congratulations! You now have enough Jedi skill points to become a Jedi Knight! Here there is no trial you just pick a side. It does not matter what faction you are, and you do not need to join a faction at all. Force Ranking System experience is earned the same way combat exp is earned and also through random spawning encounters with Jedi NPCs, These Jedi NPC encoutners will happen as long as you are outside. Here FRS gives you innate increases to Armor, Damage, and Force Power Max. Light side gets slightly more armor, Dark side gets slightly more damage. Are you ready to become a Jedi knight?")
--			sui.setOkButtonText("@jedi_trials:button_yes")
--			sui.setCancelButtonText("@jedi_trials:button_no")
--			sui.sendTo(pPlayer)
			
		end
	else
		local messageString = LuaStringIdChatParameter(stringTable .. "prose_train_failed")
		messageString:setTO(skillStringId)
		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
		clonedConversation:setDialogTextStringId(stringTable .. "error_grant_skill")
	end

	if (SkillTrainer:hasSurpassedTrainer(pPlayer, trainerType)) then
		clonedConversation:setDialogTextStringId(stringTable .. "surpass_trainer")
		clonedConversation:setDialogTextTT(CreatureObject(pPlayer):getFirstName())
		clonedConversation:setStopConversation(true)

		return pConvScreen
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. ":trainerTeachSkill")

	clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
	clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

	return pConvScreen
end

function trainerConvHandler:handleNsfSkillPointsScreen(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen, trainerType, stringTable, skillList, skillNum)
	local screen = LuaConversationScreen(pConvScreen)
	local pConvScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pConvScreen)

	if (skillNum == nil) then
		printLuaError("Nil skillNum sent to handleNsfSkillPointsScreen for trainer type " .. trainerType)
		return pConvScreen
	elseif (skillNum <= 0) then
		printLuaError("Invalid skillNum (" .. skillNum .. ") sent to handleNsfSkillPointsScreen for trainer type " .. trainerType)
		return pConvScreen
	end

	local skillName = skillList[skillNum]

	if (skillName == nil or skillName == "") then
		printLuaError(CreatureObject(pPlayer):getFirstName() .. " tried to learn a nil or empty skillName using trainer type " .. trainerType .. ", skillNum of " .. skillNum .. " with a table size of " .. #skillList)
		return pConvScreen
	end

	local skillManager = LuaSkillManager()

	local pSkill = skillManager:getSkill(skillName)

	if (pSkill == nil) then
		return pConvScreen
	end

	local skillObject = LuaSkill(pSkill)

	local pointsReq = skillObject:getSkillPointsRequired()
	local skillStringId = getStringId("@skl_n:" .. skillName)

	clonedConversation:setDialogTextStringId(stringTable .. "nsf_skill_pts")
	clonedConversation:setDialogTextDI(pointsReq)
	clonedConversation:setDialogTextTO(skillStringId)

	clonedConversation:addOption("@skill_teacher:opt1_1", "msg2_1")
	clonedConversation:addOption("@skill_teacher:opt1_2", "msg2_2")

	return pConvScreen
end
