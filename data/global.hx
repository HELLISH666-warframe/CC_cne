//
import funkin.menus.TitleState;
import openfl.Lib;
import lime.app.Application;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;

function new()
{   
    if (FlxG.save.data.songsUnlocked_seenCredits == null) FlxG.save.data.songsUnlocked_seenCredits = false;
    if (FlxG.save.data.songsUnlocked_mainWeek == null) FlxG.save.data.songsUnlocked_mainWeek = false;
    if (FlxG.save.data.screenShake_cc == null) FlxG.save.data.screenShake_cc = true;
    if (FlxG.save.data.flashing_cc == null) FlxG.save.data.flashing_cc = true;
    if (FlxG.save.data.noMechanics_cc == null) FlxG.save.data.noMechanics_cc = true;
}
function update(elapsed:Float){
if (FlxG.keys.justPressed.F5) FlxG.resetState();
if (FlxG.keys.justPressed.F6){
    Lib.application.window.resizable = true;
		FlxG.scaleMode = new RatioScaleMode(false);
		FlxG.resizeGame(1280, 720);
		FlxG.resizeWindow(1280, 720);
		FlxG.camera.width = 1280;
		FlxG.camera.height = 720;
}
if (FlxG.keys.justPressed.EIGHT) FlxG.resetState();
}

var redirectStates:Map<FlxState, String> = [
    MainMenuState => "MainMenuState", 
TitleState => "TitleState"
];

function preStateSwitch() {
for (redirectState in redirectStates.keys())
if (FlxG.game._requestedState is redirectState)
FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}