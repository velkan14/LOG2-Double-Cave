
------------------------------------------------------------------------
-- Dialogue Questionaire
--
-- An example of using the dialogue system manually to make more custom
-- conversations.
------------------------------------------------------------------------

isDone = false;
lastQuestion = nil;
result = ""

questionaireForm = {
	name = "questionaire",
	children = {
		{
			number = 1,
			name = "question1",
			question = "I was interested in the game's story",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 2,
			name = "question2",
			question = "I felt successeful.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 3,
			name = "question3",
			question = "I felt bored.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 4,
			name = "question4",
			question = "I found it impressive.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 5,
			name = "question5",
			question = "I forgot everything around me.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 6,
			name = "question6",
			question = "I felt frustated.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 7,
			name = "question7",
			question = "I found it tiresome.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 8,
			name = "question8",
			question = "I felt irritable.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 9,
			name = "question9",
			question = "I felt skilful.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 10,
			name = "question10",
			question = "I felt content.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 11,
			name = "question11",
			question = "I felt challenged.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 12,
			name = "question12",
			question = "I had to put a lot of effort into it.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
		{
			number = 13,
			name = "question13",
			question = "I felt good.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Not at all"},
				{ text = "Slightly"},
				{ text = "Moderately"},
				{ text = "Fairly"},
				{ text = "Extremely"},
			},
			done = false
		},
	}
}


-- Public Functions (pressure plate methods)

function showDemoDialogue(sender)
	if(isDone) then
		return;
	end
	_showIntroPage()
	--_showQuestionaire()
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
		speakerMessage = "You've made it through the two dungeons. Amazing! Now it's time to compare the two.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "Okay!" },
			{ text = "Definitely the Red Dungeon." },
			{ text = "Definitely the Blue Dungeon." }
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _introCallback(response)

	if ( response == 1 ) then
		nextResponse = ""
	end

	if ( response == 2 or response == 3) then
		nextResponse = "Calm down... that's not how it works. "
	end

	_showSecondPage()
end

function _showSecondPage()

	local page = {
		speakerName = "Red Wizard",
		speakerMessage = nextResponse .. "My brother will ask you several question that you need to rate from 1 to 5 according to the following scale: 1 - not at all, 2 - slightly, 3 - moderately, 4 - fairly, 5 - extremely",
		onFinish = self.go.id..".script._secondCallback",
		responses = {
			{ text = "Let's start then."},
			{ text = "I'm ready."}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _secondCallback(response)
	_faceWizard("wizard_1")
	findEntity("wizard_1").monster:turnLeft();
	_showQuestionaire()
end

function _showThirdPage()

	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = nextResponse .. "Thank you! That's all the questions I had. Now we need to evaluate and decide the better dungeon. You have been really helpful.",
		onFinish = self.go.id..".script._thirdCallback",
		responses = {
			{ text = "No problem."},
			{ text = "It was a pleasure."},
			{ text = "Can I go now?"}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _thirdCallback(response)
	_faceWizard("wizard_1")
	findEntity("wizard_1").monster:turnLeft();
	_showQuestionaire()
end

function _showQuestionaire()
	local isDoneLocal = true;
	for _, question in ipairs(questionaireForm.children) do
		if(not question.done) then
			isDoneLocal = false;
			lastQuestion = question
			_showPage(question)
			break
		end
	end

	if(isDoneLocal) then
		local scroll = spawn("scroll", 1, 18, 14, 0, 0)
		local slot = nil
		local champion = party.party:getChampionByOrdinal(1)
		for i = ItemSlot.BackpackFirst, ItemSlot.BackpackLast do
			if (champion:getItem(i) == nil) then
				slot = i
				break
			end
		end
		scroll.scrollitem:setTextAlignment("left")
		scroll.scrollitem:setScrollText(result)
		champion:insertItem(slot, scroll.item)
		hudPrint("You got a scroll with your answers.")
		isDone = true

		findEntity("red_wizard_1").monster:turnLeft();
		findEntity("wizard_1").monster:turnRight();
	end
end

function _showPage(question)
	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = question.question,
		onFinish = self.go.id..".script._callback",
		responses = question.responses
	}
	GTKGui.Dialogue.showDialoguePage(page);
	--local page = {
	--	speakerName = speaker,
	--	speakerMessage = question.name,
	--	onFinish = self.go.id..".script._callback",
	--	responses = numberResponses,
	--	leftLabel = question.leftLabel,
	--	rightLabel = question.rightLabel
	--}

	--GTKGui.Form.showFormPage(page);
end

function _callback(response)
	if(lastQuestion ~= nil) then
		lastQuestion.response = response;
		lastQuestion.done = true
		result = result .. lastQuestion.number .. ". " .. lastQuestion.question .. "\n" .. lastQuestion.response .."\n\n"
	end
	_showQuestionaire()
end

function _faceWizard(name)
	local red = findEntity(name)
	party:setPosition(party.x, party.y, getDirection(red.x - party.x, red.y - party.y), party.elevation, party.level)
end
