function create() {
	lossingHealth = true;
	needsBlackBG=true;
}
function postCreate() {
	if (FlxG.save.data.shaders){
		FlxG.camera.addShader(chromaticAberration);
		camHUD.addShader(chromaticAberration);
		chromaticAberration.rOffset=0.0045;
		chromaticAberration.bOffset=-0.0045;
	}
}

function beatHit(curBeat:Int) {
	switch(curBeat) {
		case 96:tcoBSOD(true);
		case 192:blackBG.alpha = 0;
		tcoBSOD(true);
		FlxG.camera.removeShader(chromaticAberration);
		camHUD.removeShader(chromaticAberration);
		camHUD.addShader(endingShader);
		FlxG.camera.addShader(endingShader);
		redthing.alpha = 1;
		case 128|324:tcoBSOD(false);
		case 325:FlxTween.tween(camHUD, {alpha:0}, 1, {ease: FlxEase.sineInOut});
		case 188:alphaTween([blackBG], 1, 0.3);
		colorTween([boyfriend], 0.3, 0xFF191919, FlxColor.WHITE);
		FlxTween.tween(redthing, {alpha:0}, 0.3, {ease: FlxEase.sineInOut});
		case 332:FlxG.camera.fade(FlxColor.BLACK, 0, false);
		if(FlxG.save.data.flashing_cc) camBars.flash(FlxColor.WHITE, 0.85);
		redthing.alpha = 0;
	}
}