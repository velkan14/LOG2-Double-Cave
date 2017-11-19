
---------------------------------------------------------------
-- Message Box / Alert Box
---------------------------------------------------------------

GTK.Core.GUI:addImage({ name="log2-messagebox-small", path="assets/textures/gui/gui_items.tga", origin={2032, 0}, size={436, 300} });
GTK.Core.GUI:addImage({ name="log2-messagebox-large", path="assets/textures/gui/gui_items.tga", origin={0, 1436}, size={546, 546} });

kMessageBoxFormName = "gtk_message_box";
kMessageBoxForms = { };

kMessageBoxForms["small"] = {
	name = kMessageBoxFormName,
	type = "GWindow",
	size = {436, 300},
	bgImage = "log2-messagebox-small",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.Middle,
	draggable = true,
	dimScreen = true,
	children = {
		{
			type = "GLabel",
			name = "title",
			position = {54, 32},
			size = {334, 20},
			font = GTK.Constants.Fonts.Medium,
			textAlign = GTK.Constants.TextAlign.Center,
		},
		{
			type = "GLabel",
			name = "message",
			position = {48, 82},
			size = {354, 120},
			font = GTK.Constants.Fonts.Small
		},
		{
			type = "GPushButton",
			name = "cancelButton",
			position = {48, 222},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		},
		{
			type = "GPushButton",
			name = "okButton",
			position = {268, 222},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		}
	}
};

kMessageBoxForms["large"] = {
	name = kMessageBoxFormName,
	type = "GWindow",
	size = {546, 546},
	bgImage = "log2-messagebox-large",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.Middle,
	draggable = true,
	dimScreen = true,
	children = {
		{
			type = "GLabel",
			name = "title",
			position = {124, 32},
			size = {300, 20},
			font = GTK.Constants.Fonts.Medium,
			textAlign = GTK.Constants.TextAlign.Center,
		},
		{
			type = "GLabel",
			name = "message",
			position = {54, 106},
			size = {434, 324},
			font = GTK.Constants.Fonts.Small
		},
		{
			type = "GPushButton",
			name = "cancelButton",
			position = {58, 448},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		},
		{
			type = "GPushButton",
			name = "okButton",
			position = {358, 448},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		}
	}
};


function messageBoxButtonCallback(sender, mouseState)
	local window = sender:rootWidget();
	
	if ( window and window.userdata ) then
		local onDismiss = GTK.Core.Utils.funcFromString(window.userdata.onDismiss);
		
		if ( onDismiss and type(onDismiss) == "function" ) then
			onDismiss(sender.userdata.index, sender.data.text);
		end
	end
	
	GTK.Core.GUI:destroyWindow(kMessageBoxFormName);
end


