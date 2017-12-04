function hook()
  party.party:addConnector("onWakeUp", self.go.id, "wake")
end

function wake(self)
  local door = findEntity("dungeon_door_wooden_3")
  door.door:toggle()
end

function unHook()
  party.party:removeConnector("onWakeUp", self.go.id, "wake")
end
