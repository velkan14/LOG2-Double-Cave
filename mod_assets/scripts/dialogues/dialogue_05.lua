
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
		speakerName = "King Valentine",
		speakerMessage = "Now I will set you free.",
		onFinish = self.go.id..".script._introCallback",
		responses = {
			{ text = "Thanks!" },
			{ text = "About time!" },
		}
	}

	GTKGui.Dialogue.showDialoguePage(page);
end

function _introCallback()

  local temp = spawn("teleporter", party.level, party.x, party.y, party.facing, party.elevation, "temporary_teleporter_3")
	temp.teleporter:setTriggeredByItem(false)
	temp.teleporter:setTriggeredByParty(true)
	temp.teleporter:setTriggeredByMonster(false)
	temp.teleporter:setTeleportTarget(6, 22, 15, 0)
	temp.teleporter:setSpin("east")
	
	local t = findEntity("temporary_pressureplate_3")
	if (t ~= nil) then
		 t:destroy()
	end

	local temporary_pressureplate = spawn("floor_trigger", 6, 22, 15, party.facing, 0, "temporary_pressureplate_3")
  temporary_pressureplate.floortrigger:setTriggeredByParty(true)
  temporary_pressureplate.floortrigger:setTriggeredByMonster(false)
  temporary_pressureplate.floortrigger:setTriggeredByItem(false)
  temporary_pressureplate.floortrigger:setDisableSelf(true)
  temporary_pressureplate.floortrigger:addConnector("onActivate", self.go.id, "cleanup")
end

function cleanup()
	local temporary_teleporter = findEntity("temporary_teleporter_3");
   if (temporary_teleporter ~= nil) then
      temporary_teleporter:destroy()
   end
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
