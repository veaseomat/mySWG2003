myswg_vendor = ScreenPlay:new {                
    numberOfActs = 1,                
    questString = "myswg_vendor_task",                   
    states = {}, 
}
registerScreenPlay("myswg_vendor", true)
function myswg_vendor:start()     
    -- Spawn our character into the world, setting pLarry a pointer variable we can use to check or change his state. 
    local pWeaponsmith = spawnMobile("corellia", "myswg_vendor", 1, -157, 28.0, -4724, 35, 0 )--cnet
    local pWeaponsmith1 = spawnMobile("corellia", "myswg_vendor", 1, -5042, 21.0, -2297, 35, 0 )--tyrena
    local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, -3138, 31.0, 2796, 35, 0 )--korvella   
    local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, 3333, 308.0, 5524, 35, 0 )--doaba   
    local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, -5550, 15.58, -6061, 35, 0 )--venri  
		local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, 6643.02,330.00,-5920.87, 35, 0 )--belav  

    local pWeaponsmith3 = spawnMobile("naboo", "myswg_vendor", 1, -4872, 6.0, 4151, 35, 0 )--theed
    local pWeaponsmith4 = spawnMobile("naboo", "myswg_vendor", 1, 4807, 4.0, -4705, 35, 0 )--moena
    local pWeaponsmith5 = spawnMobile("naboo", "myswg_vendor", 1, 5200, -192.0, 6677, 35, 0 )--kaadara
    local pWeaponsmith5 = spawnMobile("naboo", "myswg_vendor", 1, 1444, 14.0, 2777, 35, 0 )--keren
    local pWeaponsmith5 = spawnMobile("naboo", "myswg_vendor", 1, 5331.16,326.95,-1576.12, 35, 0 )--deja
    local pWeaponsmith5 = spawnMobile("naboo", "myswg_vendor", 1, -5495.62,-150.00,-24.69, 35, 0 )--lake ret
    
    local pWeaponsmith3 = spawnMobile("tatooine", "myswg_vendor", 1, 3522, 5.0, -4803, 35, 0 )--eisley
    local pWeaponsmith4 = spawnMobile("tatooine", "myswg_vendor", 1, -1281, 12.0, -3590, 35, 0 )--bestine
    local pWeaponsmith5 = spawnMobile("tatooine", "myswg_vendor", 1, -2914, 5.0, 2129, 35, 0 )--espa
    local pWeaponsmith5 = spawnMobile("tatooine", "myswg_vendor", 1, 1293, 7.0, 3140, 35, 0 )--entha
    local pWeaponsmith5 = spawnMobile("tatooine", "myswg_vendor", 1, 48.33,52.00,-5340.53, 35, 0 )--anc 
        
    local pWeaponsmith4 = spawnMobile("talus", "myswg_vendor", 1, -2193, 20.0, 2313, 35, 0 )--talus imp
    local pWeaponsmith4 = spawnMobile("talus", "myswg_vendor", 1, 4447, 2.0, 5271, 35, 0 )--nashal
    local pWeaponsmith4 = spawnMobile("talus", "myswg_vendor", 1, 338, 6.0, -2931, 35, 0 )--dearic
    
    local pWeaponsmith4 = spawnMobile("rori", "myswg_vendor", 1, 5365, 80.0, 5657, 35, 0 )--restuss
    local pWeaponsmith4 = spawnMobile("rori", "myswg_vendor", 1, -5305, 80.0, -2228, 35, 0 )--narmle             
    local pWeaponsmith4 = spawnMobile("rori", "myswg_vendor", 1, 3683, 96.0, -6436, 35, 0 )--reb
    
    local pWeaponsmith4 = spawnMobile("endor", "myswg_vendor", 1, -948, 73.0, 1550, 35, 0 )--smugglers
    local pWeaponsmith4 = spawnMobile("endor", "myswg_vendor", 1, 3201, 24.0, -3501, 35, 0 )--research
    
    local pWeaponsmith4 = spawnMobile("dantooine", "myswg_vendor", 1, -638, 3.0, 2505, 35, 0 )--mining
    local pWeaponsmith4 = spawnMobile("dantooine", "myswg_vendor", 1, -4209, 3.0, -2349, 35, 0 )--imp
    local pWeaponsmith4 = spawnMobile("dantooine", "myswg_vendor", 1, 1564, 4.0, -6415, 35, 0 )--aggro
    
    local pWeaponsmith4 = spawnMobile("dathomir", "myswg_vendor", 1, 619, 3.0, 3090, 35, 0 )--trade
    local pWeaponsmith4 = spawnMobile("dathomir", "myswg_vendor", 1, -47, 18.0, -1586, 35, 0 )--science
     
    local pWeaponsmith4 = spawnMobile("yavin4", "myswg_vendor", 1, -265, 35.0, 4897, 35, 0 )--mining
    local pWeaponsmith4 = spawnMobile("yavin4", "myswg_vendor", 1, 4053, 17.0, -6217, 35, 0 )--imp
    local pWeaponsmith4 = spawnMobile("yavin4", "myswg_vendor", 1, -6922, 73.0, -5730, 35, 0 )--labor
    
    local pWeaponsmith4 = spawnMobile("lok", "myswg_vendor", 1, 479, 8.0, 5512, 35, 0 )--lok
    
    local pWeaponsmith4 = spawnMobile("endor", "myswg_vendor", 1, -4964, 9.0, 3620, 35, 0 )--pcity
    local pWeaponsmith4 = spawnMobile("dantooine", "myswg_vendor", 1, -5731.72, 2.01,6574.19, 35, 0 )--pcity
    local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, -1453.02,10.00,-3211.87, 35, 0 )--pc  
    local pWeaponsmith5 = spawnMobile("tatooine", "myswg_vendor", 1, 5767.33,20.00,4408.53, 35, 0 )--pc
    local pWeaponsmith2 = spawnMobile("corellia", "myswg_vendor", 1, 3184.02,10.00,-6778.87, 35, 0 )--pc  
    local pWeaponsmith4 = spawnMobile("dathomir", "junk_dealer", 1, -4337, 0.0, 54, 35, 0 )--pc
    
    --junk dealers
    local pWeaponsmith4 = spawnMobile("endor", "junk_dealer", 1, -4679, 12.0, 4334, 35, 0 )--dwb
    local pWeaponsmith4 = spawnMobile("dathomir", "junk_dealer", 1, -3947, 124.0, -54, 35, 0 )--ns    
    local pWeaponsmith4 = spawnMobile("dantooine", "junk_dealer", 1, -615, 3.0, 2505, 35, 0 )--dant mo
    local pWeaponsmith4 = spawnMobile("dathomir", "junk_dealer", 1, 617, 3.0, 3090, 35, 0 )--trade
    local pWeaponsmith4 = spawnMobile("dathomir", "junk_dealer", 1, -45, 18.0, -1586, 35, 0 )--science
    local pWeaponsmith5 = spawnMobile("tatooine", "junk_dealer", 1, 6668.33,22.00,4245.53, 35, 0 )--gy 
                
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
                    