function showMessageBox(title, message, onDismiss, buttons, template)
	if ( GTK.Core.GUI:getWindow(kMessageBoxFormName) ) then
		Console.warn("[GTK] MessageBox is already showing. Cannot show another.");
		return
	end

	if buttons == nil then buttons = { "Okay" }; end	
	if template == nil then template = "small"; end
	
	local form = kMessageBoxForms[template];
	
	if ( form == nil ) then
		Console.warn("[GTK] No MessageBox template '" .. template .. "'");
		return
	end
	
	local window = GTK.Core.GUI:createWindow(form);
	
	if ( window == nil ) then
		return
	end

	if ( type(onDismiss) ~= "string" ) then
		Console.warn("[GTK] showMessageBox expects a connector string for the onDismiss parameter.");
		return;
	end
	
	window.userdata.onDismiss = onDismiss;

	local titleLabel = window:findChild("title");
	local messageLabel = window:findChild("message");
	local okButton = window:findChild("okButton");
	local cancelButton = window:findChild("cancelButton");

	if ( titleLabel ~= nil ) then
		titleLabel.data.text = title;
	end

	if ( messageLabel ~= nil ) then
		messageLabel.data.text = message;
	end

	if ( okButton ~= nil ) then		
		okButton.userdata.index = 1;
		okButton.label.data.text = iff((#buttons < 1), "Okay", buttons[1]);
		okButton:addConnectorWithStr("onPressed", "GTKGui.Basic.messageBoxButtonCallback");
	end	
	
	if ( cancelButton ~= nil ) then
		if (#buttons < 2) then
			cancelButton:setVisible(false);
		else 
			cancelButton.userdata.index = 2;
			cancelButton.label.data.text = buttons[2];
			cancelButton:addConnectorWithStr("onPressed", "GTKGui.Basic.messageBoxButtonCallback");
		end
	end

end

function dismissMessageBox()
	GTK.Core.GUI:destroyWindow(kMessageBoxFormName);
end

---------------------------------------------------------------
-- Show an Info Message in the middle of the screen
---------------------------------------------------------------

GTK.Core.GUI:addImage({ name="gtk-info-message-box", path="mod_assets/ext/grimtk/textures/info_message_box.tga", origin={0, 0}, size={512, 88} });

infoMessageForm = {
	name = "gtk_info_message",
	type = "GWindow",
	size = {512, 88},
	bgImage = "gtk-info-message-box",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.Middle,
	draggable = false,
	dimScreen = false,	
	children = {
		{
			type = "GLabel",
			name = "message",
			position = {36, 11},
			size = {440, 66},
			text = "Example",
			textColor = {255, 255, 255, 255},
			textAlign = GTK.Constants.TextAlign.Center,
			font = GTK.Constants.Fonts.Medium
		}	
	}
}

function showInfoMessage(text, duration)
	if ( duration == nil ) then duration = 3.0; end
	local window = GTK.Core.GUI:getWindow(infoMessageForm.name);

	if ( window == nil ) then
		window = GTK.Core.GUI:createWindow(infoMessageForm);
	end

	if ( window == nil ) then
		Console.warn("[GTK] InfoMessage Failed: " .. text);
		return;
	end
	
	local messageLabel = window:findChild("message");

	if ( messageLabel ~= nil ) then
		messageLabel.data.text = text;
	end
	
	window:setOpacity(1.0);
	window:setVisible(true);

	local actionSequence = GTK.Widgets.GSequenceAction.create({
		GTK.Widgets.GWaitAction.create(duration),
		GTK.Widgets.GFadeToAction.create(0.0, 1.0)
	});
	
	window:stopAllActions();
	window:runAction(actionSequence);
	
end

function hideInfoMessage()
	local window = GTK.Core.GUI:getWindow(infoMessageForm.name);
	
	if ( window ) then
		window:setVisible(false);
	end
end


---------------------------------------------------------------
-- Text Input Dialogue Box
---------------------------------------------------------------

GTK.Core.GUI:addImage({ name="log2-textinputbox", path="assets/textures/gui/gui_items.tga", origin={547, 2116}, size={548, 188} });

kTextInputFormName = "gtk_text_input";
kTextInputForm = {
	name = kTextInputFormName,
	type = "GWindow",
	size = {548, 188},
	bgImage = "log2-textinputbox",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.Middle,
	draggable = false,
	dimScreen = false,	
	children = {
		{
			type = "GLabel",
			name = "title",
			position = {52, 32},
			size = {450, 30},
			textColor = {255, 255, 255, 255},
			textAlign = GTK.Constants.TextAlign.Center,
			font = GTK.Constants.Fonts.Medium
		},
		{
			type = "GLabel",
			name = "fieldName",
			position = {34, 85},
			size = {98, 20},
			textColor = {255, 255, 255, 255},
			font = GTK.Constants.Fonts.Small,
			textAlign = GTK.Constants.TextAlign.Right,
		},
		{
			type = "GTextEdit",
			name = "textEdit",
			position = {140, 80},
			size = {378, 22},
			textColor = {255, 255, 255, 255},
			bgColor = {0, 0, 0, 0},
			borders = {0, 0, 0, 0},
			font = GTK.Constants.Fonts.Small,
			text = "";
		},
		{
			type = "GPushButton",
			name = "cancelButton",
			position = {50, 118},
			size = {160, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		},
		{
			type = "GPushButton",
			name = "okButton",
			position = {354, 118},
			size = {160, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		}
	}
}


function textInputBoxButtonCallback(sender, mouseState)
	local window = sender:rootWidget();
	local textEdit = window:findChild("textEdit");
	
	if ( window and window.userdata ) then
		local onDismiss = GTK.Core.Utils.funcFromString(window.userdata.onDismiss);
		
		if ( onDismiss and type(onDismiss) == "function" ) then
			if ( sender.userdata.index == 1 ) then
				onDismiss(textEdit.data.text);
			else
				onDismiss(nil);
			end
		end
	end
	
	GTK.Core.GUI:destroyWindow(kTextInputFormName);
end


function showTextInputBox(title, fieldName, onDismiss)
	if ( GTK.Core.GUI:getWindow(kTextInputFormName) ) then
		Console.warn("[GTK] TextInputBox is already showing. Cannot show another.");
		return
	end

	local window = GTK.Core.GUI:createWindow(kTextInputForm);
	
	if ( window == nil ) then
		Console.warn("[GTK] Failed to create TextInputForm window. Sorry!");
		return
	end

	if ( type(onDismiss) ~= "string" ) then
		Console.warn("[GTK] showTextInputBox expects a connector string for the onDismiss parameter.");
		return;
	end
	
	window.userdata.onDismiss = onDismiss;

	local titleLabel = window:findChild("title");
	local fieldNameLabel = window:findChild("fieldName");
	local okButton = window:findChild("okButton");
	local cancelButton = window:findChild("cancelButton");

	if ( titleLabel ~= nil ) then
		titleLabel.data.text = title;
	end

	if ( fieldNameLabel ~= nil ) then
		fieldNameLabel.data.text = fieldName;
	end

	if ( okButton ~= nil ) then		
		okButton.userdata.index = 1;
		okButton.label.data.text = "Okay";
		okButton:addConnectorWithStr("onPressed", "GTKGui.Basic.textInputBoxButtonCallback");
	end	
	
	if ( cancelButton ~= nil ) then
		cancelButton.userdata.index = 2;
		cancelButton.label.data.text = "Cancel";
		cancelButton:addConnectorWithStr("onPressed", "GTKGui.Basic.textInputBoxButtonCallback");
	end
end

function dismissTextInputBox()
	GTK.Core.GUI:destroyWindow(kTextInputFormName);
end

------------------------------------------------------------------------
-- Present the player with up to about 10-15 options and allow them to pick one
------------------------------------------------------------------------

GTK.Core.GUI:addImage({ name="gtk-select-menu", path="assets/textures/gui/gui_items.tga", origin={1484, 0}, size={546, 760} });
GTK.Core.GUI:addImage({ name="gtk-select-menu-option", path="assets/textures/gui/gui_items.tga", origin={1970, 1893}, size={231, 27} });

selectMenuForm = {
	name = "gtk_select_menu",
	type = "GWindow",
	size = {518, 720},
	bgImage = "gtk-select-menu",
	bgDrawMode = GTK.Constants.ImageDrawMode.Stretched,
	gravity = GTK.Constants.Gravity.Middle,
	draggable = false,
	dimScreen = false,	
	children = {
		{
			type = "GLabel",
			name = "title",
			position = {120, 31},
			size = {290, 20},
			textColor = {255, 255, 255, 255},
			textAlign = GTK.Constants.TextAlign.Center,
			font = GTK.Constants.Fonts.Medium
		},
		{
			type = "GLabel",
			name = "message",
			position = {50, 96},
			size = {430, 80},
			textColor = {255, 255, 255, 255},
			font = GTK.Constants.Fonts.Small
		},
		{
			type = "GWidget",
			name = "container",
			position = {140, 180},
			size = {240, 320},
			layout = {
				type = "GFlowLayout",
				direction = GTK.Constants.Direction.Vertical,
				hideOverflow = true,
				spacing = {4, 4},
				margin = {4, 4, 4, 4}
			},
		},
		{
			type = "GLabel",
			name = "detail",
			position = {56, 526},
			size = {408, 90},
			textColor = {255, 255, 255, 255},
			font = GTK.Constants.Fonts.Small,
			text = "";
		},
		{
			type = "GPushButton",
			name = "cancelButton",
			position = {48, 636},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		},
		{
			type = "GPushButton",
			name = "okButton",
			position = {344, 636},
			size = {128, 24},
			bgColor = {0, 0, 0, 128},
			borders = {2, 2, 2, 2},
			onPressedSound = "click_up",
			label = {
				padding = {4, 4, 4, 4},
				font = GTK.Constants.Fonts.Small
			}
		}
	}
}

selectMenuOptionForm = {
	type = "GPushButton",
	bgImage = "gtk-select-menu-option",
	size = {231, 27},
	isCheckable = true,
	isExclusiveCheck = true,
	onPressedSound = "click_up",
	label = {
		padding = {14, 6, 6, 6}
	}
}


function selectMenuCheckedCallback(sender)
	local window = sender:rootWidget();

	if ( not window or not window.userdata.options ) then
		Console.warn("[GTK] Could not find option data on select menu callback.");
		return false;
	end

	local detailLabel = window:findChild("detail");	
	local options = window.userdata.options;

	if ( sender.userdata.index and options[sender.userdata.index] ) then
		detailLabel.data.text = options[sender.userdata.index].detail;
	end		
end


function selectMenuButtonCallback(sender, mouseState)
	local window = sender:rootWidget();

	if ( not window or not window.userdata.options ) then
		Console.warn("[GTK] Could not find option data on select menu callback.");
		return false;
	end

	local options = window.userdata.options;
	local selectedButton = nil;
	local buttonIndex = nil;
	local buttonText = nil;
	
	if ( sender.userdata.index == 1 ) then
		local container = window:findChild("container");
	
		for _,widget in ipairs(container._children) do
			if ( widget.data.isChecked ) then
				selectedButton = widget;
			end
		end
	end
	
	if ( selectedButton ) then
		buttonIndex = selectedButton.userdata.index;
		buttonText = options[selectedButton.userdata.index].title;
	end

	local onDismiss = GTK.Core.Utils.funcFromString(window.userdata.onDismiss);
	
	if ( onDismiss and type(onDismiss) == "function" ) then
		onDismiss(buttonIndex, buttonText);
	end
	
	GTK.Core.GUI:destroyWindow(selectMenuForm.name);
end


function showSelectMenu(title, message, options, onDismiss, buttons)
	if ( GTK.Core.GUI:getWindow(selectMenuForm.name) ) then
		Console.warn("[GTK] Only one selectMenu can exist at one time.");
		return
	end

	if buttons == nil then buttons = { "Okay" }; end	
	
	local window = GTK.Core.GUI:createWindow(selectMenuForm);

	if ( type(onDismiss) ~= "string" ) then
		Console.warn("[GTK] showSelectMenu expects a connector string for the onDismiss parameter.");
		return;
	end

	window.userdata.options = options;
	window.userdata.onDismiss = onDismiss;

	if ( window == nil ) then
		Console.warn("[GTK] SelectMenu Creation Failed: " .. title);
		return;
	end
	
	local titleLabel = window:findChild("title");
	local messageLabel = window:findChild("message");
	local container = window:findChild("container");
	local detailLabel = window:findChild("detail");
	local okButton = window:findChild("okButton");
	local cancelButton = window:findChild("cancelButton");
	
	if ( titleLabel ~= nil ) then
		titleLabel.data.text = title;
	end
	
	if ( messageLabel ~= nil ) then
		messageLabel.data.text = message;
	end
	
	if ( okButton ~= nil ) then		
		okButton.userdata.index = 1;
		okButton.label.data.text = iff((#buttons < 1), "Okay", buttons[1]);
		okButton:addConnectorWithStr("onPressed", "GTKGui.Basic.selectMenuButtonCallback");
	end	
	
	if ( cancelButton ~= nil ) then
		if (#buttons < 2) then
			cancelButton:setVisible(false);
		else 
			cancelButton.userdata.index = 2;
			cancelButton.label.data.text = buttons[2];
			cancelButton:addConnectorWithStr("onPressed", "GTKGui.Basic.selectMenuButtonCallback");
		end
	end
	
	if ( container and options ) then	
		for i,opt in ipairs(options) do
			local widget = GTK.Widgets.GWidget.createGeneric(selectMenuOptionForm);
			widget.userdata.index = i;
			widget.label.data.text = opt.title;
			widget:addConnectorWithStr("onChecked", "GTKGui.Basic.selectMenuCheckedCallback");
			container:addChild(widget);
		end
	end
end

function dismissSelectMenu()
	GTK.Core.GUI:destroyWindow(selectMenuForm.name);
end

