public var BF_X:Float = 770;
public var BF_Y:Float = 100;
public var DAD_X:Float = 100;
public var DAD_Y:Float = 100;
public var GF_X:Float = 400;
public var GF_Y:Float = 130;

public var camLYRICS = new FlxCamera();
public var camOther = new FlxCamera();
public var camBars = new FlxCamera();
public var camChar = new FlxCamera();

//Popup Mechanic:
var popUp:FlxSprite;
var closePopup:FlxSprite;
public var popUpTimer:FlxTimer;

//kaboom effect
var angleshit = 1;
var anglevar = 1;
var intensity = 0;
var intensity2 = 3;
var kaboomEnabled:Bool = false;

var tweenZoomEvent:FlxTween;
var LightsColors:Array<FlxColor>; //for the vignette changing color

var bestPart2:Bool = false; //VIGNETTES HANDLER

var noCurLight:Bool = false;

//sonic.exe mod beat zooms type:
var zoomType1:Bool = false;
var zoomType2:Bool = false;
var zoomType3:Bool = false;

//cutscene shit
var topBars:FlxSprite;
var bottomBars:FlxSprite;

var topBarsALT:FlxSprite; //THESE ONES AREN'T THE ONES WITH TWEEN
var bottomBarsALT:FlxSprite; //THIS TOO

//vignettes type:
var vignetteTrojan:FlxSprite; //USED IN TROJAN AND OTHER COOL SONGS
var coolShit:FlxSprite; //USED IN TROJAN AND OTHER COOL SONGS

function new() {
	camLYRICS.bgColor = 0;
	camOther.bgColor = 0;
	camBars.bgColor = 0;
	camChar.bgColor = 0;

	var songsWithCamChar:Array<String> = ['amity', 'trojan', 'alan', 'proficiency'];
	if (songsWithCamChar.contains(PlayState.SONG.meta.name.toLowerCase())) FlxG.cameras.add(camChar, false);

	FlxG.cameras.add(camBars, false);//Before_camHUD.

	FlxG.cameras.remove(camHUD, false);
    camChar.bgColor = 0x00000000;
	
	var songsWithCamLyrics:Array<String> = ['practice time', 'time travel', 'contrivance'];
	if (songsWithCamLyrics.contains(PlayState.SONG.meta.displayName.toLowerCase())) FlxG.cameras.add(camLYRICS, false);

    FlxG.cameras.add(camHUD, false);
	FlxG.cameras.add(camOther, false);

	/*BF_X = stageData.boyfriend[0];
	BF_Y = stageData.boyfriend[1];
	GF_X = stageData.girlfriend[0];
	GF_Y = stageData.girlfriend[1];
	DAD_X = stageData.opponent[0];
	DAD_Y = stageData.opponent[1];*/

	scripts.call('postNew');
}

function postCreate() {
	//For_the_diff_text_the_first_letter_needs_to_be_capitalised.FUUUUUUUCK.
	window.title = "Computerized Conflict -"+curSong+ " - ["+PlayState.difficulty+"] - Composed by: " +PlayState.SONG.meta.composer;
}

