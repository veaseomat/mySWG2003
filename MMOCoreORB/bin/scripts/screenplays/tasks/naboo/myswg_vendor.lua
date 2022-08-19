myswg_vendor = ScreenPlay:new {                
    numberOfActs = 1,                
    questString = "myswg_vendor_task",                   
    states = {}, 
}
registerScreenPlay("myswg_vendor", true)
function myswg_vendor:start()     
    -- Spawn our character into the world, setting pLarry a pointer variable we can use to check or change his state. 
    local pWeaponsmith = spawnMobile("corellia", "myswg_vendor", 1, -157, 28.0, -4715, 35, 0 )
--    local pLarry = spawnMobile("naboo", "merch_crazy_larry", 1, -4881, 6.0, 4150, 35, 0 )
end
myswg_vendor_convo_handler = Object:new {
    tstring = "myconversation" 
}
function myswg_vendor_convo_handler:getNextConversationScreen(conversationTemplate, conversingPlayer, selectedOption)            
        -- Assign the player to variable creature for use inside this function.
        local creature = LuaCreatureObject(conversingPlayer)
        -- Get the last conversation to determine whether or not we’re on the first screen      
        local convosession = creature:getConversationSession()  
        lastConversation = nil      
        local conversation = LuaConversationTemplate(conversationTemplate)  
        local nextConversationScreen     
        -- If there is a conversation open, do stuff with it        
        if ( conversation ~= nil ) then  -- check to see if we have a next screen   
            if ( convosession ~= nil ) then             
                local session = LuaConversationSession(convosession)
                if ( session ~= nil ) then                  
                    lastConversationScreen = session:getLastConversationScreen()   
                end         
            end         
            -- Last conversation was nil, so get the first screen
            if ( lastConversationScreen == nil ) then          
                nextConversationScreen = conversation:getInitialScreen()
            else
                -- Start playing the rest of the conversation based on user input               
                local luaLastConversationScreen = LuaConversationScreen(lastConversationScreen) 
                -- Set variable to track what option the player picked and get the option picked                
                local optionLink = luaLastConversationScreen:getOptionLink(selectedOption)
                nextConversationScreen = conversation:getScreen(optionLink)
                -- Get some information about the player.
                local credits = creature:getCashCredits()
                local pInventory = creature:getSlottedObject("inventory")
                local inventory = LuaSceneObject(pInventory)
                -- Take action when the player makes a purchase.
                --if (inventory:hasFullContainerObjects() == true) then -- removed, does not work
                if (SceneObject(pInventory):isContainerFullRecursive()) then
                    -- Bail if the player doesn’t have enough space in their inventory.
                    -- Plays a chat box message from the NPC as well as a system message.
                    nextConversationScreen = conversation:getScreen("insufficient_space")
                    creature:sendSystemMessage("You do not have enough inventory space")
                    
--                if (optionLink == "buff1" and credits < 5000) then
--                    -- Bail if the player doesn’t have enough cash on hand.  
--                    -- Plays a chat box message from the NPC as well as a system message.
--                      nextConversationScreen = conversation:getScreen("insufficient_funds")
--                      creature:sendSystemMessage("You have insufficient funds") 
--                elseif (optionLink == "buff1" and credits >= 5000) then
--                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
--                    creature:subtractCashCredits(5000)
--                    local pItem = 
--										CreatureObject(conversingPlayer):enhanceCharacter()
										--buffTerminalMenuComponent:logUsage(conversingPlayer, "enhanceCharacter")
                    --giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
                    --createLoot(pInventory, "junk", 1, false)
                    
--                elseif (optionLink == "buff2" and credits < 5000000) then
--                    -- Bail if the player doesn’t have enough cash on hand.  
--                    -- Plays a chat box message from the NPC as well as a system message.
--                      nextConversationScreen = conversation:getScreen("insufficient_funds")
--                      creature:sendSystemMessage("You have insufficient funds") 
--                elseif (optionLink == "buff2" and credits >= 5000000) then
--                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
--                    creature:subtractCashCredits(5000000)
--                    local pItem = 
--										CreatureObject(conversingPlayer):enhanceCharacter()
--                    --giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
--                    --createLoot(pInventory, "junk", 300, false)

                elseif (optionLink == "option1" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option1" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/carbine/carbine_e11.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option2" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option2" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_e11.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option3" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option3" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/pistol/pistol_fwg5.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option4" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option4" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/baton/baton_stun.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option5" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option5" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/2h_sword/2h_sword_cleaver.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option6" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option6" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/polearm/lance_vibrolance.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option7" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option7" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/special/vibroknuckler.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option8" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option8" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_lightning.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option9" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option9" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_flame_thrower.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option10" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option10" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_acid_beam.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option11" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option11" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/grenade/grenade_proton.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
--ARMORRRRRR
                elseif (optionLink == "option12" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option12" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_leggings.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option13" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option13" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_chest_plate.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option14" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option14" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_helmet.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option15" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option15" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_bracer_r.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option16" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option16" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/kashyyykian_hunting/armor_kashyyykian_hunting_leggings.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option17" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option17" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/kashyyykian_hunting/armor_kashyyykian_hunting_chest_plate.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option18" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option18" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/kashyyykian_hunting/armor_kashyyykian_hunting_bracer_r.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option19" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option19" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/kashyyykian_hunting/armor_kashyyykian_hunting_bracer_l.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option20" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option20" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/ithorian_sentinel/ith_armor_s03_leggings.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option21" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option21" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/ithorian_sentinel/ith_armor_s03_chest_plate.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option22" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option22" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/ithorian_sentinel/ith_armor_s03_helmet.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option23" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option23" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/ithorian_sentinel/ith_armor_s03_bicep_r.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                                       
                    
                    
                    
                end
            end
        end
        -- end of the conversation logic.
        return nextConversationScreen
    end
    function myswg_vendor_convo_handler:runScreenHandlers(conversationTemplate, conversingPlayer, conversingNPC, selectedOption, conversationScreen)
    -- Plays the screens of the conversation.
    return conversationScreen
end