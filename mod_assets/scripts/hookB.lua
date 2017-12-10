function hook()
	party.party:addConnector("onDie", self.go.id, "deadB")
end

first = true
function deadB(self, champion)
	if(not first) then
		return;
	end
	first = false
	self:heal()
	--findEntity("partygate").script:teleport(17,14, 1, 0)
	--spawn(object, level, x, y, facing, elevation, [id])
	local temp = spawn("teleporter", party.level, party.x, party.y, party.facing, party.elevation, "temporary_teleporter_2")
	temp.teleporter:setTriggeredByItem(false)
	temp.teleporter:setTriggeredByParty(true)
	temp.teleporter:setTriggeredByMonster(false)
	temp.teleporter:setTeleportTarget(1, 17, 15, 0)

	local t = findEntity("temporary_pressureplate_2")
	if (t ~= nil) then
		 t:destroy()
	end

	local temporary_pressureplate = spawn("floor_trigger", 1, 17, 15, party.facing, 0, "temporary_pressureplate_2")
  temporary_pressureplate.floortrigger:setTriggeredByParty(true)
  temporary_pressureplate.floortrigger:setTriggeredByMonster(false)
  temporary_pressureplate.floortrigger:setTriggeredByItem(false)
  temporary_pressureplate.floortrigger:setDisableSelf(true)
  temporary_pressureplate.floortrigger:addConnector("onActivate", self.go.id, "cleanup")

	findEntity("script_dialogue").script:setBlueTrue()
	findEntity("script_dialogue").script:setDeadTrue()
end

function cleanup()
	printHud("CLEAn")
	local temporary_teleporter = findEntity("temporary_teleporter_2");
   if (temporary_teleporter ~= nil) then
      temporary_teleporter:destroy()
   end
	 unHook()
end

function unHook()
	party.party:removeConnector("onDie", self.go.id, "deadB")
end
