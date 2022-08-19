mastermerchant_template = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "mastermerchant_convo_handler",
    screens = {}
}
mastermerchant_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "Would you like to buy a buff?",
    stopConversation = "false",
    options = { 
        {"speederbike - 10k", "option1"},
        {"crate of resources - 50k", "option2"},
        {"Random max lvl Clothing Loot - 50k", "option6"},
        {"Random max lvl Armor Loot - 50k", "option4"},
        {"Random max lvl Weapon Loot - 100k", "option3"},
       -- {"Jedi Holocron - 10mil", "option5"},
        {"No thank you.", "deny_quest"}, 
    }
}
mastermerchant_template:addScreen(mastermerchant_first_screen);
mastermerchant_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
mastermerchant_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
mastermerchant_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
mastermerchant_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
mastermerchant_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
mastermerchant_template:addScreen(mastermerchant_accept_quest);
mastermerchant_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, have a nice day!",
    stopConversation = "true",
    options = { }
}
mastermerchant_template:addScreen(mastermerchant_deny_quest);
mastermerchant_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that.",
    stopConversation = "true",
    options = { }
}
mastermerchant_template:addScreen(mastermerchant_insufficient_funds);
mastermerchant_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item.",    
    stopConversation = "true",  
    options = { }
}
mastermerchant_template:addScreen(mastermerchant_insufficient_space);
addConversationTemplate("mastermerchant_template", mastermerchant_template);