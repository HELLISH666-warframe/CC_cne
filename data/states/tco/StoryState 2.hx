import funkin.menus.StoryMenuState.StoryWeeklist;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import cc.FlxSpriteExtra;
import Shaders;

var scoreText:FlxText;
var bgSprite:FlxSprite;
var fires:FlxSprite;
var scrollingThing:FlxBackdrop;
var upperBar:FlxSprite;
var circleTiles:FlxSprite;
var songsBG:FlxSprite;
var weekImages:FlxSprite;
var diff:String;
var txtTracklist:FlxText;
var sprDifficulty:FlxSprite;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;

public var camGame:FlxCamera;
public var camGameShaders:Array<ShaderEffect> = [];
public var camHUD:FlxCamera;

var selectedSmth:Bool = false;

public static var curDiffSM:Int = 0;
public static var crtShader = new CRTShader();
var shaderFilter = new ShaderFilter(crtShader);

public static var difficulties:Array<String> =['Simple','Hard','Insane'];

var checkpointSystemON:Bool;

var blackThing:FlxSpriteExtra;
var text:FlxText;

public static var weeks:Array<WeekInfo> = [];

var chapterThingyText:FlxText;

var finishedZoom:Bool = false;

function create() {
	DiscordUtil.changePresenceSince("In the Story Mode", null);

	weeks =[new WeekInfo('week 1', ['Adobe', 'Outrage', 'End Process'], 'Episode 1: Computer Breakdown')];

	PlayState.isStoryMode = true;

	window.title = "Computerized Conflict - Story Menu - Theme by: DangDoodle";

	camGame = new FlxCamera();
	camHUD = new FlxCamera();
	camHUD.bgColor.alpha = 0;
	FlxG.cameras.reset(camGame);
	FlxCamera.defaultCameras = [camGame];
	FlxG.cameras.add(camHUD, false);

	checkpointSystemON = FlxG.save.data.checkpoint != null;
	trace(checkpointSystemON);
	trace(FlxG.save.data.checkpoint);

	FlxG.camera.zoom = 1.5;
	camHUD.zoom = 1.5;

	bgSprite = new FlxSprite().loadGraphic(Paths.image('storymenu/week1BG'));
	bgSprite.updateHitbox();
	bgSprite.screenCenter();
	bgSprite.antialiasing = Options.antialiasing;
		
	scrollingThing = new FlxBackdrop(Paths.image('storymenu/scroll'),FlxAxes.XY);
	scrollingThing.scrollFactor.set(0, 0.07);
		
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.alpha = 0.85;
		
	circleTiles = new FlxSprite().loadGraphic(Paths.image('storymenu/circlesTiles'));
	circleTiles.updateHitbox();
	circleTiles.screenCenter();
	circleTiles.antialiasing = Options.antialiasing;
		
	fires = new FlxSprite();
	fires.frames = Paths.getSparrowAtlas('storymenu/StoryMenuFire');
	fires.animation.addByPrefix('tCoGoesInsane', 'StoryMenuFire', 24, true);
	fires.animation.play('tCoGoesInsane');
	fires.setGraphicSize(Std.int(fires.width * 0.9));
	fires.updateHitbox();
	fires.screenCenter();
	fires.y += 200;
	fires.alpha = 0.0001;
	fires.antialiasing = Options.antialiasing;

	spikes1 = new FlxBackdrop(Paths.image('mainmenu/spikes'),FlxAxes.X);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
		
	upperBar = new FlxSprite().loadGraphic(Paths.image('storymenu/upperBar'));
	upperBar.updateHitbox();
	upperBar.screenCenter();
	upperBar.antialiasing = Options.antialiasing;
		
	spikes2 = new FlxBackdrop(Paths.image('mainmenu/spikes'),FlxAxes.X);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
		
	songsBG = new FlxSprite().loadGraphic(Paths.image('storymenu/songBG'));
	songsBG.updateHitbox();
	songsBG.x = 0;
	songsBG.y = FlxG.height - songsBG.height - 90;
	songsBG.antialiasing = Options.antialiasing;

	scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("VCR OSD Mono", 32);

	chapterThingyText = new FlxText(10, 15, 0, weeks[0].desc, 36);
	chapterThingyText.setFormat("VCR OSD Mono", 32);
		
	txtTracklist = new FlxText(FlxG.width * 0.05, songsBG.y + 60, 0, "", 32);
	txtTracklist.alignment = CENTER;
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
	difficultyText.fontColor = 0xFFFFFFFF;
	difficultyText.outline = 10;
	difficultyText.outlineColor = 0xFF000000;
	add(difficultyText);

	difficultyText.outlineCameras = [camGame];

	sprDifficulty = new FlxSprite(150, 200);
	add(sprDifficulty);

	weekImages = new FlxSprite();
	add(weekImages);
		
	if (checkpointSystemON) {
		blackThing = new FlxSpriteExtra().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackThing.alpha = 0.7;
		blackThing.screenCenter();
		blackThing.camera = camHUD;
		add(blackThing);
			
		text = new FlxText(0, 250, FlxG.width, 'Looks like you left the game before,\nbut your progress has been saved.
		\n\nWould you like to continue?\n\nENTER - Yes.\nESC - No.');
		text.setFormat(Paths.font("phantommuff.ttf"), 48, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		text.camera = camHUD;
		text.screenCenter();
		add(text);
	}

	changeDifficulty(0);

	if (FlxG.save.data.shaders) FlxG.camera.setFilters([shaderFilter]);
	if (FlxG.save.data.shaders) camHUD.setFilters([shaderFilter]);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxTween.tween(camHUD, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	camHUD.fade(FlxColor.BLACK, 0.8, true, function(){finishedZoom = true;});
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
			if (!checkpointSystemON){
				FlxG.sound.play(Paths.sound('cancelMenu'));

				FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
				FlxTween.tween(camHUD, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
				camHUD.fade(FlxColor.BLACK, 0.8, false, ()->{FlxG.switchState(new MainMenuState());});
			}else{checkpointSystemON = false;
				FlxG.save.data.checkpoint = null;
				FlxG.save.flush();
					
				FlxTween.tween(blackThing, {alpha: 0}, 1, {ease: FlxEase.cubeInOut,onComplete: ()->{remove(blackThing); blackThing.destroy();}});

				FlxTween.tween(text, {alpha: 0}, 1, {ease: FlxEase.cubeInOut,onComplete: ()->{remove(text); text.destroy();}});
			}
		}
		else if (controls.RIGHT_P||controls.LEFT_P) changeDifficulty(controls.RIGHT_P?1:-1, checkpointSystemON);
		else if (controls.ACCEPT) {
			selectedSmth = true;
			if (!checkpointSystemON){
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {playSongs(weeks[0].songs, 0, 0, curDiffSM, true);});
			}else{
				checkpointSystemON = false;

				curDiffSM = FlxG.save.data.checkpoint.difficulty;
				playSongs(FlxG.save.data.checkpoint.playlist, FlxG.save.data.checkpoint.campaignScore, FlxG.save.data.checkpoint.campaignMisses, FlxG.save.data.checkpoint.difficulty, false);
			}
		}
	}
}

function changeDifficulty(change:Int = 0, ?stop:Bool = false) {
	stop??=false;
	if(stop) return;
	FlxG.sound.play(Paths.sound('scrollMenu'));

	curDiffSM = FlxMath.wrap(curDiffSM + change, 0, difficulties.length - 1);

	var diff:String = difficulties[curDiffSM];

	sprDifficulty.loadGraphic(Paths.image('storymenu/difficult/${diff}'));
	sprDifficulty.antialiasing = Options.antialiasing;
	sprDifficulty.x = 40;
	sprDifficulty.y = 230;

	weekImages.loadGraphic(Paths.image('storymenu/chapterImages/w1-${diff}'));
	weekImages.screenCenter(FlxAxes.Y);
	weekImages.x = FlxG.width - weekImages.width;
	weekImages.antialiasing = Options.antialiasing;
	weekImages.setGraphicSize(Std.int(weekImages.width * 0.8));

	switch(curDiffSM) {
		case 0:FlxG.cameras.flash(FlxColor.BLACK, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = FlxColor.WHITE;
		circleTiles.color = FlxColor.WHITE;
		scrollingThing.color = FlxColor.WHITE;
		FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
		case 1:FlxG.cameras.flash(FlxColor.WHITE, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = FlxColor.WHITE;
		circleTiles.color = FlxColor.WHITE;
		scrollingThing.color = FlxColor.WHITE;
		case 2:FlxG.cameras.flash(FlxColor.RED, 0.50);
		fires.alpha = 1;
		bgSprite.color = 0xFF2C2425;
		circleTiles.color = 0xFF2C2425;
		scrollingThing.color = 0xFF2C2425;
	}

	var weekPlusDiffName:String = weeks[0].name + '-${difficulties[curDiffSM]}';
	var weekScore:Int = CoolUtil.songsUnlocked.data.weeksData.get(weekPlusDiffName);

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
	} else LoadingState.loadAndSwitchState(new PlayState(), true);

	FreeplayState.destroyFreeplayVocals();
	CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
}

class WeekInfo {
	public var name:String = "";
	public var songs:Array<String> = [];
	public var desc:String = "";

	public function new(name:String, songs:Array<String>, desc:String) {
		this.name = name;
		this.songs = songs;
		this.desc = desc;
	}
}