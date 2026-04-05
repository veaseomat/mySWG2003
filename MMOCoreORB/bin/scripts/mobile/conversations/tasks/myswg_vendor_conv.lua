myswg_vendor_conv = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "myswg_vendor_convo_handler",
    screens = {}
}
myswg_vendor_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "What can I help you with?",
    stopConversation = "false",
    options = { 
        {"DOC/ENT BUFFS", "newbuff1"},
        {"Weapons", "weaps1"},
        {"Armor", "armor1"},
        {"Loot", "loot1"},
        {"Artisan", "art1"},
        {"Architect", "arch1"},
        {"Chef", "chef1"},        
        {"Medic", "doc1"},
        {"Droids", "droid1"},
       -- {"Tailor", "tailor1"},--needs work
                
			--	{"No thank you.", "deny_quest"},--not needed
    }
}
myswg_vendor_conv:addScreen(myswg_vendor_first_screen);

weaps1 = ConvoScreen:new {    
    id = "weaps1",
    leftDialog = "",
    customDialogText = "Selling weapons.",
    stopConversation = "false",
    options = { 
       -- {"Proton Grenades (150damage, 4.4speed) - 100k", "option11"},
      --  {"Heavy Rocket Launcher (150damage, 4.4speed) - 100k", "option55"},

        {"FWG5 Pistol (130damage, 3.2speed) - 25k", "option3"},
        {"DXR6 Carbine (143damage, 4.1speed) - 25k", "option1"},
        {"T21 Rifle	(360damage, 6.5speed) - 25k", "option2"},
        {"Vibro Knuckler (111damage, 2.5speed) - 25k", "option7"},
        {"1h Gaderiffi Baton (182damage, 4.0speed) - 25k", "option4"},
        {"2h Power Hammer (357damage, 4.8speed) - 25k", "option5"},
        {"Polearm Vibro Axe (364damage, 4.5speed) - 25k", "option6"},
        {"Light Lightning Cannon (730damage, 4.7speed) - 25k", "option8"},
        {"Flame Thrower (830damage, 6.0speed) - 25k", "option9"},
        {"Heavy Acid Rifle (770damage, 5.5speed) - 25k", "option10"},
        
        {"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(weaps1);

armor1 = ConvoScreen:new {    
    id = "armor1",
    leftDialog = "",
    customDialogText = "typical blue frog armor 80%sp/65%eff/25%stun.",
    stopConversation = "false",
    options = { 
        {"Composite Leggings - 100k", "option12"},
        {"Composite Chest Plate - 100k", "option13"},
        {"Composite Helmet - 100k", "option14"},
        {"Composite Right Bracer - 100k", "option15"},
        {"Wookie hunting leggings - 100k", "option16"},
        {"Wookie hunting chest plate - 100k", "option17"},
        {"Wookie hunting right bracer - 100k", "option18"},
        {"Wookie hunting left bracer - 100k", "option19"},
        {"Ithorian sentinel leggings - 100k", "option20"},
        {"Ithorian sentinel chest plate - 100k", "option21"},
        {"Ithorian sentinel helmet - 100k", "option22"},
        {"Ithorian sentinel right bicep - 100k", "option23"},                                
        {"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(armor1);


art1 = ConvoScreen:new {
    id = "art1",
    leftDialog = "",
    customDialogText = "I sell artisan stuff! Need anything?",
    stopConversation = "false",
    options = {
        {"Mineral survey tool - 500", "option24"},
        {"Chemical survey tool - 500", "option25"},
        {"Generic Crafting Tool - 1k", "option26"},
        {"Backpack - 5k", "option27"},
        --{"Weapon Repair Tool - 10k", "option66"},
        --{"Armor Repair Tool - 10k", "option67"},
        {"Weapon Upgrade Kit - 10k", "option68"},
        {"Armor Upgrade Kit - 10k", "option69"},  
        {"Speederbike (regular, not swoop) - 15k", "option28"},     
        
  --      {"Medium Mineral Harvester Deed - 50k", "option29"}, --needs work
	--      {"Medium Flora Harvester Deed - 50k", "option30"},
 --       {"Medium Gas Harvester Deed - 50k", "option31"},
 --       {"Medium Chemical Harvester Deed - 50k", "option32"},
--        {"Medium Moisture Harvester Deed - 50k", "option33"},
        {"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(art1);

arch1 = ConvoScreen:new {
    id = "arch1",
    leftDialog = "",
    customDialogText = "I sell structures! See anything you like?",
    stopConversation = "false",
    options = { 
        {"25 effectiveness Weapon/Item Crafting Station - 50k", "option74"},
        {"25 effectiveness Structure Crafting Station - 50k", "option75"},
      	{"25 effectiveness Clothing Crafting Station - 50k", "option72"},
        {"25 effectiveness Food Crafting Station - 50k", "option73"},
      	{"Small Generic House - 100k", "option34"},
--        {"Medium Generic House - 100k", "option35"},
        {"Clothing Factory Deed - 100k", "option36"},
        {"Food Factory Deed - 100k", "option37"},
        {"item Factory Deed - 100k", "option38"},
        {"Structure Factory Deed - 100k", "option39"},
        {"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(arch1);

chef1 = ConvoScreen:new {
    id = "chef1",
    leftDialog = "",
    customDialogText = "I sell food! See anything you like?",
    stopConversation = "false",
    options = { 
        {"Air Cake Dodge Food - 10k", "option40"},
        {"Crispic Accuracy Food - 10k", "option41"},
        {"Garrmorl Health Buff Drink - 10k", "option43"},
        {"Accarragm Action Buff Drink - 10k", "option44"},
        {"Vasarian Brandy Mind Buff Drink - 10k", "option42"},
        {"Blue Milk Mind Heal Drink - 10k", "option45"},
       	{"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(chef1);

loot1 = ConvoScreen:new {
    id = "loot1",
    leftDialog = "",
    customDialogText = "Would you like to buy some loot drops?",
    stopConversation = "false",
    options = { 
        {"free Resource Deed - 200k", "option46"},

        {"Random max lvl Pistol - 100k", "option56"},
        {"Random max lvl Carbine - 100k", "option57"},
        {"Random max lvl Rifle - 100k", "option58"},
        {"Random max lvl 1h sword - 100k", "option59"},
        {"Random max lvl 2h sword - 100k", "option60"},
        {"Random max lvl Polearm - 100k", "option61"},
				{"Random max lvl Unarmed - 100k", "option62"},        
				{"Random max lvl Hvy Weapon (flame/acid/LLC) - 100k", "option63"},
				              
        {"Random max lvl Clothing Loot - 25k", "option47"},
        {"Random max lvl Armor Loot - 100k", "option48"},
        {"Random max lvl Weapon Loot - 100k", "option49"},
        {"Random max lvl Krayt Tissue - 100k", "option77"},
        {"Random max lvl Krayt Pearl - 100k", "option78"},
        {"Holocron - 100k", "option79"},
       	--{"Jedi Holocron - 10mil", "option5"},--was never added?
        {"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(loot1);

doc1 = ConvoScreen:new {
    id = "doc1",
    leftDialog = "",
    customDialogText = "medical supplies, need anything?",
    stopConversation = "false",
    options = { 

        {"StimPack A - 500", "option50"},
        {"StimPack B - 1k", "option51"},
        {"StimPack C - 2k", "option52"},
        {"StimPack D - 5k", "option53"},
        {"StimPack E - 10k", "option54"},
      	{"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(doc1);

droid1 = ConvoScreen:new {
    id = "droid1",
    leftDialog = "",
    customDialogText = "droid stuff, need anything?",
    stopConversation = "false",
    options = { 

        {"Seeker Droid - 5k", "option64"},
        {"Probe Droid - 10k", "option65"},
      	{"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(droid1);

tailor1 = ConvoScreen:new {
    id = "tailor1",
    leftDialog = "",
    customDialogText = "Tailor stuff, need anything?",
    stopConversation = "false",
    options = { 
--        {"25 Fiberplast Panel - 5k", "option71"},    //not useable in crafting : /
--        {"25 Reinforced Fiber Panel - 5k", "option70"},
--        {"25 Synthetic Cloth- 5k", "option76"},     
        
      	{"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(tailor1);

newbuff1 = ConvoScreen:new {
    id = "newbuff1",
    leftDialog = "",
    customDialogText = "I sell buffs!",
    stopConversation = "false",
    options = { 
      -- 	{"Remove all buffs - FREE", "buff7"},--not working yet
        {"Heal all wounds - 5k", "buff6"},

        {"1500 doctor buffs 8hr - FREE", "buff1"},
        {"2500 Doctor Buffs 8hr - 25k", "buff2"},
        {"3500 Doctor Buffs 8hr - 50k", "buff3"},
        
        {"125% Entertainer Buffs 8hr - FREE", "buff4"},
        {"250% Entertainer Buffs 8hr - 20k", "buff5"},
 
      	{"Main menu.", "first_screen"},
    }
}
myswg_vendor_conv:addScreen(newbuff1);

myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "buff7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option8",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option9",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option10",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option11",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option12",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option13",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option14",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option15",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option16",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option17",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option18",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option19",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option20",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option21",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option22",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option23",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option24",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option25",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option26",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option27",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option28",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option29",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option30",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option31",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option32",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option33",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option34",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option35",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option36",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option37",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option38",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option39",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option40",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option41",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option42",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option43",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option44",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option45",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option46",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option47",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option48",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option49",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option50",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option51",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option52",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option53",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option54",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option55",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option56",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option57",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option58",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option59",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option60",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option61",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option62",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option63",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option64",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option65",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option66",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option67",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option68",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option69",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option70",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option71",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option72",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option73",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option74",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option75",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option76",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option77",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option78",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "option79",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_conv:addScreen(myswg_vendor_accept_quest);
myswg_vendor_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, have a nice day!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_conv:addScreen(myswg_vendor_deny_quest);
myswg_vendor_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough cash credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_conv:addScreen(myswg_vendor_insufficient_funds);
myswg_vendor_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item. Please make some space and try again.",    
    stopConversation = "true",  
    options = { }
}
myswg_vendor_conv:addScreen(myswg_vendor_insufficient_space);
addConversationTemplate("myswg_vendor_conv", myswg_vendor_conv);