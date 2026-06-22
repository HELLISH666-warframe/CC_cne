import openfl.Lib;
import lime.app.Application;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.text.FlxTypeText;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
var intensity:Float = 0;

public function alphaTween(object:Array<FlxSprite>, duration:Float, alpha:Float){
	for (i in 0...object.length) FlxTween.tween(object[i], {alpha:duration}, alpha, {ease: FlxEase.sineInOut});
}

public var camChar = new FlxCamera();
public var camLYRICS = new FlxCamera();
public var camOther:HudCamera;

public var vignetteTrojan:FlxSprite; //USED IN TROJAN AND OTHER COOL SONGS

public var needsBlackBG:Bool = false; //for songs that need to have a black bg (not hiding bf or dad)

public var chromaticAberration = new CustomShader("ChromaticAberrationShader");
public var endingShader = new CustomShader("Glitch02Shader");

public var blackBG:FlxSprite;
public var num1:Int=4;
public var num2:Int=3;

function postCreate() {
    FlxG.cameras.add(camOther = new HudCamera(), false);
    camOther.bgColor = 0x00000000;
    add(vignetteTrojan);
	if (needsBlackBG) {
		blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), 0xFF000000);
		blackBG.scrollFactor.set();
		blackBG.alpha = 0;
		blackBG.screenCenter();
		add(blackBG);
	}
	endingShader.data.iMouseX.value=[num1];
	endingShader.data.NUM_SAMPLES.value=[num2];
	endingShader.data.glitchMultiply.value=[num2];
}

public var bestPart2:Bool = false; //VIGNETTES HANDLER

public var noCurLight:Bool = false;

public var lightsColors:Array<FlxColor>; //for the vignette changing color

function beatHit(curBeat:Int) {
    if (curBeat % 1 == 0 && bestPart2) {
		vignetteTrojan.alpha = 1;
		FlxTween.tween(vignetteTrojan, {alpha:0}, 0.2, {ease: FlxEase.quadInOut});

		if (curSong == 'trojan')
		{
			coolShit.alpha = 1;
			FlxTween.tween(coolShit, {alpha:0}, Conductor.crochet * 5, {ease: FlxEase.sineIn});
		}
	}
    if (bestPart2 && curBeat % 1 == 0 && !noCurLight) {
		curLight = FlxG.random.int(0, lightsColors.length - 1, [curLight]);
		vignetteTrojan.color = lightsColors[curLight];

		if(curSong == 'trojan')
		{
			coolShit.color = lightsColors[curLight];
		}
	}
}

public var curLight:Int = -1;

public static var oldVideoResolution:Bool = false; 
function create() {
    FlxG.cameras.remove(camHUD, false);
    camChar.bgColor = 0x00000000;
	FlxG.cameras.add(camChar, false);
    FlxG.cameras.add(camHUD, false);
	FlxG.cameras.add(camLYRICS, false);
	camLYRICS.bgColor = 0;
	FlxG.cameras.add(camOther = new HudCamera(), false);
    camOther.bgColor = 0x00000000;
    if(oldVideoResolution) {
	if(FlxG.fullscreen)	FlxG.fullscreen = false;
		Lib.application.window.resizable = false;
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.resizeGame(960, 720);
		FlxG.resizeWindow(960, 720);
		//camHUD.width=720;
	}
}
var time:Float=0;
function update(elapsed:Float) {
	time+=elapsed;
	endingShader.uTime= time;
}

function destroy() {
	if(oldVideoResolution){
	Lib.application.window.resizable = true;
	FlxG.scaleMode = new RatioScaleMode(false);
	FlxG.resizeGame(1280, 720);
	FlxG.resizeWindow(1280, 720);
	oldVideoResolution=false;
	}
}
public function tcoBSOD(fuck:Bool) {
	if (fuck) {
		if (stage.getSprite("bsod") != null) alphaTween([stage.getSprite("bsod")], 1, 1);
		if (stage.getSprite("bsod") != null) colorTween([boyfriend], 1, 0xFF2C2425, FlxColor.WHITE);
	}
	else {
		if (stage.getSprite("bsod") != null) alphaTween([stage.getSprite("bsod")], 0, 1);
		if (stage.getSprite("bsod") != null) colorTween([boyfriend], 1, FlxColor.WHITE, 0xFF2C2425);
	}
}

