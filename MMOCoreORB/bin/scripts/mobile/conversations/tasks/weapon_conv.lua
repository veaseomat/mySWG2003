masterweapon_template = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "masterweapon_convo_handler",
    screens = {}
}
masterweapon_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "I sell weapons! looking to buy?",
    stopConversation = "false",
    options = { 
        --{"Doc/Ent Buffs - 5k", "buff1"},
        --{"1500 Health/Action Buffs - 10k", "buff2"},
        {"Laser Carbine - 25k", "option1"},
        {"Laser Rifle - 25k", "option2"},
        {"FWG5 Pistol - 25k", "option3"},
        {"1h Curved Sword - 25k", "option4"},
        {"2h Curved Sword - 25k", "option5"},
        {"Lance - 25k", "option6"},
        {"Vibro Knuckler - 25k", "option7"},
        {"Light Lightning Cannon - 25k", "option8"},
        {"Flame Thrower - 25k", "option9"},
        {"Heavy Acid Rifle - 25k", "option10"},
        {"No thank you.", "deny_quest"},
    }
}
masterweapon_template:addScreen(masterweapon_first_screen);
masterweapon_accept_quest = ConvoScreen:new {    
    id = "buff1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "buff2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option8",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option9",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_accept_quest = ConvoScreen:new {    
    id = "option10",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterweapon_template:addScreen(masterweapon_accept_quest);
masterweapon_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, ya'll have a nice day. Ya hear!",
    stopConversation = "true",
    options = { }
}
masterweapon_template:addScreen(masterweapon_deny_quest);
masterweapon_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
    stopConversation = "true",
    options = { }
}
masterweapon_template:addScreen(masterweapon_insufficient_funds);
masterweapon_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item. Please make some space and try again.",    
    stopConversation = "true",  
    options = { }
}
masterweapon_template:addScreen(masterweapon_insufficient_space);
addConversationTemplate("masterweapon_template", masterweapon_template);