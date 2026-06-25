import flixel.text.FlxTextBorderStyle;
import psych.BGSprite;

//adobe:
public var Crowd:BGSprite;
public var Background1:BGSprite;
public var Floor:BGSprite;
public var spotlightdad = new FlxSprite().loadGraphic(Paths.image("stages/spotlight"));
public var spotlightbf = new FlxSprite().loadGraphic(Paths.image("stages/spotlight"));

//t.c.o:
public var ScaredCrowd:BGSprite;
public var redthing:FlxSprite;
public var fires1:BGSprite;
public var fires2:BGSprite;
public var extraFires:BGSprite;

public var bsod:BGSprite;
public var stickpage:BGSprite;
public var stickpageFloor:BGSprite;

//end process:
public var newgroundsBurn:FlxSprite;
public var twitterBurn:FlxSprite;
public var googleBurn:FlxSprite;

var virabot1:BGSprite;
var virabot2:BGSprite;
var virabot3:BGSprite;
var virabot4:BGSprite;

//corrupted bgs:
public var corruptBG:BGSprite;
public var corruptFloor:BGSprite;

//bsod 2 and rsod + conflict bsod:
public var bsodStatic:BGSprite;
public var rsod:BGSprite;

//Popup Mechanic:
var popupsExplanation:FlxText;

