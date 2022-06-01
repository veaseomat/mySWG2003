masterartisan_template = ConvoTemplate:new {
    initialScreen = "first_screen",
    templateType = "Lua",
    luaClassHandler = "masterartisan_convo_handler",
    screens = {}
}
masterartisan_first_screen = ConvoScreen:new {
    id = "first_screen",
    leftDialog = "",
    customDialogText = "I sell artisan stuff! Need anything?",
    stopConversation = "false",
    options = { 
        {"Mineral survey tool - 500", "option9"},
        {"Chemical survey tool - 500", "option10"},
        {"Generic Crafting Tool - 1k", "option2"},
        {"Backpack - 5k", "option3"},
        {"Speederbike - 10k", "option1"},
        {"Personal Mineral Harvester Deed - 25k", "option4"},
        {"Personal Flora Harvester Deed - 25k", "option5"},
        {"Personal Gas Harvester Deed - 25k", "option6"},
        {"Personal Chemical Harvester Deed - 25k", "option7"},
        {"Personal Moisture Harvester Deed - 25k", "option8"},
--        {"", "option9"},
--        {"", "option10"},
        {"No thank you.", "deny_quest"}, 
    }
}
masterartisan_template:addScreen(masterartisan_first_screen);
masterartisan_accept_quest = ConvoScreen:new {    
    id = "buff1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "buff2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option1",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option2",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option3",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option4",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option5",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option6",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option7",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option8",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option9",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_accept_quest = ConvoScreen:new {    
    id = "option10",
    leftDialog = "",
    customDialogText = "Enjoy!",
    stopConversation = "true",
    options = { }
}
masterartisan_template:addScreen(masterartisan_accept_quest);
masterartisan_deny_quest = ConvoScreen:new {
    id = "deny_quest",
    leftDialog = "",
    customDialogText = "Well, ya'll have a nice day. Ya hear!",
    stopConversation = "true",
    options = { }
}
masterartisan_template:addScreen(masterartisan_deny_quest);
masterartisan_insufficient_funds = ConvoScreen:new {
    id = "insufficient_funds",  
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough credits with you to purchase that. Head on over to the bank. I'll be here when ya get back!",
    stopConversation = "true",
    options = { }
}
masterartisan_template:addScreen(masterartisan_insufficient_funds);
masterartisan_insufficient_space = ConvoScreen:new {
    id = "insufficient_space",
    leftDialog = "", 
    customDialogText = "Sorry, but you don't have enough space in your inventory to accept the item. Please make some space and try again.",    
    stopConversation = "true",  
    options = { }
}
masterartisan_template:addScreen(masterartisan_insufficient_space);
addConversationTemplate("masterartisan_template", masterartisan_template);