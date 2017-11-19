
-- Mouse state for a given widget/region (so we can detect mouse clicks differently to just "being held" events).
MouseState = {
	create = function() 
		local self = { };
		
		self.buffer1 = { };
		self.buffer1.position = {0, 0};
		self.buffer1.buttons = { };
		self.buffer1.buttons[GTK.Constants.MouseButtons.Left] = false;
		self.buffer1.buttons[GTK.Constants.MouseButtons.Middle] = false;
		self.buffer1.buttons[GTK.Constants.MouseButtons.Right] = false;
		self.buffer1.widgetStack = { };		

		self.buffer2 = GTK.Core.Utils.tableDeepCopy(self.buffer1);

		self.current = self.buffer1;
		self.last = self.buffer2;
		
		self.mouseFocus = nil;
		
		self.reset = function(self, gContext)
			if ( self.current == self.buffer1 ) then
				self.current = self.buffer2;
				self.last = self.buffer1;
			else 
				self.current = self.buffer1;
				self.last = self.buffer2;
			end

			self.current.position = gContext:mousePosition();
			self.current.buttons[GTK.Constants.MouseButtons.Left] = gContext:mouseDown(0);
			self.current.buttons[GTK.Constants.MouseButtons.Middle] = gContext:mouseDown(1);
			self.current.buttons[GTK.Constants.MouseButtons.Right] = gContext:mouseDown(2);	
			self.current.widgetStack = { };
		end
		
		self.visitWidget = function(self, gContext, widget)
			if ( widget._isMouseResponder ~= true ) then
				-- Early exit if we are not in debug mode in the editor
				if ( (Editor.isRunning() == false) or (gContext.debugMode == false) ) then
					return;
				end
			end
		
			local position = gContext:workspaceToGlobal(widget.data.position);
			local size = widget.data.size;
			local mousePos = gContext:mousePosition();

			if ( (mousePos[1] > position[1]) and (mousePos[2] > position[2]) and (mousePos[1] < position[1]+size[1]) and (mousePos[2] < position[2]+size[2]) ) then
				table.insert(self.current.widgetStack, widget);
			end				
		end
		
		self.commit = function(self)
			if ( self:isAnyDown() == false ) then
				self.mouseFocus = nil;
			end

			if ( Editor.isRunning() and GTK.Debug.isDebugWindowShown() ) then
				if ( #self.current.widgetStack > 0 ) then
					local debugWidget = self.current.widgetStack[#self.current.widgetStack];
					GTK.Debug.setDebugWidget(debugWidget);
				else
					GTK.Debug.setDebugWidget(nil);
				end
			end

			-- If something has "mouse focus" it should get a first chance at using the mouse (even if it's not under the cursor)
			if ( self.mouseFocus ~= nil ) then
				table.insert(self.current.widgetStack, self.mouseFocus);
			end
			
			local i = #self.current.widgetStack;
			
			while( i > 0 ) do
				local widget = self.current.widgetStack[i];
				i = i-1;
				
				if ( widget._isMouseResponder == true ) then
					widget:doHandleMouse(self);
				
					if ( self:wasAnyPressed() ) then
						self.mouseFocus = widget;
						widget:_triggerPlug("onPressed", self.mouseState);
					end

					if ( self:wasAnyReleased() ) then
						widget:_triggerPlug("onReleased", self.mouseState);
					end
				
					i = 0;
				end
			end
		end
		
		self.getDelta = function(self)
			return {self.current.position[1] - self.last.position[1], self.current.position[2] - self.last.position[2]};
		end
					
		self.isOver = function(self, widget)
			return GTK.Core.Utils.tableContains(self.current.widgetStack, widget);
		end
		
		self.isDown = function(self, button)
			return ( self.current.buttons[button] );
		end

		self.isAnyDown = function(self)
			return self:isDown(GTK.Constants.MouseButtons.Left) or self:isDown(GTK.Constants.MouseButtons.Middle) or self:isDown(GTK.Constants.MouseButtons.Right); 
		end

		self.wasPressed = function(self, button)
			return ( (self.current.buttons[button] == true) and (self.last.buttons[button] == false) );
		end

		self.wasAnyPressed = function(self)
			return self:wasPressed(GTK.Constants.MouseButtons.Left) or self:wasPressed(GTK.Constants.MouseButtons.Middle) or self:wasPressed(GTK.Constants.MouseButtons.Right); 
		end

		self.wasReleased = function(self, button)
			return ( (self.last.buttons[button] == true) and (self.current.buttons[button] == false) );
		end		

		self.wasAnyReleased = function(self)
			return self:wasReleased(GTK.Constants.MouseButtons.Left) or self:wasReleased(GTK.Constants.MouseButtons.Middle) or self:wasReleased(GTK.Constants.MouseButtons.Right); 
		end

		return self;
	end
}


KeyShift = string.char(16);
KeyControl = string.char(17);
KeyBackspace = string.char(8);
KeyEnter = string.char(13);
KeyEscape = string.char(27);
KeyLeft = string.char(37);
KeyRight = string.char(39);
KeyUp = string.char(38);
KeyDown = string.char(40);


KeyboardState = {
	create = function()
		local self = { };
		self._context = nil;
		self._focusWidget = nil;
		
		self.keyboardShiftValues = { ["1"]="!", ["2"]="\"", ["3"]="'", ["4"]="$", ["5"]="%", ["6"]="^", ["7"]="&", ["8"]="*", ["9"]="(", ["0"]=")" };
		self.textEntryKeys = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 
							   "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "\n", "/", "?", " ", "\"", "-", "=", "+", "[", "]", ";", ",", ".",
							   KeyBackspace, KeyEnter, KeyEscape, KeyLeft, KeyRight, KeyUp, KeyDown };
		
		self.buffer1 = { };
		self.buffer1.keys = { };
		self.buffer1.textKeysDown = { };
		self.buffer1.scannedTextKeys = false;
		
		self.buffer2 = GTK.Core.Utils.tableDeepCopy(self.buffer1);
		
		self.current = self.buffer1;
		self.last = self.buffer2;
		
		self.startTextEntry = function(self, focusWidget)
			self._focusWidget = focusWidget;
		end
		
		self.finishTextEntry = function(self)
			self._focusWidget = nil;
		end
			
		self.reset = function(self, gContext)
			if ( self.current == self.buffer1 ) then
				self.current = self.buffer2;
				self.last = self.buffer1;
			else 
				self.current = self.buffer1;
				self.last = self.buffer2;
			end
		
			self._context = gContext;
			self.current.keys = { };
			self.current.textKeysDown = { };
			self.current.scannedTextKeys = false;
			self.current.keyDownCount = 0;
			
			-- If a key was down last frame, check to see if it's still down
			for k,v in pairs(self.last.keys) do
				if ( v == true ) then
					self:isKeyDown(k);
				end
			end			
			
			-- For debugging only
			--[[
			for i = 1, 255 do
				if ( self:wasPressed(string.char(i)) ) then
					print(i, string.char(i))
				end
			end
			]]--
			
			if ( self._focusWidget ~= nil ) then
				self:scanTextEntryKeys();
			end
		end

		self.visitWidget = function(self, gContext, widget)
			if ( (self._focusWidget ~= nil) or (widget.data.keyboardShortcut == nil) ) then
				return;
			end

			if ( self:wasPressed(widget.data.keyboardShortcut) ) then
				widget:doKeyboardShortcut();
			end
		end
		
		self.commit = function(self)
			if ( self._focusWidget == nil ) then
				return
			end

			for _,k in ipairs(self.current.textKeysDown) do
				local event = {
					key = k,
					text = "",
					wasPressed = false,
					wasReleased = false
				};
										
				if ( self:wasPressed(k) ) then
					event.text = self:modifiedCharacter(k);
					event.wasPressed = true;
				elseif ( self:wasReleased(k) ) then
					event.wasReleased = true;
				end
				
				if ( event.wasPressed or event.wasReleased ) then
					self._focusWidget:doHandleKeyboard(self, event);
				end
			end
			
			if ( self:isKeyDown(KeyEscape) ) then
				GTK.Core.GUI:setFocus(nil);
			end
		end
		
		self.modifiedCharacter = function(self, c) 
			if ( self:isKeyDown(KeyShift) ) then
				if ( self.keyboardShiftValues[c] ~= nil ) then
					return self.keyboardShiftValues[c];
				end
	
				return string.upper(c);
			end
			
			return string.lower(c);
		end
		
		self.scanTextEntryKeys = function(self)
			if ( self.current.scannedTextKeys == true ) then
				return;
			end
			
			for _,v in ipairs(self.textEntryKeys) do
				self.current.keys[v] = self._context:keyDown(v);
				
				if ( self.current.keys[v] == true ) then
					table.insert(self.current.textKeysDown, v);
				end
			end		
			
			self.current.scannedTextKeys = true;
		end
		
		self.isKeyDown = function(self, key)
			if ( self.current.keys[key] == nil ) then
				self.current.keys[key] = self._context:keyDown(key);
			end
			
			return self.current.keys[key];
		end
		
		self.wasPressed = function(self, key)
			local isDown = self:isKeyDown(key);
			return ( (isDown == true) and (self.last.keys[key] ~= true) );
		end
		
		self.wasReleased = function(self, key)
			local isDown = self:isKeyDown(key);
			return ( (isDown == false) and (self.last.keys[key] == true) );			
		end
					
		return self;
	end
}
