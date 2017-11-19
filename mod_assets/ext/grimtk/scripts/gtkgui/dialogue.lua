
---------------------------------------------------------------
-- NPC Dialogue System
---------------------------------------------------------------

GTK.Core.GUI:addImage({ name="gtk-dialogue-top", path="mod_assets/ext/grimtk/textures/dialogue_top.tga", origin={0, 0}, size={836, 397} });
GTK.Core.GUI:addImage({ name="gtk-dialogue-bottom", path="mod_assets/ext/grimtk/textures/dialogue_bottom.tga", origin={0, 0}, size={836, 302} });
GTK.Core.GUI:addImage({ name="gtk-dialogue-bottom-speaker-box", path="mod_assets/ext/grimtk/textures/dialogue_bottom_speaker_box.tga", origin={0, 0}, size={770, 92} });

dialogueTopFormName = "gtk-dialogue-top";
dialogueBottomFormName = "gtk-dialogue-bottom";
currentDialogue = nil;
currentPage = nil;
isShowing = false;
didShowPage = false;

dialogueTopForm = {
	name = dialogueTopFormName,
	type = "GWindow",
	size = {836, 397},
	bgImage = "gtk-dialogue-top",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.North,
	offset = {0, 10},
	layout = {
		type = "GBoxLayout",
		direction = GTK.Constants.Direction.Horizontal,
		gravity = GTK.Constants.Gravity.NorthWest,			
		spacing = {10, 8},
		margin = {30, 20, 30, 30}
	},	
	children = 
	{
		{
			name = "mainImageView", 
			type = "GImageView",
			image = "gtk-dialogue-top",
			drawMode = GTK.Constants.ImageDrawMode.ShrinkToBox,
			imageGravity = GTK.Constants.Gravity.Middle,
			size = {380, 340},
			minSize = {380, 340},
			maxSize = {770, 900},			
		},
		{
			name = "mainMessageLabel", 
			type = "GLabel",
			text = "",
			size = {380, 340},
			minSize = {380, 340},
			maxSize = {770, 900},
			font = GTK.Constants.Fonts.Medium,
		}
	}
}

dialogueBottomForm = {
	name = dialogueBottomFormName,
	type = "GWindow",
	bgImage = "gtk-dialogue-bottom",
	size = {836, 302},
	gravity = GTK.Constants.Gravity.South,
	offset = {0, -10},
	lockKeyboard = true,
	freezeAI = true,
	layout = {
		type = "GBoxLayout",
		direction = GTK.Constants.Direction.Vertical,	
		spacing = {8, 12},
		margin = {24, 24, 24, 24}
	},		
	children = 
	{	
		{
			name = "speakerContainer",
			type = "GWidget",
			position = {0, 0},
			size = {770, 92},
			bgImage = "gtk-dialogue-bottom-speaker-box",
			minSize = {770, 92},
			maxSize = {770, 92},
			layout = {
				type = "GBoxLayout",
				direction = GTK.Constants.Direction.Vertical,	
				spacing = {2, 2},
				margin = {2, 10, 2, 10}
			},				
			children = 
			{
				{
					name = "speakerLabel", 
					type = "GLabel",
					text = "[Speaker]",
					position = {5, 4},
					size = {750, 30},
					minSize = {750, 30},
					maxSize = {750, 30},
					font = GTK.Constants.Fonts.Large,
					textColor = {255, 192, 64, 255}
				},
				{
					name = "messageLabel", 
					type = "GLabel",
					text = "[Message]",
					position = {5, 38},
					size = {750, 48},
					minSize = {750, 48},
					maxSize = {750, 86},
					font = GTK.Constants.Fonts.Medium,
					textColor = {255, 192, 64, 255}
				},	
			}
		},
		{
			name = "responseContainer", 
			type = "GWidget",
			position = {34, 124},
			size = {780, 140},
			minSize = {780, 140},
			maxSize = {780, 1000},
			layout = {
				type = "GBoxLayout",
				direction = GTK.Constants.Direction.Vertical,
				gravity = GTK.Constants.Gravity.NorthWest,			
				hideOverflow = true,
				spacing = {4, 4},
				margin = {4, 4, 4, 4}
			},
			children = 
			{ 
		
			}
		},				
	}
}

