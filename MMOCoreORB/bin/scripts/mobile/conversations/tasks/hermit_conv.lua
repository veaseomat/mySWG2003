hermit_convotemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "librarian_handler",
	screens = {}
}

want_trivia = ConvoScreen:new {
	id = "want_trivia",
	leftDialog = "Stay awhile and listen...",
	stopConversation = "false",
	options = {
		{"of course","rant_1"},
		{"no thanks","good_bye"}
	}
}

hermit_convotemplate:addScreen(want_trivia);

rant_1 = ConvoScreen:new {
	id = "rant_1",
	leftDialog = "Many years ago I was just like you, oh nearly 2 decades ago now, so young and eager to conquer the galaxy like so many others, before the dark times. We didnt know how good we had it, now all we have are shadows of the past in a fading Galaxy.",
	stopConversation = "false",
	options = {
		{"I'd like to hear more","rant_2"},
		{"Good bye.","good_bye"}
	}
}

hermit_convotemplate:addScreen(rant_1);

rant_2 = ConvoScreen:new {
	id = "rant_2",
	leftDialog = "There were so many changes, we lost the things that meant most to us all those years ago... and yet we are still here. Nothing else has quite captured that original feeling has it? I know it surely hasnt for me, that's why I'm still here, wandering as you are today.",
	stopConversation = "false",
	options = {
		{"please continue","rant_3"},
		{"Good bye.","good_bye"}
	}
}

hermit_convotemplate:addScreen(rant_2);

rant_3 = ConvoScreen:new {
	id = "rant_3",
	leftDialog = "I've fought in countless battles, been to every corner of the galaxy, even in the vastness of space that I now look up and wonder if I'll ever get to see it again. Friends and enemies made and lost forever, did we ever know that one day it would be the last time we spoke with one another? I try not to think about all those great acquaintences that made the Galaxy what it was.",
	stopConversation = "false",
	options = {
		{"go on","rant_4"},
		{"Good bye.","good_bye"}
	}
}

hermit_convotemplate:addScreen(rant_3);

rant_4 = ConvoScreen:new {
	id = "rant_4",
	leftDialog = "But it gives me great hope meeting you here today. I see a light in your eyes I've not seen in years. I think we are more similar than you realize. I know, how about a test? A test of character if you'll humor me.",
	stopConversation = "false",
	options = {
		{"Okay, I'll take a test","question_1"},
		{"No thanks, I must be going.","good_bye"}
	}
}

hermit_convotemplate:addScreen(rant_4);

good_bye = ConvoScreen:new {
	id = "good_bye",
	leftDialog = "@celebrity/librarian:good_bye",
	stopConversation = "true",
	options = {
	}
}

hermit_convotemplate:addScreen(good_bye);

question_1 = ConvoScreen:new {
	id = "question_1",
	leftDialog = "Very well lets begin, true of false? the first version of jedi on SWG featured 5 jedi skill trees.",
	stopConversation = "false",
	options = {
		{"True","question_1a"},
		{"False","question_1b"}
	}
}

hermit_convotemplate:addScreen(question_1);

question_1a = ConvoScreen:new {
	id = "question_1a",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_2"}
	}
}

hermit_convotemplate:addScreen(question_1a);

question_1b = ConvoScreen:new {
	id = "question_1b",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_2"}
	}
}

hermit_convotemplate:addScreen(question_1b);

question_2 = ConvoScreen:new {
	id = "question_2",
	leftDialog = "True or false? ==.",
	stopConversation = "false",
	options = {
		{"True","question_2a"},
		{"False","question_2b"}
	}
}

hermit_convotemplate:addScreen(question_2);

question_2a = ConvoScreen:new {
	id = "question_2a",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_3"}
	}
}

hermit_convotemplate:addScreen(question_2a);

question_2b = ConvoScreen:new {
	id = "question_2b",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_3"}
	}
}

hermit_convotemplate:addScreen(question_2b);

