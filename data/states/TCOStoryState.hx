import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import funkin.menus.StoryMenuState;
import flixel.math.FlxMath;
import openfl.Lib;

var scoreText:FlxText;
var weekName:FlxText;
var bgSprite:FlxSprite;
var fires:FlxSprite;
var scrollingThing:FlxBackdrop;
var upperBar:FlxSprite;
var downBar:FlxSprite;
var circleTiles:FlxSprite;
var songsBG:FlxSprite;
var weekImages:FlxSprite;
var diff:String;
var txtTracklist:FlxText;
var sprDifficulty:FlxSprite;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;

public var camGame:FlxCamera;

var selectedSmth:Bool = false;

public static var lastDifficultyName:String = '';
static var curDifficulty:Int = 0;
var outline:FlxSprite;

public static var difficulties:Array<String> =['Simple','Hard','Insane'];

var text:FlxText;

public static var weeks:Array<WeekInfo> = [];

var chapterThingyText:FlxText;

var finishedZoom:Bool = false;

override function create() {
	DiscordUtil.changePresence('In the Story Mode', null);

	weeks =
	[new WeekInfo('week 1', ['Adobe', 'Outrage', 'End Process'], 'Episode 1: Computer Breakdown'),
	new WeekInfo('week 2', ['Adobe', 'Outrage', 'End Process'], 'Episode 1: Computer Breakdown'),
	];

	PlayState.isStoryMode = true;

	Lib.application.window.title = "Computerized Conflict - Story Menu - Theme by: DangDoodle";

	camGame = new FlxCamera();
	FlxG.cameras.reset(camGame);
	FlxCamera.defaultCameras = [camGame];

	FlxG.camera.zoom = 1.5;

	bgSprite = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/week1BG'));
	bgSprite.updateHitbox();
	bgSprite.screenCenter();
	bgSprite.antialiasing = true;
		
	scrollingThing = new FlxBackdrop(Paths.image('menus/storymenu/scroll'), FlxAxes.XY, 0, 0);
	scrollingThing.scrollFactor.set(0, 0.07);
		
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.alpha = 0.85;
		
	circleTiles = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/circlesTiles'));
	circleTiles.updateHitbox();
	circleTiles.screenCenter();
	circleTiles.antialiasing = true;
		
	fires = new FlxSprite();
	fires.frames = Paths.getSparrowAtlas('menus/storymenu/StoryMenuFire');
	fires.animation.addByPrefix('tCoGoesInsane', 'StoryMenuFire', 24, true);
	fires.animation.play('tCoGoesInsane');
	fires.setGraphicSize(Std.int(fires.width * 0.9));
	fires.updateHitbox();
	fires.screenCenter();
	fires.y += 200;
	fires.alpha = 0.0001;
	fires.antialiasing = true;

	spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
		
	upperBar = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/upperBar'));
	upperBar.updateHitbox();
	upperBar.screenCenter();
	upperBar.antialiasing = true;
		
	spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
		
	songsBG = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/songBG'));
	songsBG.updateHitbox();
	songsBG.x = 0;
	songsBG.y = FlxG.height - songsBG.height - 90;
	songsBG.antialiasing = true;

	scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("VCR OSD Mono", 32);

	chapterThingyText = new FlxText(10, 15, 0, weeks[0].desc, 36);
	chapterThingyText.setFormat("VCR OSD Mono", 32);
		
	txtTracklist = new FlxText(FlxG.width * 0.05, songsBG.y + 60, 0, "", 32);
	txtTracklist.alignment = 'center';
	txtTracklist.color = 0xFFe55777;

	txtTracklist.text = 'Tracks:';
	txtTracklist.font = 'Small Print.ttf';
	for (i in 0...weeks[0].songs.length) {
		txtTracklist.text = txtTracklist.text + '\n' + weeks[0].songs[i];
		txtTracklist.updateHitbox();
	}
	//TO DO: FIX THIS
	txtTracklist.y = songsBG.y + (songsBG.height - txtTracklist.height) / 2;
	txtTracklist.x -= 20;
		
	add(bgSprite);
	add(scrollingThing);
	add(circleTiles);
	add(fires);
	add(spikes1);
	add(upperBar);
	add(spikes2);
	add(songsBG);
	add(scoreText);
	add(chapterThingyText);
	add(txtTracklist);

	var difficultyText = new Alphabet(50, 100, 'Difficulty:', false);
	//difficultyText.fontColor = 0xFFFFFFFF;
	//difficultyText.outline = 10;
	//difficultyText.outlineColor = 0xFF000000;
	add(difficultyText);

	//difficultyText.outlineCameras = [camGame];

	sprDifficulty = new FlxSprite(150, 200);
	add(sprDifficulty);

	weekImages = new FlxSprite();
	add(weekImages);

	trace(diff);

	changeDifficulty(0);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function() {
		finishedZoom = true;
	});
}

