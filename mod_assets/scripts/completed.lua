isDoneBlue = false;
isDoneRed = false;

function setBlueTrue()
	isDoneBlue = true;

  if(isDoneRed) then
    findEntity("teleporter_1").teleporter:setTeleportTarget(1, 17, 14, 0)
  end

end

function setRedTrue()
	isDoneRed = true;

  if(isDoneBlue) then
    findEntity("teleporter_2").teleporter:setTeleportTarget(1, 17, 14, 0)
  end
end
