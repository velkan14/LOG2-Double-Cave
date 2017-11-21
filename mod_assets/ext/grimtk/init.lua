
defineObject{
	name = "grimtk",
	baseObject = "script_entity",
	components = {
		{
			class = "Null",
			onInit = function(self)
				if ( findEntity("GTK") == nil ) then
					local gtk = spawn("script_entity", 1, 1, 1, 1, 1, "GTK");
					gtk.script:loadFile("mod_assets/ext/grimtk/scripts/hook.lua");
					gtk:createComponent("Script", "Constants"):loadFile("mod_assets/ext/grimtk/scripts/gtk/constants.lua");
					gtk:createComponent("Script", "Input"):loadFile("mod_assets/ext/grimtk/scripts/gtk/input.lua");
					gtk:createComponent("Script", "Core"):loadFile("mod_assets/ext/grimtk/scripts/gtk/core.lua");
					gtk:createComponent("Script", "Widgets"):loadFile("mod_assets/ext/grimtk/scripts/gtk/widgets.lua");

					if ( Editor.isRunning() ) then
						gtk:createComponent("Script", "Debug"):loadFile("mod_assets/ext/grimtk/scripts/gtk/debug.lua");
					end

					delayedCall("GTK", 0.01, "emitGtkDidLoad");
				end

				if ( findEntity("GTKGui") == nil ) then
					local gtkgui = spawn("script_entity", 1, 1, 1, 1, 1, "GTKGui");
					gtkgui:createComponent("Script", "Basic"):loadFile("mod_assets/ext/grimtk/scripts/gtkgui/basic.lua");
					gtkgui:createComponent("Script", "Dialogue"):loadFile("mod_assets/ext/grimtk/scripts/gtkgui/dialogue.lua");
					gtkgui:createComponent("Script", "Cinematic"):loadFile("mod_assets/ext/grimtk/scripts/gtkgui/cinematic.lua");
					gtkgui:createComponent("Script", "Form"):loadFile("mod_assets/ext/grimtk/scripts/gtkgui/form_scale.lua");
				end
			end
		}
	}
}


--
-- If the Log2 Framework has been included before this script, then we will use the framework instead.
-- Otherwise, the default behaviour is to override these hooks.
-- NOTE: If you are using the framework, you MUST define an onDrawGui hook SOMEWHERE (even an empty one).
--

if fw_hook == nil then

	defineObject{
		name = "party",
		baseObject = "party",
		components = {
			{
				class = "Party",
				onDrawGui = function(party, g)

				end,
				onRest = function(party)
					if ( findEntity("GTK") ) then
						if ( GTK.Core.GUI:isPartyLocked() ) then
							return false;
						end
					end
				end,
				onWakeUp = function(party)
					if ( findEntity("GTK") ) then
						if ( GTK.Core.GUI:isPartyLocked() ) then
							return false;
						end
					end
				end
			}
		}
	}

end
