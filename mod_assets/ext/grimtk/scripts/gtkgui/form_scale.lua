
---------------------------------------------------------------
-- NPC Form System
---------------------------------------------------------------

GTK.Core.GUI:addImage({ name="gtk-form-top", path="mod_assets/ext/grimtk/textures/dialogue_top.tga", origin={0, 0}, size={836, 397} });
GTK.Core.GUI:addImage({ name="gtk-form-bottom", path="mod_assets/ext/grimtk/textures/dialogue_bottom.tga", origin={0, 0}, size={836, 302} });
GTK.Core.GUI:addImage({ name="gtk-form-bottom-speaker-box", path="mod_assets/ext/grimtk/textures/dialogue_bottom_speaker_box.tga", origin={0, 0}, size={770, 92} });

formTopFormName = "gtk-form-top";
formBottomFormName = "gtk-form-bottom";
currentForm = nil;
currentPage = nil;
isShowing = false;
didShowPage = false;
lastResponseButtonA = nil;
lastResponseButtonB = nil;

formTopForm = {
	name = formTopFormName,
	type = "GWindow",
	size = {836, 397},
	bgImage = "gtk-form-top",
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
			image = "gtk-form-top",
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

formResponseForm = {
	{
		name = "leftLabel",
		type = "GLabel",
		text = "[left]",
		textAlign = GTK.Constants.TextAlign.Right,
		position = {0, 0},
		size = {270, 60},
		minSize = {270, 60},
		maxSize = {270, 60},
		font = GTK.Constants.Fonts.Large,
		textColor = {255, 192, 64, 255}
	},
	{
		name = "responseContainer",
		type = "GWidget",
		position = {270, 0},
		size = {240, 60},
		minSize = {240, 60},
		maxSize = {288, 60},
		layout = {
			type = "GBoxLayout",
			direction = GTK.Constants.Direction.Horizontal,
			gravity = GTK.Constants.Gravity.North,
			hideOverflow = true,
			spacing = {4, 4},
			margin = {4, 4, 4, 4}
		},
		children =
		{

		}
	},
	{
		name = "rightLabel",
		type = "GLabel",
		text = "[right]",
		textAlign = GTK.Constants.TextAlign.Left,
		position = {510, 0},
		size = {270, 60},
		minSize = {270, 60},
		maxSize = {270, 60},
		font = GTK.Constants.Fonts.Large,
		textColor = {255, 192, 64, 255}
	},
}

formBottomForm = {
	name = formBottomFormName,
	type = "GWindow",
	bgImage = "gtk-form-bottom",
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
			bgImage = "gtk-form-bottom-speaker-box",
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
			name = "formContainerA",
			type = "GWidget",
			position = {34, 0},
			size = {780, 50},
			minSize = {780, 50},
			maxSize = {780, 50},
			layout = {
				type = "GBoxLayout",
				direction = GTK.Constants.Direction.Horizontal,
				gravity = GTK.Constants.Gravity.NorthWest,
				hideOverflow = true,
				spacing = {4, 4},
				margin = {4, 4, 4, 4}
			},
			children = formResponseForm
		},
		{
			name = "formContainerB",
			type = "GWidget",
			position = {34, 0},
			size = {780, 50},
			minSize = {780, 50},
			maxSize = {780, 50},
			layout = {
				type = "GBoxLayout",
				direction = GTK.Constants.Direction.Horizontal,
				gravity = GTK.Constants.Gravity.NorthWest,
				hideOverflow = true,
				spacing = {4, 4},
				margin = {4, 4, 4, 4}
			},
			children = formResponseForm
		},
		{
			name = "sendresponse",
			type = "GPushButton",
			position = {0, 0},
			size = {24, 24},
			minSize = {24, 24},
			maxSize = {64, 48},
			bgColor = {0, 0, 0, 0},
			borders = {0, 0, 0, 0},
			tintHover = {255, 192, 64, 64},
			onPressedSound = "click_up",
			label = {
				text = "- Ok -",
				font = GTK.Constants.Fonts.Medium,
				padding = {4,4,4,4},
				textAlign = GTK.Constants.TextAlign.Center,
			}
		},
	}
}

