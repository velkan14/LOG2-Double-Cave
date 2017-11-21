
------------------------------------------------------------------------
-- Dialogue Questionaire
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
	local page = {
		speakerName = "Red Wizard",
		speakerMessage = "You're alive! That's some good news.",
		onFinish = self.go.id..".script._introCallback",
		responses = 5,
		leftLabel = "Not at all",
		rightLabel = "Extremely"
	}

	GTKGui.Form.showDialoguePage(page);
end

function _introCallback(response)

	if ( response == 1 ) then
		print("response 1")
	end

	if ( response == 2 ) then
		print("response 2")
	end

	if ( response == 3 ) then
		print("response 3")
	end

	if ( response == 4 ) then
		print("response 4")
	end
	if ( response == 5 ) then
		print("response 5")
	end

end

function _faceWizard(name)
	local red = findEntity(name)
	party:setPosition(party.x, party.y, getDirection(red.x - party.x, red.y - party.y), party.elevation, party.level)
end
