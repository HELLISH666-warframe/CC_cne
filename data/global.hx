import haxe.io.Path;
function new() {   
    FlxG.save.data.songsUnlocked_mainWeek ??= false;
    FlxG.save.data.songsUnlocked_seenCredits ??= false;
    FlxG.save.data.screenShake_cc ??= true;
    FlxG.save.data.flashing_cc ??= true;
    FlxG.save.data.noMechanics_cc ??= true;
    FlxG.save.data.songsUnlocked ??= [];
    FlxG.save.data.checkpoint_cc = null;
    FlxG.save.data.crt_cc ??= true;
    FlxG.save.data.alanUnlocked ??= false;
    FlxG.save.data.code_songs_cc ??= [];//GUARANTEE this won't be needed later.
    FlxG.save.data.shaders ??= true;
    FlxG.save.data.wideScreenSongs ??= false;
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
    FlxG.save.data.hideHud??=false;
    FlxG.save.data.healthBarAlpha??=1;
    FlxG.save.data.TimeBar ??= "Disabled";
    for (i in Paths.getFolderContent('data/global')) importScript("data/global/"+Path.withoutExtension(i)); //import different global scripts for organization reasons
}

public static function mouseShit(pa:String,?size:Float=1,?offsets=[0,0]){   
    size??=1;offsets??=[0,0];
    // STUPID ASS HSCRIPT DOESNT LET ME ADD DEFAULT PARAMETERS. FUK.//Thanks PJ Party for letting me know.
    FlxG.mouse.useSystemCursor = false;
    FlxG.mouse.load(Assets.getBitmapData(Paths.image(pa)),size,offsets[0],offsets[1]);
}

function destroy(){
    FlxG.mouse.useSystemCursor = true;
    FlxG.mouse.visible = false;
}