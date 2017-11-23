function hook()
	party.party:addConnector("onDie", self.go.id, "dead")
end

function dead(self, champion)
	self:heal()
	--findEntity("partygate").script:teleport(17,14, 1, 0)
	--spawn(object, level, x, y, facing, elevation, [id])
	local temp = spawn("teleporter", party.level, party.x, party.y, party.facing, party.elevation, "temporary_teleporter")
	temp.teleporter:setTriggeredByItem(false)
	temp.teleporter:setTriggeredByParty(true)
	temp.teleporter:setTriggeredByMonster(false)
	temp.teleporter:setTeleportTarget(1, 17, 14, 0)

	local t = findEntity("temporary_pressureplate")
	if (t ~= nil) then
		 t:destroy()
	end

	local temporary_pressureplate = spawn("floor_trigger", 1, 17, 14, party.facing, 0, "temporary_pressureplate")
  temporary_pressureplate.floortrigger:setTriggeredByParty(true)
  temporary_pressureplate.floortrigger:setTriggeredByMonster(false)
  temporary_pressureplate.floortrigger:setTriggeredByItem(false)
  temporary_pressureplate.floortrigger:setDisableSelf(true)
  temporary_pressureplate.floortrigger:addConnector("onActivate", "script_entity_3", "cleanup")
end

function cleanup()
	local temporary_teleporter = findEntity("temporary_teleporter");
   if (temporary_teleporter ~= nil) then
      temporary_teleporter:destroy()
   end
end
