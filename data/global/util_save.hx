public static var ccSSC;

function new() {   
    FlxG.save.data.Computerized_Conflict_Save??={};
    ccSSC=FlxG.save.data.Computerized_Conflict_Save;

    ccSSC.arrowHSV??=[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
    ccSSC.framerate??=60;
    ccSSC.globalAntialiasing??=true;
    ccSSC.songsUnlocked_mainWeek ??= false;
    ccSSC.songsUnlocked_seenCredits ??= false;
    ccSSC.songsUnlocked ??= [];
    ccSSC.checkpoint_cc = null;
    ccSSC.crt_cc ??= true;
    ccSSC.alanUnlocked ??= false;
    ccSSC.code_songs_cc ??= [];//GUARANTEE this won't be needed later.
    ccSSC.shaders ??= true;
    ccSSC.advancedShaders ??= true;
    ccSSC.noteSplashes ??= true;
    ccSSC.hideHud??=false;
    ccSSC.timeBarType ??= "Time Left";
    ccSSC.screenShake ??= true;
    ccSSC.camZooms??=true;
    ccSSC.scoreZoom??=true;
    ccSSC.healthBarAlpha??=1;
    ccSSC.comboStacking??=false;
    ccSSC.lagText??=true;
    ccSSC.showFPS??=true;
    ccSSC.showExtraInfo??=false;
    ccSSC.cameraMovement??=true;
    ccSSC.wideScreenSongs ??= false;
    ccSSC.controllerMode??=false;
    ccSSC.downScroll??=false;
    ccSSC.middleScroll??=false;
    ccSSC.noMechanics??=false;
    ccSSC.judCounter??=false;
    ccSSC.laneunderlay??=true;
    ccSSC.laneTransparency??=0;
    ccSSC.ghostTapping??=true;
    ccSSC.opponentStrums??=true;
    ccSSC.noReset??=false;
    ccSSC.hitsoundVolume??=0;
    ccSSC.ratingOffset??=0;
    ccSSC.sickWindow??=45;
    ccSSC.goodWindow??=90;
    ccSSC.badWindow??=135;
    ccSSC.safeFrames??=10;
    ccSSC.gameplaySettings??=[
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

    ccSSC.autoPause??=true;
    ccSSC.songOffset??=0;
    ccSSC.streamedMusic??=true;
    ccSSC.streamedVocals??=true;
    ccSSC.gpuOnlyBitmaps??=false;

    saveMyShit();
    trace(ccSSC);
}

function preStateSwitch() {
    saveMyShit();
}

public static function saveMyShit() {
    Options.antialiasing=ccSSC.globalAntialiasing;
    Options.lowMemoryMode=ccSSC.lowQuality;
    Options.framerate=ccSSC.framerate;
    if (FlxG.updateFramerate < Options.framerate) FlxG.drawFramerate = FlxG.updateFramerate = Options.framerate;
	else FlxG.updateFramerate = FlxG.drawFramerate = Options.framerate;
    Options.splashesEnabled=ccSSC.noteSplashes;
    Options.flashingMenu=ccSSC.flashing;
    Options.camZoomOnBeat=ccSSC.camZooms;
    Options.downscroll=ccSSC.downScroll;
    Options.ghostTapping=ccSSC.ghostTapping;

    Options.autoPause=ccSSC.autoPause;
    FlxG.autoPause = Options.autoPause;
    Options.songOffset=ccSSC.songOffset;
    Options.streamedMusic=ccSSC.streamedMusic;
    Options.streamedVocals=ccSSC.streamedVocals;
    Options.gpuOnlyBitmaps=ccSSC.gpuOnlyBitmaps;

    FlxG.save.flush();
    trace(ccSSC.flashing);
}