question_3 = ConvoScreen:new {
	id = "question_3",
	leftDialog = "True or false? Violence is the supreme authority from which all authority is derived.",
	stopConversation = "false",
	options = {
		{"True","question_3a"},
		{"False","question_3b"}
	}
}

hermit_convotemplate:addScreen(question_3);

question_3a = ConvoScreen:new {
	id = "question_3a",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_4"}
	}
}

hermit_convotemplate:addScreen(question_3a);

question_3b = ConvoScreen:new {
	id = "question_3b",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_4"}
	}
}

hermit_convotemplate:addScreen(question_3b);

question_4 = ConvoScreen:new {
	id = "question_4",
	leftDialog = "True or false? The Force .",
	stopConversation = "false",
	options = {
		{"True","question_4a"},
		{"False","question_4b"}
	}
}

hermit_convotemplate:addScreen(question_4);

question_4a = ConvoScreen:new {
	id = "question_4a",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_5"}
	}
}

hermit_convotemplate:addScreen(question_4a);

question_4b = ConvoScreen:new {
	id = "question_4b",
	leftDialog = "interesting, ready for the next question?",
	stopConversation = "false",
	options = {
		{"ready","question_5"}
	}
}

hermit_convotemplate:addScreen(question_4b);

question_5 = ConvoScreen:new {
	id = "question_5",
	leftDialog = "@celebrity/librarian:question_5",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_5);

question_6 = ConvoScreen:new {
	id = "question_6",
	leftDialog = "@celebrity/librarian:question_6",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_6);

question_7 = ConvoScreen:new {
	id = "question_7",
	leftDialog = "@celebrity/librarian:question_7",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_7);

question_8 = ConvoScreen:new {
	id = "question_8",
	leftDialog = "@celebrity/librarian:question_8",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_8);

question_9 = ConvoScreen:new {
	id = "question_9",
	leftDialog = "@celebrity/librarian:question_9",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_9);

question_10 = ConvoScreen:new {
	id = "question_10",
	leftDialog = "@celebrity/librarian:question_10",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_10);

question_11 = ConvoScreen:new {
	id = "question_11",
	leftDialog = "@celebrity/librarian:question_11",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_11);

question_12 = ConvoScreen:new {
	id = "question_12",
	leftDialog = "@celebrity/librarian:question_12",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_12);

question_13 = ConvoScreen:new {
	id = "question_13",
	leftDialog = "@celebrity/librarian:question_13",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_13);

question_14 = ConvoScreen:new {
	id = "question_14",
	leftDialog = "@celebrity/librarian:question_14",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_14);

question_15 = ConvoScreen:new {
	id = "question_15",
	leftDialog = "@celebrity/librarian:question_15",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_15);

question_16 = ConvoScreen:new {
	id = "question_16",
	leftDialog = "@celebrity/librarian:question_16",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_16);

question_17 = ConvoScreen:new {
	id = "question_17",
	leftDialog = "@celebrity/librarian:question_17",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_17);

question_18 = ConvoScreen:new {
	id = "question_18",
	leftDialog = "@celebrity/librarian:question_18",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_18);

question_19 = ConvoScreen:new {
	id = "question_19",
	leftDialog = "@celebrity/librarian:question_19",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_19);


