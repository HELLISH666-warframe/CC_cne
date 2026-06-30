import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import psych.BGSprite;

//week 2:
//proficiency:
var altAnimation2 = false;

var ChromaticAberrationEffect = new CustomShader("ChromaticAberrationShader");
function setChrome(shader:Dynamic,chromeOffset) {
	shader.rOffset=chromeOffset;
	shader.gOffset=0;
	shader.bOffset=chromeOffset * -1;
}

function postNew() {
	alanBG = new BGSprite('extras/trojan/alan_desktop', -80, -1800, 1, 1);
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));
	add(alanBG);

	particleEmitter = new FlxTypedEmitter(-400, 1500);
	particleEmitter.launchMode = FlxEmitterMode.SQUARE;
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.scale.set(1.5, 1.5, 1.5, 1.5, 0, 0, 0, 0);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.loadParticles(Paths.image('particle'), 500, 16, true);
	//particleEmitter.color.set(FlxColor.ORANGE, FlxColor.ORANGE);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	particleEmitter.cameras =  [camChar];
	particleEmitter.color.set(FlxColor.WHITE, FlxColor.WHITE);
	add(particleEmitter);

	googleBurn = new FlxSprite(1280, 85);
	googleBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/GoogleBurning');
	googleBurn.animation.addByPrefix('idle', 'Symbol 2 instance 10', 16, true);
	googleBurn.animation.play('idle');
	add(googleBurn);

	daFloor = new BGSprite('chapter2/floor', -80, -1800, 1, 1);
	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;
	add(daFloor);

	//sofa = new BGSprite('couch_' + SONG.player2, 1000, 480, 1, 1, ['couch beat0'], true);
	//sofa.setGraphicSize(Std.int(sofa.width * 1.1));

	veryEpicVignette = new BGSprite('chapter2/proficiency/proficiencyOverlay1', 0, 0, 1, 1);
	veryEpicVignette.screenCenter();
	veryEpicVignette.updateHitbox();
	veryEpicVignette.camera = camBars;
	add(veryEpicVignette);

	glow= new BGSprite('chapter2/proficiency/proficiencyOverlay', 0, 0, 1, 1);
	glow.screenCenter();
	glow.updateHitbox();
	glow.camera = camBars;
	glow.alpha = 0;
	add(glow);

	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter2/proficiency/proficiencyOverlayMid'));
	vignetteTrojan.camera = camBars;
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0;
	//vignetteTrojan.blend = LIGHTEN;
	add(vignetteTrojan);

	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter2/proficiency/proficiencyOverlayA'));
	redthing.antialiasing = Options.antialiasing;
	redthing.camera = camBars;
	redthing.alpha = 0.0001;
	add(redthing);

	twitterBurn = new FlxSprite(2850, 500);
	twitterBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/TwitterBurning');
	twitterBurn.animation.addByPrefix('idle', 'Symbol 4 instance 10', 16, true);
	twitterBurn.animation.play('idle');
	twitterBurn.scale.set(1.2, 1.2);
	twitterBurn.scrollFactor.set(1.3, 1.3);
	twitterBurn.angle = -20;

	newgroundsBurn = new FlxSprite(-485,230);
	newgroundsBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/NewgroundsBurning');
	newgroundsBurn.animation.addByPrefix('idle', 'Symbol 3 instance 10', 16, true);
	newgroundsBurn.animation.play('idle');
	newgroundsBurn.scale.set(1.2, 1.2);
	newgroundsBurn.scrollFactor.set(1.3, 1.3);
	newgroundsBurn.angle = 40;

	shine = new BGSprite('extras/world1/shine', 0, 0, 1, 1);
	shine.screenCenter();
	shine.antialiasing = Options.antialiasing;
	shine.updateHitbox();

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

	//var ref:BGSprite = new BGSprite('ref', 0, 0, 1, 1);
	//ref.alpha = 0.65;
	//ref.camera = camBars;
	//ref.screenCenter();
	//add(ref);

	needsBlackBG = true;

	camBars.fade(FlxColor.BLACK, 0, false);
	camChar.alpha = 0;
	camHUD.alpha = 0;

	if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
		camHUD.addShader(ChromaticAberrationEffect);
		setChrome(ChromaticAberrationEffect,0.0005);
	}

	killThem(2);

	if (needsBlackBG){
		blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), 0xFF000000);
		blackBG.scrollFactor.set();
		blackBG.alpha = 0;
		blackBG.screenCenter();
		add(blackBG);
	}

	killThem(0);
	killThem(1);

	add(newgroundsBurn);
	add(twitterBurn);
	add(shine);
}

function onDadHit(e){
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
	case 'proficiency':if(altAnimation2)e.animSuffix='-alt2';
	}
}

import flixel.math.FlxPoint;
function onSongStart() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()){
		case 'proficiency'|'stick em up'|'artistry'|'morality':camBars.fade(FlxColor.BLACK, 0, true);
		camHUD.alpha = 1;
	}
}

function postUpdate() {
	cpuStrums.notes.forEach((note) -> note.alpha=cpuStrums.members[0].alpha);
	playerStrums.notes.forEach((note) -> note.alpha=playerStrums.members[0].alpha);
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
	case 'proficiency':
		switch(curBeat) {
			case 16:FlxTween.tween(camHUD, {alpha:1}, 1);
			case 64:veryEpicVignette.alpha = 1;
			case 156:FlxTween.tween(blackBG, {alpha:1}, 0.3);
			case 160:blackBG.alpha = 0;
			glow.alpha = 1;
			redthing.alpha = 1;
			camChar.alpha = 1;
			veryEpicVignette.alpha = 0;
			case 224:veryEpicVignette.alpha = 1;
			glow.alpha = 0;
			redthing.alpha = 0;
			camChar.alpha = 0;
			case 280:dad.playAnim('phase2Transition', true);
			strumLines.members[0].animSuffix=dad.idleSuffix='-alt';
			case 284:cpuStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha: 0}, 1));
			cpuStrums.notes.forEach((note) -> FlxTween.tween(note, {alpha: 0}, 1));
			case 288:veryEpicVignette.alpha = 0;
			vignetteTrojan.alpha = 1;
			case 316:cpuStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha:FlxG.save.data.middleScroll ? 0 : 1}, 1));
			cpuStrums.notes.forEach((note) -> FlxTween.tween(note, {alpha: FlxG.save.data.middleScroll ? 0 : 1}, 1));
			dad.playAnim('phase3Transition', true);
			dad.specialAnim = true;
			case 320:altAnimation2 = true;
			dad.idleSuffix='-alt2';
			vignetteTrojan.alpha = 0;
			glow.alpha = 1;
			redthing.alpha = 1;
			camChar.alpha = 1;
		}
	case 'masterpiece':
		switch(curBeat) {
			case 4:camBars.fade(FlxColor.BLACK, 3, true);
			case 32:FlxTween.tween(camHUD, {alpha:1}, 1);
			case 383:camHUD.fade(FlxColor.BLACK, 0.5, false);
			case 416:camHUD.fade(FlxColor.BLACK, 1, true);
			scoreTxt.alpha = 0;
			healthBar.alpha = 0;
			healthBarBG.alpha = 0;
			iconP1.alpha = 0;
			iconP2.alpha = 0;
			case 640:cpuStrums.forEach(function(spr:StrumNote) {spr.alpha = 0;});
			playerStrums.forEach(function(spr:StrumNote) {spr.alpha = 0;});
			case 654:cpuStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha: 1}, 1));
			playerStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha: 1}, 1));
			case 798:

			case 896:
		}
	}
}