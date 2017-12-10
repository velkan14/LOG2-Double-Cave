
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
			question = "I felt content",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly on the first dungeon."},
				{ text = "Slightly on the first dungeon."},
				{ text = "No difference between the two."},
				{ text = "Slightly on the last dungeon."},
				{ text = "Clearly on the last dungeon"},
			},
			done = false
		},
		{
			number = 2,
			name = "question2",
			question = "I felt skilful.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 3,
			name = "question3",
			question = "I was interested in the game's story.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 4,
			name = "question4",
			question = "I through it was fun.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 5,
			name = "question5",
			question = "I was fully occupied with the game.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 6,
			name = "question6",
			question = "I felt happy.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 7,
			name = "question7",
			question = "It gave me a bad mood.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 8,
			name = "question8",
			question = "I tought about other things.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 9,
			name = "question9",
			question = "I found it tiresome.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 10,
			name = "question10",
			question = "I felt competent.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 11,
			name = "question11",
			question = "I tought it was hard.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 12,
			name = "question12",
			question = "It was aesthetically pleasing.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 13,
			name = "question13",
			question = "I forgot everything around me.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 14,
			name = "question14",
			question = "I felt good.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 15,
			name = "question15",
			question = "I was good at it.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 16,
			name = "question16",
			question = "I felt bored.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 17,
			name = "question17",
			question = "I felt successful.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 18,
			name = "question18",
			question = "I felt imaginative.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 19,
			name = "question19",
			question = "I felt that I could explore things.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 20,
			name = "question20",
			question = "I enjoyed it.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 21,
			name = "question21",
			question = "I was fast at reaching the game's targets.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 22,
			name = "question22",
			question = "I felt annoyed.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 23,
			name = "question23",
			question = "I felt pressured.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 24,
			name = "question24",
			question = "I felt irritable.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 25,
			name = "question25",
			question = "I lost track of time.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 26,
			name = "question26",
			question = "I felt challenged.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 27,
			name = "question27",
			question = "I found it impressive.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 28,
			name = "question28",
			question = "I was deeply concentrated in the game.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 29,
			name = "question29",
			question = "I felt frustated.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 30,
			name = "question30",
			question = "It felt like a rich experience.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 31,
			name = "question31",
			question = "I lost connection with the outside world.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 32,
			name = "question32",
			question = "I felt time pressure.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
		{
			number = 33,
			name = "question33",
			question = "I had to put a lot of effort into it.",
			speaker = "",
			response = -1,
			responses = {
				{ text = "Clearly A"},
				{ text = "Slightly A"},
				{ text = "No difference"},
				{ text = "Slightly B"},
				{ text = "Clearly B"},
			},
			done = false
		},
	}
}


-- Public Functions (pressure plate methods)

wasDead = false;
function setDeadTrue()
	wasDead = true
end

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
_faceWizard("wizard_1")
	_WizardFaceYou()

local page = {}
if(wasDead) then
	page = {
		speakerName = "King Valentine",
		speakerMessage = "You almost died! I had to pull you out of the dungeon. Now it's time to compare the two.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "Okay!" },
			{ text = "Definitely the first dungeon." },
			{ text = "Definitely the second dungeon." }
		}
	}
else
	page = {
		speakerName = "King Valentine",
		speakerMessage = "You've made it through the two dungeons. Amazing! Now it's time to compare the two.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "Okay!" },
			{ text = "Definitely the first dungeon." },
			{ text = "Definitely the second dungeon." }
		}
	}
end



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
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "I will show you several sentences that you need to rate according to the dungeon that represents better the topic.",
		onFinish = self.go.id..".script._secondCallback",
		responses = {
			{ text = "Let's start then."},
			{ text = "I'm ready."}
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _secondCallback(response)
	local s = party.party:getChampionByOrdinal(1):getName()
	local d = s:sub(0,1)
	if( d == "A") then
		result = "First Dungeon = A\n"
	else
		result = "First Dungeon = B\n"
	end
	_showQuestionaire()
end

function _showThirdPage()

	local page = {
		speakerName = "King Valentine",
		speakerMessage = "Thank you! That's all the questions I had. Now I need to evaluate and decide the better dungeon thanks to your answers. You have been really helpful.",
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
	if ( response == 1 or response == 2) then
		nextResponse = ""
	end

	if ( response == 3) then
		nextResponse = "Almost... "
	end
	_showFourthPage()
end

function _showFourthPage()

	local page = {
		speakerName = "King Valentine",
		speakerMessage = nextResponse .. "Go heal you up in the crystal and then come talk to me.",
		onFinish = self.go.id..".script._fourthCallback",
		responses = {
			{ text = "Okay."},
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _fourthCallback(response)
	isDone = true
	_WizardFaceReturn()
	findEntity("script_dialogue").script:setQuestionsTrue()
	findEntity("healing_crystal_2").clickable:addConnector("onClick", "script_dialogue", "setSavedTrue")
	findEntity("floor_trigger_18").floortrigger:removeConnector("onActivate", "castle_door_portcullis_2", "close")
	findEntity("castle_door_portcullis_2").door:open()
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
		_showThirdPage()
	end
end

function _showPage(question)
	local page = {
		speakerName = "Blue Wizard",
		speakerMessage = question.question,
		onFinish = self.go.id..".script._callback",
		responses = {
			{ text = "Clearly on the first dungeon."},
			{ text = "Slightly on the first dungeon."},
			{ text = "No difference between the two."},
			{ text = "Slightly on the last dungeon."},
			{ text = "Clearly on the last dungeon."},
		}
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
		result = result .. lastQuestion.number .. ". " .. lastQuestion.question .. ": " .. lastQuestion.response .."\n"
	end
	_showQuestionaire()
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
