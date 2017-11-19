---------------------------------------------------------------
-- Widget Library
---------------------------------------------------------------

-- Default Images
GTK.Core.GUI:addImage({ name="gtk-checkbox-normal", path="assets/textures/gui/gui_items.tga", origin={2469, 408}, size={20, 20} });
GTK.Core.GUI:addImage({ name="gtk-checkbox-checked", path="assets/textures/gui/gui_items.tga", origin={2466, 619}, size={20, 20} });


---------------------------------------------------------------
-- Widgets
---------------------------------------------------------------


GWidget = {
	createGeneric = function(args)		
		if ( args and args.type ~= nil ) then
			if ( GTK.Widgets[args.type] ~= nil ) then
				local self = GTK.Widgets[args.type].create(args);
	
				if ( self == nil ) then
					Console.warn("Failed to create GUI from blueprint of " .. args.type);
				end
				
				return self;
			else 
				Console.warn("[GKT] GUI Type '" .. args.type .. "' does not exist.");
			end
		end
	end,

	create = function(args) 
		local self = { };
		self.data = { };
		self.userdata = { };
		self.plugs = { };
		
		-- "Protected" Members		
		self._name = iff(args.name ~= nil, args.name, GTK.Core.GUI:nextAutoWidgetId());
		self._gtkTypes = {"widget"};
		self._parent = nil;
		self._children = { };
		self._actions = { };
		self._topLevel = false;
		self._isMouseResponder = false;
		self._isFocusResponder = false;
		self._layout = nil;
		self._needsRefresh = true;
		self._needsLayout = true;
		
		-- Data / Members
		self.enabled = iff(args.enabled ~= nil, args.enabled, true);
		self.onUpdate = args.onUpdate;

		self.data.visible = iff(args.visible ~= nil, args.visible, true);
		self.data.opacity = iff(args.opacity ~= nil, args.opacity, 1.0);
		self.data.position = iff(args.position ~= nil, args.position, {0, 0});
		self.data.gravity = iff(args.gravity ~= nil, args.gravity, nil);
		self.data.offset = iff(args.offset ~= nil, args.offset, {0, 0});
		self.data.size = iff(args.size ~= nil, args.size, {0, 0});
		self.data.minSize = iff(args.minSize ~= nil, args.minSize, {0, 0});
		self.data.maxSize = iff(args.maxSize ~= nil, args.maxSize, {0, 0});
		self.data.bgColor = iff(args.bgColor ~= nil, args.bgColor, {0, 0, 0, 0});	
		self.data.bgImage = iff(args.bgImage ~= nil, args.bgImage, nil);
		self.data.bgDrawMode = iff(args.bgDrawMode ~= nil, args.bgDrawMode, GTK.Constants.ImageDrawMode.Stretched);
		self.data.bgGravity = iff(args.bgGravity ~= nil, args.gravity, GTK.Constants.Gravity.Middle);	
		self.data.padding = iff(args.padding ~= nil, args.padding, {0, 0, 0, 0});
		self.data.borders = iff(args.borders ~= nil, args.borders, {0, 0, 0, 0});
		self.data.borderColor = iff(args.borderColor ~= nil, args.borderColor, {0, 0, 0, 255});	
		self.data.keyboardShortcut = iff(args.keyboardShortcut, args.keyboardShortcut, nil);	

		self.data.initialSize = self.data.size;		
		
		-- Some getters / setters
		
		self.name = function(self) 
			return self._name;
		end
		
		self.setVisible = function(self, value)
			self.data.visible = value;

			if (self._parent) then
				self._parent:layoutChildren();
			end

			self:onSetVisible(value);
		end	

		self.setOpacity = function(self, value)
			self.data.opacity = value;
		end

		self.hasType = function(self, value)
			for _,v in ipairs(self._gtkTypes) do
				if ( v == value ) then
					return true;
				end
			end

			return false;
		end
		
		self.setLayout = function(self, value) 
			if ( value == nil or value.layoutChildren == nil ) then
				Console.warn("[GTK] setLayout called without a Layout object (no layoutChildren method).");
				return;
			end
						
			self._layout = value;
			self._needsLayout = true;
		end
		
		self.layoutChildren = function(self)
			if ( self._layout ~= nil ) then
				self._layout:layoutChildren(self);
			end
			
			self._needsLayout = false;
		end
		
		self.setSize = function(self, param1, param2)
			if ( param1 == nil ) then			
				Console.warn("[GTK] setSize requires either setSize({x,y}) or setSize(x,y)");
				return;
			end
			
			if ( param2 == nil ) then
				self.data.size = {param1[1], param1[2]};
			else 
				self.data.size = {param1, param2};
			end
			
			self._needsLayout = true;
		end
		
		self.setPosition = function(self, x, y)
			if ( x == nil or y == nil ) then
				Console.warn("[GTK] Invalid parameters to setPosition(x, y)");
				return;
			end
			
			self.data.gravity = nil;
			self.data.position = {x, y};
		end
		
		-- Widget Hierarchy

		self.addChild = function(self, widget)
			if ( widget:hasType("widget") == false ) then
				Console.warn("Attempted to add a non-widget to a GrimTK hierarchy.");
				return;
			end

			if ( widget._parent ~= nil ) then
				Console.warn("Attempted to add a widget to a GrimTK hierarchy, but that widget already has a parent!");
				return;
			end

			if ( widget._topLevel == true ) then
				Console.warn("Attempted to add a top level widget to a GrimTK hierarchy.");
				return;
			end

			widget._parent = self;
			table.insert(self._children, widget);
			self._needsLayout = true;
		end

		self.removeChild = function(self, widget)
			widget._parent = nil;
			GTK.Core.Utils.tableRemove(self._children, widget);
			self._needsLayout = true;
		end
		
		self.removeChildAtIndex = function(self, index)
			local child = self:childAtIndex(index);
			if ( child ) then self:removeChild(child); end
		end
		
		self.removeAllChildren = function(self)
			for _,v in ipairs(self._children) do
				v._parent = nil;
			end
			
			self._children = { };
			self._needsLayout = true;
		end
		
		self.childCount = function(self)
			return #self._children;
		end
		
		self.childAtIndex = function(self, index)
			return self._children[index];
		end
		
		self.findChild = function(self, name)
			for _,v in ipairs(self._children) do
				if ( v._name == name ) then
					return v;
				end

				local find = v:findChild(name); 
				
				if ( find ~= nil ) then
					return find;
				end
			end

			return nil;
		end

		self.removeFromParent = function(self)
			if ( self._parent ~= nil ) then 
				self._parent.removeChild(self);
			end
		end
		
		self.rootWidget = function(self)
			local widget = self;
			
			while(widget._parent ~= nil) do
				widget = widget._parent;
			end
			
			return widget;
		end
		
		-- Update / Draw

		self.updatePositionInParent = function(self, gContext)
			if ( self.data.gravity == nil ) then
				return
			end

			local offset = self.data.offset;
			local size = self.data.size;
			local workspace = gContext.workspace;
			local anchor = GTK.Core.Utils.anchorFromGravity(self.data.gravity);

			self.data.position[1] = workspace.frame[1] + (workspace.frame[3] * anchor[1]) - (size[1] * anchor[1]) + offset[1];
			self.data.position[2] = workspace.frame[2] + (workspace.frame[4] * anchor[2]) - (size[2] * anchor[2]) + offset[2];
		end
		
		self.update = function(self, gContext, deltaTime)
			if ( self._needsRefresh == true ) then
				self:doRefresh();
				self._needsRefresh = false;
			end
		
			if ( self._needsLayout == true ) then
				self:doLayout();
				self:layoutChildren();
			end
		
			self:doUpdate(gContext, deltaTime);
			self:_updateActions(deltaTime);
			
			if ( self.onUpdate ) then
				self.onUpdate(self, deltaTime);
			end
		end

		self.draw = function(self, gContext)
			if ( self.data.bgColor[4] > 0 ) then
				gContext:drawRect( self.data );
			end

			if ( self.data.bgImage ~= nil ) then
				gContext:drawImage({ position=self.data.position, size=self.data.size, imageName=self.data.bgImage, drawMode=self.data.bgDrawMode, imageGravity=self.data.bgGravity });
			end
			
			if ( (self.data.borders[1] > 0) or (self.data.borders[2] > 0) or (self.data.borders[3] > 0) or (self.data.borders[4] > 0) ) then
				gContext:drawBorders( self.data );
			end
			
			if ( gContext.debugMode ) then
				local r = 255 - (#gContext._workspaces * 20);
				local g = (#gContext._workspaces * 20);
				gContext:drawBorders({ position=self.data.position, size=self.data.size, borders={1,1,1,1}, borderColor={r,g,0,255} });	
			end

			self:doDraw(gContext);
		end
		
		-- Stubs for Subclasses
		
		self.onSetVisible = function(self, value)						end

		self.doUpdate = function(self, gContext, deltaTime)				end
		self.doDraw = function(self, gContext)							end
		self.doRefresh = function(self)									end
		self.doLayout = function(self)									end
		self.doHandleMouse = function(self, mouseState)					end
		self.doHandleKeyboard = function(self, keyboardState, event)	end		
		self.doGainFocus = function(self)								end
		self.doLoseFocus = function(self)								end
		self.doKeyboardShortcut = function(self)						end
						
		-- Plugs / Hooks

		self._createPlug = function(self, method)
			self.plugs[method] = GTK.Core.GPlug.create(method);
		end

		self._triggerPlug = function(self, method, ...)
			local plug = self.plugs[method];
			
			if ( plug == nil ) then
				Console.warn("[GTK] _callHook: No plug for '" .. method .. "' on widget.");
				return;
			end

			plug:trigger(self, ...);
		end
		
		self._setCallback = function(self, method, func)
			-- Callbacks MUST NOT reference variables outside of the scope of the function, otherwise 
			-- it will not survive a save/load operation (functions move scope to the other script).
			if ( self.plugs[method] == nil ) then
				Console.warn("[GTK] _setCallback: No plug for '" .. method .. "' on widget.");
				return;
			end

			self.plugs[method].func = func;		
		end

		self.addConnector = function(self, method, target, action, component)
			if ( self.plugs[method] == nil ) then
				Console.warn("[GTK] addConnector: No plug for '" .. method .. "' on widget.");
				return;
			end

			self.plugs[method]:addConnector(target, action, component);
		end

		self.addConnectorWithStr = function(self, method, str)
			if ( self.plugs[method] == nil ) then
				Console.warn("[GTK] addConnectorWithStr: No plug for '" .. method .. "' on widget.");
				return;
			end

			self.plugs[method]:addConnectorWithStr(str);
		end

		self.removeConnector = function(self, method, target, action, component)
			if ( self.plugs[method] == nil ) then 
				Console.warn("[GTK] removeConnector: No hook for '" .. method .. "' on widget.");
				return;
			end

			self.plugs[method]:removeConnector(target, action, component);
		end

		self.removeConnectorWithStr = function(self, method, str)
			if ( self.plugs[method] == nil ) then
				Console.warn("[GTK] removeConnectorWithStr: No plug for '" .. method .. "' on widget.");
				return;
			end

			self.plugs[method]:removeConnectorWithStr(str);
		end
		
		-- Actions 

		self.runAction = function(self, action)
			if ( action == nil or action.start == nil or action.update == nil or action.finish == nil ) then
				Console.warn("[GTK] Attempted to run a 'nil' action or an action without start/update/finish methods.");
				return false;
			end
			
			table.insert(self._actions, action);
			action:start(self);
		end
		
		self._updateActions = function(self, deltaTime)
			for i=#self._actions, 1, -1 do
				local action = self._actions[i];
				action:update(deltaTime, self);
				
				if ( action.data.hasFinished ) then
					table.remove(self._actions, i);
				end
			end
		end
		
		self.stopAction = function(self, name)
			for i=#self._actions, 1 do
				if ( self._actions[i].name == name ) then
					self._actions[i]:finish(self);
					table.remove(self._actions, i);
				end
			end
		end
		
		self.stopAllActions = function(self, recursive)
			for _,action in pairs(self._actions) do
				action:finish(self);
			end
			
			self._actions = { };
			
			if ( recursive ) then
				for _,child in ipairs(self._children) do
					child:stopAllActions(recursive);
				end
			end
		end
		
		-- Enable Mouse Responder 
		
		self.enableMouseResponder = function(self)
			if ( self._isMouseResponder == false ) then		
				self._isMouseResponder = true;
				self:_createPlug("onPressed");
				self:_createPlug("onReleased");
			end
		end

		self.enableFocusResponder = function(self)
			if ( self._isFocusResponder == false ) then
				self._isFocusResponder = true;
				self:_createPlug("onGainFocus");
				self:_createPlug("onLoseFocus");
			end
		end
		
		-- Load Children / Layout from Args (After Funcs Created)
		
		if ( args.children ~= nil ) then
			for _,v in pairs(args.children) do
				local child = GWidget.createGeneric(v);
				
				if ( child ) then
					self:addChild(child);
				end
			end
		end
		
		if ( args.layout ~= nil and args.layout.type ~= nil and GTK.Widgets[args.layout.type] ~= nil ) then
			local layout = GTK.Widgets[args.layout.type].create(args.layout);
			self:setLayout(layout);
		end				

		return self;
	end
}


GWindow = {
	create = function(args)
		local self = GWidget.create(args);

		table.insert(self._gtkTypes, "window");
		self._topLevel = true;
		
		self.data.fullscreen = iff(args.fullscreen ~= nil, args.fullscreen, false);
		self.data.dimScreen = iff(args.dimScreen, args.dimScreen, false);
		self.data.lockParty = iff(args.lockParty, args.lockParty, false);
		self.data.lockKeyboard = iff(args.lockKeyboard, args.lockKeyboard, false);
		self.data.freezeAI = iff(args.freezeAI, args.freezeAI, false);

		self.data._isLockingParty = false;
		self.data._isLockingKeyboard = false;
		self.data._isFreezingAI = false;
			
		if ( args.draggable == true ) then
			self:enableMouseResponder();
		end

		self.onSetVisible = function(self, value)
			if ( value ) then 
				-- Showing Window 

				if ( self.data.lockParty and self.data._isLockingParty == false ) then
					GTK.Core.GUI:lockParty();
					self.data._isLockingParty = true;
				end

				if ( self.data.lockKeyboard and self.data._isLockingKeyboard == false ) then
					GTK.Core.GUI:lockKeyboard();
					self.data._isLockingKeyboard = true;
				end

				if ( self.data.freezeAI and self.data._isFreezingAI == false ) then
					GTK.Core.GUI:freezeAI();
					self.data._isFreezingAI = true;
				end
			else
				-- Hiding Window

				if ( self.data._isLockingParty ) then
					GTK.Core.GUI:unlockParty();
					self.data._isLockingParty = false;
				end

				if ( self.data._isLockingKeyboard ) then
					GTK.Core.GUI:unlockKeyboard();
					self.data._isLockingKeyboard = false;
				end

				if ( self.data._isFreezingAI ) then
					GTK.Core.GUI:unfreezeAI();
					self.data._isFreezingAI = false;
				end

				local focusWidget = GTK.Core.GUI:focusWidget();

				if ( focusWidget and focusWidget:rootWidget() == self ) then
					GTK.Core.GUI:setFocus(nil);
				end
			end
		end
		
		self.doHandleMouse = function(self, mouseState)
			if ( mouseState:isDown(GTK.Constants.MouseButtons.Left) ) then
				local delta = mouseState:getDelta();
				
				self.data.gravity = nil;
				self.data.position[1] = self.data.position[1] + delta[1];
				self.data.position[2] = self.data.position[2] + delta[2];
				
				local screenSize = GTK.Core.GUI:getContext():size();
				
				for i = 1,2 do
					if ( self.data.position[i] < 0 ) then
						self.data.position[i] = 0;
					elseif ( self.data.position[i] + self.data.size[i] > screenSize[i] ) then
						self.data.position[i] = screenSize[i] - self.data.size[i];
					end
				end
			end
		end

		return self;
	end
}


GImageView = {
	create = function(args)
		local self = GWidget.create(args);
		table.insert(self._gtkTypes, "imageView");

		self.data.imageName = iff(args.imageName ~= nil, args.imageName, nil);
		self.data.drawMode = iff(args.drawMode ~= nil, args.drawMode, nil);
		self.data.imageGravity = iff(args.imageGravity ~= nil, args.imageGravity, nil);
		self.data.tint = iff(args.tint ~= nil, args.tint, nil);

		self.doDraw = function(self, gContext)
			if (self.data.imageName ~= nil) then
				gContext:drawImage(self.data);
			end
		end

		return self;
	end
}


GIcon = {
	create = function(args)
		local self = GWidget.create(args);
		table.insert(self._gtkTypes, "icon");

		self.data.gfxAtlas = iff(args.gfxAtlas, args.gfxAtlas, nil);
		self.data.gfxIndex = iff(args.gfxIndex, args.gfxIndex, 0);
		self.data.drawMode = iff(args.drawMode, args.drawMode, nil);
		self.data.imageGravity = iff(args.imageGravity, args.imageGravity, nil);
		self.data.tint = iff(args.tint ~= nil, args.tint, nil);

		self.doDraw = function(self, gContext)
			if (self.data.gfxIndex ~= nil) then
				gContext:drawIcon(self.data);
			end
		end

		return self;

	end
}


GLabel = {
	create = function(args)
		local self = GWidget.create(args);
		table.insert(self._gtkTypes, "label");
		
		self.data.text = iff(args.text ~= nil, args.text, "");
		self.data.textColor = iff(args.textColor ~= nil, args.textColor, {255, 255, 255, 255});
		self.data.textAlign = iff(args.textAlign, args.textAlign, GTK.Constants.TextAlign.Left);
		self.data.font = iff(args.font ~= nil, args.font, "small");

		self.doDraw = function(self, gContext)
			if ( self.data.text ~= nil ) then
				gContext:drawText( self.data );
			end
		end

		return self;
	end
}


GTextEdit = {
	create = function(args)
		local self = GLabel.create(args);
		table.insert(self._gtkTypes, "textEdit");
		
		if ( args.bgColor == nil ) then self.data.bgColor = {0, 0, 0, 160}; end
		if ( args.borders == nil ) then self.data.borders = {1, 1, 1, 1}; end
		if ( args.padding == nil ) then self.data.padding = {4, 4, 4, 4}; end
	
		self.data.maxLength = iff(args.maxLength ~= nil, args.maxLength, 0);
		self.data.multiLine = iff(args.multiLine ~= nil, args.multiLine, false);
		self.data.cursorPos = 0;
		
		self:enableMouseResponder();
		self:enableFocusResponder();

		if ( args.onGainFocus ) then self:addConnectorWithStr("onGainFocus", args.onGainFocus); end
		if ( args.onLoseFocus ) then self:addConnectorWithStr("onLoseFocus", args.onLoseFocus); end
		
		self.doHandleMouse = function(self, mouseHandle)
			if ( mouseHandle:wasPressed(GTK.Constants.MouseButtons.Left) ) then
				GTK.Core.GUI:setFocus(self);
			end
		end
		
		self.doGainFocus = function(self)
			self.data.previousBorderColor = GTK.Core.Utils.tableDeepCopy(self.data.borderColor);
			self.data.borderColor = {255, 128, 0, 160};
			self.data.showCursor = true;
			self.data.cursorPos = #self.data.text;
		end
		
		self.doLoseFocus = function(self)
			self.data.borderColor = self.data.previousBorderColor;
			self.data.showCursor = false;
		end
		
		self.appendText = function(self, text)
			self.data.text = string.sub(self.data.text, 1, self.data.cursorPos) .. text .. string.sub(self.data.text, self.data.cursorPos+1);
			self.data.cursorPos = self.data.cursorPos + #text;
			
			if ( self.data.maxLength > 0 and #self.data.text > self.data.maxLength ) then
				self.data.text = string.sub(self.data.text, 1, self.data.maxLength);
				self.data.cursorPos = self.data.maxLength;
			end
		end
		
		self.doHandleKeyboard = function(self, keyboardState, event)
			if ( event.wasPressed ) then
				if ( event.key == GTK.Input.KeyEnter ) then
					if ( self.data.multiLine == false ) then 
						GTK.Core.GUI:setFocus(nil);
					else
						self:appendText("\n");
					end
				elseif ( event.key == GTK.Input.KeyLeft ) then
					if ( self.data.cursorPos >= 1 ) then
						self.data.cursorPos = self.data.cursorPos - 1;
					end
				elseif ( event.key == GTK.Input.KeyRight ) then
					if ( self.data.cursorPos < #self.data.text ) then
						self.data.cursorPos = self.data.cursorPos + 1;
					end
				elseif ( event.key == GTK.Input.KeyUp ) then
					self.data.cursorPos = 0;
				elseif ( event.key == GTK.Input.KeyDown ) then
					self.data.cursorPos = #self.data.text;
				elseif ( event.key == GTK.Input.KeyBackspace ) then
					if ( #self.data.text > 0 ) then
						self.data.text = string.sub(self.data.text, 1, self.data.cursorPos-1) .. string.sub(self.data.text, self.data.cursorPos+1);
						self.data.cursorPos = self.data.cursorPos - 1;
					end					
				elseif ( event.text ~= nil ) then
					self:appendText(event.text);
				end
			end
		end
		
		return self;
	end
}


GBaseButton = {
	create = function(args)
		local self = GWidget.create(args);
		table.insert(self._gtkTypes, "button");

		self:enableMouseResponder();			
		self:_createPlug("onChecked");
		
		self.data.isCheckable = iff(args.isCheckable, args.isCheckable, false);
		self.data.isChecked = iff(args.isChecked, args.isChecked, false);
		self.data.isExclusiveCheck = iff(args.isExclusiveCheck, args.isExclusiveCheck, false);		-- Exclusive check in parent widget?
		self.data.onPressedSound = iff(args.onPressedSound, args.onPressedSound, nil);
			
		if ( args.onPressed ~= nil ) then self:addConnectorWithStr("onPressed", args.onPressed); end
		if ( args.onReleased ~= nil ) then self:addConnectorWithStr("onReleased", args.onReleased); end

		self.doHandleMouse = function(self, mouseHandle)
			if ( mouseHandle:wasPressed(GTK.Constants.MouseButtons.Left) ) then				
				if ( self.data.isCheckable ) then
					self:setChecked(not self.data.isChecked);
				end

				if ( self.data.onPressedSound ) then
					playSound(self.data.onPressedSound);
				end
			end
		end
		
		self.setChecked = function(self, value)
			local wasChecked = self.data.isChecked;
			self.data.isChecked = value;
			self._needsRefresh = true;

			if ( wasChecked == false and self.data.isChecked == true ) then
				self:_triggerPlug("onChecked");

				if ( self._parent and self.data.isExclusiveCheck ) then
					for _,widget in ipairs(self._parent._children) do
						if ( widget:hasType("button") and widget ~= self ) then
							widget:setChecked(false);
						end
					end
				end
			end			
		end

		return self;
	end
}


GPushButton = {
	create = function(args)
		local self = GBaseButton.create(args);
		table.insert(self._gtkTypes, "pushbutton");
						
		self.data.bgColor = iff(args.bgColor, args.bgColor, {0, 0, 0, 128});
		self.data.borders = iff(args.borders, args.borders, {1, 1, 1, 1});
		self.data.borderColor = iff(args.borderColor, args.borderColor, {0, 0, 0, 255});
		self.data.tintHover = iff(args.tintHover ~= nil, args.tintHover, {128, 128, 128, 32});
		self.data.tintDown = iff(args.tintDown ~= nil, args.tintDown, {0, 0, 0, 32});		
		self.data.tintChecked = iff(args.tintChecked ~= nil, args.tintChecked, {255, 255, 128, 48});
		
		local labelArgs = iff(args.label, args.label, {});
		if ( labelArgs.textAlign == nil ) then labelArgs.textAlign = GTK.Constants.TextAlign.Center; end

		self.label = GLabel.create(labelArgs);
		self:addChild(self.label);

		self.doDraw = function(self, gContext)
			local mouseState = GTK.Core.GUI.mouseState;
		
			if ( self.data.isChecked ) then
				gContext:drawRect({ position=self.data.position, size=self.data.size, bgColor=self.data.tintChecked });
			end
		
			if ( mouseState:isOver(self) ) then
				if ( mouseState:isDown(GTK.Constants.MouseButtons.Left) ) then
					gContext:drawRect({ position=self.data.position, size=self.data.size, bgColor=self.data.tintDown });
				else
					gContext:drawRect({ position=self.data.position, size=self.data.size, bgColor=self.data.tintHover });
				end
			end
		end
		
		self.doLayout = function(self)
			self.label:setPosition(0, 0);
			self.label:setSize(self.data.size[1], self.data.size[2]);
		end

		self.doKeyboardShortcut = function(self)
			self:_triggerPlug("onPressed", nil);
			self:_triggerPlug("onReleased", nil);
		end
		
		return self;
	end
}


GCheckBox = {
	create = function(args)
		local self = GBaseButton.create(args);
		table.insert(self._gtkTypes, "checkbox");
		
		local labelArgs = iff(args.label, args.label, {});
		local imageArgs = iff(args.image, args.image, {});
		
		if ( labelArgs.padding == nil ) then labelArgs.padding = {4, 4, 4, 4} end
		
		self.label = GLabel.create(labelArgs);
		self.imageView = GImageView.create(imageArgs);

		self:addChild(self.label);
		self:addChild(self.imageView);
		
		self.data.isCheckable = true;
		self.data.normalImage = "gtk-checkbox-normal";
		self.data.checkedImage = "gtk-checkbox-checked";
		
		self.doRefresh = function(self)
			if (self.data.isChecked) then
				self.imageView.data.imageName = self.data.checkedImage;
			else
				self.imageView.data.imageName = self.data.normalImage;
			end
		end
				
		self.doLayout = function(self)
			local imageSize = GTK.Core.GUI:getImageSize(self.data.normalImage);
		
			self.imageView:setPosition(0, 0);
			self.imageView:setSize(imageSize);
			
			self.label:setPosition(imageSize[1] + 2, 0);
			self.label:setSize(self.data.size[1] - imageSize[1], self.data.size[2]);
		end
						
		return self;
	end
}


GRadioButton = {
	create = function(args)
		local self = GCheckBox.create(args);
		table.insert(self._gtkTypes, "radiobutton");
		
		self.data.isExclusiveCheck = true;
		
		return self;
	end
}


---------------------------------------------------------------
-- Layouts
---------------------------------------------------------------

GLayout = {
	create = function(args)
		local self = { };
		self.data = { };
		
		self.layoutChildren = function(self, widget)
			if ( #widget._children < 1 ) then
				return;
			end

			self:doLayoutChildren(widget);
		end
		
		self.doLayoutChildren = function(self, widget)
		
		end
		
		return self;
	end
}


--
-- Flow layout places items one after another without resizing any of them.
-- Almost like a text-run of characters but can be horizontal or vertical.
--
GFlowLayout = {
	create = function(args)
		local self = GLayout.create(args);
		self.data.direction = iff(args.direction, args.direction, GTK.Constants.Direction.Horizontal);
		self.data.margin = iff(args.margin, args.margin, {8,8,8,8});
		self.data.spacing = iff(args.spacing, args.spacing, {4,4});
		self.data.hideOverflow = iff(args.hideOverflow, args.hideOverflow, false);
		
		self.doLayoutChildren = function(self, widget)
			local mainAxis = iff(self.data.direction == GTK.Constants.Direction.Horizontal, 1, 2);
			local otherAxis = iff(mainAxis == 1, 2, 1);
		
			local cursor = {self.data.margin[1], self.data.margin[2]};
			local contentSize = {widget.data.size[1] - self.data.margin[1] - self.data.margin[3], widget.data.size[2] - self.data.margin[2] - self.data.margin[4]};
			local lineHeight = 0;
			local visibleChildren = { };

			for _,child in ipairs(widget._children) do
				if ( child.data.visible == true or child.data.hiddenByLayout == true ) then
					table.insert(visibleChildren, child);
				end
			end

			for _,child in ipairs(visibleChildren) do
				if ( (cursor[mainAxis] - self.data.margin[mainAxis] + child.data.size[mainAxis]) > contentSize[mainAxis] ) then
					cursor[mainAxis] = self.data.margin[mainAxis];
					cursor[otherAxis] = cursor[otherAxis] + lineHeight + self.data.spacing[otherAxis];
					lineHeight = 0;
				end
				
				if ( self.data.hideOverflow ) then
					if ( (cursor[1] - self.data.margin[1] + child.data.size[1] > contentSize[1]) or (cursor[2] - self.data.margin[2] + child.data.size[2] > contentSize[2]) ) then
						child.data.visible = false;
						child.data.hiddenByLayout = true;
					else
						child.data.visible = true;
						child.data.hiddenByLayout = nil;
					end
				end
				
				child:setPosition( cursor[1], cursor[2] );
				lineHeight = iff(child.data.size[otherAxis] > lineHeight, child.data.size[otherAxis], lineHeight);
				cursor[mainAxis] = cursor[mainAxis] + child.data.size[mainAxis] + self.data.spacing[mainAxis];
			end
		end
		
		return self;
	end
}


--
-- Box layout attempts to fill an entire area by stacking elements vertically or horizontally.
-- Elements will be resized in an attempt to make all items fit (either stretching to fill space or squishing to fit).
--
GBoxLayout = {
	create = function(args)
		local self = GLayout.create(args);
		self.data.direction = iff(args.direction, args.direction, GTK.Constants.Direction.Vertical);
		self.data.margin = iff(args.margin, args.margin, {8,8,8,8});
		self.data.spacing = iff(args.spacing, args.spacing, {4,4});
		self.data.gravity = iff(args.gravity, args.gravity, GTK.Constants.Gravity.Middle);
		
		self.doLayoutChildren = function(self, widget)
			local mainAxis = iff(self.data.direction == GTK.Constants.Direction.Horizontal, 1, 2);
			local otherAxis = iff(mainAxis == 1, 2, 1);
			local cursor = {self.data.margin[1], self.data.margin[2]};
			local contentSize = {widget.data.size[1] - self.data.margin[1] - self.data.margin[3], widget.data.size[2] - self.data.margin[2] - self.data.margin[4]};			
			local resizeIterations = 0;
			local visibleChildren = { };	

			for _,child in ipairs(widget._children) do
				if ( child.data.visible == true or child.data.hiddenByLayout == true ) then
					table.insert(visibleChildren, child);
				end
			end

			-- First worry about sizes
			-- Initially make everything the min size
			for _,child in ipairs(visibleChildren) do
				child:setSize(child.data.minSize[1], child.data.minSize[2]);
			end

			-- Then resize everything to fit
			while( resizeIterations < 10 ) do
				local totalSize = (#visibleChildren - 1) * self.data.spacing[mainAxis];
				local growableWidgets = 0;
				local shrinkableWidgets = 0;
			
				for _,child in ipairs(visibleChildren) do
					totalSize = totalSize + child.data.size[mainAxis];
					
					if ( (child.data.maxSize[mainAxis] > 0) and (child.data.size[mainAxis] < child.data.maxSize[mainAxis]) ) then growableWidgets = growableWidgets + 1; end
					if ( (child.data.minSize[mainAxis] > 0) and (child.data.size[mainAxis] > child.data.minSize[mainAxis]) ) then shrinkableWidgets = shrinkableWidgets + 1; end
				end
				
				if ( totalSize ~= contentSize[mainAxis] ) then
					local delta = 0;

					if ( (totalSize > contentSize[mainAxis]) and (shrinkableWidgets > 0) ) then
						delta = (totalSize - contentSize[mainAxis]) / shrinkableWidgets;
					elseif ( (totalSize < contentSize[mainAxis]) and (growableWidgets > 0) ) then
						delta = (totalSize - contentSize[mainAxis]) / growableWidgets;
					end
					
					if ( delta ~= 0 ) then					
						for _,child in ipairs(widget._children) do
							local size = child.data.size;
							size[mainAxis] = size[mainAxis] - delta;
							
							if ( (child.data.minSize[mainAxis] > 0) and (size[mainAxis] < child.data.minSize[mainAxis]) ) then size[mainAxis] = child.data.minSize[mainAxis] end
							if ( (child.data.maxSize[mainAxis] > 0) and (size[mainAxis] > child.data.maxSize[mainAxis]) ) then size[mainAxis] = child.data.maxSize[mainAxis] end
							child:setSize(size[1], size[2]);
						end				
					else
						resizeIterations = 100;
					end
				else
					resizeIterations = 100;
				end
				
				resizeIterations = resizeIterations + 1;
			end
			
			-- Now just assign the other axis sizes
			for _,child in ipairs(visibleChildren) do
				local size = child.data.size;
				size[otherAxis] = contentSize[otherAxis];
			
				if ( (child.data.minSize[otherAxis] > 0) and (size[otherAxis] < child.data.minSize[otherAxis]) ) then size[otherAxis] = child.data.minSize[otherAxis] end
				if ( (child.data.maxSize[otherAxis] > 0) and (size[otherAxis] > child.data.maxSize[otherAxis]) ) then size[otherAxis] = child.data.maxSize[otherAxis] end
				child:setSize(size[1], size[2]);
			end

			-- Finally, just do positioning
			for _,child in ipairs(visibleChildren) do
				local anchor = GTK.Core.Utils.anchorFromGravity(self.data.gravity);				
				cursor[otherAxis] = self.data.margin[otherAxis] + (anchor[otherAxis] * contentSize[otherAxis]) - (anchor[otherAxis] * child.data.size[otherAxis]);
				child:setPosition( cursor[1], cursor[2] );
				cursor[mainAxis] = cursor[mainAxis] + child.data.size[mainAxis] + self.data.spacing[mainAxis];				
			end
		end
		
		return self;
	end
}


---------------------------------------------------------------
-- Actions
---------------------------------------------------------------

GAction = {
	create = function(duration)
		local self = { };
		
		self.data = { };
		self.data.isImmediate = false;
		self.data.isRunning = false;
		self.data.hasFinished = false;
		self.data.time = 0.0;
		self.data.progress = 0.0;
		self.data.duration = iff(duration, duration, 3.0);			-- Negate duration = run forever (until it stops itself)
				
		self.start = function(self, widget)
			if ( widget == nil ) then
				Console.warn("[GTK] Action has not been assigned to a widget!");
				return;
			end
			
			if ( self.data.isImmediate ) then
				if ( self.data.hasFinished == false ) then
					self.data.hasFinished = true;
					self:doImmediate(widget);
				end
			else
				if ( self.data.isRunning == false and self.data.hasFinished == false ) then
					self.data.isRunning = true; 
					self:doStart(widget);
				end			
			end
		end
		
		self.update = function(self, deltaTime, widget)
			if ( self.data.isRunning == false ) then
				return;
			end
		
			self.data.time = self.data.time + deltaTime;
			self.data.progress = self.data.time / self.data.duration;
		
			if ( self.data.duration >= 0 ) then
				if ( self.data.time >= self.data.duration ) then
					self.data.time = self.data.duration;
				end
			end
			
			self:doUpdate(deltaTime, widget);
			
			if ( self.data.duration >= 0 ) then
				if ( self.data.time >= self.data.duration ) then
					self:finish(widget);
				end
			end
		end
		
		self.finish = function(self, widget)
			if ( self.data.isRunning == true ) then
				self.data.isRunning = false;
				self.data.hasFinished = true;
				self:doFinish(widget);
			end
		end
		
		-- Implementation Stubs
		self.doStart = function(self, widget)				end
		self.doUpdate = function(self, deltaTime, widget)	end
		self.doImmediate = function(self, widget)			end
		self.doFinish = function(self, widget)				end
				
		return self;
	end
}

GWaitAction = {
	create = function(duration)
		local self = GAction.create(duration);
			
		self.doUpdate = function(self, deltaTime, widget) 

		end
			
		return self;
	end
}

GCallbackAction = {
	create = function(func) 
		local self = GAction.create(-1.0);
		
		self.doImmediate = function(self, widget)
			func(widget);
		end
		
		return self;
	end
}

GMoveToAction = {
	create = function(targetPosition, duration)
		local self = GAction.create(duration);
		
		self.data.startPosition = {0, 0};
		self.data.targetPosition = targetPosition;
		
		self.doStart = function(self, widget)
			self.data.startPosition = widget.data.position;
			self.data.deltaPosition = {
				self.data.targetPosition[1] - self.data.startPosition[1], 
				self.data.targetPosition[2] - self.data.startPosition[2], 
			};
		end
		
		self.doUpdate = function(self, deltaTime, widget)
			widget:setPosition(
				self.data.startPosition[1] + (self.data.progress * self.data.deltaPosition[1]),
				self.data.startPosition[2] + (self.data.progress * self.data.deltaPosition[2])
			);
		end
		
		self.doFinish = function(self, widget)
			widget:setPosition(self.data.targetPosition[1], self.data.targetPosition[2]);
		end
		
		return self;
	end
}

GTextTypeAction = {
	create = function(text, duration)
		if ( text == nil ) then text = "" end
		if ( duration == nil ) then duration = #text/40 end
	
		local self = GAction.create(duration);
		self.data.text = text;
		
		self.doStart = function(self, widget)
			widget.data.text = "";
		end
		
		self.doUpdate = function(self, deltaTime, widget)
			local charCount = math.floor(self.data.progress * #self.data.text);
			widget.data.text = string.sub(self.data.text, 1, charCount);
		end
		
		self.doFinish = function(self, widget)
			widget.data.text = self.data.text;
		end
		
		return self;
	end
}

GFadeToAction = {
	create = function(targetOpacity, duration)
		local self = GAction.create(duration);
		
		self.data.startOpacity = 1.0;
		self.data.targetOpacity = targetOpacity;
		
		self.doStart = function(self, widget)
			self.data.startOpacity = widget.data.opacity;
			self.data.deltaOpacity = self.data.targetOpacity - self.data.startOpacity;
		end
		
		self.doUpdate = function(self, deltaTime, widget)
			local opacity = self.data.startOpacity + (self.data.progress * self.data.deltaOpacity);
			widget:setOpacity(opacity);
		end
		
		self.doFinish = function(self, widget)
			widget:setOpacity(self.data.targetOpacity);
		end
		
		return self;
	end
}

GSequenceAction = {
	create = function(actions)
		local self = GAction.create(-1.0);
		
		self.data.actions = actions;
		self.data.currentIndex = 1;
		self.data.repeatCount = 1;
		
		self.doUpdate = function(self, deltaTime, widget) 
			local index = self.data.currentIndex;
		
			if ( index <= #self.data.actions ) then
				local action = self.data.actions[index];
			
				if ( action.data.isRunning == false ) then
					action:start(widget);
				end
				
				action:update(deltaTime, widget);
				
				if ( action.data.hasFinished == true ) then
					self.data.currentIndex = index + 1;
				end
			else
				if ( self.data.repeatCount >= 0 ) then
					self.data.repeatCount = self.data.repeatCount - 1;
					
					if ( self.data.repeatCount == 0 ) then
						self:finish(widget);
					end
				end
				
				self.data.currentIndex = 1;
			end
		end
		
		return self;
	end
}

GDestroyAction = {
	create = function(func) 
		local self = GAction.create(-1.0);
		
		self.doImmediate = function(self, widget)
			widget:removeFromParent();
		end
		
		return self;
	end
}