responseForm = {
	name = "response", 
	type = "GPushButton",
	size = {760, 24},
	minSize = {760, 24},
	maxSize = {1000, 100},
	bgColor = {0, 0, 0, 0},
	borders = {0, 0, 0, 0},
	tintHover = {255, 192, 64, 64},
	onPressedSound = "click_up",
	label = {
		text = "[-]",
		font = GTK.Constants.Fonts.Medium,
		padding = {4,4,4,4},
		textAlign = GTK.Constants.TextAlign.Left,
	}
}	


function createDialogueForms()
	if ( GTK.Core.GUI:getWindow(dialogueTopFormName) == nil ) then
		GTK.Core.GUI:createWindow(dialogueTopForm);
	end
	
	if ( GTK.Core.GUI:getWindow(dialogueBottomFormName) == nil ) then
		GTK.Core.GUI:createWindow(dialogueBottomForm);
	end
end


function dialogueResponseCallback(sender, mouseState)
	if ( currentPage == nil ) then
		Console.warn("[GTK] Dialog response called but no current page.");
		hideDialogue();
		return;
	end

	local page = currentPage;
	local response = page.responses[sender.userdata.index];
	local nextPage = nil;

	didShowPage = false;		-- Incase another "show page" is called in a callback
	
	if ( response ) then
		local onSelect = GTK.Core.Utils.funcFromString(response.onSelect);

		if (onSelect) then
			nextPage = onSelect(sender.userdata.index);
		end
	end

	local onFinish = GTK.Core.Utils.funcFromString(page.onFinish);

	if (onFinish) then
		onFinish(sender.userdata.index);
	end
	
	if ( (nextPage == nil) and currentDialogue and response.nextPage ) then
		nextPage = response.nextPage;
	end
	
	if ( nextPage and (didShowPage == false) ) then
		showDialoguePage(nextPage);
	else
		if ( didShowPage == false ) then
			hideDialogue();
		end
	end
end


