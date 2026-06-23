public var camLYRICS = new FlxCamera();
public var camOther = new FlxCamera();
public var camBars = new FlxCamera();
public var camChar = new FlxCamera();

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

	scripts.call('postNew');
}

function postCreate() {
	//For_the_diff_text_the_first_letter_needs_to_be_capitalised.FUUUUUUUCK.
	window.title = "Computerized Conflict -"+curSong+ " - ["+PlayState.difficulty+"] - Composed by: " +curSong.composer;
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
}

function update(elapsed:Float) {
    healthDrainLolz(0.09 * elapsed, 0.2, multiplierDrain);
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
		var newTweenColor = FlxTween.color(object[i], duration, colorToSayGoodbye, colorToSayHello);
		trace(object[0].color);
		//object[i].color=colorToSayGoodbye;
		//FlxTween.tween(object[i], {color:colorToSayHello}, duration, {ease: FlxEase.sineInOut});
	}
}

public function makeBGSprite(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false){
	scrollX??=1;
	scrollY??=1;
	animArray??=null;
	loop??=false;

	spr = new FlxSprite(x,y);

	if (animArray != null) {
		spr.frames = Paths.getSparrowAtlas(image); //fix for the story cutscenes
		for (i in 0...animArray.length) {
			var anim:String = animArray[i];
			spr.animation.addByPrefix(anim, anim, 24, loop);
			if(idleAnim == null) {
				spr.idleAnim = anim;
				spr.animation.play(anim);
			}
		}
	} else {
		spr.loadGraphic(Paths.image(image));
	}

	spr.set(scrollX, scrollY);
	return spr;
}

function objectColor(object:Array<FlxSprite>, shitColor:FlxColor) for (i in 0...object.length) object[i].color = shitColor;

function alphaTween(object:Array<FlxSprite>, duration:Float, alpha:Float) for (i in 0...object.length) FlxTween.tween(object[i], {alpha:duration}, alpha, {ease: FlxEase.sineInOut});

function setVisible(object:Array<FlxSprite>, visibility:Bool) for (i in 0...object.length) object[i].visible = visibility;

function setAlpha(object:Array<FlxSprite>, visibility:Int) for (i in 0...object.length) object[i].alpha = visibility;

function setCamShake(shit:Array<FlxCamera>, intensity:Float, duration:Float, intensityAlt:Float) {
	for (i in 0...shit.length) {
		if (SONG.notes[curSection].mustHitSection) camGame.shake(intensityAlt, duration);
		else shit[i].shake(intensity, duration);
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

public function tcoBSOD(fuck:Bool){
	if (fuck) {
		if (bsod != null) alphaTween([bsod], 1, 1);
		if (bsod != null) colorTween([boyfriend], 1, 0xFF2C2425, FlxColor.WHITE);
	} else {
		if (bsod != null) alphaTween([bsod], 0, 1);
		if (bsod != null) colorTween([boyfriend], 1, FlxColor.WHITE, 0xFF2C2425);
	}
}

public function tcoStickPage(show:Bool) {
	if (stickpage != null) setAlpha([stickpage, stickpageFloor], 1);
	if (stickpage != null) triggerEventNote('Change Character', 'bf', 'stick-bf');
	if (stickpage != null) boyfriend.color = 0xFF2C2425;
	if (stickpage != null) redthing.color = 0xFF000000;

	if (!show && bsod != null && stickpage != null) {
		setAlpha([stickpage, stickpageFloor], 0);
		remove(stickpage);
		stickpage.destroy();
		stickpage = null;

		triggerEventNote('Change Character', 'bf', 'animator-bf-stressed');
		redthing.color = 0xFFFFFFFF;
	}
}

public function endProcessBSODS(fuck:Bool, type:Int) {
	switch(type) {
		case 1:if (fuck && bsodStatic != null) alphaTween([bsodStatic], 1, 1);
		else alphaTween([bsodStatic], 0, 1);
		case 2:if (fuck && rsod != null) alphaTween([rsod], 1, 1);
		else alphaTween([rsod], 0, 1);
	}
}

public function showUpCorruptBackground(fuck:Bool) {
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

public function healthDrainLolz(drain:Float, min:Float, mult:Float) {
	if(!lossingHealth) return;
	if(PlayState.difficulty.toUpperCase() == 'SIMPLE') return;
	if(PlayState.difficulty.toUpperCase()== 'HARD' && FlxG.save.data.noMechanics_cc) return;
	if(health <= min) return;

	health -= drain * multiplierDrain;
}