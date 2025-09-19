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
function create() {
	whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	insert(0,whiteScreen);
}

function postCreate(){
	whiteScreen.color = background1.color;

	crowd.visible = false;

	fires1.visible = false;
	fires2.visible = false;
	stickpage.alpha = 0.0001;
	stickpageFloor.alpha = 0.0001;
	scaredCrowd.visible=false;
	bsod.alpha = 0.0001;

	googleBurn.alpha = 0.0001;
	twitterBurn.alpha = 0.0001;
	newgroundsBurn.alpha = 0.0001;
	corruptBG.alpha = 0.0001;
	corruptFloor.alpha = 0.0001;
	bsodStatic.alpha = 0.0001;
	rsod.alpha = 0.0001;

	switch(curSong){
		case "adobe": noCurLight = true;
		crowd.updateHitbox();
		crowd.visible=true;

		spotlightdad.alpha = 0.0001;
		spotlightbf.alpha = 0.0001;

		/*if (ClientPrefs.shaders)*/camHUD.addShader(chromaticAberration);
		FlxG.camera.addShader(chromaticAberration);
		chromaticAberration.rOffset=0.0005;
		chromaticAberration.bOffset=0.0005;
		FlxG.camera.fade(FlxColor.BLACK, 0, false);
		add(spotlightbf);
		add(spotlightdad);
		case "outrage-(old)": scaredCrowd.visible=true;
		/*if (ClientPrefs.shaders)*/ bsod.shader = new CustomShader("CRT");

		redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/victim/vignette'));
		redthing.antialiasing = Options.antialiasing;
		redthing.cameras = [camBars];
		redthing.alpha = 0.0001;
		add(redthing);

		/*if (ClientPrefs.shaders)*/ camHUD.addShader(chromaticAberration);
		FlxG.camera.addShader(chromaticAberration);
		chromaticAberration.rOffset=0.0005;
		chromaticAberration.bOffset=0.0005;

		case "end-process-(old)": FlxG.mouse.visible = true;
		fires1.visible = false;
		fires2.visible = false;
		fires2.x=-1500;
		googleBurn.screenCenter();
		googleBurn.y -= 900;
		googleBurn.x += 250;
		googleBurn.angle = -4;
		FlxTween.angle(googleBurn, googleBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		twitterBurn.angle = -4;
		FlxTween.angle(twitterBurn, twitterBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		newgroundsBurn.angle = -4;
		FlxTween.angle(newgroundsBurn, newgroundsBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		corruptBG.color = 0xFF7B6CAD;
		corruptBG.alpha = 0.0001;
		/*if (ClientPrefs.shaders)*/ corruptBG.shader = new CustomShader("CRT");
		corruptFloor.color = 0xFF7B6CAD;
		corruptFloor.alpha = 0.0001;
		/*if (ClientPrefs.shaders)*/ corruptFloor.shader = new CustomShader("CRT");

		bsodStatic.alpha = 0.0001;
		/*if (ClientPrefs.shaders)*/ bsodStatic.shader = new CustomShader("CRT");

		rsod.alpha = 0.0001;

		redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/victim/vignette'));
		//redthing.antialiasing = Options.antialiasing;
		redthing.cameras = [camBars];
		redthing.alpha = 0.0001;
		add(redthing);

		/*if (ClientPrefs.shaders)*/ rsod.shader = new CustomShader("CRT");


		/*if (ClientPrefs.shaders)*/ camHUD.addShader(chromaticAberration);
		FlxG.camera.addShader(chromaticAberration);
		chromaticAberration.rOffset=0.0045;
		chromaticAberration.bOffset=0.0045;

		case "phantasm": defaultCamZoom = 1.8;
		//GameOverSubstate.deathSoundName = 'aurora_loss_sfx';
	}

	topBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	topBars.cameras = [camBars];
	topBars.screenCenter();
	topBars.y -= 850;
	add(topBars);

	bottomBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	bottomBars.cameras = [camBars];
	bottomBars.screenCenter();
	bottomBars.y += 850;
	add(bottomBars);

	topBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	topBarsALT.cameras = [camBars];
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	add(topBarsALT);

	bottomBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	bottomBarsALT.cameras = [camBars];
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	add(bottomBarsALT);

	needsBlackBG = true;
}
function onStartCountdown() {
	trace(dad.x);
    spotlightdad.x = dad.x - 400;
	spotlightdad.y = dad.y + dad.height - 1550;

	spotlightbf.x = boyfriend.x - 200;
	spotlightbf.y = boyfriend.y + boyfriend.height - 750;
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


/*
function stepHit(curStep:Int) {
	switch(curSong){
		case "adobe":
	if (curBeat % 1 == 0 && stage.getSprite("crowd") != null) stage.getSprite("crowd").animation.play("BG  Guys");
	}
}*/
//if_and_presses_fire2_x+100;