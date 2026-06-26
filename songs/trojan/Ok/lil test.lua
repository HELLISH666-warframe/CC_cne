local piss = {};
local doModchart = false;
local modchartTimes = {258, 384, 898, 1024, 1282, 1536};
function onUpdate(elapsed)
	if doModchart == true then
		songPos = getSongPosition()
		local currentBeat = (songPos/3000)*(curBpm/30)

		for i = 0,3 do
			noteTweenX(piss[i+1], i, piss[i+1] + 80*math.sin((currentBeat+(i+4)*0.25)*math.pi), 0.6)
		end
		for i = 4,7 do
			noteTweenX(piss[i+1], i, piss[i+1] - 80*math.sin((currentBeat+i*0.25)*math.pi), 0.6)
		end
    else
		for i = 0,7 do
			if piss[1] ~= nil then
				noteTweenX(piss[i+1], i, piss[i+1], 0.6);
			end
		end
	end
end

function onStepHit()
	if curStep == 257 then
		for i = 0,7 do
			local papuselo = getPropertyFromGroup('strumLineNotes', i, 'x');
			table.insert(piss, papuselo)
		end
	end
	
	for i = 1,6 do
		if curStep == modchartTimes[i] then
			if doModchart == true then
				doModchart = false;
			else
				doModchart = true;
			end
		end
		--debugPrint(modchartTimes[i])
	end
end