
-- Public

isDone = false;



function start()
	if(isDone) then
		return;
	end
end

function refresh()
	_checkChampionPosition()
end

function _checkChampionPosition()
	if(party.party:getChampionByOrdinal(1) ~= party.party:getChampion(1)) then
		for i=1,4 do
			if(party.party:getChampionByOrdinal(1) == party.party:getChampion(i)) then
				party.party:swapChampions(i, 1)
			end
		end
	end
	if(party.party:getChampionByOrdinal(2) ~= party.party:getChampion(2)) then
		for i=1,4 do
			if(party.party:getChampionByOrdinal(2) == party.party:getChampion(i)) then
				party.party:swapChampions(i, 2)
			end
		end
	end
end