responseForm = {
	name = "response",
	type = "GPushButton",
	size = {24, 24},
	minSize = {24, 24},
	maxSize = {48, 48},
	bgColor = {0, 0, 0, 0},
	borders = {0, 0, 0, 0},
	tintHover = {255, 192, 64, 64},
	onPressedSound = "click_up",
	label = {
		text = "[-]",
		font = GTK.Constants.Fonts.Medium,
		padding = {4,4,4,4},
		textAlign = GTK.Constants.TextAlign.Center,
	}
}


function createFormForms()
	if ( GTK.Core.GUI:getWindow(formTopFormName) == nil ) then
		GTK.Core.GUI:createWindow(formTopForm);
	end

	if ( GTK.Core.GUI:getWindow(formBottomFormName) == nil ) then
		GTK.Core.GUI:createWindow(formBottomForm);
	end
end


function formSelectCallback(sender, mouseState)
	if ( currentPage == nil ) then
		Console.warn("[GTK] Dialog response called but no current page.");
		hideForm();
		return;
	end

	if(sender.userdata.type == "A") then
		if(not (lastResponseButtonA == nil)) then
			lastResponseButtonA.data.bgColor ={0,0,0,0}
		end
		lastResponseButtonA = sender;
		sender.data.bgColor = {100, 200, 100, 100}
	end
	if(sender.userdata.type == "B") then
		if(not (lastResponseButtonB == nil)) then
			lastResponseButtonB.data.bgColor ={0,0,0,0}
		end
		lastResponseButtonB = sender;
		sender.data.bgColor = {100, 200, 100, 100}
	end

	local bottomWindow = GTK.Core.GUI:getWindow(formBottomFormName);
	local sendresponse = bottomWindow:findChild("sendresponse");

	if((not (lastResponseButtonB == nil)) and (not (lastResponseButtonA == nil)) and (sendresponse.data.visible == false)) then
			sendresponse:setOpacity(1.0);
			sendresponse:setVisible(true);
			sendresponse.userdata.type = "Ok";
			sendresponse:addConnectorWithStr("onPressed", "GTKGui.Form.formResponseCallback");
	end
end

function formResponseCallback(sender, mouseState)
	if ( currentPage == nil ) then
		Console.warn("[GTK] Dialog response called but no current page.");
		hideForm();
		return;
	end

	local page = currentPage;
	local nextPage = nil;

	didShowPage = false;		-- Incase another "show page" is called in a callback

	local onFinish = GTK.Core.Utils.funcFromString(page.onFinish);
	local awnser = {
		A = lastResponseButtonA.userdata.index,
		B = lastResponseButtonB.userdata.index,
	}
	if (onFinish) then
		onFinish(awnser);
	end

	if ( (nextPage == nil) and currentForm and response.nextPage ) then
		nextPage = response.nextPage;
	end

	if ( nextPage and (didShowPage == false) ) then
		showFormPage(nextPage);
	else
		if ( didShowPage == false ) then
			hideForm();
		end
	end
end


