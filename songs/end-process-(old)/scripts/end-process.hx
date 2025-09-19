import flixel.text.FlxTextBorderStyle;
var popupsExplanation:FlxText;
function postCreate() {
	if (PlayState.isStoryMode) {
		popupsExplanation = new FlxText(0, 0, FlxG.width, "Close the popups when they appear,\nand press the slice notes", 20);
		popupsExplanation.setFormat(Paths.font("phantommuff.ttf"), 60, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		popupsExplanation.borderSize = 2;
		popupsExplanation.cameras = [camHUD];
		popupsExplanation.screenCenter();
		popupsExplanation.alpha = 0;
		add(popupsExplanation);
	}
	FlxG.camera.fade(FlxColor.BLACK, 0, false);
}

function onSongEnd() {
	if (PlayState.isStoryMode)
	FlxG.save.data.songsUnlocked_mainWeek=true;
}
function stepHit(curStep:Int) {
	switch(curStep) {
		case 1: if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 1}, 2);
		case 192: if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 0}, 1);
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		case 1344: FlxTween.tween(redthing, {alpha: 0}, 0.4);
		showUpCorruptBackground(true);
		dad.color = 0xFF7A006A;
		boyfriend.color = 0xFF7B6CAD;
		case 1536: endProcessBSODS(true, 1);
		FlxTween.color(dad, 1, 0xFF7A006A, FlxColor.WHITE);
		FlxTween.color(boyfriend, 1, 0xFF7B6CAD, FlxColor.WHITE);
		case 1580: showUpCorruptBackground(false);
		case 1600: endProcessBSODS(false, 1);
		FlxTween.tween(redthing, {alpha: 1}, 0.8);
		/*case 1328: constantShake = true;
		case 1344: endProcessBSODS(true, 2);
		case 1470: endProcessBSODS(false, 2);
		constantShake = false;*/
	}
}

function beatHit(curBeat:Int) {
	switch(curBeat) {
		case 76: defaultCamZoom += 0.3;
		case 78|79: defaultCamZoom -= 0.075;
		case 80: defaultCamZoom -= 0.15;
		FlxG.camera.zoom = defaultCamZoom;
        FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000);
		case 144|192: defaultCamZoom += 0.2;
        case 176|208: defaultCamZoom -= 0.2;
		case 336:
		var epRTween1:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
		stopTweens.push(epRTween1);
		case 368:
		var epRTween2:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom - 0.4}, Conductor.crochet / 1000, {ease: FlxEase.linear});
        stopTweens.push(epRTween2);
		case 398: var epRTween3:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
		stopTweens.push(epRTween3);
		case 400: defaultCamZoom -= 0.4;
		case 80: FlxTween.tween(redthing, {alpha: 1}, 0.6);
		var epTween1:FlxTween = FlxTween.tween(newgroundsBurn, {y:newgroundsBurn.y +2300}, 2, {ease: FlxEase.linear, type:LOOPING});
		var epTween2:FlxTween = FlxTween.tween(twitterBurn, {y:twitterBurn.y +1800}, 1.6, {ease: FlxEase.linear, type:LOOPING});
		var epTween3:FlxTween = FlxTween.tween(googleBurn, {y:googleBurn.y +2900}, 2.5, {ease: FlxEase.linear, type:LOOPING});
		stopTweens.push(epTween1);
		stopTweens.push(epTween2);
		stopTweens.push(epTween3);
		case 460: FlxG.sound.play(Paths.sound('intro3'), 0.8);
		case 461: FlxG.sound.play(Paths.sound('intro2'), 0.8);
		case 462: FlxG.sound.play(Paths.sound('intro1'), 0.8);
		case 463: FlxG.sound.play(Paths.sound('introGo'), 0.8);
		case 464: //lxG.camera.setFilters([new ShaderFilter(fishEyeshader)]);
		//fishEyeshader.MAX_POWER.value = [0.10];





		/*case 400: generateStaticArrows(0);
		generateStaticArrows(1);
		skipArrowStartTween = true;*/
		case 416:
		//FlxTween.tween(redthing, {alpha: 0}, 2);
		/*case 448: camFollow.x = 750;
		camFollow.y = 350;
		isCameraOnForcedPos = true;
		defaultCamZoom = 0.6;
		FlxTween.tween(camHUD, {alpha:0}, 1);
		case 456: FlxG.camera.fade(FlxColor.BLACK, 2, false);*/
	}
}