function update(elapsed:Float) {
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;
		
	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 30, 0, 1)));
	if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
		
	scoreText.text = "WEEK SCORE:" + lerpScore;
	scoreText.screenCenter(FlxAxes.X);
	scoreText.y = FlxG.height - scoreText.height - 15;

	chapterThingyText.x = FlxG.width - chapterThingyText.width - 60;

	if (!selectedSmth && finishedZoom) {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				FlxG.switchState(new ModState('MainMenuState'));
			});
		}
		if (controls.RIGHT_P||controls.LEFT_P){
			changeDifficulty(controls.RIGHT_P ? 1 : -1);
		}
		else if (controls.ACCEPT) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
			{
				playSongs(weeks[0].songs, 0, 0, curDifficulty, true);
			});
		}
	}
}

function changeDifficulty(change:Int = 0, ?stop:Bool = false):Void {
	if(stop) return;
		
	FlxG.sound.play(Paths.sound('scrollMenu'));

	curDifficulty += change;

	if (curDifficulty < 0)
		curDifficulty = difficulties.length-1;
	if (curDifficulty >= difficulties.length)
		curDifficulty = 0;

	var diff:String = difficulties[curDifficulty];

	sprDifficulty.loadGraphic(Paths.image('menus/storymenu/difficult/' +diff));
	sprDifficulty.antialiasing = true;
	sprDifficulty.x = 40;
	sprDifficulty.y = 230;

	weekImages.loadGraphic(Paths.image('menus/storymenu/chapterImages/w1-'+diff));
	weekImages.screenCenter(FlxAxes.Y);
	weekImages.x = FlxG.width - weekImages.width;
	weekImages.antialiasing = true;
	weekImages.setGraphicSize(Std.int(weekImages.width * 0.8));

	switch(curDifficulty) {
		case 0:
			FlxG.cameras.flash(FlxColor.BLACK, 0.50);
			fires.alpha = 0.0001;
			bgSprite.alpha = 1;
			bgSprite.color = FlxColor.WHITE;
			circleTiles.color = FlxColor.WHITE;
			scrollingThing.color = FlxColor.WHITE;
			FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
		case 1:
			FlxG.cameras.flash(FlxColor.WHITE, 0.50);
			fires.alpha = 0.0001;
			bgSprite.alpha = 1;
			bgSprite.color = FlxColor.WHITE;
			circleTiles.color = FlxColor.WHITE;
			scrollingThing.color = FlxColor.WHITE;
		case 2:
		    FlxG.cameras.flash(FlxColor.RED, 0.50);
			fires.alpha = 1;
			bgSprite.color = 0xFF2C2425;
			circleTiles.color = 0xFF2C2425;
			scrollingThing.color = 0xFF2C2425;
	}
		
	lastDifficultyName = diff;

	var weekPlusDiffName:String = weeks[0].name + '-'+difficulties[curDifficulty];
	//var weekScore:Int = CoolUtil.songsUnlocked.data.weeksData.get(weekPlusDiffName);
	var weekScore:Int = 0;

	intendedScore = weekScore;
}
	
var lerpScore:Int = 0;
var intendedScore:Int = 0;

function playSongs(songlist:Array<String>, campaignScore:Int, campaignMisses:Int, difficultyStory:Int, introCutscene:Bool) {
	PlayState.storyPlaylist = songlist;
	PlayState.isStoryMode = true;
	PlayState.vaultSong = false;
	PlayState.storyDifficulty = difficultyStory;

	PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-' + difficulties[difficultyStory], PlayState.storyPlaylist[0].toLowerCase());
	PlayState.campaignScore = campaignScore;
	PlayState.campaignMisses = campaignMisses;
	PlayState.storyWeek = 0;
	PlayState.seenCutscene = false;
	PlayState.weekNames = 'Episode 1: Computer Breakdown';

	if (introCutscene) {
		LoadingState.loadAndSwitchState(new CutsceneState('adobe', true, function() //this is still playing somehow
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			}), true);
	}
	else {
		LoadingState.loadAndSwitchState(new PlayState(), true);
	}

	FreeplayState.destroyFreeplayVocals();
	CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
}

class WeekInfo {
	public var name:String = "";
	public var songs:Array<String> = [];
	public var desc:String = "";

	public function new(name:String, songs:Array<String>, desc:String)
	{
		this.name = name;
		this.songs = songs;
		this.desc = desc;
	}
}