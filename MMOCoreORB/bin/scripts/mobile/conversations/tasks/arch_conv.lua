masterarch_template = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "masterarch_convo_handler",
    screens = {}
}
masterarch_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "I sell structures! See anything you like?",
    stopConversation = "false",
    options = { 
        --{"Doc/Ent Buffs - 5k", "buff1"},
        --{"1500 Health/Action Buffs - 10k", "buff2"},
        {"Small Generic House - 25k", "option1"},
        {"Medium Generic House - 50k", "option2"},
        {"Clothing Factory Deed - 50k", "option3"},
        {"Food Factory Deed - 50k", "option4"},
        {"item Factory Deed - 50k", "option5"},
        {"Structure Factory Deed - 50k", "option6"},
--        {"", "option7"},
--        {"", "option8"},
--        {"", "option9"},
--        {"", "option10"},
        {"No thank you.", "deny_quest"}, 
    }
}
masterarch_template:addScreen(masterarch_first_screen);
masterarch_accept_quest = ConvoScreen:new {    
    id = "buff1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "buff2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option8",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option9",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_accept_quest = ConvoScreen:new {    
    id = "option10",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterarch_template:addScreen(masterarch_accept_quest);
masterarch_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, ya'll have a nice day. Ya hear!",
    stopConversation = "true",
    options = { }
}
masterarch_template:addScreen(masterarch_deny_quest);
masterarch_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
    stopConversation = "true",
    options = { }
}
masterarch_template:addScreen(masterarch_insufficient_funds);
masterarch_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item. Please make some space and try again.",    
    stopConversation = "true",  
    options = { }
}
masterarch_template:addScreen(masterarch_insufficient_space);
addConversationTemplate("masterarch_template", masterarch_template);