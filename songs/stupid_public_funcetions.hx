import openfl.Lib;
import lime.app.Application;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
public var stopTweens:Array<FlxTween> = [];
public function colorTween(object:Array<FlxSprite>, duration:Float, colorToSayGoodbye:FlxColor, colorToSayHello:FlxColor)
{
	for (i in 0...object.length) {
		var newTweenColor = FlxTween.color(object[i], duration, colorToSayGoodbye, colorToSayHello);

		stopTweens.push(newTweenColor);
	}
}

public var camChar = new FlxCamera();
public var camBars:HudCamera;
public var camOther:HudCamera;

public var vignetteTrojan:FlxSprite; //USED IN TROJAN AND OTHER COOL SONGS

function postCreate() {
    FlxG.cameras.add(camOther = new HudCamera(), false);
    camOther.bgColor = 0x00000000;
    add(vignetteTrojan);
}

public var bestPart2:Bool = false; //VIGNETTES HANDLER

public var noCurLight:Bool = false;

public var lightsColors:Array<FlxColor>; //for the vignette changing color

function beatHit(curBeat:Int) {
    if (curBeat % 1 == 0 && bestPart2)
	{
		vignetteTrojan.alpha = 1;
		FlxTween.tween(vignetteTrojan, {alpha:0}, 0.2, {ease: FlxEase.quadInOut});

		if (curSong == 'trojan')
		{
			coolShit.alpha = 1;
			FlxTween.tween(coolShit, {alpha:0}, Conductor.crochet * 5, {ease: FlxEase.sineIn});
		}
	}
    if (bestPart2 && curBeat % 1 == 0 && !noCurLight)
	{
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

public function healthDrainLolz(drain:Float, min:Float, mult:Float)
{
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

function update(elapsed:Float) {
    healthDrainLolz(0.09 * elapsed, 0.2, multiplierDrain);
}

public var zoomType1:Bool = false;
public var zoomType2:Bool = false;
public var zoomType3:Bool = false;

public function zoomtype(number:String) {
    switch(number){
		case '0': zoomType1 = !zoomType1;
		trace("zoomType1");
		case '1': zoomType2 = !zoomType2;
		trace("zoomType2");
		case '2': zoomType3 = !zoomType3;
		trace("zoomType3");
	}
}
function onSongEnd(){
	if(oldVideoResolution) {
	oldVideoResolution=false;
	Lib.application.window.resizable = true;
	FlxG.scaleMode = new RatioScaleMode(false);
	FlxG.resizeGame(1280, 720);
	FlxG.resizeWindow(1280, 720);
	}
}
