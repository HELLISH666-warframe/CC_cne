var angleshit = 1;
var anglevar = 2;
var doSilly:Bool = true;
var eventNum = 0;

var active:Bool = false;

var chris_pratt:FlxTween;

function postCreate() {
	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/victim/vignette'));
	redthing.antialiasing = true;
	redthing.cameras = [camBars];
	redthing.alpha = 0.0001;
	add(redthing);
}

function beatHit(curBeat:Int) {
    switch(curBeat)
	{
		case 28 | 188:
		camGame.fade(FlxColor.WHITE, (Conductor.crochet/1000*3), false);
		case 32:
		camGame.fade(FlxColor.WHITE, 0, true);
		//if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0045));
		redthing.alpha = 1;
		case 64 | 224 | 320:
		bestPart2 = true;
		colorTween([gf, alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.1, FlxColor.WHITE, 0xFF191919);
		radialLine.alpha = 1;
		//if (ClientPrefs.shaders && ClientPrefs.advancedShaders) FlxG.camera.setFilters([new ShaderFilter(nightTimeShader.shader)]); //put the advanced shader first
		scroll.alpha = 0;
		vignettMid.alpha = 0;
		redthing.alpha = 0.0001;
		camGame.alpha= 1;
		filter.alpha = 1;
		case 96:
		vignetteTrojan.alpha = 0.0001;
		coolShit.alpha = 0.0001;
		bestPart2 = false;
		if (!ClientPrefs.lowQuality) colorTween([gf, alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE);
		else colorTween([gf, alanBG, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE);
		radialLine.alpha = 0.0001;
		redthing.alpha = 0;
		if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0));
		case 160:
		if (ClientPrefs.shaders && ClientPrefs.advancedShaders) FlxG.camera.setFilters([new ShaderFilter(new BloomShader())]);
		case 192:
		camGame.fade(FlxColor.WHITE, 0, true);
		if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0));
		redthing.alpha = 1;
		case 256:
		vignetteTrojan.alpha = 0.0001;
		vignettMid.alpha = 1;
		scroll.alpha = 1;
		radialLine.alpha = 0.0001;
		coolShit.alpha = 0;
		bestPart2 = false;
		filter.alpha = 0.0001;
		if(ClientPrefs.flashing) camChar.flash(FlxColor.WHITE, 0.85);
		boyfriend.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
		dad.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
		gf.alpha = 0.0001;
		case 288:
		if(ClientPrefs.flashing) camChar.flash(FlxColor.WHITE, 0.85);
		case 318:
		camGame.alpha = 0;
		boyfriend.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		dad.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		vignettMid.alpha = 0;
		case 348:
		FlxG.sound.play(Paths.sound('intro3'), 0.4);
		camGame.fade(FlxColor.WHITE, (Conductor.crochet/1000*3), false);
		stopBFFlyTrojan = true;
		FlxTween.tween(boyfriend, {y: BF_Y - 1000}, 1, {ease: FlxEase.quadIn});
		FlxTween.tween(boyfriendGroup, {angle: 359.99 * 4}, 23);
		case 349:
		FlxG.sound.play(Paths.sound('intro2'), 0.4);
		case 350:
		FlxG.sound.play(Paths.sound('intro1'), 0.4);
		case 351:
		FlxG.sound.play(Paths.sound('introGo'), 0.4);
		case 352:
		stopBFFlyTrojan = false;
		camGame.fade(FlxColor.WHITE, 0.5, true);
		if (ClientPrefs.shaders && ClientPrefs.flashing) FlxG.camera.setFilters([new ShaderFilter(colorShad.shader), new ShaderFilter(fishEyeshader)]);
		fishEyeshader.MAX_POWER.value = [0.15];
		isPlayersSpinning = true;
		cameraLocked = false;
		constantShake = true;
		viraScroll.alpha = 1;
		vignetteFin.alpha = 1;
		filter.alpha = 0.0001;
		gf.alpha = 0.0001;
		if (!ClientPrefs.lowQuality) colorTween([alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.BLACK);
		else colorTween([alanBG, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.BLACK);
		case 384:
		if (!ClientPrefs.lowQuality) colorTween([gf, alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE);
		else colorTween([gf, alanBG, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE);
		clearShaderFromCamera(['camgame', 'camhud']);
		if (ClientPrefs.shaders && ClientPrefs.advancedShaders) FlxG.camera.setFilters([new ShaderFilter(new BloomShader())]);
		fishEyeshader.MAX_POWER.value = [0];
		constantShake = false;
		viraScroll.alpha = 0;
		vignetteFin.alpha = 0;
		scroll.alpha = 0;
		gf.alpha = 1;
		filter.alpha = 1;
		radialLine.alpha = 0;
		case 388:
		boyfriend.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		case 400:
		camGame.alpha = 0;
		camOther.alpha  = 0;
		if(ClientPrefs.flashing) camBars.flash(FlxColor.WHITE, 0.55);
		if(ClientPrefs.flashing) camHUD.flash(FlxColor.BLACK, 0.35);
		FlxTween.tween(camHUD, {alpha:0}, 1);
		coolShit.alpha = 0;
		bestPart2 = false;
		radialLine.alpha = 0;
		filter.alpha = 0;
	}
}