var practiceMode=FlxG.save.data.gameplaySettings.get('practice');
function postCreate() {
	validScore=!practiceMode;
	scrollSpeed*=FlxG.save.data.gameplaySettings.get('scrollspeed');
}

function onEvent(_) {
	switch(_.event.name){
		case 'Scroll Speed Change':
			if(FlxG.save.data.gameplaySettings.get('scrolltype')!='multiplicative')_.cancel();
	}
}

function onPlayerMiss(e) {
	if(practiceMode)validScore=false;
	if(FlxG.save.data.gameplaySettings.get('instakill'))gameOver();
	e.healthGain*FlxG.save.data.gameplaySettings.get('healthloss');
}

function onPlayerHit(e) {
	if(practiceMode)validScore=false;
	e.healthGain*=FlxG.save.data.gameplaySettings.get('healthgain');
}

function onSubstateClose(e) {
	if(practiceMode)validScore=false;//So_
	trace(validScore);
}