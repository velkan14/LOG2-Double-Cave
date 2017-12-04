
------------------------------------------------------------------------
-- Dialogue Red Dungeon completed
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

	_faceWizard("red_wizard_1")
	findEntity("red_wizard_1").monster:turnRight();

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = "You're alive! That's some good news.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "It was easy!" },
			{ text = "I like a good chalenge." },
			{ text = "I... almost... DIED!!!" }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _introCallback(response)

	if ( response == 1 ) then
		nextResponse = "Haha! "
	end

	if ( response == 2 ) then
		nextResponse = "You still have one more challenge! "
	end

	if ( response == 3 ) then
		nextResponse = "Since you are alive... "
	end
	_showSecondPage()
end


function _showSecondPage()

	_faceWizard("wizard_1")
	findEntity("wizard_1").monster:turnLeft();

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = nextResponse .. "Now it's time to try the dungeon B. Are you ready?",
		onFinish = self.go.id..".script._secondCallback",
		responses = {
			{ text = "Always ready for adventure."},
			{ text = "I'm tired."},
			{ text = "I'm still alive..."}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _secondCallback(response)

	if ( response == 1 ) then
		nextResponse = "That's the spirit! "
	end

	if ( response == 2 ) then
		nextResponse = "Let me heal you up! "
	end

	if ( response == 3 ) then
		nextResponse = "I love your humor! "
	end
	_showThirdPage()
end

function _showThirdPage()

	_faceWizard("wizard_1")

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = nextResponse .. "Let me just take away all your stuff, and you can enter the portal.",
		onFinish = self.go.id..".script._thirdCallback",
		responses = {
			{ text = "Okay."}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _thirdCallback(response)
	for i=1,4 do
		for j=1,32 do
			party.party:getChampion(i):removeItemFromSlot(j);
		end
	end
	party.party:heal()
	isDone = true;

	local teleprt = spawn("teleporter", 1, 14, 14, 0, 0, "teleporter_blue")
	teleprt.teleporter:setTeleportTarget(2, 20, 11, 0)
	teleprt.teleporter:setSpin("south")
	findEntity("wizard_1").monster:turnRight();
	findEntity("red_wizard_1").monster:turnLeft();
end


function _faceWizard(name)
	local red = findEntity(name)
	party:setPosition(party.x, party.y, getDirection(red.x - party.x, red.y - party.y), party.elevation, party.level)
end
