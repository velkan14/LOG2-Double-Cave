 
-- GrimTK Constants

Gravity = {
	NorthWest = "northwest",
	North = "north",
	NorthEast = "northeast",
	East = "east",
	SouthEast = "southeast",
	South = "south", 
	SouthWest = "southwest",
	West = "west",
	Middle = "middle"
};

Fonts = {
	Tiny = "tiny",
	Small = "small",
	Medium = "medium",
	Large = "large"
};

TextAlign = {
	Left = "left",
	Center = "center",
	Right = "right"
}

Direction = {
	Horizontal = "horizontal",
	Vertical = "vertical"
};

FontInfo = {
	tiny = {
		lineHeight = 10,
	},
	small = {
		lineHeight = 12,
	},
	medium = {
		lineHeight = 14,
	},
	large = {
		lineHeight = 18,
	},	
};

MouseButtons = {
	Left = 1,
	Middle = 2,
	Right = 3
};

ImageDrawMode = {
	Stretched = "stretched",		-- Fill the entire draw area with the image, distorting if necessary.
	Tiled = "tiled",				-- Do not resize the image at all, but draw it repeatedly over the destination area.
	ScaleToBox = "scaleToBox",		-- Scale the image (up or down and maintaining aspect ratio) and fit inside the draw area using gravity.
	ShrinkToBox = "shrinkToBox",	-- If the image is bigger than the draw area, scale it down (maintaining aspect ratio) and gravity position in the draw area.
	Anchored = "anchored",			-- Draw the image at it's native size with a given gravity, even if it spills over the area.
	NineSliced = "ninesliced"		-- Slice the image up, maintaining the corners, repeating the edges over and over and tiling the middle.
};
