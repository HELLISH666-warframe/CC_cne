import openfl.Lib;
import lime.app.Application;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
public var stopTweens:Array<FlxTween> = [];
var intensity:Float = 0;
public function colorTween(object:Array<FlxSprite>, duration:Float, colorToSayGoodbye:FlxColor, colorToSayHello:FlxColor) {
	for (i in 0...object.length) {
		var newTweenColor = FlxTween.color(object[i], duration, colorToSayGoodbye, colorToSayHello);

		stopTweens.push(newTweenColor);
	}
}

public function alphaTween(object:Array<FlxSprite>, duration:Float, alpha:Float){
	for (i in 0...object.length) FlxTween.tween(object[i], {alpha:duration}, alpha, {ease: FlxEase.sineInOut});
}

public var camChar = new FlxCamera();
public var camBars:HudCamera;
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
}

public var lossingHealth:Bool = false;

public var multiplierDrain:Float = 1;

public function healthDrainLolz(drain:Float, min:Float, mult:Float) {
	if(!lossingHealth) return;
	if(PlayState.difficulty.toUpperCase() == 'SIMPLE') return;
	if(PlayState.difficulty.toUpperCase()== 'HARD' && FlxG.save.data.noMechanics_cc) return;
	if(health <= min) return;

	health -= drain * multiplierDrain;
}

public var curLight:Int = -1;

public static var oldVideoResolution:Bool = false; 
function create() {
    FlxG.cameras.remove(camHUD, false);
    camChar.bgColor = 0x00000000;
	FlxG.cameras.add(camChar, false);
    FlxG.cameras.add(camBars = new HudCamera(), false);
    camBars.bgColor = 0x00000000;
    FlxG.cameras.add(camHUD, false);
    if(oldVideoResolution) {
	if(FlxG.fullscreen)	FlxG.fullscreen = false;
		Lib.application.window.resizable = false;
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.resizeGame(960, 720);
		FlxG.resizeWindow(960, 720);
		camHUD.width=960;
	}
    Lib.application.window.title = "Computerized Conflict -"+curSong+ "- Composed by: "+curSong.composer;
}
var time:Float=0;
function update(elapsed:Float) {
	time+=elapsed;
    healthDrainLolz(0.09 * elapsed, 0.2, multiplierDrain);
	endingShader.uTime= time;
}

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
function destroy() {
	if(oldVideoResolution){
	Lib.application.window.resizable = true;
	FlxG.scaleMode = new RatioScaleMode(false);
	FlxG.resizeGame(1280, 720);
	FlxG.resizeWindow(1280, 720);
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