function stepHit() {
	if (kaboomEnabled) {
		if (curStep % 4 == 0) {
			FlxTween.tween(camHUD, {y: -6 * intensity2}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
			FlxTween.tween(camGame.scroll, {y: 12}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
		}
		if (curStep % 4 == 2) {
			FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
			FlxTween.tween(camGame.scroll, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
		}
	}
}

function beatHit() {
	if (zoomType1) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}
	if (curBeat % 2 == 0 && zoomType2) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}
	if (curBeat % 1 == 0 && zoomType3) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}

	if (curBeat % 1 == 0 && bestPart2) {
		vignetteTrojan.alpha = 1;
		FlxTween.tween(vignetteTrojan, {alpha:0}, 0.2, {ease: FlxEase.quadInOut});

		if (PlayState.SONG.meta.displayName.toLowerCase() == 'trojan') {
			coolShit.alpha = 1;
			FlxTween.tween(coolShit, {alpha:0}, Conductor.crochet * 5, {ease: FlxEase.sineIn});
		}
	}

	if (bestPart2 && curBeat % 1 == 0 && !noCurLight) {
		curLight = FlxG.random.int(0, LightsColors.length - 1, [curLight]);
		vignetteTrojan.color = LightsColors[curLight];

		if(PlayState.SONG.meta.displayName.toLowerCase() == 'trojan') coolShit.color = LightsColors[curLight];
	}

	if (kaboomEnabled) {
		if (curBeat % 2 == 0) angleshit = anglevar;
		else angleshit = -anglevar;

		camHUD.angle = angleshit * intensity2;
		camGame.angle = angleshit * intensity2;
		FlxTween.tween(camHUD, {angle: angleshit * intensity}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
		FlxTween.tween(camHUD, {x: -angleshit * intensity}, Conductor.crochet * 0.001, {ease: FlxEase.linear});
		FlxTween.tween(camGame, {angle: angleshit * intensity}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
		FlxTween.tween(camGame, {x: -angleshit * intensity}, Conductor.crochet * 0.001, {ease: FlxEase.linear});
	}
}

function update(elapsed:Float) {
    healthDrainLolz(0.09 * elapsed, 0.2, multiplierDrain);

	//TODO: rework
	//TODO: 440, 22
	if (popUp != null && closePopup != null){
		FlxG.mouse.visible = true;
		checkIfClicked(closePopup, 'EP popup');
	}
}

//This_way_EVERY_event_is_atcually_loaded.
function onEvent(_) {
	switch(_.event.name){
		case 'add_cam_zoom':if(FlxG.save.data.camZooms && FlxG.camera.zoom < 1.35) {
			var camZoom:Float = Std.parseFloat(_.event.params[0]);
			var hudZoom:Float = Std.parseFloat(_.event.params[1]);
			if(Math.isNaN(camZoom)) camZoom = 0.015;
			if(Math.isNaN(hudZoom)) hudZoom = 0.03;

			FlxG.camera.zoom += camZoom;
			camHUD.zoom += hudZoom;
		}
		case 'Camera Follow Pos':if(camFollow != null) {
			var val1:Float = Std.parseFloat(_.event.params[0]);
			var val2:Float = Std.parseFloat(_.event.params[1]);
			if(Math.isNaN(val1)) val1 = 0;
			if(Math.isNaN(val2)) val2 = 0;

			isCameraOnForcedPos = false;
			if(!Math.isNaN(Std.parseFloat(_.event.params[0])) || !Math.isNaN(Std.parseFloat(_.event.params[1]))) {
				camFollow.x = val1;
				camFollow.y = val2;
				isCameraOnForcedPos = true;
			}
		}
		case 'Alt Idle Animation':strumLines.members[_.event.params[0]].characters[0].idleSuffix=_.event.params[1];
		case 'Screen Shake':var valuesArray:Array<String> = [_.event.params[0], _.event.params[1]];
		var targetsArray:Array<FlxCamera> = [camGame, camHUD];
		for (i in 0...targetsArray.length) {
			var split:Array<String> = valuesArray[i].split(',');
			var duration:Float = 0;
			var intensity:Float = 0;
			if(split[0] != null) duration = Std.parseFloat(split[0].trim());
			if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
			if(Math.isNaN(duration)) duration = 0;
			if(Math.isNaN(intensity)) intensity = 0;

			if(duration > 0 && intensity != 0) targetsArray[i].shake(intensity, duration);
		}

		case 'Popup':if (popUp != null) return;
		if (cpuControlled) return;
		if (PlayState.difficulty.toLowerCase()== 'simple'||(PlayState.difficulty.toLowerCase()== 'hard' && FlxG.save.data.noMechanics)) return;

		FlxG.sound.play(Paths.sound("erro"));
		popUp = new FlxSprite(FlxG.random.int(0, 774), FlxG.random.int(0, 421)).loadGraphic(Paths.image('chapter1/EProcess/popups/popup_' + FlxG.random.int(1, 7)));
		popUp.camera = camBars;
		popUp.updateHitbox();
		add(popUp);

		closePopup = new FlxSprite().loadGraphic(Paths.image('chapter1/EProcess/popups/close_icon'));
		closePopup.camera = camBars;
		closePopup.scale.set(0.20, 0.20);
		closePopup.x = popUp.x + 436;
		closePopup.y = popUp.y + 22;
		closePopup.setGraphicSize(Std.int(closePopup.width * 0.2));
		closePopup.updateHitbox();
		add(closePopup);

		var timeThing = 10; //ahí para que te jodas un poquito si juegas en insane
		switch(PlayState.difficulty.toLowerCase()) {
			case 'HARD':timeThing = 27; // nerfing more lolz
		}

		popUpTimer = new FlxTimer();
		popUpTimer.start(timeThing, ()->{
			popUpTimer = null;
			health = -0.1;
		});

		case 'zoomBeatType1':if(FlxG.save.data.camZooms) zoomType1 = true;
		case 'zoomBeatType2':if(FlxG.save.data.camZooms) zoomType2 = true;
		case 'zoomBeatType3':if(FlxG.save.data.camZooms) zoomType3 = true;

		//stop beats
		case 'zoomBeatType1 Cancel':zoomType1 = false;
		case 'zoomBeatType2 Cancel':zoomType2 = false;
		case 'zoomBeatType3 Cancel':zoomType3 = false;
		case 'blackBars test':blackBars(1);
		case 'cancel blackbars':blackBars(0);
		case 'blackBars2 test':pushBlackBars2(1);
		case 'cancel blackbars2':pushBlackBars2(0);
		case 'Set Cam Zoom'|'defaultCamZoom':defaultCamZoom = _.event.params[0];
		case 'Tween Zoom':
		tweenZoomEvent = FlxTween.tween(FlxG.camera, {zoom: _.event.params[0]}, _.event.params[1] * scripts.get('playbackRate'), {
			ease: FlxEase.quadInOut,
			onComplete: function(twn){defaultCamZoom = _.event.params[0];},
		});
		case 'cancel Tween Zoom':if (tweenZoomEvent != null) tweenZoomEvent = null;
		case 'Flash Camera BLACK':if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.BLACK, _.event.params[0]);
		case 'Flash Camera WHITE':if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.WHITE, _.event.params[0]);
		case 'Flash Camera RED':if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.RED, _.event.params[0]);
		case 'Virabot Attack'://virabotAttack();
		case 'Kaboom':kaboomEnabled = true;
	}
}

