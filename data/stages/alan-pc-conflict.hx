import psych.BGSprite;

public var alanBG:BGSprite;
public var daFloor:BGSprite;
public var fires1:BGSprite;
public var fires2:BGSprite;
public var bsod:BGSprite;
public var redthing:FlxSprite;

var ChromaticAberrationEffect = new CustomShader("ChromaticAberrationShader");
function setChrome(shader:Dynamic,chromeOffset) {
	shader.rOffset=chromeOffset;
	shader.gOffset=0;
	shader.bOffset=chromeOffset * -1;
}

function postNew() {
	alanBG = new BGSprite('extras/trojan/alan_desktop', -80, -1800, 1, 1);
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));

	daFloor = new BGSprite('extras/trojan/floor', -80, -1800, 1, 1);
	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;

	fires1 = new BGSprite('chapter1/victim/BGFire', 1230, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
	fires1.setGraphicSize(Std.int(fires1.width * 1.6));

	fires2 = new BGSprite('chapter1/victim/BGFire', -400, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
	fires2.setGraphicSize(Std.int(fires2.width * 1.6));

	bsod = new BGSprite('extras/error_conflict', 0, 0, 1, 1);
	bsod.setGraphicSize(Std.int(bsod.width * 1.25));
	bsod.screenCenter();
	bsod.x += 1250;
	bsod.antialiasing = Options.antialiasing;
	//bsod.alpha = 0.0001;//FUCK

	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter1/victim/vignette'));
	redthing.antialiasing = Options.antialiasing;
	redthing.camera = camBars;
	add(redthing);

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

	if (ccSSC.shaders) {bsod.shader = new CustomShader("CRTShader");
	bsod.shader.iTime=0;
	}

	if (ccSSC.shaders) {camGame.addShader(ChromaticAberrationEffect);
		camHUD.addShader(ChromaticAberrationEffect);
		setChrome(ChromaticAberrationEffect,0.0045);
	}

	needsBlackBG = true;

	add(alanBG);
	add(fires1);
	add(fires2);
	add(daFloor);
	add(bsod);

	if (needsBlackBG) {
		blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), 0xFF000000);
		blackBG.scrollFactor.set();
		blackBG.alpha = 0;
		blackBG.screenCenter();
		add(blackBG);
	}

	killThem(0);
	killThem(1);

	scripts.call('objectColor',[[boyfriend, alanBG, daFloor], 0xFF2C2425]);
}

function killThem(num:Int) {
	if(strumLines.length<=num)return;
	for(i in 0...strumLines.members[num].characters.length){
		remove(strumLines.members[num].characters[i],true);
		add(strumLines.members[num].characters[i]);
	}
}

var endingShader = new CustomShader("Glitch02Shader");
endingShader.uTime = 0;
function setCGlitch(shader:Dynamic,mouse,numsample,glithcmult) {
	shader.iMouseX = mouse;
	shader.NUM_SAMPLES = numsample;
	shader.glitchMultiply = glithcmult;
}

function beatHit() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
	case 'conflict':
		switch(curBeat) {
			case 1:lossingHealth = true;
			case 96:scripts.call('tcoBSOD',[true]);
			case 192:blackBG.alpha = 0;
			scripts.call('tcoBSOD',[true]);
			camGame._filters = [];
			camHUD._filters = [];
			if (ccSSC.shaders){camGame.addShader(endingShader);
			camHUD.addShader(endingShader);
			setCGlitch(endingShader,4,3,3);}
			redthing.alpha = 1;
			case 128|324:scripts.call('tcoBSOD',[false]);
			case 325:FlxTween.tween(camHUD, {alpha:0}, 1, {ease: FlxEase.sineInOut});
			case 188:scripts.call('alphaTween',[[blackBG], 1, 0.3]);
			scripts.call('colorTween',[[boyfriend], 0.3, 0xFF191919, FlxColor.WHITE]);
			FlxTween.tween(redthing, {alpha:0}, 0.3, {ease: FlxEase.sineInOut});
			case 332:FlxG.camera.fade(FlxColor.BLACK, 0, false);
			if(ccSSC.flashing) camBars.flash(FlxColor.WHITE, 0.85);
			redthing.alpha = 0;
		}
	}
}

function update(elapsed:Float) {
	bsod.shader.iTime +=elapsed;
	confBSODShake(1.0);


	endingShader.uTime += elapsed;
}

function confBSODShake(intensity:Float = 1.0) {
	new FlxTimer().start(0.01, ()->{bsod.y += (10 * intensity);});
	new FlxTimer().start(0.05, ()->{bsod.y -= (15 * intensity);});
	new FlxTimer().start(0.10, ()->{bsod.y += (8 * intensity);});
	new FlxTimer().start(0.15, ()->{bsod.y -= (5 * intensity);});
	new FlxTimer().start(0.20, ()->{bsod.y += (3 * intensity);});
	new FlxTimer().start(0.25, ()->{bsod.y -= (1 * intensity);});
}