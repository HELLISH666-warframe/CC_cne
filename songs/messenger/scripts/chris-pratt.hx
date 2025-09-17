import openfl.Lib;
import lime.app.Application;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
function create() {
	oldVideoResolution=true;
}

function destroy() {
	Lib.application.window.resizable = true;
	FlxG.scaleMode = new RatioScaleMode(false);
	FlxG.resizeGame(1280, 720);
	FlxG.resizeWindow(1280, 720);
	FlxG.camera.width = 1280;
	FlxG.camera.height = 720;
	
}