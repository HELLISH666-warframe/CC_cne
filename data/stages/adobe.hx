import psych.BGSprite;
public var whiteScreen:FlxSprite;
public var spotlightdad = new FlxSprite().loadGraphic(Paths.image("stages/spotlight"));
public var spotlightbf = new FlxSprite().loadGraphic(Paths.image("stages/spotlight"));
var shine:FlxSprite;
public var topBars:FlxSprite;
public var bottomBars:FlxSprite;
public var topBarsALT:FlxSprite;
public var bottomBarsALT:FlxSprite;
var time:Float = 0;
public var redthing:FlxSprite;
function afterNew() {
	defaultCamZoom = 0.65;

	whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	add(whiteScreen);

	Background1 = new BGSprite('chapter1/bg', -600, -600, 0.9, 0.9);
	//Background1.setGraphicSize(Std.int(Background1.width * 1.1));
	Background1.antialiasing = Options.antialiasing;
	add(Background1);

	whiteScreen.color = Background1.color;

	switch(PlayState.SONG.meta.name.toLowerCase()){
		case 'adobe':noCurLight = true;
		Crowd = new BGSprite('chapter1/theBGGuyz', -400, 7, 0.95, 0.95, ['BG  Guys']);
		Crowd.setGraphicSize(Std.int(Crowd.width * 1.1));
		Crowd.updateHitbox();
		Crowd.antialiasing = Options.antialiasing;
		add(Crowd);

		spotlightdad = new FlxSprite().loadGraphic(Paths.image("spotlight"));
		spotlightdad.alpha = 0.0001;

		spotlightbf = new FlxSprite().loadGraphic(Paths.image("spotlight"));
		spotlightbf.alpha = 0.0001;

		//bbgColor = 0xFF929292;

		//if (FlxG.save.data.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0005));//LATER_BRO.

		FlxG.camera.fade(FlxColor.BLACK, 0, false);
	}

	Floor = new BGSprite('chapter1/floor', -750, 713, 1, 1);
	Floor.setGraphicSize(Std.int(Floor.width * 1.2));
	add(Floor);

	if (PlayState.SONG.meta.name.toLowerCase() == 'phantasm') {
		defaultCamZoom = 1.8;
		GameOverSubstate.deathSoundName = 'aurora_loss_sfx';
	}

	needsBlackBG = true;

	oldSongs = false;

	switch(PlayState.SONG.meta.name.toLowerCase()) {
		case 'outrage':add(stickpage); add(stickpageFloor); add(bsod);
		case 'phantasm':add(bsod);
		case 'end process':add(corruptBG); add(corruptFloor); add(bsodStatic); add(rsod);
	}

	if (needsBlackBG) {
		blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), 0xFF000000);
		blackBG.scrollFactor.set();
		blackBG.alpha = 0;
		blackBG.screenCenter();
		add(blackBG);
	}

	switch(PlayState.SONG.meta.name.toLowerCase()) {
		case 'adobe':add(spotlightbf); add(spotlightdad);
	}
}

function create() {
	topBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	topBars.camera = camBars;
	topBars.screenCenter();
	topBars.y -= 850;
	add(topBars);			

	bottomBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	bottomBars.camera = camBars;
	bottomBars.screenCenter();
	bottomBars.y += 850;
	add(bottomBars);

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
}

function onStartCountdown() {
	switch(PlayState.SONG.meta.name.toLowerCase()) {
		case 'adobe':spotlightdad.x = dad.x - 400;
		spotlightdad.y = dad.y + dad.height - 1550;

		spotlightbf.x = boyfriend.x - 50;
		spotlightbf.y = boyfriend.y + boyfriend.height - 1450;
	}
}

function stepHit() {
	switch(PlayState.SONG.meta.name.toLowerCase()) {
		case 'adobe':
			switch(curStep){
				case 1:FlxG.camera.fade(FlxColor.BLACK, 3, true);
				Crowd.color = 0xFF3A3A3A;
				gf.color = 0xFF3A3A3A;
				Background1.color = 0xFF3A3A3A;
				whiteScreen.color = 0xFF3A3A3A;

				spotlightdad.alpha = 0.7;
				spotlightbf.alpha = 0.7;
				case 256:Crowd.color = 0xFFFFFFFF;
				gf.color = 0xFFFFFFFF;
				Background1.color = 0xFFFFFFFF;
				whiteScreen.color = 0xFFFFFFFF;
				if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				spotlightdad.alpha = 0;
				spotlightbf.alpha = 0;
				case 576:FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5);
				case 768:if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				if(FlxG.save.data.screenShake) FlxG.camera.shake(0.0175, 0.15);
				blackBars(1);
				colorTween([gf, dad, Crowd, Background1, Floor], 0.7, FlxColor.WHITE, 0xFF191919);
				spotlightdad.alpha = 0.8;
				spotlightbf.alpha = 0.8;
				case 1024:if (FlxG.save.data.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0));
				if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				colorTween([gf, dad, boyfriend, Crowd, Background1, Floor], 0.7, 0xFF191919, FlxColor.WHITE);
				blackBars(0);
				spotlightdad.alpha = 0;
				spotlightbf.alpha = 0;
			}
	}
}
function beatHit() {
	switch(PlayState.SONG.meta.name.toLowerCase()) {
		case 'adobe':if (curBeat % 1 == 0 && Crowd != null) setDance([Crowd], true);
		case 'end process':if (!FlxG.save.data.lowQuality){
			if (curBeat % 2 == 0 && virabot1 != null && virabot2 != null && virabot3 != null
			&& virabot4 != null) setDance([virabot1, virabot2, virabot3, virabot4], true);
		}
	}
}

function update(elapsed:Float) {
	time += elapsed;
	if(curSong == "outrage-(old)")
	bsod.shader.data.iTime.value = [time];
	if(curSong == "end-process-(old)"){
		for(i in [bsodStatic,corruptFloor,corruptBG,rsod])
			i.shader.data.iTime.value = [time];
	}
}