import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import psych.BGSprite;

var stopBFFlyTrojan = false;
var ChromaticAberrationEffect = new CustomShader("ChromaticAberrationShader");
var nightTimeShader = new CustomShader("NightTimeShader"+getTheOs());
nightTimeShader.iTime=0;
var BloomShader = new CustomShader("BloomShader");
BloomShader.intensity = 0.35;
BloomShader.blurSize = 1.0/512.0;
function setChrome(shader:Dynamic,chromeOffset) {
	shader.rOffset=chromeOffset;
	shader.gOffset=0;
	shader.bOffset=chromeOffset * -1;
}

function postNew() {
	scripts.set('LightsColors',[[0xFFE5BE01, 0xFF00AAE4, 0xFF76BD17, 0xFFFF0000, 0xFFFF8000]]);

	alanBG = new BGSprite('extras/trojan/alan_desktop', -80, -1800, 1, 1);
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));

	adobeWindow = new BGSprite('extras/trojan/XD', -80, -1800, 1, 1);
	adobeWindow.setGraphicSize(Std.int(adobeWindow.width * 2));
	adobeWindow.screenCenter();
	adobeWindow.y -= 900;
	adobeWindow.x += 1500;

	sFWindow = new BGSprite('extras/trojan/stickFightwindow', -80, -1800, 1, 1);
	sFWindow.screenCenter();
	sFWindow.y -= 900;
	sFWindow.x += 900;
	sFWindow.setGraphicSize(Std.int(sFWindow.width * 1.5));

	daFloor = new BGSprite('extras/trojan/floor', -80, -1800, 1, 1);
	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;

	if (!FlxG.save.data.lowQuality) {
		tscseeing = new BGSprite('extras/trojan/secbop', 0, 0, 1, 1, ['secbop']);
		tscseeing.setGraphicSize(Std.int(tscseeing.width * 1.3));
		tscseeing.screenCenter();
		tscseeing.updateHitbox();
		tscseeing.x += 2480;
		tscseeing.y += 95;
		tscseeing.antialiasing = Options.antialiasing;
	}

	radialLine = new BGSprite('extras/radial line', 0, 0, 1, 1, ['anime_lines'], true);
	radialLine.setGraphicSize(Std.int(radialLine.width * 1.7));
	radialLine.camera = camBars;
	radialLine.screenCenter();
	add(radialLine);
	radialLine.alpha = 0.0001; //kinda laggy when it changes to an alpha of 1 if it's set to 0

	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('chapter1/victim/vignette'));
	redthing.antialiasing = Options.antialiasing;
	redthing.camera = camBars;
	redthing.alpha = 0.0001;
	add(redthing);

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

	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/vignette'));
	vignetteTrojan.antialiasing = Options.antialiasing;
	vignetteTrojan.camera = camBars;
	vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0.0001;
	//vignetteTrojan.blend = LIGHTEN;
	add(vignetteTrojan);

	coolShit = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/cool'));
	coolShit.antialiasing = Options.antialiasing;
	coolShit.camera = camBars;
	coolShit.scale.set(20, 20);
	coolShit.screenCenter();
	coolShit.alpha = 0.0001;
	//coolShit.blend = LIGHTEN;
	add(coolShit);

	add(alanBG);
	add(adobeWindow);
	add(sFWindow);
	add(daFloor);
	if (!FlxG.save.data.lowQuality) add(tscseeing);

	filter = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/filterr'));
	filter.antialiasing = Options.antialiasing;
	filter.alpha = 0.0001;
	filter.scrollFactor.set();
	filter.camera = camChar;
	add(filter);

	scroll = new FlxBackdrop(Paths.image('extras/trojan/scrollmidsong'),FlxAxes.XY);
	scroll.setGraphicSize(Std.int(scroll.width * 0.9));
	scroll.alpha = 0.0001;
	add(scroll);

	vignettMid = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/vigMidSong'));
	vignettMid.antialiasing = Options.antialiasing;
	vignettMid.alpha = 0.0001;
	vignettMid.scrollFactor.set();
	vignettMid.camera = camChar;
	add(vignettMid);

	viraScroll = new FlxBackdrop(Paths.image('extras/trojan/exe'),FlxAxes.XY);
	viraScroll.setGraphicSize(Std.int(viraScroll.width * 0.9));
	viraScroll.alpha = 0.0001;
	add(viraScroll);

	vignetteFin = new FlxSprite(0, 0).loadGraphic(Paths.image('extras/trojan/vignetteFin'));
	vignetteFin.antialiasing = Options.antialiasing;
	vignetteFin.alpha = 0.0001;
	vignetteFin.scrollFactor.set();
	vignetteFin.camera = camChar;
	add(vignetteFin);

	//colorShadShit(colorShad,)
	colorShad.data.uHsv.value=[0,0,0];
	if(PlayState.SONG.meta.displayName.toLowerCase()== 'trojan') camGame.alpha = 0;

	killThem(2);

	add(scroll);
	add(viraScroll);

	killThem(0);
	killThem(1);
}

