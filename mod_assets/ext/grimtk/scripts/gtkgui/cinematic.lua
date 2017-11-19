
---------------------------------------------------------------
-- Cinematic Playback System
---------------------------------------------------------------

--[[
-- cinematic with a title and story text
enableUserInput()
startMusic("assets/samples/music/intro.ogg")

showImage("assets/textures/cinematic/intro/page01.tga")
fadeIn(2)

-- show the title text
sleep(1)
setFont("IntroTitle")
showText("The Sinister Bannister", 3)
sleep(2)
fadeOutText(1)

-- show the story text
sleep(1)
setFont("Intro")
textWriter([ [
Some folks call it the Evil Railing. Or the Vile Balustrade.
However, no matter what you decide to call it, it is certain that
the Sinister Bannister is an ancient source of distraught and ill fortune.

You must venture forth and disassemble the nefarious inanimate object!
] ])
click()
fadeOutText(0.5)

fadeOut(4)
fadeOutMusic(3)
]]--

cinematicPlayerFormName = "cinematicPlayerForm";
isCinematicPlaying = false;

cinematicPlayerForm = 
{
	name = cinematicPlayerFormName,
	type = "GWindow",
	fullscreen = true,
	bgColor = {0, 0, 0, 255},
	children = 
	{

	}	
}


GCinematicPlayer = {
	create = function(args)
		local self = { };
		self.updateableId = "cinematic";
		self.window = nil;
		self.timeline = { };
		self.playerTime = 0.0;
		self.endTime = 0.0;

		-- State variables used when building the queue
		self.queueTime = 0.0;
		self.queueFont = "medium";		


		self.runCinematic = function(self, cinemaFunc)
			if ( isCinematicPlaying ) then
				Console.warn("[GTK] Cinematic already playing!");
				return;
			end

			-- Builds the timeline
			cinemaFunc(self);

			-- Note the end time
			self.endTime = self.queueTime;

			-- Create the window
			if ( GTK.Core.GUI:getWindow(cinematicPlayerFormName) == nil ) then
				GTK.Core.GUI:createWindow(cinematicPlayerForm);
			end

			self.window = GTK.Core.GUI:getWindow(cinematicPlayerFormName);
			self.window:setVisible(true);
			self.window:setOpacity(0.0);

			-- Register for ticks
			GTK.Core.GUI:addUpdateable(self);

			-- Only one cinematic at a time!
			isCinematicPlaying = true;
		end

		self.stopCinematic = function(self)
			if ( isCinematicPlaying ) then
				isCinematicPlaying = false;	
				self.window:setVisible(false);		
				GTK.Core.GUI:removeUpdateable(self);
			end
		end

		self.update = function(self, deltaTime)
			self.playerTime = self.playerTime + deltaTime;

			for _,item in ipairs(self.timeline) do
				if ( item.started == false and self.playerTime > item.startTime ) then
					item:runAction(self);
				end
			end

			if ( self.playerTime > self.endTime ) then
				self:stopCinematic();
			end
		end

		self.queueAction = function(self, action, args)
			table.insert(self.timeline, GCinematicAction.create(self.queueTime, action, args));
		end

		self.sleep = function(self, duration)
			self.queueTime = self.queueTime + duration;
		end

		self.fadeInPlayer = function(self, duration)
			local action = function(player, args)
				player.window:runAction(GTK.Widgets.GFadeToAction.create(1.0, args.duration));
			end

			self:queueAction(action, {duration=duration});
			self.queueTime = self.queueTime + duration;
		end

		self.fadeOutPlayer = function(self, duration)
			local action = function(player, args)
				player.window:runAction(GTK.Widgets.GFadeToAction.create(0.0, args.duration));
			end

			self:queueAction(action, {duration=duration});
			self.queueTime = self.queueTime + duration;
		end

		self.setFont = function(self, font)
			self.queueFont = font;
		end

		self.startMusic = function(self, music)
			local action = function(player, args)
				GameMode.playStream(args.music)
			end

			self:queueAction(action, {music=music});
		end

		self.showText = function(self, text, duration)
			local action = function(player, args)
				local widget = GTK.Widgets.GLabel.create({
					text = args.text,
					size = {#text * 20, 100},
					gravity = GTK.Constants.Gravity.North,
					offset = {0, 40},
					opacity = 0.0,
					font = GTK.Constants.Fonts.Large,
					textColor = {255, 255, 255, 255}
				});

				local fadeTime = 0.0;

				if ( duration > 1.0 ) then
					fadeTime = 0.2;
				end

				local sequence = GTK.Widgets.GSequenceAction.create({
					GTK.Widgets.GFadeToAction.create(1.0, fadeTime),
					GTK.Widgets.GWaitAction.create(duration - 2 * fadeTime),
					GTK.Widgets.GFadeToAction.create(0.0, fadeTime),
					GTK.Widgets.GDestroyAction.create(),
				});				

				widget:runAction(sequence);
				player.window:addChild(widget);
			end

			self:queueAction(action, {text=text, duration=duration});
		end

		self.showImage = function(self, image, duration)
			
		end
	
		return self;
	end
}


GCinematicAction = {
	create = function(startTime, action, args)
		local self = { };
		self.startTime = startTime;
		self.action = action;
		self.args = args;
		self.started = false;

		self.runAction = function(self, player)
			self.action(player, self.args);
			self.started = true;
		end

		return self;
	end	
}


function playCinematic(cinemaFunc) 
	local player = GCinematicPlayer.create();
	player:runCinematic(cinemaFunc);
end
