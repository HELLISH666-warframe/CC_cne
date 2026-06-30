import hxvlc.flixel.FlxVideoSprite;
import sys.FileSystem;
public var finishCallback:Void->Void;
var videoName=data.videoName;
public var endingCutscene:Bool = false;
public var isIntro:Bool = false;
public var skipeable:Bool = true;

var video:MP4Handler;

function create() {
	if(FlxG.sound.music!=null)FlxG.sound.music.volume =0;
	//isEnd=data.isEnd;//???_What_does_this_even_DO_bro.
	if (data.finishCallback != null)finishCallback = data.finishCallback;
	skipeable=data.canSkip;

	startVideo(videoName + '-cutscene', skipeable);
}

function startVideo(name:String, ?canSkip:Bool = true) {
	var video = new FlxVideoSprite();
	video.load(Paths.video(videoName));
	add(video).play();
	video.bitmap.onEndReached.add(function(){goToState();});
}

function goToState() {
	switch(videoName) {
		case 'codes':FlxG.switchState(new MessagesState(true));
		case 'alan-unlock':FlxG.switchState(new ModState('FreeplayMenu'));
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		case 'tco_credits':if(!FlxG.save.data.songsUnlocked_seenCredits){
		FlxG.switchState(new TitleState());
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		FlxG.save.data.songsUnlocked_seenCredits=true;
		}else{
			FlxG.switchState(new ModState('tco/FreeplayMenu'));
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		default:LoadingState.loadAndSwitchState(new PlayState());
	}
}