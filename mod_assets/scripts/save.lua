function hook()
	findEntity("healing_crystal_2").clickable:addConnector("onClick", self.go.id, "b")
end

firstTime = true
function b(self)
	if(firstTime) then
	findEntity("castle_door_portcullis_2").door:open()
	--firstTime = false
	end
end

function unHook()
	findEntity("healing_crystal_2").clickable:addConnector("onClick", self.go.id, "b")
end