function onDadHit(e){
	switch(e.character.curCharacter.toLowerCase()){
		case 'the-chosen-one':
			if (!FlxG.fullscreen || !window.maximized) setCamShake([camHUD, camGame], 0.015, 0.05, 0.005);
			else setCamShake([camHUD, camGame, camOther], 0.015, 0.05, 0.0045);
	}
}

function onSongEnd() {
	trace(FlxG.save.data.songsUnlocked);
	if(!FlxG.save.data.songsUnlocked.contains(curSong)){
		trace('played'+curSong+'for the first time');

		FlxG.save.data.songsUnlocked.push(curSong);
	}
}

public var lossingHealth:Bool = false;

public var multiplierDrain:Float = 1;

public var zoomType1:Bool = false;
public var zoomType2:Bool = false;
public var zoomType3:Bool = false;

public function zoomtype(number:String) {
    switch(number){
		case '0': zoomType1 = !zoomType1;
		case '1': zoomType2 = !zoomType2;
		case '2': zoomType3 = !zoomType3;
	}
}

public function dialogOnSong(dialog:String, duration:Float, color:FlxColor) {
	if (lyricsDestroyTimer != null) lyricsDestroyTimer.cancel();
	if (textTween != null) textTween.cancel();
	if (textTweenAlpha != null) textTweenAlpha.cancel();
	if (textLyrics != null) {remove(textLyrics); textLyrics.destroy();}
	textLyrics = new FlxTypeText(0, -40, FlxG.width, dialog, 24);
	textLyrics.setFormat(Paths.font("phantommuff.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textLyrics.camera = camLYRICS;
	textLyrics.screenCenter();
	textLyrics.y += 250;
	textLyrics.scrollFactor.set();
	textLyrics.color = color;
	add(textLyrics);
	textLyrics.alpha = 0;

	textLyrics.start(0.03, true);
	textTweenAlpha = FlxTween.tween(textLyrics, {alpha:1}, 0.3);

	lyricsDestroyTimer = new FlxTimer().start(duration, function(A:FlxTimer) {
		textTween = FlxTween.tween(textLyrics, {alpha: 0}, 0.3, {
		ease: FlxEase.linear,
		onComplete: function(twn:FlxTween) {
			remove(textLyrics);
			textLyrics.destroy();
		}});
	});
}

public function dialogOnSongNoTween(dialog:String, duration:Float, color:FlxColor) {
	textNoTween = new FlxText(0, -20, FlxG.width, dialog, 24);
	textNoTween.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textNoTween.camera = camHUD;
	textNoTween.screenCenter();
	textNoTween.y += 200;
	textNoTween.scrollFactor.set();
	textNoTween.color = color;
	add(textNoTween);

	new FlxTimer().start(duration, function(A:FlxTimer) {
		if (textNoTween != null) {
			remove(textNoTween);
			textNoTween.destroy();
		}
	});
}

function blackBars(yes:Int) {
	if (topBars != null && bottomBars != null) {
		if (yes == 1) {
			FlxTween.tween(topBars, {y: -200}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(bottomBars, {y: 550}, 1, {ease: FlxEase.quadInOut});
		} else {
			FlxTween.tween(topBars, {y: -650}, 0.5, {ease: FlxEase.quadInOut});
			FlxTween.tween(bottomBars, {y: 850}, 0.5, {ease: FlxEase.quadInOut});
		}
	}
}

function pushBlackBars2(yes:Int) {
	if (topBarsALT != null && bottomBarsALT != null) {
		if (yes == 1) {
			topBarsALT.alpha = 1;
			bottomBarsALT.alpha = 1;
		} else {
			topBarsALT.alpha = 0;
			bottomBarsALT.alpha = 0;
		}
	}
}

function flash(color:FlxColor, duration:Float) if(FlxG.save.data.flashing) FlxG.cameras.flash(color, duration);

function colorTween(object:Array<FlxSprite>, duration:Float, colorToSayGoodbye:FlxColor, colorToSayHello:FlxColor){
	for (i in 0...object.length){
		obj=object[i];
		var newTweenColor = FlxTween.color(obj, duration, colorToSayGoodbye, colorToSayHello);
	}
}

function objectColor(object:Array<FlxSprite>, shitColor:FlxColor) for (i in 0...object.length) {
	object[i].color = shitColor;
	}

function alphaTween(object:Array<FlxSprite>, duration:Float, alpha:Float){
	for (i in 0...object.length) {
	obj=object[i];
	FlxTween.tween(obj, {alpha:duration}, alpha, {ease: FlxEase.sineInOut});
	}
}

function setVisible(object:Array<FlxSprite>, visibility:Bool) for (i in 0...object.length) object[i].visible = visibility;

function setAlpha(object:Array<FlxSprite>, visibility:Int) for (i in 0...object.length) {
	obj=object[i];
	obj.alpha = visibility;
	}

function setCamShake(shit:Array<FlxCamera>, intensity:Float, duration:Float, intensityAlt:Float) {
	for (i in 0...shit.length) {
		curCameraTarget==1? camGame.shake(intensityAlt, duration):shit[i].shake(intensity, duration);
	}
}

public function setDance(object:Array<BGSprite>, dance:Bool) for (i in 0...object.length) object[i].dance(dance);

function changeBetweenMinusTCO(angry:Bool) {
	if (!angry) {
		if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.BLACK, 0.50);
		triggerEventNote('Change Character', 'dad', 'minus-tco');
	} else {
		if(FlxG.save.data.flashing) FlxG.camera.flash(FlxColor.RED, 0.50);
		triggerEventNote('Change Character', 'dad', 'angry-minus-tco');
	}
}

function healthDrainRates(simple:Float, hard:Float, insane:Float, mult:Float = 1) {
	if((PlayState.difficulty.toUpperCase() == 'HARD' || PlayState.difficulty.toUpperCase() == 'SIMPLE') && FlxG.save.data.noMechanics) return;

	switch(PlayState.difficulty.toUpperCase()) {
		case 'SIMPLE':health -= simple * mult;
		case 'HARD':health -= hard * mult;
		case 'INSANE':health -= insane * mult;
	}
}

public function confBSODShake(intensity:Float = 1.0) {
	new FlxTimer().start(0.01, ()->{bsod.y += (10 * intensity);});
	new FlxTimer().start(0.05, ()->{bsod.y -= (15 * intensity);});
	new FlxTimer().start(0.10, ()->{bsod.y += (8 * intensity);});
	new FlxTimer().start(0.15, ()->{bsod.y -= (5 * intensity);});
	new FlxTimer().start(0.20, ()->{bsod.y += (3 * intensity);});
	new FlxTimer().start(0.25, ()->{bsod.y -= (1 * intensity);});
}

function tcoBSOD(fuck:Bool){
	if (fuck) {
		if (bsod != null) alphaTween([bsod], 1, 1);
		if (bsod != null) colorTween([boyfriend], 1, 0xFF2C2425, FlxColor.WHITE);
	} else {
		if (bsod != null) alphaTween([bsod], 0, 1);
		if (bsod != null) colorTween([boyfriend], 1, FlxColor.WHITE, 0xFF2C2425);
	}
}

function tcoStickPage(show:Bool) {
	if (stickpage != null) setAlpha([stickpage, stickpageFloor], 1);
	//if (stickpage != null) triggerEventNote('Change Character', 'bf', 'stick-bf');
	if (stickpage != null) boyfriend.color = 0xFF2C2425;
	if (stickpage != null) redthing.color = 0xFF000000;

	if (!show && bsod != null && stickpage != null) {
		setAlpha([stickpage, stickpageFloor], 0);
		remove(stickpage);
		stickpage.destroy();
		stickpage = null;

		//triggerEventNote('Change Character', 'bf', 'animator-bf-stressed');
		redthing.color = 0xFFFFFFFF;
	}
}

function endProcessBSODS(fuck:Bool, type:Int) {
	switch(type) {
		case 1:if (fuck && bsodStatic != null) alphaTween([bsodStatic], 1, 1);
		else alphaTween([bsodStatic], 0, 1);
		case 2:if (fuck && rsod != null) alphaTween([rsod], 1, 1);
		else alphaTween([rsod], 0, 1);
	}
}

function showUpCorruptBackground(fuck:Bool) {
	if (fuck) if (corruptBG != null) setAlpha([corruptBG, corruptFloor], 1);
	else if (corruptBG != null) setAlpha([corruptBG, corruptFloor], 0);
}

public function showHUDTween(duration:Float, alpha:Float) {
	if(!FlxG.save.data.hideHud) {
		alphaTween([healthBar, healthBarBG, iconP1, iconP2, scoreTxt, judgementCounter, botplayTxt], duration, alpha);
		if (iconP3 != null) alphaTween([iconP3], duration, alpha);
		if (iconP4 != null) alphaTween([iconP4], duration, alpha);
	}

	if(FlxG.save.data.timeBarType != 'Disabled') {
		alphaTween([timeBar, timeBarBG, timeTxt], duration, alpha);
	}

	for (i in 0...playerStrums.length) alphaTween([playerStrums.members[i]], duration, alpha);

	if (FlxG.save.data.middleScroll && alpha <= 0.35) {
		for (i in 0...opponentStrums.length) alphaTween([opponentStrums.members[i]], ClientPrefs.middleScroll ? 0 : duration, 0.35);
	} else {
		for (i in 0...opponentStrums.length) alphaTween([opponentStrums.members[i]], ClientPrefs.middleScroll ? 0 : duration, alpha);
	}
}

public function addShaderToCamera(cam:Array<String>, effect:ShaderEffect){//STOLE FROM ANDROMEDA
	for (i in 0...cam.length) {
		switch(cam[i].toLowerCase()) {
			case 'camhud'|'hud':camHUDShaders.push(effect);
			var newCamEffects:Array<BitmapFilter> = []; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
			for (i in camHUDShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camHUD.setFilters(newCamEffects);
			case 'camother' | 'other':
			camOtherShaders.push(effect);
			var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
			for (i in camOtherShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camOther.setFilters(newCamEffects);
			case 'camgame' | 'game':
			camGameShaders.push(effect);
			var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
			for (i in camGameShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camGame.setFilters(newCamEffects);
			default:if (modchartSprites.exists(cam[i])) Reflect.setProperty(modchartSprites.get(cam[i]),"shader",effect.shader);
			else if (modchartTexts.exists(cam[i])) Reflect.setProperty(modchartTexts.get(cam[i]),"shader",effect.shader);
			else {
				var OBJ = Reflect.getProperty(PlayState.instance, cam[i]);
				Reflect.setProperty(OBJ,"shader", effect.shader);
			}
		}
	}
}

public function removeShaderFromCamera(cam:Array<String>, effect:ShaderEffect) {
	for (i in 0...cam.length) {
		switch(cam[i].toLowerCase()) {
			case 'camhud'|'hud':camHUDShaders.remove(effect);
			var newCamEffects:Array<BitmapFilter> = [];
			for (i in camHUDShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camHUD.setFilters(newCamEffects);
			case 'camother'|'other':
			camOtherShaders.remove(effect);
			var newCamEffects:Array<BitmapFilter> = [];
			for (i in camOtherShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camOther.setFilters(newCamEffects);
			default:camGameShaders.remove(effect);
			var newCamEffects:Array<BitmapFilter> = [];
			for (i in camGameShaders) newCamEffects.push(new ShaderFilter(i.shader));

			camGame.setFilters(newCamEffects);
		}
	}
}

public function clearShaderFromCamera(cam:Array<String>) {
	for (i in 0...cam.length) {
		switch(cam[i].toLowerCase()) {
			case 'camhud'|'hud':camHUDShaders = [];
			var newCamEffects:Array<BitmapFilter> = [];
			camHUD.setFilters(newCamEffects);
			case 'camother'|'other':camOtherShaders = [];
			var newCamEffects:Array<BitmapFilter> = [];
			camOther.setFilters(newCamEffects);
			default:camGameShaders = [];
			var newCamEffects:Array<BitmapFilter> = [];
			camGame.setFilters(newCamEffects);
		}
	}
}

function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
	if(gfCheck && char.curCharacter.startsWith('gf') || char.curCharacter.startsWith('animator-gf') && PlayState.SONG.meta.displayName.toLowerCase() == 'practice time') { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
		char.setPosition(GF_X, GF_Y);
		char.scrollFactor.set(0.95, 0.95);
		char.danceEveryNumBeats = 2;
	}
	char.x += char.positionArray[0];
	char.y += char.positionArray[1];
}

function virabotAttack() {
	dodged = false;

	dad.playAnim('throw', true);
	dad.specialAnim = true;

	if (dad.animation.curAnim.finished)	dad.specialAnim = false;

	new FlxTimer().start(0.4, ()->{
		if (dodged) {
			boyfriend.playAnim('dodge');
			boyfriend.specialAnim = true;

			if (boyfriend.animation.curAnim.finished) boyfriend.specialAnim = false;
		} else health -= 0.5;
	});
}

function checkIfClicked(object:FlxSprite, tag:String) {//the tag is the thing used for the select void
	if(!FlxG.mouse.justPressed) return;
	if(!mouseOverlaps(object)) return;

	trace(object);

	//FlxG.sound.play(Paths.sound('mouseClick'));

	switch(tag) {
		case 'EP popup':
		FlxG.sound.play(Paths.sound('mouseClick'));

		//tweens are broken when 2 clicks in a row idk why xd
		remove(popUp);
		popUp.destroy();
		popUp = null;
		remove(closePopup);
		closePopup.destroy();
		closePopup = null;
			
		popUpTimer.cancel();
		popUpTimer.destroy();
	}
}

function mouseOverlaps(spr:FlxSprite) {//I needed neo's help for this
	for (camera in spr.cameras) {
		if (spr.overlapsPoint(FlxG.mouse.getWorldPosition(camera), true, camera)) return true;
	}
	return false;
}

public function healthDrainLolz(drain:Float, min:Float, mult:Float) {
	if(!lossingHealth) return;
	if(PlayState.difficulty.toUpperCase() == 'SIMPLE') return;
	if(PlayState.difficulty.toUpperCase()== 'HARD' && FlxG.save.data.noMechanics_cc) return;
	if(health <= min) return;

	health -= drain * multiplierDrain;
}