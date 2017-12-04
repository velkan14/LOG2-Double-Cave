
------------------------------------------------------------------------
-- Dialogue Intro of The Wizards
--
-- An example of using the dialogue system manually to make more custom
-- conversations.
------------------------------------------------------------------------
isDone = false;
nextResponse = "";
nextSpeaker = "";

-- Public Functions (pressure plate methods)

function showDemoDialogue(sender)
	if(isDone) then
		return;
	end

	_showIntroPage();
end

function hideDemoDialogue()
	GTKGui.Dialogue.hideDialogue();
end

-- Internal Methods

function _showIntroPage()

	_faceWizard("wizard_1")
	findEntity("wizard_1").monster:turnLeft();

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = "Hello Adventurer! I see you find our great castle.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "Hello!" },
			{ text = "Who are you?" },
			{ text = "I'm scared..." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _introCallback(response)

	if ( response == 1 ) then
		nextResponse = "Greetings! "
	end

	if ( response == 2 ) then
		nextResponse = ""
	end

	if ( response == 3 ) then
		nextResponse = "There's no reason to be scared!"
	end
	_showSecondPage()
end


function _showSecondPage()

	_faceWizard("red_wizard_1")
	findEntity("red_wizard_1").monster:turnRight();

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = nextResponse .. "We are the shifty brothers, sons of the old and mighty king Valentine. You might have heard of us?",
		onFinish = self.go.id..".script._secondCallback",
		responses = {
			{ text = "Never heard about you."},
			{ text = "It does ring a bell..."},
			{ text = "Urgh…"}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _secondCallback(response)

	if ( response == 1 ) then
		nextResponse = "Nonsense! "
	end

	if ( response == 2 ) then
		nextResponse = "Of course it does! "
	end

	if ( response == 3 ) then
		nextResponse = ""
	end
	_showThirdPage()
end

function _showThirdPage()

	_faceWizard("red_wizard_1")

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = nextResponse .. "The king Valentine is the greatest king ever and rules the kingdom with fear and despair. ",
		onFinish = self.go.id..".script._thirdCallback",
		responses = {
			{ text = "That doesn't seem good…"},
			{ text = "Amazing, can I join your crew?"},
			{ text = "Where is the nearest exit?!"}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _thirdCallback(response)

	if ( response == 1 ) then
		nenextResponse = "That's the point! "
	end

	if ( response == 2 ) then
		nextResponse = "We're not hiring yet. "
	end

	if ( response == 3 ) then
		nextResponse = "Hahaha, you're funny! "
	end
	_showFourthPage()
end

function _showFourthPage()

	_faceWizard("wizard_1")

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = nextResponse .. "Either way, I'm sure that soon one of us will be crowned after him!",
		onFinish = self.go.id..".script._fourthCallback",
		responses = {
			{ text = "Are you goin' to kill him?!" },
			{ text = "Good for you." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _fourthCallback(response)

	if ( response == 1 ) then
		nextResponse = "Don't be silly! He's old! "
	end

	if ( response == 2 ) then
		nextResponse = "Yes! "
	end
	_showFifthPage()
end

function _showFifthPage()

	_faceWizard("wizard_1")

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = nextResponse .. "He will crown one of us when we are ready. And I have a feeling it's soon. He asked us to fulfil the ultimate task!",
		onFinish = self.go.id..".script._fifthCallback",
		responses = {
			{ text = "It must be hard!"  },
			{ text = "I don't care." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _fifthCallback(response)

	if ( response == 1 ) then
		nextResponse = "It is! "
	end

	if ( response == 2 ) then
		nextResponse = ""
	end
	_showSixPage()
end

function _showSixPage()

	_faceWizard("red_wizard_1")

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = nextResponse .. "We need to protect the main dungeon that leads to our king's treasure, but we are in a hustle, because we don't agree on some stuff. Maybe you can help us, brave warrior.",
		onFinish = self.go.id..".script._sixCallback",
		responses = {
			{ text = "Of course!" },
			{ text = "How?"  },
			{ text = "Where's the exit…?" }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _sixCallback(response)

	if ( response == 1 ) then
		nextResponse = "That's the spirit! "
	end

	if ( response == 2 ) then
		nextResponse = "It must be easy for an adventurer like you. "
	end
	if ( response == 3 ) then
		nextResponse = "Don't be silly! "
	end
	_showSevenPage()
end

function _showSevenPage()

	_faceWizard("red_wizard_1")

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = nextResponse .. "All you need to do is test our dungeons and tell us which is better! We will start with one but we won't tell you if it's mine our my brother's dungeon.",
		onFinish = self.go.id..".script._sevenPageCallback",
		responses = {
			{ text = "Okay, we can start!", nextResponse = "" },
			{ text = "Why not?.", nextResponse = "" }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _sevenPageCallback(response)


	_faceWizard("wizard_1")
	nextSpeaker = "Wizard"

	if ( response == 1 ) then
		nextResponse ="I've created a teleporter that will take you to the dungeon B. But first I'll have to take your weapons away. Have fun!";
	end
	if ( response == 2 ) then
		nextResponse ="We have our reasons. I've created a teleporter that will take you to the dungeon B. But first I'll have to take your weapons away. Have fun!";
	end
	--local teleprt = spawn("teleporter", 1, 14, 14, 0, 0, "teleporter_red")
	--teleprt.teleporter:setTeleportTarget(3, 20, 11, 0)
	--teleprt.teleporter:setSpin("south")
	local teleprt = spawn("teleporter", 1, 14, 14, 0, 0, "teleporter_blue")
	teleprt.teleporter:setTeleportTarget(2, 20, 11, 0)
	teleprt.teleporter:setSpin("south")
	_showEightPage()
end

function _showEightPage()
	local page = {
		speakerName = nextSpeaker,
		speakerMessage = nextResponse,
		onFinish = self.go.id..".script._eightPageCallback",
		responses = {
			{ text = "Okay." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _eightPageCallback(response)
	for i=1,4 do
		for j=1,32 do
			party.party:getChampion(i):removeItemFromSlot(j);
		end
	end
	party.party:heal()
	isDone = true;
	findEntity("wizard_1").monster:turnRight();
	findEntity("red_wizard_1").monster:turnLeft();
end

function _faceWizard(name)
	local red = findEntity(name)
	party:setPosition(party.x, party.y, getDirection(red.x - party.x, red.y - party.y), party.elevation, party.level)
end
