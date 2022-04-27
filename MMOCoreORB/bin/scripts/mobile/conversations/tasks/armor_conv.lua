masterarmor_template = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "masterarmor_convo_handler",
    screens = {}
}
masterarmor_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "I sell armor! looking to buy?",
    stopConversation = "false",
    options = { 
        --{"Doc/Ent Buffs - 5k", "buff1"},
        --{"1500 Health/Action Buffs - 10k", "buff2"},
        {"50% Composite Leggings - 50k", "option1"},
        {"50% Composite Chest Plate - 50k", "option2"},
        {"50% Composite Helmet - 50k", "option3"},
        {"50% Composite Right Bracer - 50k", "option4"},
--        {"", "option5"},
--        {"", "option6"},
--        {"", "option7"},
--        {"", "option8"},
--        {"", "option9"},
--        {"", "option10"},
        {"No thank you.", "deny_quest"}, 
    }
}
masterarmor_template:addScreen(masterarmor_first_screen);
masterarmor_accept_quest = ConvoScreen:new {    
    id = "buff1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "buff2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option8",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option9",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_accept_quest = ConvoScreen:new {    
    id = "option10",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarmor_template:addScreen(masterarmor_accept_quest);
masterarmor_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, ya'll have a nice day. Ya hear!",
    stopConversation = "true",
    options = { }
}
masterarmor_template:addScreen(masterarmor_deny_quest);
masterarmor_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
    stopConversation = "true",
    options = { }
}
masterarmor_template:addScreen(masterarmor_insufficient_funds);
masterarmor_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item. Please make some space and try again.",    
    stopConversation = "true",  
    options = { }
}
masterarmor_template:addScreen(masterarmor_insufficient_space);
addConversationTemplate("masterarmor_template", masterarmor_template);