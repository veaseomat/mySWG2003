myswg_vendor_conv = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "myswg_vendor_convo_handler",
    screens = {}
}
myswg_vendor_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "What are you looking for?",
    stopConversation = "false",
    options = { 
        {"Weapons", "weaps1"},
        {"Armor", "armor1"},
 
    }
}
myswg_vendor_conv:addScreen(myswg_vendor_first_screen);

myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "weaps1",
    leftDialog = "",
    customDialogText = "I sell weapons! looking to buy?",
    stopConversation = "false",
    options = { 
        {"E11 Carbine - 50k", "option1"},
        {"E11 Rifle - 50k", "option2"},
        {"FWG5 Pistol - 50k", "option3"},
        {"1h Stun Baton - 50k", "option4"},
        {"2h Cleaver- 50k", "option5"},
        {"Polearm Vibrolance - 50k", "option6"},
        {"Vibro Knuckler - 50k", "option7"},
        {"Light Lightning Cannon - 50k", "option8"},
        {"Flame Thrower - 50k", "option9"},
        {"Heavy Acid Rifle - 50k", "option10"},
        {"Proton Grenade - 50k", "option11"},
        {"No thank you.", "deny_quest"},
    }
}
myswg_vendor_accept_quest = ConvoScreen:new {    
    id = "armor1",
    leftDialog = "",
    customDialogText = "I sell armor! looking to buy?",
    stopConversation = "false",
    options = { 
        {"Composite Leggings - 50k", "option12"},
        {"Composite Chest Plate - 50k", "option13"},
        {"Composite Helmet - 50k", "option14"},
        {"Composite Right Bracer - 50k", "option15"},
        {"Wookie hunting leggings - 50k", "option16"},
        {"Wookie hunting chest plate - 50k", "option17"},
        {"Wookie hunting right bracer - 50k", "option18"},
        {"Wookie hunting left bracer - 50k", "option19"},
        {"Ithorian sentinel leggings - 50k", "option20"},
        {"Ithorian sentinel chest plate - 50k", "option21"},
        {"Ithorian sentinel helmet - 50k", "option22"},
        {"Ithorian sentinel right bicep - 50k", "option23"},                               
        {"No thank you.", "deny_quest"}, 
    }
}

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
myswg_vendor_conv:addScreen(myswg_vendor_accept_quest);
myswg_vendor_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, ya'll have a nice day. Ya hear!",
    stopConversation = "true",
    options = { }
}
myswg_vendor_conv:addScreen(myswg_vendor_deny_quest);
myswg_vendor_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
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