import haxe.io.Path;

function new() {   
    for (i in Paths.getFolderContent('data/global')) importScript("data/global/"+Path.withoutExtension(i)); //import different global scripts for organization reasons
}
public static function getTheOs() {
	#if windows return ''; #else return '-unix';
}

function update() {
    if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.H)
        FlxG.switchState(new ModState('Psych/FlashingState'));
}

public static var minimizeWindowArray:Array<String> = ['dashpulse','messenger','rombie','powerup'];
function preStateSwitch() {
    if ((FlxG.width != 1280 || FlxG.height != 720) && !Std.isOfType(FlxG.game._requestedState, PlayState)){
        FlxG.resizeWindow(1280, 720);
        FlxG.resizeGame(1280, 720);
	    FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = 1280;
    }
    if (Std.isOfType(FlxG.game._requestedState, PlayState)){
        if(minimizeWindowArray.contains(PlayState.SONG.meta.displayName.toLowerCase()) && !FlxG.save.data.wideScreenSongs&&FlxG.width!=960) {
        FlxG.resizeWindow(960, 720);
		FlxG.scaleMode.width = FlxG.width = FlxG.initialWidth = 960;
        //PlayState.scripts.set('oldVideoResolution',true);
	}
    }
}

function destroy(){
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.visible = false;
}