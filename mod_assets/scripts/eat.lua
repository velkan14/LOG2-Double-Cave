function hook()
  party.party:addConnector("onPickUpItem", self.go.id, "eat")
end

function eat(self, item)
  if(item:getUiName() == "Borra") then
  GTKGui.Basic.showInfoMessage("To eat food RIGHT CLICK it when it is in the inventory or hand.", 5);
end
if(item:getUiName() == "Healing Potion") then
GTKGui.Basic.showInfoMessage("During battle, to heal yourself RIGHT CLICK the potion when it is in the inventory or hand.", 7);
end
end

function unHook()
  party.party:removeConnector("onPickUpItem", self.go.id, "eat")
end