--                elseif (optionLink == "buff2" and credits < 10000000) then
--                    -- Bail if the player doesn’t have enough cash on hand.  
--                    -- Plays a chat box message from the NPC as well as a system message.
--                      nextConversationScreen = conversation:getScreen("insufficient_funds")
--                      creature:sendSystemMessage("You have insufficient funds") 
--                elseif (optionLink == "buff2" and credits >= 10000000) then
--                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
--                    creature:subtractCashCredits(10000000)
--                    local pItem = 
--										CreatureObject(conversingPlayer):enhanceCharacter()
--                    --giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
--                    --createLoot(pInventory, "junk", 300, false)


--WEAPONS
                elseif (optionLink == "option1" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option1" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/carbine/carbine_dxr6.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option2" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option2" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_t21.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option3" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option3" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/weapon/ranged/pistol/pistol_fwg5.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option4" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option4" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/baton/baton_gaderiffi.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option5" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option5" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/2h_sword/2h_sword_maul.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option6" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option6" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/polearm/polearm_vibro_axe.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option7" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option7" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/melee/special/vibroknuckler.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option8" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option8" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_lightning.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option9" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option9" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_flame_thrower.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option10" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option10" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/rifle/rifle_acid_beam.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option11" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option11" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/grenade/grenade_proton.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option55" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option55" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/weapon/ranged/heavy/heavy_rocket_launcher.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
--ARMORRRRRR
                elseif (optionLink == "option12" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option12" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
										
                    giveItem(pInventory, "object/tangible/wearables/armor/ubese/armor_ubese_pants.iff", -1)
                    --createLoot(pInventory, "composite_armor", 50, false)
                    
                elseif (optionLink == "option13" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option13" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/armor/ubese/armor_ubese_jacket.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option14" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option14" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/armor/ubese/armor_ubese_helmet.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option15" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option15" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/ubese/armor_ubese_bracer_l.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option16" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option16" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
										
                    giveItem(pInventory, "object/tangible/wearables/armor/chitin/armor_chitin_s01_leggings.iff", -1)
                    --createLoot(pInventory, "kashyyykian_hunting_armor", 50, false)
                    
                elseif (optionLink == "option17" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option17" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/chitin/armor_chitin_s01_chest_plate.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option18" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option18" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/chitin/armor_chitin_s01_helmet.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option19" and credits < 25000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option19" and credits >= 25000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(25000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/chitin/armor_chitin_s01_bracer_l.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option20" and credits < 250000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option20" and credits >= 250000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(250000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
										
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_leggings.iff", -1)
                    --createLoot(pInventory, "ithorian_sentinel_armor", 50, false)
                    
                elseif (optionLink == "option21" and credits < 250000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option21" and credits >= 250000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(250000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_chest_plate.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option22" and credits < 250000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option22" and credits >= 250000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(250000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_helmet.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option23" and credits < 250000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option23" and credits >= 250000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(250000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/wearables/armor/composite/armor_composite_bracer_l.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                                       
--ARTISAN
                elseif (optionLink == "option28" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option28" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option26" and credits < 1000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option26" and credits >= 1000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(1000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/crafting/station/generic_tool.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option27" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option27" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/wearables/backpack/backpack_s01.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option29" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option29" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/harvester_deed/harvester_ore_s2_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option30" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option30" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/harvester_deed/harvester_flora_deed_medium.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option31" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option31" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/harvester_deed/harvester_gas_deed_medium.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option32" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option32" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/harvester_deed/harvester_liquid_deed_medium.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option33" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option33" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/harvester_deed/harvester_moisture_deed_medium.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option24" and credits < 500) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option24" and credits >= 500) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(500)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/survey_tool/survey_tool_mineral.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option25" and credits < 500) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option25" and credits >= 500) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(500)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/survey_tool/survey_tool_liquid.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)

                elseif (optionLink == "option66" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option66" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/weapon_repair.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option67" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option67" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/armor_repair.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)        
                    
                elseif (optionLink == "option68" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option68" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/slicing/slicing_weapon_upgrade_kit.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option69" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option69" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/slicing/slicing_armor_upgrade_kit.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)        
                    
--TAILOR-------------------
                elseif (optionLink == "option70" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option70" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/component/clothing/reinforced_fiber_panels.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option71" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option71" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/component/clothing/synthetic_cloth.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)    
                    
                elseif (optionLink == "option76" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option76" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/component/clothing/fiberplast_panel.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
--ARCHITECT
                elseif (optionLink == "option34" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option34" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/deed/player_house_deed/generic_house_small_style_02_floor_02_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option35" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option35" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/deed/player_house_deed/generic_house_medium_style_02_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option36" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option36" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/deed/factory_deed/factory_clothing_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option37" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option37" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/factory_deed/factory_food_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option38" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option38" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/factory_deed/factory_item_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option39" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option39" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/deed/factory_deed/factory_structure_deed.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option72" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option72" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/clothing_station.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option73" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option73" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/food_station.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)   
                    
                elseif (optionLink == "option74" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option74" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/weapon_station.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option75" and credits < 50000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option75" and credits >= 50000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(50000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/crafting/station/structure_station.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)   
                    
--cheffff

                elseif (optionLink == "option40" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option40" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/food/crafted/dessert_air_cake.iff", -1)
                    --createLoot(pInventory, "food2", 300, false)--food2
                    
                elseif (optionLink == "option41" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option41" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/food/crafted/dish_crispic.iff", -1)
                    --createLoot(pInventory, "food1", 300, false)
                    
                elseif (optionLink == "option42" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option42" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacter()
                    giveItem(pInventory, "object/tangible/food/crafted/drink_vasarian_brandy.iff", -1)
                    --createLoot(pInventory, "food5", 300, false)
                    
                elseif (optionLink == "option43" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option43" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/food/crafted/drink_garrmorl.iff", -1)
                    --createLoot(pInventory, "food4", 300, false)
                    
                elseif (optionLink == "option44" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option44" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/food/crafted/drink_accarragm.iff", -1)
                    --createLoot(pInventory, "food3", 300, false)
                    
                elseif (optionLink == "option45" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option45" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/food/crafted/drink_blue_milk.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)                  


--LOOT
                elseif (optionLink == "option56" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option56" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "pistols", 20, false)
                elseif (optionLink == "option57" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option57" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "carbines", 20, false)  
                elseif (optionLink == "option58" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option58" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "rifles", 20, false)
                elseif (optionLink == "option59" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option59" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "melee_knife", 20, false)   
                 elseif (optionLink == "option60" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option60" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "melee_two_handed", 20, false)    
                 elseif (optionLink == "option61" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option61" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "melee_polearm", 20, false)                                    
                 elseif (optionLink == "option62" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option62" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "melee_unarmed", 20, false)
                 elseif (optionLink == "option63" and credits < 15000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option63" and credits >= 15000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(15000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "heavy_weapons_rifle", 20, false)    



                elseif (optionLink == "option46" and credits < 200000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option46" and credits >= 200000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(200000)
                    local pItem = 
                    giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option49" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option49" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "weapons_all", 300, false)
                    
                elseif (optionLink == "option48" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option48" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "armor_all", 300, false)
                    
                elseif (optionLink == "option47" and credits < 100000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option47" and credits >= 100000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(100000)
                    local pItem = 
                    --giveItem(pInventory, "object/tangible/veteran_reward/resource.iff", -1)
                    createLoot(pInventory, "wearables_all", 300, false)
                    
--DOCTOR
                    
                elseif (optionLink == "buff1" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "buff1" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                   
										CreatureObject(conversingPlayer):enhanceCharacter()
										--buffTerminalMenuComponent:logUsage(conversingPlayer, "enhanceCharacter")
                    --giveItem(pInventory, "object/tangible/deed/vehicle_deed/speederbike_deed.iff", -1)
                    --createLoot(pInventory, "junk", 1, false)
                    
                elseif (optionLink == "buff2" and credits < 20000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "buff2" and credits >= 20000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(20000)

										CreatureObject(conversingPlayer):enhanceCharacterDocBuff()

                elseif (optionLink == "buff3" and credits < 30000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "buff3" and credits >= 30000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(30000)

										CreatureObject(conversingPlayer):enhanceCharacterDocBuffTHREE()

                elseif (optionLink == "buff4" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "buff4" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    
	                  creature:subtractCashCredits(10000)
	                  
										CreatureObject(conversingPlayer):enhanceCharacterEntBuffONE()

                elseif (optionLink == "buff5" and credits < 20000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "buff5" and credits >= 20000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    
	                  creature:subtractCashCredits(20000)

										CreatureObject(conversingPlayer):enhanceCharacterEntBuffTWO()


                elseif (optionLink == "option50" and credits < 500) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option50" and credits >= 500) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(500)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_a.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option51" and credits < 1000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option51" and credits >= 1000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(1000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_b.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option52" and credits < 2000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option52" and credits >= 2000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(2000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_c.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option53" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option53" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_d.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                    
                elseif (optionLink == "option54" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option54" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/medicine/crafted/crafted_stimpack_sm_s1_e.iff", -1)
                    --createLoot(pInventory, "junk", 300, false)
                       
--DROIDS  
                    
                elseif (optionLink == "option64" and credits < 5000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option64" and credits >= 5000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(5000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/mission/mission_bounty_droid_seeker.iff", -1)
                    --createLoot(pInventory, "junk", 300, false) 
                    
                elseif (optionLink == "option65" and credits < 10000) then
                    -- Bail if the player doesn’t have enough cash on hand.  
                    -- Plays a chat box message from the NPC as well as a system message.
                      nextConversationScreen = conversation:getScreen("insufficient_funds")
                      creature:sendSystemMessage("You have insufficient funds") 
                elseif (optionLink == "option65" and credits >= 10000) then
                    -- Take 10,000 credits from the player’s cash on hand and give player a speederbike.
                    creature:subtractCashCredits(10000)
                    local pItem = 
										--CreatureObject(conversingPlayer):enhanceCharacterDocBuff()
                    giveItem(pInventory, "object/tangible/mission/mission_bounty_droid_probot.iff", -1)
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