function showDialoguePage(page)
	if type(page) == "string" then
		local isDone = false

		if (currentDialogue == nil) or (currentDialogue.pages == nil) then
			Console.warn("[GTK] Can only showDialoguePage with a string/name if a dialogue is currently open.")
			return
		end

		for _,p in ipairs(currentDialogue.pages) do 
			if (isDone == false) and (p.id == page) then
				page = p;
				isDone = true;
			end
		end	

		if type(page) ~= "table" then
			Console.warn("[GTK] showDialoguePage: Page not found in current dialogue with name: " .. page)
			return
		end
	end

	createDialogueForms();
	
	local topWindow = GTK.Core.GUI:getWindow(dialogueTopFormName);
	local bottomWindow = GTK.Core.GUI:getWindow(dialogueBottomFormName);
	
	if ( topWindow == nil or bottomWindow == nil ) then
		Console.warn("[GTK-GUI] Failed to create dialogue windows.");
		return
	end
	
	topWindow:stopAllActions(true);
	bottomWindow:stopAllActions(true);

	didShowPage = true;
	
	-- Setup Bottom Panel Views
	
	local speakerLabel = bottomWindow:findChild("speakerLabel");
	local speakerMessageLabel = bottomWindow:findChild("messageLabel");
	local speakerContainer = bottomWindow:findChild("speakerContainer");
	local responseContainer = bottomWindow:findChild("responseContainer");
	
	if ( page.speakerName or page.speakerMessage ) then
		if ( speakerLabel ) then
			if ( page.speakerName ) then
				speakerLabel.data.text = page.speakerName;
				speakerLabel:setVisible(true);
			else
				speakerLabel:setVisible(false);
			end
		end

		if ( speakerMessageLabel ) then
			if ( page.speakerMessage ) then
				local textTypeDuration = #page.speakerMessage / 50;			
				speakerMessageLabel.data.text = "";
				speakerMessageLabel:runAction(GTK.Widgets.GTextTypeAction.create(page.speakerMessage, textTypeDuration));
				speakerMessageLabel:setVisible(true);
			else
				speakerMessageLabel:setVisible(false);
			end
		end

		speakerContainer:setVisible(true);
	else
		speakerContainer:setVisible(false);
	end

	if ( page.onFinish and type(page.onFinish) == "function" ) then
		Console.warn("[GTK] onFinish callbacks on NPC dialogues must now be connector strings like entity.script.function");
		page.onFinish = nil;
	end
		
	if ( responseContainer and page.responses ) then		
		local delayedStart = GTK.Widgets.GSequenceAction.create({
			GTK.Widgets.GWaitAction.create(textTypeDuration), 
			GTK.Widgets.GFadeToAction.create(1.0, 0.1)
		});
		
		responseContainer:removeAllChildren();
		responseContainer:setOpacity(1.0);
		responseContainer:runAction(delayedStart);
		
		for i,response in ipairs(page.responses) do
			local responseButton = GTK.Widgets.GWidget.createGeneric(responseForm);

			if ( response.onSelect and type(response.onSelect) == "function" ) then
				Console.warn("[GTK] onSelect callbacks on NPC dialogues must now be connector strings like entity.script.function");
				response.onSelect = nil;
			end

			if ( response.target or response.action ) then
				Console.warn("[GTK] target/action callbacks for NPC dialogue resposes have been replaced by connector strings for onSelect");
			end
			
			if ( responseButton ) then
				responseButton.data.keyboardShortcut = tostring(i);
				responseButton.userdata.index = i;
				responseButton.label.data.text = i .. ". " .. response.text;
				responseButton:addConnectorWithStr("onPressed", "GTKGui.Dialogue.dialogueResponseCallback");
				responseContainer:addChild(responseButton);
			end
		end
	end

	bottomWindow:setVisible(true);	

	-- Setup Top Panel Views
	local topMessageLabel = topWindow:findChild("mainMessageLabel");
	local topImageView = topWindow:findChild("mainImageView");

	if ( page.mainImage or page.mainMessage ) then
		if ( page.mainImage and topImageView ) then 
			topImageView.data.imageName = page.mainImage;
			topImageView:setVisible(true);
		else
			topImageView:setVisible(false);
		end

		if ( page.mainMessage and topMessageLabel ) then
			topMessageLabel.data.text = page.mainMessage;
			topMessageLabel:setVisible(true);
		else
			topMessageLabel:setVisible(false);
		end

		topWindow:setVisible(true);
	else
		topWindow:setVisible(false);
	end

	isShowing = true;
	currentPage = page;

	-- Play any sounds attached to the page.

	if ( page.playSound ) then
		playSound(page.playSound);
	end
end


function startDialogue(dialogue)
	if ( dialogue.pages == nil or #dialogue.pages == 0 ) then
		Console.warn("[GTK] Invalid dialogue provided.");
	end

	if ( dialogue.lockParty == true ) then
		GTK.Core.GUI:lockParty();
	end

	local didLoadPage = false;
	currentDialogue = dialogue;

	if ( dialogue.startPage ~= nil ) then
		for _,page in ipairs(dialogue.pages) do
			if ( page.id == dialogue.startPage ) then
				showDialoguePage(page);			
				didLoadPage = true;
			end
		end
	end

	if ( didLoadPage == false ) then
		showDialoguePage(dialogue.pages[1]);
	end
end


function hideDialogue()
	local topWindow = GTK.Core.GUI:getWindow(dialogueTopFormName);
	local bottomWindow = GTK.Core.GUI:getWindow(dialogueBottomFormName);
	
	if ( topWindow == nil or bottomWindow == nil ) then
		return
	end

	if ( currentDialogue and currentDialogue.lockParty == true ) then
		GTK.Core.GUI:unlockParty();
	end
	
	topWindow:stopAllActions(true);
	bottomWindow:stopAllActions(true);
	
	topWindow:setVisible(false);
	bottomWindow:setVisible(false);	
	
	currentDialogue = nil;
	currentPage = nil;
	isShowing = false;
end

