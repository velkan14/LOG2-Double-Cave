
------------------------------------------------------------------------
-- Dialogue Intro of The Wizards
--
-- An example of using the dialogue system manually to make more custom
-- conversations.
------------------------------------------------------------------------
isDone = false;
nextResponse = "";
nextSpeaker = "";
firstDungeon = "";

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
	_WizardFaceYou()

	local page = {
		speakerName = "King",
		speakerMessage = "Hello Adventurer! I see you find my great castle.",
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
		nextResponse = "There's no reason to be scared! "
	end
	_showSecondPage()
end


function _showSecondPage()

	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "I am the mighty king Valentine. Surely you've heard of me?",
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
	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "I am the greatest king ever and I rule this kingdom with fear and despair. ",
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
		nextResponse = "I'm not hiring now. "
	end

	if ( response == 3 ) then
		nextResponse = "Hahaha, you're funny! "
	end
	_showFourthPage()
end

function _showFourthPage()
	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "Either way, I have two sons and soon I'll crown one of them!",
		onFinish = self.go.id..".script._fourthCallback",
		responses = {
			{ text = "That is nice." },
			{ text = "Which one will you pick?" },
			{ text = "Good for them." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _fourthCallback(response)

	if ( response == 1 ) then
		nextResponse = "I am nice! "
	end

	if ( response == 2 ) then
		nextResponse = "I haven't decided yet. "
	end
	if ( response == 3 ) then
		nextResponse = ""
	end
	_showFifthPage()
end

function _showFifthPage()

	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "I will crown one of them when I find out who is ready. So I asked them to fulfil the ultimate task!",
		onFinish = self.go.id..".script._fifthCallback",
		responses = {
			{ text = "It must be hard!"  },
				{ text = "How is the task?"  },
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
	if ( response == 3 ) then
		nextResponse = ""
	end
	_showSixPage()
end

function _showSixPage()

	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "They need to protect the main dungeon that leads to my treasure. Maybe you can help me decide which has the better protection.",
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

	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "All you need to do is test their dungeons and then I'll ask you some questions!",
		onFinish = self.go.id..".script._sevenPageCallback",
		responses = {
			{ text = "Okay, we can start!" },
			{ text = "Why not?." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _sevenPageCallback(response)
	local s = party.party:getChampionByOrdinal(1):getName()
	local d = s:sub(0,1)

	if ( d == "A" ) then
		firstDungeon = "A"
		local teleprt = spawn("teleporter", 1, 14, 14, 0, 0, "teleporter_red")
		teleprt.teleporter:setTeleportTarget(3, 20, 11, 0)
		teleprt.teleporter:setSpin("south")
	else
		firstDungeon = "B"
		local teleprt = spawn("teleporter", 1, 14, 14, 0, 0, "teleporter_blue")
		teleprt.teleporter:setTeleportTarget(2, 20, 11, 0)
		teleprt.teleporter:setSpin("south")
	end

	_showEightPage()
end

function _showEightPage()
	local page = {
		speakerName = "King Valentine",
		speakerMessage = "I've created a teleporter that will take you to the first dungeon. But first I'll have to take all your equipment. Have fun!",
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
	_WizardFaceReturn()

end

function _faceWizard(name)
	local red = findEntity(name)
	party:setPosition(party.x, party.y, getDirection(red.x - party.x, red.y - party.y), party.elevation, party.level)
end

function _WizardFaceYou()
	local x, y, t, p = party:getPosition()
	if(x == 16 and y == 14) then
		findEntity("wizard_1").monster:turnLeft();
	end
end

function _WizardFaceReturn()
	local x, y, t, p = party:getPosition()
	if(x == 16 and y == 14) then
		findEntity("wizard_1").monster:turnRight();
	end
end
