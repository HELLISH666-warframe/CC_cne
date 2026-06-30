import psych.BGSprite;

function postNew() {
	otakuBG = new BGSprite('extras/dashpulse_bg', -874, -255, 1, 1);
	otakuBG.antialiasing = false;
	add(otakuBG);

	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/vignette'));
	vignetteTrojan.antialiasing = Options.antialiasing;
	vignetteTrojan.camera = camBars;
	if(!FlxG.save.data.wideScreenSongs) vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0;
	vignetteTrojan.color = FlxColor.CYAN;
	add(vignetteTrojan);

	topBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	topBarsALT.camera = camBars;
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	add(topBarsALT);

	bottomBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	bottomBarsALT.camera = camBars;
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	add(bottomBarsALT);

	if (PlayState.SONG.meta.displayName.toLowerCase() == 'dashpulse')  {
		whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		whiteScreen.scrollFactor.set();
		whiteScreen.screenCenter();
		add(whiteScreen);
		whiteScreen.camera = camHUD;
	}

	if (!FlxG.save.data.wideScreenSongs) oldVideoResolution = true;
	noCurLight = true;
	cameraSpeed = 1.2;

	if (FlxG.save.data.shaders) {
		FlxG.camera.addShader(new CustomShader("Shader244p"));
		//FlxG.camera.setFilters([{var _=new ShaderFilter(new Shader244p());_.__smooth=false;_;}]);//Smooth????
	}

	killThem(2);
	killThem(0);
	killThem(1);

	otakuBG.color = 0xFF191919;
	gf.color = 0xFF191919;
}

function killThem(num:Int) {
	if(strumLines.length<=num)return;
	for(i in 0...strumLines.members[num].characters.length){
		remove(strumLines.members[num].characters[i],true);
		add(strumLines.members[num].characters[i]);
	}
}

function beatHit() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
		case 'dashpulse':
		switch(curBeat) {
			case 32:FlxTween.tween(camHUD, {alpha:1}, 1, {ease: FlxEase.sineInOut});
			case 28|84:FlxTween.tween(FlxG.camera, {zoom:1.3}, 1.5, {ease: FlxEase.sineInOut});
			case 99:FlxTween.tween(FlxG.camera,{zoom:FlxG.camera.zoom - 0.2},3,{ease: FlxEase.sineInOut});
			case 100:otakuBG.color = gf.color = 0xFFFFFFFF;
			if(FlxG.save.data.flashing) camGame.flash(FlxColor.WHITE, Conductor.crochet/1000);
			case 256:colorTween([gf, otakuBG], 0.7, FlxColor.WHITE, 0xFF191919);
			defaultCamZoom = 1.1;
			bestPart2 = lossingHealth = true;
			multiplierDrain = 1.5;
			case 320:colorTween([gf, otakuBG], 1, 0xFF191919, FlxColor.WHITE);
			defaultCamZoom = 0.65;
			bestPart2 = lossingHealth = false;
			case 354:FlxTween.tween(camHUD, {alpha:0}, 1, {ease: FlxEase.sineInOut});
			case 364:camGame.alpha = 0;
		}
	}
}

function onSongStart() {
	zoomTweenStart = FlxTween.tween(whiteScreen, {alpha: 0}, Conductor.crochet/1000*32, {ease: FlxEase.linear});
}