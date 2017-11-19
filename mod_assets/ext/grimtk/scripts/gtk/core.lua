
--[[
GraphicsContext.button(id, x, y, width, height)	
GraphicsContext.color(r, g, b, a)	
GraphicsContext.drawImage(image, x, y)	
GraphicsContext.drawImage2(image, x, y, srcX, srcY, srcWidth, srcHeight, destWidth, destHeight)	
GraphicsContext.drawParagraph(text, x, y, width)	
GraphicsContext.drawRect(x, y, width, height)	
GraphicsContext.drawText(text, x, y)	
GraphicsContext.font(font)	[“tiny”, small”, “medium” or “large”]
GraphicsContext.keyDown(key)	returns true if the given key is down.
GraphicsContext.mouseDown(button)	  returns true if a mouse button is down (0=left, 1=middle, 2=right).
GraphicsContext.width	
GraphicsContext.height	
GraphicsContext.mouseX	
GraphicsContext.mouseY
]]--

Utils = {

	tableFind = function(aTable, item)
		for i,v in ipairs(aTable) do
			if ( v == item ) then
				return i;
			end
		end

		return 0;
	end,

	tableRemove = function(aTable, item)
		local index = Utils.tableFind(aTable, item);

		if ( index > 0 ) then
			table.remove(aTable, index);
		end
	end,

	tableContains = function(aTable, item)
		for _,v in pairs(aTable) do
			if ( v == item ) then
				return true;
			end
		end

		return false;
	end,

	tableDeepCopy = function(aTable, maxDepth)
		local copy = { };
		local depth = iff(maxDepth ~= nil, maxDepth, -1);
		
		for k,v in pairs(aTable) do
			if ( (type(v) == "table") and (depth ~= 0) ) then
				--print("Deep Copy " .. k);
				copy[k] = Utils.tableDeepCopy(v, depth-1);
			else
				--print("Standard Copy " .. k);
				copy[k] = v;
			end
		end

		return copy;
	end,

	stringSplit = function(aString, separator)
		if (type(aString) ~= "string") then return {} end
        if (separator == nil) then separator = "%s" end

        local t={}; 
        local i=1;

        for str in string.gmatch(aString, "([^"..separator.."]+)") do
                t[i] = str
                i = i + 1
        end

        return t
	end,

	funcFromString = function(aString)
		if ( type(aString) ~= "string" ) then return nil; end
		local components = Utils.stringSplit(aString, ".");

		if ( #components ~= 3 ) then
			Console.warn("Connector String must have 3 components (entity.component.function).");
			return nil;
		end

		local entity = findEntity(components[1]);

		if ( entity == nil ) then
			Console.warn("Could not find entity for connector string: " .. aString);
			return nil;
		end

		local component = entity[components[2]];

		if ( component == nil ) then
			Console.warn("Could not find component for connector string: " .. aString);
			return nil;
		end

		local func = component[components[3]];

		if ( func == nil or type(func) ~= "function" ) then	
			Console.warn("Could not find function for connector string: " .. aString);
			return nil;
		end

		return func;
	end,

	anchorFromGravity = function(gravity)
		local anchor = {0.0, 0.0};

		if 		( gravity == GTK.Constants.Gravity.NorthWest ) 	then anchor = {0.0 , 0.0} 
		elseif 	( gravity == GTK.Constants.Gravity.North ) 		then anchor = {0.5 , 0.0} 
		elseif 	( gravity == GTK.Constants.Gravity.NorthEast ) 	then anchor = {1.0 , 0.0}
		elseif 	( gravity == GTK.Constants.Gravity.West ) 		then anchor = {0.0 , 0.5} 
		elseif 	( gravity == GTK.Constants.Gravity.Middle ) 	then anchor = {0.5 , 0.5} 
		elseif 	( gravity == GTK.Constants.Gravity.East ) 		then anchor = {1.0 , 0.5} 
		elseif 	( gravity == GTK.Constants.Gravity.SouthWest ) 	then anchor = {0.0 , 1.0} 
		elseif 	( gravity == GTK.Constants.Gravity.South ) 		then anchor = {0.5 , 1.0} 
		elseif 	( gravity == GTK.Constants.Gravity.SouthEast ) 	then anchor = {1.0 , 1.0} 
		end

		return anchor;
	end,

}


-- When using the editor, we fake the grimrock context with this one which check parameters.
-- Note we have to use a global variable for the current context as the grimrock context 
-- expects parameters to be called with a dot and not :.
_gDebugCurrentGrimContext = nil;

DebugNativeContext = {
	create = function()
		local self = { };

		self.start = function(self, guiContext)
			_gDebugCurrentGrimContext = guiContext;
			self.width = guiContext.width;
			self.height = guiContext.height;
			self.mouseX = guiContext.mouseX;
			self.mouseY = guiContext.mouseY;
		end

		self.finish = function()
			_gDebugCurrentGrimContext = nil;
		end

		self.button = function(id, x, y, width, height)
			if (id == nil or x == nil or y == nil or width == nil or height == nil) then
				Console.warn("[GTK] Called 'button' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.button(id, x, y, width, height);
		end

		self.drawImage = function(image, x, y)
			if (image == nil or x == nil or y == nil) then
				Console.warn("[GTK] Called 'drawImage' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.drawImage(iamge, x, y);
		end

		self.drawImage2 = function(image, x, y, srcX, srcY, srcWidth, srcHeight, destWidth, destHeight)
			if (image == nil or x == nil or y == nil or srcX == nil or srcY == nil or srcWidth == nil or srcHeight == nil or destWidth == nil or destHeight == nil) then
				Console.warn("[GTK] Called 'drawImage2' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.drawImage2(image, x, y, srcX, srcY, srcWidth, srcHeight, destWidth, destHeight);
		end

		self.drawParagraph = function(text, x, y, width)
			if (text == nil or x == nil or y == nil or width == nil) then
				Console.warn("[GTK] Called 'drawParagraph' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.drawParagraph(text, x, y, width);
		end

		self.drawRect = function(x, y, width, height)
			if (x == nil or y == nil or width == nil or height == nil) then
				Console.warn("[GTK] Called 'drawRect' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.drawRect(x, y, width, height);
		end

		self.drawText = function(text, x, y)
			if (text == nil or x == nil or y == nil) then
				Console.warn("[GTK] Called 'drawText' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.drawText(text, x, y);
		end	

		self.font = function(font)
			if (font == nil) then
				Console.warn("[GTK] Called 'font' with a nil parameter.");
				return;
			end

			_gDebugCurrentGrimContext.font(font);
		end

		self.color = function(r, g, b, a) _gDebugCurrentGrimContext.color(r, g, b, a); end
		self.keyDown = function(key) return _gDebugCurrentGrimContext.keyDown(key); end
		self.mouseDown = function(button) return _gDebugCurrentGrimContext.mouseDown(button); end
		self.getTextWidth = function(text) return _gDebugCurrentGrimContext.getTextWidth(text); end
		self.getLineHeight = function() return _gDebugCurrentGrimContext.getLineHeight(); end
		self.translate = function(x ,y) return _gDebugCurrentGrimContext.translate(x, y); end
		self.scale = function(x, y) return _gDebugCurrentGrimContext.scale(x, y); end
		self.resetTransform = function() return _gDebugCurrentGrimContext.resetTransform(); end
		self.transformPoint = function(x, y) return _gDebugCurrentGrimContext.transformPoint(x, y); end
		self.transformVector = function(v) return _gDebugCurrentGrimContext.transformVector(v); end
		self.inverseTransformPoint = function(x, y) return _gDebugCurrentGrimContext.inverseTransformPoint(x, y); end
		self.inverseTransformVector = function(v) return _gDebugCurrentGrimContext.inverseTransformVector(v); end

		return self;		
	end
}


-- Extends the Grimrock Context with more IMGUI methods
TKContext = {
	create = function()
		local self = { };

		self.debugMode = false;
		self._debugContext = nil;
		self._grimContext = nil;
		self._workspaces = { };
		self.workspace = {
			frame = {0, 0, 0, 0},
			parentComputedOpacity = 1.0,
			localOpacity = 1.0,
		};

		if ( Editor.isRunning() ) then
			self._debugContext = DebugNativeContext.create();
		end
		
		self.start = function(self, guiContext)
			if ( Editor.isRunning() ) then
				self._debugContext:start(guiContext);
				self._grimContext = self._debugContext;
			else 
				self._grimContext = guiContext;
			end

			self._workspaces = { };
			self.workspace = {
				frame = {0, 0, guiContext.width, guiContext.height},
				parentComputedOpacity = 1.0,
				localOpacity = 1.0
			};			
		end

		self.finish = function(self)
			self._grimContext = nil;
			self._workspaces = { };
			self.workspace = { };

			if ( Editor.isRunning() ) then				
				self._debugContext:finish();
				self._workspaces["dummy"] = "";				
			end
		end
		
		self.pushWorkspace = function(self, position, size)
			if ( position == nil or size == nil ) then
				Console.warn("[GTK] Internal Error: Invalid pushWorkspace call");
				position = iff(position, position, {0,0});
				size = iff(size, size, {100,100});
			end
		
			local newWorkspace = {
				frame = {self.workspace.frame[1] + position[1], self.workspace.frame[2] + position[2], size[1], size[2]},
				parentComputedOpacity = self.workspace.parentComputedOpacity * self.workspace.localOpacity,
				localOpacity = 1.0
			}

			table.insert(self._workspaces, self.workspace);
			self.workspace = newWorkspace;
		end

		self.popWorkspace = function(self)
			local topWorkspace = #self._workspaces;

			if ( topWorkspace > 0 ) then
				self.workspace = self._workspaces[topWorkspace];
				table.remove(self._workspaces, topWorkspace);
			end
		end

		self.workspaceToGlobal = function(self, position)
			return {self.workspace.frame[1] + position[1], self.workspace.frame[2] + position[2]};
		end
		
		self.setWorkspaceOpacity = function(self, opacity)
			self.workspace.localOpacity = opacity;
		end

		self._setColor = function(self, color)
			self._grimContext.color(color[1], color[2], color[3], color[4]);
		end
		
		self._setColorInWorkspace = function(self, color) 
			local a = color[4] * self.workspace.parentComputedOpacity * self.workspace.localOpacity;
			if ( a < 0.0 ) then a = 0.0; end
			
			self._grimContext.color(color[1], color[2], color[3], a);
		end

		self._setFont = function(self, font)
			if ( Utils.tableContains(GTK.Constants.Fonts, font) == false ) then	
				Console.warn("Invalid font selected");
				font = "small";
			end

			self._grimContext.font(font);
		end
		
		self.mousePosition = function(self)
			return {self._grimContext.mouseX, self._grimContext.mouseY};
		end
		
		self.mouseDown = function(self, button)
			return self._grimContext.mouseDown(button);
		end
		
		self.keyDown = function(self, key)
			return self._grimContext.keyDown(key);
		end
		
		self.size = function(self)
			return {self._grimContext.width, self._grimContext.height};
		end

		self.drawRect = function(self, args)
			if (args.position == nil or args.size == nil or args.bgColor == nil) then
				Console.warn("Invalid parameters to drawRect");
				return
			end

			local position = self:workspaceToGlobal(args.position);

			self:_setColorInWorkspace(args.bgColor);
			self._grimContext.drawRect(position[1], position[2], args.size[1], args.size[2]);
		end
		
		self.drawBorders = function(self, args)
			if (args.position == nil or args.size == nil or args.borders == nil) then
				Console.warn("Invalid parameters to drawBorders");
				return
			end
			
			local position = self:workspaceToGlobal(args.position);
			local borderColor = iff(args.borderColor ~= nil, args.borderColor, {0, 0, 0, 255});			
			self:_setColorInWorkspace(borderColor);
			
			if ( args.borders[1] > 0 ) then		-- Left
				self._grimContext.drawRect( position[1] - args.borders[1],  position[2], args.borders[1], args.size[2] );
			end
			
			if ( args.borders[2] > 0 ) then		-- Top
				self._grimContext.drawRect( position[1] - args.borders[1],  position[2] - args.borders[2], args.size[1] + args.borders[1] + args.borders[3], args.borders[2] );
			end
			
			if ( args.borders[3] > 0 ) then		-- Right
				self._grimContext.drawRect( position[1] + args.size[1],  position[2], args.borders[1], args.size[2] );
			end
			
			if ( args.borders[3] > 0 ) then		-- Bottom
				self._grimContext.drawRect( position[1] - args.borders[1],  position[2] + args.size[2], args.size[1] + args.borders[1] + args.borders[3], args.borders[2] );
			end
		end

		self.drawText = function(self, args)
			if (args.position == nil or args.size == nil or args.text == nil) then
				Console.warn("Invalid parameters to drawText");
				return
			end

			local position = self:workspaceToGlobal(args.position);
			local padding = iff(args.padding ~= nil, args.padding, {0, 0, 0, 0});
			local textColor = iff(args.textColor ~= nil, args.textColor, {0,0,0,0});
			local font = iff(args.font ~= nil, args.font, "tiny");
			local text = args.text;
			
			position[1] = position[1] + padding[1];
			position[2] = position[2] + padding[2] + GTK.Constants.FontInfo[font].lineHeight;
			local width = args.size[1] - padding[1] - padding[3];
			
			-- Prevent infinite loop
			if ( width < 20 ) then
				Console.warn("[GTK] Cannot drawParagraph with width < 20.");
				return;
			end
			
			if ( args.showCursor and args.cursorPos and args.cursorPos <= #text ) then
				text = string.sub(text, 1, args.cursorPos) .. "|" .. string.sub(text, args.cursorPos+1);
			end

			self:_setColorInWorkspace(textColor);
			self:_setFont(font);

			if ( args.textAlign == nil or args.textAlign == GTK.Constants.TextAlign.Left ) then
				self._grimContext.drawParagraph(text, position[1], position[2], width);				
			else
				local textWidth = self._grimContext.getTextWidth(text);

				if ( textWidth > width ) then 
					textWidth = width;
				end

				if ( args.textAlign == GTK.Constants.TextAlign.Right ) then
					position[1] = position[1] + width - textWidth;
				else
					position[1] = position[1] + (width - textWidth) * 0.5;
				end

				self._grimContext.drawParagraph(text, position[1], position[2], textWidth + 2); -- Pad by two, as sometimes exact textWidth causes wrap.
			end
		end

		self._doDrawTiled = function(self, position, size, imagePath, imageOrigin, imageSize)
			local cursor = {0,0};
			local i = 0;

			if ( imageSize[1] < 4 or imageSize[2] < 4 ) then
				return false;
			end

			while( cursor[2] < size[2] ) do
				local tile = {imageSize[1], imageSize[2]};
				i = i+1;

				for i=1,2 do
					if ( cursor[i] + imageSize[i] > size[i] ) then
						tile[i] = size[i] - cursor[i];
					end
				end

				self._grimContext.drawImage2(imagePath, position[1] + cursor[1], position[2] + cursor[2], imageOrigin[1], imageOrigin[2], tile[1], tile[2], tile[1], tile[2]);		
				cursor[1] = cursor[1] + imageSize[1];

				if ( cursor[1] > size[1] ) then
					cursor[1] = 0;
					cursor[2] = cursor[2] + imageSize[2];
				end

				if ( i > 100 ) then
					return;
				end			
			end
		end

		self.drawIcon = function(self, args)
			if ( args.position == nil or args.size == nil or args.gfxIndex == nil) then
				Console.warn("Invalid parameters to drawIcon");
				return false;
			end

			local path = args.gfxAtlas;
			local index = args.gfxIndex;
			local atlasWidth = iff(args.atlasWidth, args.gfxAtlasWidth, 13);
			local iconWidth = 75;
			local iconHeight = 75;

			if ( path == nil ) then
				-- Built in atlasses (0-168 is atlas one, 200-368 is atlas two, etc).
				local builtInGfxAtlasIndex = math.floor(args.gfxIndex / 200);
				index = index - (builtInGfxAtlasIndex * 200);
				index = index % (atlasWidth * atlasWidth);

				if ( builtInGfxAtlasIndex == 0 ) then
					path = "assets/textures/gui/items.tga";
				else
					path = "assets/textures/gui/items_" .. (builtInGfxAtlasIndex + 1) .. ".tga";
				end
			end

			local image = {
				path = path,
				origin = { iconWidth * (index % atlasWidth), iconHeight * math.floor(index / atlasWidth) }, 
				size = { iconWidth, iconHeight }
			}

			local imageArgs = {
				image = image,
				position = args.position,
				size = args.size,
				drawMode = args.drawMode,
				imageGravity = args.imageGravity,
			}

			self:drawImage(imageArgs);
		end

		self.drawImage = function(self, args)
			if (args.position == nil or args.size == nil) then
				Console.warn("Invalid parameters to drawImage");
				return false;
			end

			local image = args.image;

			if (image == nil and args.imageName) then
				image = GTK.Core.GUI:getImage(args.imageName);
			end

			if (image == nil) then
				Console.warn("No valid image to draw");
				return false;
			end

			local position = self:workspaceToGlobal(args.position);
			local drawMode = iff(args.drawMode ~= nil, args.drawMode, GTK.Constants.ImageDrawMode.Stretched);
			local imageGravity = iff(args.imageGravity ~= nil, args.imageGravity, GTK.Constants.Gravity.Middle);
			local tint = iff(args.tint ~= nil, args.tint, {255, 255, 255, 255});

			self:_setColorInWorkspace(tint);

			if ( drawMode == GTK.Constants.ImageDrawMode.Stretched ) then
				self._grimContext.drawImage2(image.path, position[1], position[2], image.origin[1], image.origin[2], image.size[1], image.size[2], args.size[1], args.size[2]);
			end

			if ( drawMode == GTK.Constants.ImageDrawMode.Tiled ) then
				self:_doDrawTiled(position, args.size, image.path, image.origin, image.size);
			end

			if ( drawMode == GTK.Constants.ImageDrawMode.Anchored ) then
				local anchor = Utils.anchorFromGravity(imageGravity);
				local origin = {image.origin[1], image.origin[2]};
				local size = {image.size[1], image.size[2]};

				for i=1,2 do
					position[i] = position[i] + (args.size[i] * anchor[i]) - (image.size[i] * anchor[i]);

					if ( size[i] > args.size[i] ) then
						local delta = size[i] - args.size[i];
						position[i] = position[i] + (delta * anchor[i]);
						origin[i] = origin[i] + (delta * anchor[i]);
						size[i] = args.size[i];
					end
				end

				self._grimContext.drawImage2(image.path, position[1], position[2], origin[1], origin[2], size[1], size[2], size[1], size[2]);
			end

			if ( drawMode == GTK.Constants.ImageDrawMode.ShrinkToBox or drawMode == GTK.Constants.ImageDrawMode.ScaleToBox ) then
				local imgWHRatio = image.size[1] / image.size[2];
				local frameWHRatio = args.size[1] / args.size[2];
				local scaleFactor = 1.0;

				if ( imgWHRatio > frameWHRatio ) then
					scaleFactor = args.size[1] / image.size[1];
				else 
					scaleFactor = args.size[2] / image.size[2];
				end

				-- In ShrinkToBox mode, we only scale if the image is bigger than the box
				if ( scaleFactor > 1.0 and drawMode == GTK.Constants.ImageDrawMode.ShrinkToBox ) then
					scaleFactor = 1.0;
				end

				local anchor = Utils.anchorFromGravity(imageGravity);
				local outSize = {image.size[1] * scaleFactor, image.size[2] * scaleFactor};
				
				for i=1,2 do
					position[i] = position[i] + (args.size[i] * anchor[i]) - (outSize[i] * anchor[i]);
				end

				self._grimContext.drawImage2(image.path, position[1], position[2], image.origin[1], image.origin[2], image.size[1], image.size[2], outSize[1], outSize[2] );
			end

			if ( drawMode == GTK.Constants.ImageDrawMode.NineSliced ) then
				if ( image.margin == nil ) then 
					Console.warn("NineSliced images require margins");
					return false;
				end

				local size = {args.size[1], args.size[2]};
				local origin = {image.origin[1], image.origin[2]};
				local margin = image.margin;

				-- Draw Corners
				self._grimContext.drawImage2(image.path, position[1], position[2], origin[1], origin[2], margin[1], margin[2], margin[1], margin[2]);
				self._grimContext.drawImage2(image.path, position[1]+size[1]-margin[3], position[2], origin[1]+image.size[1]-margin[3], origin[2], margin[3], margin[2], margin[3], margin[2]);
				self._grimContext.drawImage2(image.path, position[1], position[2]+size[2]-margin[4], origin[1], origin[2]+image.size[2]-margin[4], margin[1], margin[4], margin[1], margin[4]);
				self._grimContext.drawImage2(image.path, position[1]+size[1]-margin[3], position[2]+size[2]-margin[4], origin[1]+image.size[1]-margin[3], origin[2]+image.size[2]-margin[4], margin[3], margin[4], margin[3], margin[4]);

				-- Draw Edges
				-- self._doDrawTiled = function(self, position, size, imagePath, imageOrigin, imageSize)
				self:_doDrawTiled(
					{position[1]+margin[1], position[2]}, 
					{size[1]-margin[1]-margin[3], margin[2]}, 
					image.path, 
					{origin[1]+margin[1], origin[2]}, 
					{image.size[1]-margin[1]-margin[3], margin[2]}
				);

				self:_doDrawTiled(
					{position[1], position[2]+margin[2]}, 
					{margin[1], size[2]-margin[2]-margin[4]}, 
					image.path, 
					{origin[1], origin[2]+margin[2]}, 
					{margin[1], image.size[2]-margin[2]-margin[4]}
				);				

				self:_doDrawTiled(
					{position[1]+margin[1], position[2]+size[2]-margin[4]}, 
					{size[1]-margin[1]-margin[3], margin[4]}, 
					image.path, 
					{origin[1]+margin[1], origin[2]+image.size[2]-margin[4]}, 
					{image.size[1]-margin[1]-margin[3], margin[2]}
				);

				self:_doDrawTiled(
					{position[1]+size[1]-margin[3], position[2]+margin[2]}, 
					{margin[3], size[2]-margin[2]-margin[4]}, 
					image.path, 
					{origin[1]+image.size[1]-margin[3], origin[2]+margin[2]}, 
					{margin[3], image.size[2]-margin[2]-margin[4]}
				);				

				-- Draw Middle
				self:_doDrawTiled(
					{position[1]+margin[1], position[2]+margin[2]},
					{size[1]-margin[1]-margin[3], size[2]-margin[2]-margin[4]},
					image.path,
					{origin[1]+margin[1], origin[2]+margin[2]},
					{image.size[1]-margin[1]-margin[3], image.size[2]-margin[2]-margin[4]}
				);

			end

			return true;
		end

		return self;
	end
}


-- Global GrimTK Object  
GUI = {
	_tkContext = TKContext.create(),
	_debugMessages = { },
	_windows = { },
	_images = { },
	_updateables = { },
	_shortcuts = { },
	_nextAutoId = 1,
	_focusWidget = nil,
	_partyLocks = 0,
	_keyboardLocks = 0,
	_aiLocks = 0,
	_lastUpdateTime = 0,
	_deltaTime = 0,
	_maxDeltaTime = 0.25,
	_delayedCalls = { },
	isEnabled = true,
	dimBackground = false,
	mouseState = GTK.Input.MouseState.create(),
	keyboardState = GTK.Input.KeyboardState.create(),
	
	getContext = function(self)
		return self._tkContext;
	end,

	addWindow = function(self, window)
		if ( window:name() == nil ) then 
			Console.warn("Cannot create Root window without a name.");
			return false;
		end

		if ( self._windows[window:name()] ~= nil ) then
			Console.warn("Root window already exists with that name.");
			return false;
		end

		self._windows[window:name()] = window;
		self:showWindow(window:name());
		return true;
	end,
	
	createWindow = function(self, args)
		local window = GTK.Widgets.GWindow.create(args);
		
		if ( self:addWindow(window) == true ) then
			return window;
		end

		return nil;
	end,

	destroyWindow = function(self, window)
		local windowName = nil;

		if ( type(window) == "table" ) then
			windowName = window:name();
		elseif ( type(window) == "string" ) then
			windowName = window;
		end

		if ( windowName and self._windows[windowName] ) then
			self:hideWindow(windowName);
			self._windows[windowName] = nil;
		end
	end,
	
	getWindow = function(self, windowName) 
		return self._windows[windowName];
	end,
	
	showWindow = function(self, windowName)
		local window = self._windows[windowName];
		
		if ( window ) then 
			window:setVisible(true);
		end
	end,
	
	hideWindow = function(self, windowName)
		local window = self._windows[windowName];
		
		if ( window ) then 
			window:setVisible(false);
		end
	end,

	addUpdateable = function(self, updateable)
		if ( updateable.update == nil or type(updateable.update) ~= "function" or updateable.updateableId == nil ) then
			Console.warn("[GTK] Attempted to register invalid updateable");
			return;
		end

		if ( self._updateables[updateable.updateableId] ~= nil ) then
			Console.warn("[GTK] An updateable with that name already exists.");
			return;
		end

		if ( updateable.startUpdates ~= nil ) then
			updateable:startUpdates();
		end

		self._updateables[updateable.updateableId] = updateable;
	end,

	removeUpdateable = function(self, updateable)
		local id = nil;

		if ( type(updateable) == "string" ) then
			id = updateable;
		elseif ( updateable.updateableId ~= nil ) then
			id = updateable.updateableId;
		end

		if ( id and self._updateables[id] ~= nil ) then
			if ( self._updateables[id].endUpdates ~= nil ) then
				self._updateables[id]:endUpdates();
			end

			self._updateables[id] = nil;
		end
	end,
	
	update = function(self, guiContext)
		if ( self.isEnabled == false ) then
			return
		end

		local playTime = GameMode.getStatistic("play_time");
		self._deltaTime = playTime - self._lastUpdateTime;
		self._lastUpdateTime = playTime;

		if ( self._deltaTime > self._maxDeltaTime ) then 
			self._deltaTime = self._maxDeltaTime; 
		end

		if ( #self._delayedCalls > 0 ) then
			local toRemove = { };

			for i=#self._delayedCalls,1,-1 do
				local v = self._delayedCalls[i];
				v["delay"] = v["delay"] - self._deltaTime;

				if ( v["delay"] < 0 ) then
					if ( v["func"] ) then
						v["func"](v["param"]);
					end

					table.remove(self._delayedCalls, i);
				end
			end
		end

		for _,updateable in pairs(self._updateables) do
			updateable:update(self._deltaTime);
		end
						
		self._tkContext:start(guiContext);
		self.mouseState:reset(self._tkContext);
		self.keyboardState:reset(self._tkContext);

		local dimScreen = false;
		local screenSize = self._tkContext:size();
		
		for _,window in pairs(self._windows) do
			if ( window.data.dimScreen ) then
				dimScreen = true;
			end
		end
		
		if ( dimScreen ) then
			self._tkContext:drawRect({ position={0,0}, size=screenSize, bgColor={0, 0, 0, 160} });
		end
		
		for _,window in pairs(self._windows) do
			if ( window.data.visible == true ) then
				if ( (window.data.fullscreen == true) and ((window.data.size[1] == screenSize[1]) or (window.data.size[2] ~= screenSize[2])) ) then
					window:setSize(screenSize[1], screenSize[2]);
				end
				
				self:visit(window);				
			end
		end
		
		if ( #self._debugMessages > 0 ) then
			self._tkContext:drawText({ position={10, 10}, size={1200, screenSize[2]-20}, text=table.concat(self._debugMessages, "\n"), textColor={255,255,255,255}, font="tiny" });
		end

		self.keyboardState:commit();
		self.mouseState:commit();
		self._tkContext:finish();
	end,
		
	visit = function(self, widget)		
		if ( widget == nil or widget.data.visible == false ) then
			return
		end
				
		widget:updatePositionInParent(self._tkContext);

		-- Slightly annoying that we do mouse stuff here (and it's not completely separate)
		-- but it's more efficient to only walk the tree of workspaces once...
		self.mouseState:visitWidget(self._tkContext, widget);
		self.keyboardState:visitWidget(self._tkContext, widget);

		widget:update(self._tkContext, self._deltaTime);
		
		self._tkContext:setWorkspaceOpacity(widget.data.opacity);
		widget:draw(self._tkContext);
	
		self._tkContext:pushWorkspace(widget.data.position, widget.data.size);
		
		for _,child in ipairs(widget._children) do
			self:visit(child);
		end

		self._tkContext:popWorkspace();
	end,

	addImage = function(self, args)
		local image = { };

		if ( (args.name == nil) or (args.path == nil) or (args.size == nil)) then
			Console.warn("[addImage] requires at least a name, a path and a size.");
		end

		if ( args.path:sub(-4):lower() ~= ".tga" ) then
			Console.warn("[addImage] '" .. args.path .. "' does not end in .tga");
		end

		if ( args.path:find("//") ) then
			Console.warn("[addImage] '" .. args.path .. "' conains '//' which WILL FAIL when exported!");
		end

		if ( (args.path:sub(1, 6) ~= "assets") and (args.path:sub(1, 10) ~= "mod_assets") ) then
			Console.warn("[addImage] '" .. args.path .. "' does not start with assets or mod_assets." );
		end

		image.name = args.name;
		image.path = args.path;
		image.size = args.size;
		image.margin = iff(args.margin ~= nil, args.margin, {8, 8, 8, 8});
		image.origin = iff(args.origin ~= nil, args.origin, {0,0});		

		self._images[image.name] = image;
	end,

	getImage = function(self, name) 
		return self._images[name];
	end,
	
	getImageSize = function(self, name)
		local image = self._images[name];
		if ( image == nil ) then return {0, 0}; end
		return image.size;
	end,

	nextAutoWidgetId = function(self)
		local id = "widget_" .. self._nextAutoId;
		self._nextAutoId = self._nextAutoId + 1;
		return id;
	end,
	
	setFocus = function(self, widget)
		if ( self._focusWidget ~= nil ) then
			self:unlockKeyboard();
			self:unlockParty();
			self.keyboardState:finishTextEntry();
			self._focusWidget:_triggerPlug("onLoseFocus");
			self._focusWidget:doLoseFocus();
			self._focusWidget = nil;			
		end
			
		if ( widget ~= nil ) then
			self:lockKeyboard();
			self:lockParty();
			self.keyboardState:startTextEntry(widget);
			self._focusWidget = widget;
			self._focusWidget:doGainFocus();
			self._focusWidget:_triggerPlug("onGainFocus");
			GameMode.setGameFlag("DisableKeyboardShortcuts", true);
		end
	end,

	focusWidget = function(self)
		return self._focusWidget;
	end,

	delayedCall = function(self, delay, param, func)
		table.insert(self._delayedCalls, {delay = delay, func = func, param = param});
	end,
	
	lockParty = function(self)
		self._partyLocks = self._partyLocks + 1;
		GameMode.setGameFlag("DisableMovement", true);
		GameMode.setGameFlag("DisableMouseLook", true);
	end,
	
	unlockParty = function(self)
		self._partyLocks = self._partyLocks - 1;

		if ( self._partyLocks <= 0 ) then
			GameMode.setGameFlag("DisableMovement", false);
			GameMode.setGameFlag("DisableMouseLook", false);
			self._partyLocks = 0;
		end
	end,
	
	isPartyLocked = function(self)
		return self._partyLocks > 0;
	end,

	lockKeyboard = function(self)
		self._keyboardLocks = self._keyboardLocks + 1;
		GameMode.setGameFlag("DisableKeyboardShortcuts", true);
	end,

	unlockKeyboard = function(self)
		self._keyboardLocks = self._keyboardLocks - 1;

		if ( self._keyboardLocks <= 0 ) then
			self._keyboardLocks = 0;

			self:delayedCall(0.1, self, function(self) 
				if ( self._keyboardLocks == 0 ) then
					GameMode.setGameFlag("DisableKeyboardShortcuts", false); 
				end
			end);
		end
	end,

	isKeyboardLocked = function(self)
		return self._keyboardLocks > 0;
	end,

	freezeAI = function(self)
		self._aiLocks = self._aiLocks + 1;
		GameMode.setGameFlag("DisableMonsterAI", true);
	end,

	unfreezeAI = function(self)
		self._aiLocks = self._aiLocks - 1;

		if ( self._aiLocks <= 0 ) then
			GameMode.setGameFlag("DisableMonsterAI", false);
			self._aiLocks = 0;
		end
	end,

	isAIFrozen = function(self)
		return self._aiLocks > 0;
	end,

	log = function(self, message)
		if ( #self._debugMessages > 50 ) then
			table.remove(self._debugMessages, 1);
		end

		table.insert(self._debugMessages, message);
	end,
	
	clearDebug = function(self)
		self._debugMessages = { };
	end,

	toggleDebug = function(self)
		if ( self._tkContext.debugMode == false) then
			self._tkContext.debugMode = true;

			if ( Editor.isRunning() )  then
				GTK.Debug.showDebugWindow();
			end
		else
			self._tkContext.debugMode = false;

			if ( Editor.isRunning() ) then
				GTK.Debug.destroyDebugWindow();
			end
		end
	end,
	
}


-- A Plug provides a hooked function AND a basic connector mechanism
GPlug = {
	create = function(method)
		local self = { };
		self.method = method;
		self.callback = nil;		-- Intended for internal GUI use only
		self.connectors = { 		
			-- { target, method }
		};

		self.addConnector = function(self, target, action, component)
			if ( component == nil ) then component = "script" end

			if ( type(target) == "string" and type(action) == "string" ) then
				table.insert(self.connectors, {t=target, a=action, c=component});
			else
				Console.warn("[GTK] Invalid parameters to addConnector");
			end
		end

		self.addConnectorWithStr = function(self, connectorStr)
			local parameters = Utils.stringSplit(connectorStr, ".");

			if ( #parameters ~= 3 ) then
				Console.warn("[GTK] Adding a connector using a string must use the form entity.component.function");
			end

			self:addConnector(parameters[1], parameters[3], parameters[2]);
		end 

		self.removeConnector = function(self, target, action, component)
			if ( component == nil ) then component = "script" end
			local index = 0;

			for i,v in ipairs(self.connectors) do
				if ( v.t == target and v.a == action and v.c == component ) then
					index = i;
				end
			end

			if ( index > 0 ) then
				table.remove(self.connectors, index);
			end
		end

		self.removeConnectorWithStr = function(self, connectorStr)
			local parameters = Utils.stringSplit(connectorStr, ".");

			if ( #parameters ~= 3 ) then
				Console.warn("[GTK] Removing a connector using a string must use the form entity.component.function");
			end

			self:removeConnector(parameters[1], parameters[3], parameters[2]);
		end 

		self.removeAllConnectors = function(self)
			self.connectors = { };
		end

		self.trigger = function(self, ...)		
			if self.callback then
				self.callback(...);
			end

			for i,v in ipairs(self.connectors) do
				local e = findEntity(v.t);

				if ( e == nil ) then
					Console.warn("[GTK] Could not find target entity '" .. v.t .. "' for connector '" .. self.method .. "'.");
				elseif ( e[v.c] == nil ) then
					Console.warn("[GTK] Could not find entity component '" .. v.t .. "." .. v.c .. " for connector '" .. self.method .. "'.");
				else 
					local f = e[v.c][v.a];

					if ( f == nil or type(f) ~= "function" ) then
						Console.warn("[GTK] Could not find method '" .. v[2] .. "' on target entity '" .. v[1] .. "' for connector '" .. self.method .. "'.");
					else
						f(...);
					end
				end
			end
		end

		return self;
	end
}

