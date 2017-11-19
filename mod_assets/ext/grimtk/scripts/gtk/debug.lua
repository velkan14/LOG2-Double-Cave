
kDebugFormName = "gtk_debug_window";

kDebugForm = {
	name = kDebugFormName,
	type = "GWindow",
	size = {200, 240},
	bgColor = {0, 0, 0, 128},
	offset = {-2, 2},
	gravity = GTK.Constants.Gravity.NorthEast,
	children = 
	{
		{
			name = "debugLabel",
			type = "GLabel",
			text = "-",
			position = {5, 5},
			size = {190, 230},
			font = GTK.Constants.Fonts.Tiny,
		}
	}
}


function showDebugWindow()
	if ( GTK.Core.GUI:getWindow(kDebugFormName) ) then
		Console.warn("[GTK] DebugWindow is already showing.");
		return
	end

	local form = kDebugForm;
	local window = GTK.Core.GUI:createWindow(form);

	if ( window == nil ) then
		return
	end
end


function destroyDebugWindow()
	GTK.Core.GUI:destroyWindow(kDebugFormName);
end


function isDebugWindowShown() 
	return (GTK.Core.GUI:getWindow(kDebugFormName) ~= nil);
end


function widgetDescription(widget, title)
	if ( widget == nil ) then
		return "";
	end

	local text ="";
	text = text .. title .. ": " .. widget:name() .. "\n";
	text = text .. " Type: " .. widget._gtkTypes[#widget._gtkTypes] .. "\n";
	text = text .. " Position: " .. widget.data.position[1] .. ", " .. widget.data.position[2] .. "\n";
	text = text .. " Size: " .. widget.data.size[1] .. ", " .. widget.data.size[2] .. "\n";

	return text;
end


function setDebugWidget(widget)
	local window = GTK.Core.GUI:getWindow(kDebugFormName);

	if ( window == nil ) then
		return;
	end

	local debugLabel = window:findChild("debugLabel");

	if ( debugLabel == nil ) then
		return;
	end

	if ( widget == nil ) then
		debugLabel.data.text = "Mouse Over a Widget";
		return;
	end

	local text = widgetDescription(widget, "Widget");

	if ( widget._parent ) then
		text = text .. "\n" .. widgetDescription(widget._parent, "Parent");
	end

	debugLabel.data.text = text;
end
