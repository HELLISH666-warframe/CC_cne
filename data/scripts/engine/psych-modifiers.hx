var playbackRate:Float=ccSSC.gameplaySettings.get('songspeed');
var practiceMode=FlxG.save.data.gameplaySettings.get('practice');

function postCreate() {
	scrollSpeed*=ccSSC.gameplaySettings.get('scrollspeed');
}

function onEvent(_) {
	switch(_.event.name){
		case 'Scroll Speed Change':
			if(ccSSC.gameplaySettings.get('scrolltype')!='multiplicative')_.cancel();
	}
}

function onPlayerMiss(e) {
	if(practiceMode)validScore=false;
	if(ccSSC.gameplaySettings.get('instakill'))gameOver();
	e.healthGain*ccSSC.gameplaySettings.get('healthloss');
}

function onPlayerHit(e) {
	if(practiceMode)validScore=false;
	e.healthGain*=ccSSC.gameplaySettings.get('healthgain');
}