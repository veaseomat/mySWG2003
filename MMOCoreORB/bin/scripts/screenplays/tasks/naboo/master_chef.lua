MasterChef = ScreenPlay:new {                
    numberOfActs = 1,                
    questString = "masterchef_task",                   
    states = {}, 
}
registerScreenPlay("MasterChef", true)
function MasterChef:start()     
    -- Spawn our character into the world, setting pLarry a pointer variable we can use to check or change his state.   
    local pChef = spawnMobile("corellia", "master_chef", 1, -157, 28.0, -4733, 35, 0 )
--    local pLarry = spawnMobile("naboo", "merch_crazy_larry", 1, -4881, 6.0, 4150, 35, 0 )
end
masterchef_convo_handler = Object:new {
    tstring = "myconversation" 
}
function masterchef_convo_handler:getNextConversationScreen(conversationTemplate, conversingPlayer, selectedOption)            
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
                    
--                elseif (optionLink == "buff2" and credits < 10000) then
--                    -- Bail if the player doesn’t have enough cash on hand.  
--                    -- Plays a chat box message from the NPC as well as a system message.
--                      nextConversationScreen = conversation:getScreen("insufficient_funds")
--                      creature:sendSystemMessage("You have insufficient funds") 
--                elseif (optionLink == "buff2" and credits >= 10000) then
--                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
--                    creature:subtractCashCredits(10000)
--                    local pItem = 
--										CreatureObject(conversingPlayer):enhanceCharacter()
--                    --giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
--                    --createLoot(pInventory, "junk", 300, false)

                elseif (optionLink == "option1" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option1" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/food/crafted/dessert_air_cake.iff", -1)
                    --createLoot(pInventory, "food2", 300, false)--food2
                    
                elseif (optionLink == "option2" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option2" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    --giveItem(pInventory, "object/tangible/food/crafted/dish_crispic.iff", -1)
                    createLoot(pInventory, "food1", 300, false)
                    
                elseif (optionLink == "option3" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option3" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    --giveItem(pInventory, "object/tangible/food/crafted/drink_vasarian_brandy.iff", -1)
                    createLoot(pInventory, "food5", 300, false)
                    
                elseif (optionLink == "option4" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option4" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    --giveItem(pInventory, "object/tangible/food/crafted/drink_garrmorl.iff", -1)
                    createLoot(pInventory, "food4", 300, false)
                    
                elseif (optionLink == "option5" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option5" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    --giveItem(pInventory, "object/tangible/food/crafted/drink_accarragm.iff", -1)
                    createLoot(pInventory, "food3", 300, false)
                    
                elseif (optionLink == "option6" and credits < 100) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option6" and credits >= 100) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option7" and credits < 100) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option7" and credits >= 100) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option8" and credits < 100) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option8" and credits >= 100) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option9" and credits < 100) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option9" and credits >= 100) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option10" and credits < 100) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option10" and credits >= 100) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                end
            end
        end
        -- end of the conversation logic.
        return nextConversationScreen
    end
    function masterchef_convo_handler:runScreenHandlers(conversationTemplate, conversingPlayer, conversingNPC, selectedOption, conversationScreen)
    -- Plays the screens of the conversation.
    return conversationScreen
end