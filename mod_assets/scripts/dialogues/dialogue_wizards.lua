
------------------------------------------------------------------------
-- Dialogue of The Wizards
--
-- An example of using the dialogue system manually to make more custom
-- conversations.
------------------------------------------------------------------------
isDoneIntro = false;
isDoneBlue = false;
isDoneRed = false;

-- Public Functions (pressure plate methods)

function showDemoDialogue(sender)
	if ( isDoneRed and isDoneBlue ) then
		-- questionaire
		return;
	end
	if( isDoneBlue or isDoneRed ) then
		if(isDoneBlue) then
			findEntity("script_dialogue_02").script:showDemoDialogue();
		end
		if(isDoneRed) then
			findEntity("script_dialogue_03").script:showDemoDialogue();
		end
		return;
	end
	if(isDoneIntro) then
		return;
	end
	
	findEntity("script_dialogue_01").script:showDemoDialogue();
	isDoneIntro = true;
end

function hideDemoDialogue()
	GTKGui.Dialogue.hideDialogue();
end

function setBlueTrue()
	isDoneBlue = true;
end

function setRedTrue()
	isDoneRed = true;
end