function onSongStart() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()){
		case 'trojan':camGame.alpha = 1;filter.alpha = 1;
	}
}

function update(elapsed:Float) {
	scroll.x -= 0.45 * 60 * elapsed;
	scroll.y -= 0.16 * 60 * elapsed;

	viraScroll.x -= 0.45 * 240 * elapsed;
	viraScroll.y -= 0.16 * 240 * elapsed;

	waterShit([256, 318]);

	nightTimeShader.iTime+=elapsed;
}

function beatHit() {
	switch(PlayState.SONG.meta.displayName.toLowerCase()){
		case 'trojan':
			switch(curBeat){
				case 28|188:camGame.fade(FlxColor.WHITE, (Conductor.crochet/1000*3), false);
				case 32:camGame.fade(FlxColor.WHITE, 0, true);
				if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
					camHUD.addShader(ChromaticAberrationEffect);
					setChrome(ChromaticAberrationEffect,0.0045);
				}
				redthing.alpha = 1;
				case 64|224|320:bestPart2 = true;
				if (!FlxG.save.data.lowQuality)scripts.call('colorTween',[[gf, alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.1, FlxColor.WHITE, 0xFF191919]);
				else scripts.call('colorTween',[[gf, alanBG, sFWindow, adobeWindow, daFloor], 0.1, FlxColor.WHITE, 0xFF191919]);
				radialLine.alpha = 1;
				if (FlxG.save.data.shaders && FlxG.save.data.advancedShaders) {
					FlxG.camera._filters = [];
					FlxG.camera.addShader(nightTimeShader);
				}
				scroll.alpha = 0;
				vignettMid.alpha = 0;
				redthing.alpha = 0.0001;
				camGame.alpha= 1;
				filter.alpha = 1;
				case 96:vignetteTrojan.alpha = 0.0001;
				coolShit.alpha = 0.0001;
				bestPart2 = false;
				if (!FlxG.save.data.lowQuality) scripts.call('colorTween',[[gf, alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE]);
				else scripts.call('colorTween',[[gf, alanBG, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.WHITE]);
				radialLine.alpha = 0.0001;
				redthing.alpha = 0;
				if (FlxG.save.data.shaders) {FlxG.camera._filters = [];
					camHUD._filters = [];
					camGame.addShader(ChromaticAberrationEffect);
					camHUD.addShader(ChromaticAberrationEffect);
					setChrome(ChromaticAberrationEffect,0.0045);
				}
				case 160:if (FlxG.save.data.shaders && FlxG.save.data.advancedShaders) {
					FlxG.camera._filters = [];
					FlxG.camera.addShader(BloomShader);
				}
				case 192:camGame.fade(FlxColor.WHITE, 0, true);
				if (FlxG.save.data.shaders) {FlxG.camera._filters = [];
					camHUD._filters = [];
					camGame.addShader(ChromaticAberrationEffect);
					camHUD.addShader(ChromaticAberrationEffect);
					setChrome(ChromaticAberrationEffect,0.0045);
				}
				redthing.alpha = 1;
				case 256:vignetteTrojan.alpha = 0.0001;
				vignettMid.alpha = 1;
				scroll.alpha = 1;
				radialLine.alpha = 0.0001;
				coolShit.alpha = 0;
				bestPart2 = false;
				filter.alpha = 0.0001;
				if(FlxG.save.data.flashing) camChar.flash(FlxColor.WHITE, 0.85);
				boyfriend.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
				dad.setColorTransform(1, 1, 1, 1, 255, 255, 255, 0);
				gf.alpha = 0.0001;
				case 288:if(FlxG.save.data.flashing) camChar.flash(FlxColor.WHITE, 0.85);
				case 318:camGame.alpha = 0;
				boyfriend.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				dad.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
				vignettMid.alpha = 0;
				case 348:FlxG.sound.play(Paths.sound('intro3'), 0.4);
				camGame.fade(FlxColor.WHITE, (Conductor.crochet/1000*3), false);
				//cameraLocked = true;
				stopBFFlyTrojan = true;
				FlxTween.tween(boyfriend, {y: BF_Y - 1000}, 1, {ease: FlxEase.quadIn});
				FlxTween.tween(boyfriendGroup, {angle: 359.99 * 4}, 23);
				case 349:FlxG.sound.play(Paths.sound('intro2'), 0.4);
				case 350:FlxG.sound.play(Paths.sound('intro1'), 0.4);
				case 351:FlxG.sound.play(Paths.sound('introGo'), 0.4);
				case 352:stopBFFlyTrojan = false;
				camGame.fade(FlxColor.WHITE, 0.5, true);
				if (FlxG.save.data.shaders && FlxG.save.data.flashing) {
					FlxG.camera.setFilters([new ShaderFilter(colorShad.shader), new ShaderFilter(fishEyeshader)]);
				fishEyeshader.MAX_POWER.value = [0.15];
				}
				isPlayersSpinning = true;
				cameraLocked = false;
				constantShake = true;
				viraScroll.alpha = 1;
				vignetteFin.alpha = 1;
				filter.alpha = 0.0001;
				gf.alpha = 0.0001;
				if (!FlxG.save.data.lowQuality) scripts.call('colorTween',[[alanBG, tscseeing, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.BLACK]);
				else scripts.call('colorTween',[[alanBG, sFWindow, adobeWindow, daFloor], 0.8, 0xFF191919, FlxColor.BLACK]);
			}
	}
}

var colorShad = new CustomShader("psych/ColorSwapShader");

function colorShadShit(shader,var:Int,val) {
	shader.data.uHsv.value[0]=val;
}

function killThem(num:Int) {
	if(strumLines.length<=num)return;
	for(i in 0...strumLines.members[num].characters.length){
		remove(strumLines.members[num].characters[i],true);
		add(strumLines.members[num].characters[i]);
	}
}

function waterShit(betweenBeats:Array<Int>) {
	if(stopBFFlyTrojan) return;

	if(curBeat >= betweenBeats[0] && curBeat < betweenBeats[1]) {
		var test:Float = (Conductor.songPosition/3000)*(Conductor.bpm/30);

		dad.setPosition(DAD_X, DAD_Y);
		scripts.call('startCharacterPos',[dad, true]);
		dad.angle = 30*Math.cos(test/6);
		dad.x += 50*Math.cos(test/6);
		dad.y += 50*Math.sin(test/6);

		boyfriend.setPosition(BF_X, BF_Y);
		scripts.call('startCharacterPos',[boyfriend]);
		boyfriend.angle = 30*Math.sin(test/6);
		boyfriend.x += 50*Math.sin(test/6);
		boyfriend.y += 50*Math.cos(test/6);
	} else {
		dad.setPosition(DAD_X, DAD_Y);
		scripts.call('startCharacterPos',[dad, true]);
		dad.angle = 0;
		boyfriend.setPosition(BF_X, BF_Y);
		scripts.call('startCharacterPos',[boyfriend]);
		boyfriend.angle = 0;
	}
}