public var whiteScreen:FlxSprite;
var time:Float = 0;
public var redthing:FlxSprite;
var ChromaticAberrationEffect = new CustomShader("ChromaticAberrationShader");
function setChrome(shader:Dynamic,chromeOffset) {
	shader.rOffset=chromeOffset;
	shader.gOffset=0;
	shader.bOffset=chromeOffset * -1;
}
function postNew() {
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

	switch(PlayState.SONG.meta.displayName.toLowerCase()){
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

		if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
			camHUD.addShader(ChromaticAberrationEffect);
			setChrome(ChromaticAberrationEffect,0.0005);
		}
		//if (FlxG.save.data.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0005));//LATER_BRO.

		FlxG.camera.fade(FlxColor.BLACK, 0, false);
		case 'outrage'|'phantasm':FlxG.camera.fade(FlxColor.BLACK, 0, false);

		fires1 = new BGSprite('chapter1/victim/BGFire', 870, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
		fires1.setGraphicSize(Std.int(fires1.width * 1.4));
		fires1.visible = false;
		add(fires1);

		extraFires = new BGSprite('chapter1/victim/BGFire', 1370, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
		extraFires.setGraphicSize(Std.int(extraFires.width * 1.4));
		extraFires.visible = false;

		fires2 = new BGSprite('chapter1/victim/BGFire', -1600, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
		fires2.setGraphicSize(Std.int(fires2.width * 1.4));
		fires2.visible = false;
		add(fires2);

		if(PlayState.SONG.meta.displayName.toLowerCase() == 'outrage')  {
			stickpage = new BGSprite('chapter1/victim/distorted_stickpage_bg', -50, -90, 0.9, 0.9);
			stickpage.setGraphicSize(Std.int(stickpage.width * 2.4));
			stickpage.alpha = 0.0001;

			stickpageFloor = new BGSprite('chapter1/victim/dsp_floor', -350, 600, 1, 1);
			stickpageFloor.setGraphicSize(Std.int(stickpageFloor.width * 1.25));
			stickpageFloor.alpha = 0.0001;

			ScaredCrowd = new BGSprite('chapter1/theBGGuyz', -265, 105, 0.95, 0.95, ['BG Guys Scared'], true);
			ScaredCrowd.setGraphicSize(Std.int(ScaredCrowd.width * 1.1));
			ScaredCrowd.antialiasing = Options.antialiasing;
			add(ScaredCrowd);
		}

		bsod = new BGSprite('chapter1/victim/error', -650, -500, 1, 1);
		bsod.setGraphicSize(Std.int(bsod.width * 1.1));
		bsod.antialiasing = Options.antialiasing;
		if (FlxG.save.data.shaders) bsod.shader = new CustomShader("CRT");
		bsod.alpha = 0.0001;

		redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter1/victim/vignette'));
		redthing.antialiasing = Options.antialiasing;
		redthing.camera = camBars;
		redthing.alpha = 0.0001;
		add(redthing);

		if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
			camHUD.addShader(ChromaticAberrationEffect);
			setChrome(ChromaticAberrationEffect,0.0005);
		}
		
		case 'end process':FlxG.mouse.visible = true;
		FlxG.mouse.unload();
		FlxG.mouse.load(Paths.image("chapter1/EProcess/alt").bitmap, 1.5, 0);

		fires1 = new BGSprite('chapter1/victim/BGFire', 870, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
		fires1.setGraphicSize(Std.int(fires1.width * 1.4));
		add(fires1);

		fires2 = new BGSprite('chapter1/victim/BGFire', -1500, -240, 0.9, 0.9, ['Symbol 1 instance 1'], true);
		fires2.setGraphicSize(Std.int(fires2.width * 1.4));
		add(fires2);
		if (!FlxG.save.data.lowQuality) {
			virabot1 = new BGSprite('chapter1/EProcess/virabop', -50, 455, 0.9, 0.9, ['ViraBop']);
			virabot1.setGraphicSize(Std.int(virabot1.width * 1.3));
			add(virabot1);

			virabot4 = new BGSprite('chapter1/EProcess/virabop', -650, 455, 0.9, 0.9, ['ViraBop']);
			virabot4.setGraphicSize(Std.int(virabot1.width * 1.3));
			add(virabot4);

			virabot2 = new BGSprite('chapter1/EProcess/virabop', 1250, 455, 0.9, 0.9, ['ViraBop']);
			virabot2.setGraphicSize(Std.int(virabot2.width * 1.3));
			virabot2.flipX = true;
			add(virabot2);

			virabot3 = new BGSprite('chapter1/EProcess/virabop', 1750, 455, 0.9, 0.9, ['ViraBop']);
			virabot3.setGraphicSize(Std.int(virabot3.width * 1.3));
			virabot3.flipX = true;
			add(virabot3);

			googleBurn = new FlxSprite(0, -1100);
			googleBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/GoogleBurning');
			googleBurn.animation.addByPrefix('idle', 'Symbol 2 instance 10', 16, true);
			googleBurn.animation.play('idle');
			googleBurn.scale.set(0.7, 0.7);
			googleBurn.screenCenter();
			googleBurn.y -= 900;
			googleBurn.x += 250;
			googleBurn.angle = -4;
			add(googleBurn);
			FlxTween.tween(googleBurn, {y: googleBurn.y + 30}, 1, {ease:FlxEase.smoothStepInOut, type: FlxTween.PINGPONG});
			FlxTween.angle(googleBurn, googleBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxTween.PINGPONG});

			twitterBurn = new FlxSprite(1300, -820); //thank to god the most toxic social media is on fire
			twitterBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/TwitterBurning');
			twitterBurn.animation.addByPrefix('idle', 'Symbol 4 instance 10', 16, true);
			twitterBurn.animation.play('idle');
			twitterBurn.scale.set(0.7, 0.7);
			twitterBurn.angle = -4;
			add(twitterBurn);
			FlxTween.tween(twitterBurn, {y: twitterBurn.y + 30}, 1, {ease:FlxEase.smoothStepInOut, type: FlxTween.PINGPONG});
			FlxTween.angle(twitterBurn, twitterBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxTween.PINGPONG});

			newgroundsBurn = new FlxSprite(-1000, -1020);
			newgroundsBurn.frames = Paths.getSparrowAtlas('chapter1/EProcess/NewgroundsBurning');
			newgroundsBurn.animation.addByPrefix('idle', 'Symbol 3 instance 10', 16, true);
			newgroundsBurn.animation.play('idle');
			newgroundsBurn.scale.set(0.7, 0.7);
			newgroundsBurn.angle = -4;
			add(newgroundsBurn);
			FlxTween.tween(newgroundsBurn, {y: newgroundsBurn.y + 30}, 1, {ease:FlxEase.smoothStepInOut, type: FlxTween.PINGPONG});
			FlxTween.angle(newgroundsBurn, newgroundsBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxTween.PINGPONG});
		}

		corruptBG = new BGSprite('chapter1/bgCorrupted', -650, -600, 0.9, 0.9);
		corruptBG.setGraphicSize(Std.int(corruptBG.width * 1.1));
		corruptBG.color = 0xFF7B6CAD;
		corruptBG.alpha = 0.0001;
		if (FlxG.save.data.shaders) corruptBG.shader = new CustomShader("CRT");

		corruptFloor = new BGSprite('chapter1/floorCorrupted', -750, -405, 1, 1);
		corruptFloor.setGraphicSize(Std.int(corruptFloor.width * 1.2));
		corruptFloor.color = 0xFF7B6CAD;
		corruptFloor.alpha = 0.0001;
		if (FlxG.save.data.shaders) corruptFloor.shader = new CustomShader("CRT");

		bsodStatic = new BGSprite('chapter1/EProcess/error_3rdsong', -50, -90, 1, 1);
		bsodStatic.setGraphicSize(Std.int(bsodStatic.width * 2.4));
		bsodStatic.antialiasing = Options.antialiasing;
		bsodStatic.alpha = 0.0001;
		if (FlxG.save.data.shaders) bsodStatic.shader = new CustomShader("CRT");

		rsod = new BGSprite('chapter1/EProcess/rsod', -50, -90, 1, 1);
		rsod.setGraphicSize(Std.int(rsod.width * 2.4));
		rsod.antialiasing = Options.antialiasing;
		rsod.alpha = 0.0001;

		redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter1/victim/vignette'));
		redthing.antialiasing = Options.antialiasing;
		redthing.camera = camBars;
		redthing.alpha = 0.0001;
		add(redthing);

		if (PlayState.SONG.meta.displayName.toLowerCase() == 'end process' && PlayState.isStoryMode) {
			popupsExplanation = new FlxText(0, 0, FlxG.width, "Close the popups when they appear,\nand press the slice notes", 20);
			popupsExplanation.setFormat(Paths.font("phantommuff.ttf"), 60, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			popupsExplanation.borderSize = 2;
			popupsExplanation.camera = camHUD;
			popupsExplanation.screenCenter();
			popupsExplanation.alpha = 0;
			add(popupsExplanation);
		}

		if (FlxG.save.data.shaders) rsod.shader = new CustomShader("CRT");

		FlxG.camera.fade(FlxColor.BLACK, 0, false);

		if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
			camHUD.addShader(ChromaticAberrationEffect);
			setChrome(ChromaticAberrationEffect,0.0045);
		}
	}

	Floor = new BGSprite('chapter1/floor', -750, 713, 1, 1);
	Floor.setGraphicSize(Std.int(Floor.width * 1.2));
	add(Floor);

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

	if (PlayState.SONG.meta.displayName.toLowerCase() == 'phantasm') {
		defaultCamZoom = 1.8;
		GameOverSubstate.deathSoundName = 'aurora_loss_sfx';
	}

	needsBlackBG = true;

	oldSongs = false;

	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
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
}
function create() {killEVERYONE();}
function postCreate() {switch(PlayState.SONG.meta.displayName.toLowerCase()) {
		case 'adobe':add(spotlightbf); add(spotlightdad);
	}
}
function killEVERYONE() {
	for(i in 0...strumLines.length){
		for(c in 0...strumLines.members[i].characters.length){
			remove(strumLines.members[i].characters[c]);
			insert(members.indexOf(scripts.get('blackBG'))+1,strumLines.members[i].characters[c]);
		}
	}
}

