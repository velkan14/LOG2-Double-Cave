
------------------------------------------------------------------------
-- Dialogue of The Wizards
--
-- An example of using the dialogue system manually to make more custom
-- conversations.
------------------------------------------------------------------------
isDoneIntro = false;
isDoneBlue = false;
isDoneRed = false;
isDoneQuestion = false;
isSaved = false;
isDead = false;

-- Public Functions (pressure plate methods)

function showDemoDialogue(sender)
	print(isDead)
	if(isDoneQuestion and isSaved) then
		findEntity("script_dialogue_05").script:showDemoDialogue();
	end
	if ( isDoneRed and isDoneBlue ) then
		local s = findEntity("script_dialogue_04").script
		if(isDead) then s:setDeadTrue() end
		s:showDemoDialogue(isDead);
		isDead = false
		return;
	end
	if( isDoneBlue or isDoneRed ) then
		if(isDoneBlue) then
			local s = findEntity("script_dialogue_02").script
			if(isDead) then s:setDeadTrue() end
			s:showDemoDialogue(isDead);
			isDead = false
		end
		if(isDoneRed) then
			local s = findEntity("script_dialogue_03").script
			if(isDead) then s:setDeadTrue() end
			s:showDemoDialogue(isDead);
			isDead = false
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

function setQuestionsTrue()
	isDoneQuestion = true
end

function setSavedTrue()
	isSaved = true
end

function setDeadTrue()
	isDead = true
end