question_20 = ConvoScreen:new {
	id = "question_20",
	leftDialog = "@celebrity/librarian:question_20",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(question_20);

winner_is_you = ConvoScreen:new {
	id = "winner_is_you",
	leftDialog = "@celebrity/librarian:winner_is_you",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(winner_is_you);

too_bad_so_sad = ConvoScreen:new {
	id = "too_bad_so_sad",
	leftDialog = "@celebrity/librarian:too_bad_so_sad",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(too_bad_so_sad);

worst_ever_guesser = ConvoScreen:new {
	id = "worst_ever_guesser",
	leftDialog = "@celebrity/librarian:worst_ever_guesser",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(worst_ever_guesser);

you_are_right = ConvoScreen:new {
	id = "you_are_right",
	leftDialog = "@celebrity/librarian:you_are_right",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(you_are_right);

good_answer = ConvoScreen:new {
	id = "good_answer",
	leftDialog = "@celebrity/librarian:good_answer",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(good_answer);

correct = ConvoScreen:new {
	id = "correct",
	leftDialog = "@celebrity/librarian:correct",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(correct);

correctamundo = ConvoScreen:new {
	id = "correctamundo",
	leftDialog = "@celebrity/librarian:correctamundo",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(correctamundo);

you_got_it = ConvoScreen:new {
	id = "you_got_it",
	leftDialog = "@celebrity/librarian:you_got_it",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(you_got_it);

thats_not_it = ConvoScreen:new {
	id = "thats_not_it",
	leftDialog = "@celebrity/librarian:thats_not_it",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(thats_not_it);

no_sir = ConvoScreen:new {
	id = "no_sir",
	leftDialog = "@celebrity/librarian:no_sir",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(no_sir);

you_are_wrong = ConvoScreen:new {
	id = "you_are_wrong",
	leftDialog = "@celebrity/librarian:you_are_wrong",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(you_are_wrong);

incorrect = ConvoScreen:new {
	id = "incorrect",
	leftDialog = "@celebrity/librarian:incorrect",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(incorrect);

buzz_wrong_answer = ConvoScreen:new {
	id = "buzz_wrong_answer",
	leftDialog = "@celebrity/librarian:buzz_wrong_answer",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(buzz_wrong_answer);

couldnt_be_wronger = ConvoScreen:new {
	id = "couldnt_be_wronger",
	leftDialog = "@celebrity/librarian:couldnt_be_wronger",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(couldnt_be_wronger);

most_wrong = ConvoScreen:new {
	id = "most_wrong",
	leftDialog = "@celebrity/librarian:most_wrong",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(most_wrong);

bad_answer = ConvoScreen:new {
	id = "bad_answer",
	leftDialog = "@celebrity/librarian:bad_answer",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(bad_answer);

most_unfortunate = ConvoScreen:new {
	id = "most_unfortunate",
	leftDialog = "@celebrity/librarian:most_unfortunate",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(most_unfortunate);

most_incorrect = ConvoScreen:new {
	id = "most_incorrect",
	leftDialog = "@celebrity/librarian:most_incorrect",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(most_incorrect);

worst_answer_ever = ConvoScreen:new {
	id = "worst_answer_ever",
	leftDialog = "@celebrity/librarian:worst_answer_ever",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(worst_answer_ever);

wrongest = ConvoScreen:new {
	id = "wrongest",
	leftDialog = "@celebrity/librarian:wrongest",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(wrongest);

wrong_squared = ConvoScreen:new {
	id = "wrong_squared",
	leftDialog = "@celebrity/librarian:wrong_squared",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(wrong_squared);

you_are_weakest_link = ConvoScreen:new {
	id = "you_are_weakest_link",
	leftDialog = "@celebrity/librarian:you_are_weakest_link",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(you_are_weakest_link);

not_even_trying = ConvoScreen:new {
	id = "not_even_trying",
	leftDialog = "@celebrity/librarian:not_even_trying",
	stopConversation = "false",
	options = {
	}
}

hermit_convotemplate:addScreen(not_even_trying);

done = ConvoScreen:new {
	id = "done",
	leftDialog = "@celebrity/librarian:done",
	stopConversation = "false",
	options = {
		{"@celebrity/librarian:thanks","answered_all"}
	}
}

hermit_convotemplate:addScreen(done);

answered_all = ConvoScreen:new {
	id = "answered_all",
	leftDialog = "@celebrity/librarian:answered_all",
	stopConversation = "true",
	options = {
	}
}

hermit_convotemplate:addScreen(answered_all);

addConversationTemplate("hermit_convotemplate", hermit_convotemplate);
