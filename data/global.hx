import haxe.io.Path;

function new() {   
    FlxG.save.data.songsUnlocked_mainWeek ??= false;
    FlxG.save.data.songsUnlocked_seenCredits ??= false;
    FlxG.save.data.songsUnlocked ??= [];
    FlxG.save.data.checkpoint_cc = null;
    FlxG.save.data.crt_cc ??= true;
    FlxG.save.data.alanUnlocked ??= false;
    FlxG.save.data.code_songs_cc ??= [];//GUARANTEE this won't be needed later.
    FlxG.save.data.shaders ??= true;
    FlxG.save.data.advancedShaders ??= true;
    FlxG.save.data.noteSplashes ??= true;
    FlxG.save.data.hideHud??=false;
    FlxG.save.data.timeBarType ??= "Disabled";
    FlxG.save.data.flashing??=true;
    FlxG.save.data.screenShake ??= true;
    FlxG.save.data.camZooms??=true;
    FlxG.save.data.scoreZoom??=true;
    FlxG.save.data.healthBarAlpha??=1;
    FlxG.save.data.comboStacking??=false;
    FlxG.save.data.lagText??=true;
    FlxG.save.data.showFPS??=true;
    FlxG.save.data.showExtraInfo??=false;
    FlxG.save.data.cameraMovement??=true;
    FlxG.save.data.wideScreenSongs ??= false;
    FlxG.save.data.controllerMode??=false;
    FlxG.save.data.downScroll??=false;
    FlxG.save.data.middleScroll??=false;
    FlxG.save.data.noMechanics??=false;
    FlxG.save.data.judCounter??=false;
    FlxG.save.data.laneunderlay??=true;
    FlxG.save.data.laneTransparency??=0;
    FlxG.save.data.ghostTapping??=true;
    FlxG.save.data.opponentStrums??=true;
    FlxG.save.data.noReset??=false;
    FlxG.save.data.hitsoundVolume??=0;
    FlxG.save.data.ratingOffset??=0;
    FlxG.save.data.sickWindow??=45;
    FlxG.save.data.goodWindow??=90;
    FlxG.save.data.badWindow??=135;
    FlxG.save.data.safeFrames??=10;
    FlxG.save.data.gameplaySettings??=[
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];
    for (i in Paths.getFolderContent('data/global')) importScript("data/global/"+Path.withoutExtension(i)); //import different global scripts for organization reasons
}
public static function getTheOs() {
	#if windows return ''; #else return '-unix';
}

function update() {
    if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.H)
        FlxG.switchState(new ModState('Psych/options/OptionsState',{"exitState":(_) ->  FlxG.switchState(new TitleState())}));
        //FlxG.switchState(new ModState('tco/credits_test',{"videoName": 'tco_credits',"canSkip":false}));
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