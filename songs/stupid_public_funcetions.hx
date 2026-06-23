import openfl.Lib;
import lime.app.Application;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.text.FlxTypeText;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;

public var chromaticAberration = new CustomShader("ChromaticAberrationShader");
public var endingShader = new CustomShader("Glitch02Shader");

public var num1:Int=4;
public var num2:Int=3;

function postCreate() {
	endingShader.data.iMouseX.value=[num1];
	endingShader.data.NUM_SAMPLES.value=[num2];
	endingShader.data.glitchMultiply.value=[num2];
}

public static var oldVideoResolution:Bool = false; 
function create() {
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