public function confBSODShake(intensity:Float = 1.0) {
	intensity=intensity;
	new FlxTimer().start(0.01, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y += (10 * intensity);
	});
	new FlxTimer().start(0.05, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y -= (15 * intensity);
	});
	new FlxTimer().start(0.10, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y += (8 * intensity);
	});
	new FlxTimer().start(0.15, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y -= (5 * intensity);
	});
	new FlxTimer().start(0.20, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y += (3 * intensity);
	});
	new FlxTimer().start(0.25, function(tmr:FlxTimer) {
		stage.getSprite("bsod").y -= (1 * intensity);
	});
}

//remove the lyrics
public var lyricsDestroyTimer:FlxTimer;
public var textTween:FlxTween;
public var textTweenAlpha:FlxTween;

public var textLyrics:FlxTypeText; //the dialog text

public function dialogOnSong(dialog:String, duration:Float, color:FlxColor) {
	if (lyricsDestroyTimer != null) lyricsDestroyTimer.cancel();
	if (textTween != null) textTween.cancel();
	if (textTweenAlpha != null) textTweenAlpha.cancel();
	if (textLyrics != null) {remove(textLyrics); textLyrics.destroy();}
	textLyrics = new FlxTypeText(0, -40, FlxG.width, dialog, 24);
	textLyrics.setFormat(Paths.font("phantommuff.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textLyrics.cameras = [camLYRICS];
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

public function objectColor(object:Array<FlxSprite>, shitColor:FlxColor) {
	for (i in 0...object.length) object[i].color = shitColor;
}
public function setAlpha(object:Array<FlxSprite>, visibility:Int) {
	for (i in 0...object.length) object[i].alpha = visibility;
}
public function setVisible(object:Array<FlxSprite>, visibility:Bool) {
	for (i in 0...object.length) object[i].visible = visibility;
}

public function tcoStickPage(show:Bool) {
	if (stage.getSprite("stickpage") != null) setAlpha([stage.getSprite("stickpage"), stage.getSprite("stickpageFloor")], 1);
	//if (stage.getSprite("stickpage") != null) triggerEventNote('Change Character', 'bf', 'stick-bf');
	if (stage.getSprite("stickpage") != null) boyfriend.color = 0xFF2C2425;
	if (stage.getSprite("stickpage") != null) redthing.color = 0xFF000000;

	if (!show && stage.getSprite("bsod") != null && stage.getSprite("stickpage") != null) {
		setAlpha([stage.getSprite("stickpage"), stage.getSprite("stickpageFloor")], 0);
		remove(stage.getSprite("stickpage"));
		stage.getSprite("stickpage").destroy();

		//triggerEventNote('Change Character', 'bf', 'animator-bf-stressed');
		redthing.color = 0xFFFFFFFF;
	}
}
/*public function setCamShake(shit:Array<FlxCamera>, intensity:Float, duration:Float, intensityAlt:Float) {
	for (i in 0...shit.length) {
		if (SONG.notes[curSection].mustHitSection) {
			camGame.shake(intensityAlt, duration);
		}
		else
		{
			shit[i].shake(intensity, duration);
		}
	}
}*/

public function endProcessBSODS(fuck:Bool, type:Int) {
	switch(type) {
		case 1:
			if (fuck && stage.getSprite("bsodStatic") != null) alphaTween([stage.getSprite("bsodStatic")], 1, 1);
			else alphaTween([stage.getSprite("bsodStatic")], 0, 1);
		case 2:
			if (fuck && stage.getSprite("rsod") != null) alphaTween([stage.getSprite("rsod")], 1, 1);
			else alphaTween([stage.getSprite("rsod")], 0, 1);
	}
}

public function showUpCorruptBackground(fuck:Bool) {
	if (fuck) {
		if (stage.getSprite("corruptBG") != null) setAlpha([stage.getSprite("corruptBG"), stage.getSprite("corruptFloor")], 1);
	} else {
		if (stage.getSprite("corruptBG") != null) setAlpha([stage.getSprite("corruptBG"), stage.getSprite("corruptFloor")], 0);
	}
}