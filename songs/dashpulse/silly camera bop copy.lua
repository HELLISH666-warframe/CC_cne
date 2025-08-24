local angleshit = 1;
local anglevar = 2;
local doSilly = true;
local eventNum = 0;

local active = false;

--doing this because the other idea I had didn't work :skull;

function onBeatHit()
	if curBeat == 100 or curBeat == 260 or curBeat == 288 then
		active = true
	end
	
	if curBeat == 160 or curBeat == 284 or curBeat == 336 then
		active = false
	end
	
	if active then
		if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
		setProperty('camGame.angle',angleshit*3)
		doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
	else
		cancelTween('tt')
		setProperty('camGame.angle',0)
	end
end