function showFormPage(page)
	if type(page) == "string" then
		local isDone = false

		if (currentForm == nil) or (currentForm.pages == nil) then
			Console.warn("[GTK] Can only showFormPage with a string/name if a form is currently open.")
			return
		end

		for _,p in ipairs(currentForm.pages) do
			if (isDone == false) and (p.id == page) then
				page = p;
				isDone = true;
			end
		end

		if type(page) ~= "table" then
			Console.warn("[GTK] showFormPage: Page not found in current form with name: " .. page)
			return
		end
	end

	createFormForms();

	local topWindow = GTK.Core.GUI:getWindow(formTopFormName);
	local bottomWindow = GTK.Core.GUI:getWindow(formBottomFormName);

	if ( topWindow == nil or bottomWindow == nil ) then
		Console.warn("[GTK-GUI] Failed to create form windows.");
		return
	end

	topWindow:stopAllActions(true);
	bottomWindow:stopAllActions(true);

	didShowPage = true;

	-- Setup Bottom Panel Views

	local speakerLabel = bottomWindow:findChild("speakerLabel");
	local speakerMessageLabel = bottomWindow:findChild("messageLabel");
	local speakerContainer = bottomWindow:findChild("speakerContainer");
	-- A
	local formContainerA = bottomWindow:findChild("formContainerA");
	local responseContainerA = formContainerA:findChild("responseContainer");
	local leftLabelA = formContainerA:findChild("leftLabel");
	local rightLabelA = formContainerA:findChild("rightLabel");
	-- B
	local formContainerB = bottomWindow:findChild("formContainerB");
	local responseContainerB = formContainerB:findChild("responseContainer");
	local leftLabelB = formContainerB:findChild("leftLabel");
	local rightLabelB = formContainerB:findChild("rightLabel");

	local sendresponse = bottomWindow:findChild("sendresponse");

	if( sendresponse ) then
		sendresponse:setVisible(false)
	end

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
		Console.warn("[GTK] onFinish callbacks on NPC forms must now be connector strings like entity.script.function");
		page.onFinish = nil;
	end

	-- if( leftLabel and page.leftLabel ) then
	-- 	leftLabel.data.text = "\n" .. page.leftLabel;
	-- 	leftLabel:setVisible(true);
	-- end
  --
	-- if( rightLabel and page.rightLabel ) then
	-- 	rightLabel.data.text = "\n" .. page.rightLabel;
	-- 	rightLabel:setVisible(true);
	-- end

	-- A --
	if ( responseContainerA and page.responses ) then
		local delayedStart = GTK.Widgets.GSequenceAction.create({
			GTK.Widgets.GWaitAction.create(textTypeDuration),
			GTK.Widgets.GFadeToAction.create(1.0, 0.1)
		});

		responseContainerA:removeAllChildren();
		responseContainerA:setOpacity(1.0);
		responseContainerA:runAction(delayedStart);

		for i=1, page.responses do
			local responseButton = GTK.Widgets.GWidget.createGeneric(responseForm);

			if ( responseButton ) then
				responseButton.data.keyboardShortcut = tostring(i);
				responseButton.userdata.index = i;
				responseButton.userdata.type = "A";
				responseButton.label.data.text = " -" .. i .. "- ";
				responseButton.bgColor = {64, 255, 64, 64};
				responseButton:addConnectorWithStr("onPressed", "GTKGui.Form.formSelectCallback");
				responseContainerA:addChild(responseButton);
			end
		end
	end

	-- B --
	if ( responseContainerB and page.responses ) then
		local delayedStart = GTK.Widgets.GSequenceAction.create({
			GTK.Widgets.GWaitAction.create(textTypeDuration),
			GTK.Widgets.GFadeToAction.create(1.0, 0.1)
		});

		responseContainerB:removeAllChildren();
		responseContainerB:setOpacity(1.0);
		responseContainerB:runAction(delayedStart);

		for i=1, page.responses do
			local responseButton = GTK.Widgets.GWidget.createGeneric(responseForm);

			if ( responseButton ) then
				responseButton.data.keyboardShortcut = tostring(i);
				responseButton.userdata.index = i;
				responseButton.userdata.type = "B";
				responseButton.label.data.text = " -" .. i  .. "- ";
				responseButton:addConnectorWithStr("onPressed", "GTKGui.Form.formSelectCallback");
				responseContainerB:addChild(responseButton);
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


function startForm(form)
	if ( form.pages == nil or #form.pages == 0 ) then
		Console.warn("[GTK] Invalid form provided.");
	end

	if ( form.lockParty == true ) then
		GTK.Core.GUI:lockParty();
	end

	local didLoadPage = false;
	currentForm = form;

	if ( form.startPage ~= nil ) then
		for _,page in ipairs(form.pages) do
			if ( page.id == form.startPage ) then
				showFormPage(page);
				didLoadPage = true;
			end
		end
	end

	if ( didLoadPage == false ) then
		showFormPage(form.pages[1]);
	end
end


function hideForm()
	local topWindow = GTK.Core.GUI:getWindow(formTopFormName);
	local bottomWindow = GTK.Core.GUI:getWindow(formBottomFormName);

	if ( topWindow == nil or bottomWindow == nil ) then
		return
	end

	if ( currentForm and currentForm.lockParty == true ) then
		GTK.Core.GUI:unlockParty();
	end

	topWindow:stopAllActions(true);
	bottomWindow:stopAllActions(true);

	topWindow:setVisible(false);
	bottomWindow:setVisible(false);

	currentForm = nil;
	currentPage = nil;
	isShowing = false;
end