function onStartCountdown() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
		case 'adobe':spotlightdad.x = dad.x - 400;
		spotlightdad.y = dad.y + dad.height - 1550;

		spotlightbf.x = boyfriend.x - 250;
		spotlightbf.y = boyfriend.y + boyfriend.height - 750;
	}
}

function stepHit() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
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
				scripts.call('blackBars',[1]);
				scripts.call('colorTween',[[gf, dad, Crowd, Background1, Floor], 0.7, FlxColor.WHITE, 0xFF191919]);
				spotlightdad.alpha = 0.8;
				spotlightbf.alpha = 0.8;
				case 1024:if (FlxG.save.data.shaders) setChrome(ChromaticAberrationEffect,0);
				//if (FlxG.save.data.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0));
				if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				scripts.call('colorTween',[[gf, dad, boyfriend, Crowd, Background1, Floor], 0.7, 0xFF191919, FlxColor.WHITE]);
				scripts.call('blackBars',[0]);
				spotlightdad.alpha = 0;
				spotlightbf.alpha = 0;
			}
		case 'outrage':
			switch(curStep) {
				case 1|8|16|32|40|48|64|72|80|96|104|112:
				if(FlxG.save.data.flashing || !FlxG.save.data.lowQuality) FlxG.camera.fade(FlxColor.BLACK, 0.5, false);
				case 120:FlxG.camera.fade(FlxColor.BLACK, 0, true);
				case 767:scripts.call('tcoBSOD',[true]);
				redthing.color = 0xFFFFFFFF;
				case 1392:defaultCamZoom = 1.45;
				scripts.call('alphaTween',[[blackBG], 1, 0.75]);
				case 1406:scripts.call('tcoStickPage',[false]);
				trace(Conductor.songPosition);
				scripts.call('tcoBSOD',[true]);
				bsod.alpha = 1; //fixing the bug
				scripts.call('setAlpha',[[blackBG], 0]);
				if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				case 1025 | 1670:scripts.call('tcoBSOD',[false]);
			}
		case 'end process':
			switch(curStep) {
				case 1:if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 1}, 2);
				case 192:if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 0}, 1);
				FlxG.camera.fade(FlxColor.BLACK, 1, true);
				case 1344:FlxTween.tween(redthing, {alpha: 0}, 0.4);
				scripts.call('showUpCorruptBackground',[true]);
				dad.color = 0xFF7A006A;
				boyfriend.color = 0xFF7B6CAD;
				case 1536:scripts.call('endProcessBSODS',[true, 1]);
				FlxTween.color(dad, 1, 0xFF7A006A, FlxColor.WHITE);
				FlxTween.color(boyfriend, 1, 0xFF7B6CAD, FlxColor.WHITE);
				case 1580:scripts.call('showUpCorruptBackground',[false]);
				case 1600:scripts.call('endProcessBSODS',[false, 1]);
				FlxTween.tween(redthing, {alpha: 1}, 0.8);
				/*case 1328:constantShake = true;
				case 1344:endProcessBSODS(true, 2);
				case 1470:endProcessBSODS(false, 2);
				constantShake = false;*/
			}
	}
}
function beatHit() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
		case 'outrage':
			switch(curBeat) {
				case 32:if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.RED, 0.5);
				if (FlxG.save.data.shaders) setChrome(ChromaticAberrationEffect,0.0040);
				if(FlxG.save.data.screenShake) FlxG.camera.shake(0.01, 0.20);
				scripts.call('objectColor',[[boyfriend, gf, Floor, Background1, ScaredCrowd, whiteScreen], 0xFF2C2425]);
				scripts.call('setAlpha',[[redthing], 1]);
				scripts.call('setVisible',[[fires1, fires2], true]);
				lossingHealth = true;
				case 288:scripts.call('tcoStickPage',[true]);
				case 424:if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, 0.5);
				if(FlxG.save.data.screenShake) FlxG.camera.shake(0.01, 0.20);
				scripts.call('colorTween',[[boyfriend, gf, Floor, Background1, ScaredCrowd, whiteScreen], 0.8, 0xFF2C2425, FlxColor.WHITE]);
				lossingHealth = false;
			}
		case 'end process':
			switch(curBeat) {
				case 76:defaultCamZoom += 0.3;
				case 78|79:defaultCamZoom -= 0.075;
				case 80:defaultCamZoom -= 0.15;
				FlxG.camera.zoom = defaultCamZoom;

				FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000);
				case 144|192:defaultCamZoom += 0.2;
				case 176|208:defaultCamZoom -= 0.2;
				case 336:FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
				case 368:FlxTween.tween(this, {defaultCamZoom: defaultCamZoom - 0.4}, Conductor.crochet / 1000, {ease: FlxEase.linear});
				case 398:FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
				case 400:defaultCamZoom -= 0.4;
				case 80:FlxTween.tween(redthing, {alpha: 1}, 0.6);
				if (!FlxG.save.data.lowQuality) {
					FlxTween.tween(newgroundsBurn, {y:newgroundsBurn.y +2300}, 2, {ease: FlxEase.linear, type:FlxTween.LOOPING});
					FlxTween.tween(twitterBurn, {y:twitterBurn.y +1800}, 1.6, {ease: FlxEase.linear, type:FlxTween.LOOPING});
					FlxTween.tween(googleBurn, {y:googleBurn.y +2900}, 2.5, {ease: FlxEase.linear, type:FlxTween.LOOPING});
				}
				case 460:FlxG.sound.play(Paths.sound('intro3'), 0.8);
				case 461:FlxG.sound.play(Paths.sound('intro2'), 0.8);
				case 462:FlxG.sound.play(Paths.sound('intro1'), 0.8);
				case 463:FlxG.sound.play(Paths.sound('introGo'), 0.8);
				case 464:FlxG.camera.setFilters([new ShaderFilter(fishEyeshader)]);
				fishEyeshader.MAX_POWER.value = [0.10];
				/*case 400:generateStaticArrows(0);
				generateStaticArrows(1);
				skipArrowStartTween = true;*/
				case 416://FlxTween.tween(redthing, {alpha: 0}, 2);
				/*case 448:
				camFollow.x = 750;
				camFollow.y = 350;
				isCameraOnForcedPos = true;
				defaultCamZoom = 0.6;
				FlxTween.tween(camHUD, {alpha:0}, 1);
				case 456:FlxG.camera.fade(FlxColor.BLACK, 2, false);*/
			}
	}
	switch(PlayState.SONG.meta.displayName.toLowerCase()) {
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

function onSongEnd() {
	if(PlayState.SONG.meta.displayName.toLowerCase() == 'end process' && PlayState.isStoryMode){
		FlxG.save.data.songsUnlocked_mainWeek = true;
	}
}

function destroy() {
	if(PlayState.SONG.meta.displayName.toLowerCase() == 'end process'){
		FlxG.mouse.unload();
		FlxG.mouse.visible = false;
	}
}