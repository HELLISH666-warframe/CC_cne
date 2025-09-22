import flixel.addons.transition.FlxTransitionableState;
import funkin.menus.StoryMenuState.StoryWeeklist;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import funkin.menus.StoryMenuState;
import flixel.math.FlxMath;

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
//public var camGameShaders:Array<ShaderEffect> = [];
public var camHUD:FlxCamera;

var selectedSmth:Bool = false;

static var lastDifficultyName:String = '';
static var curDifficulty_storymode:Int = 0;
var outline:FlxSprite;
var crtShader = new CustomShader("CRT"); 
public static var difficulties:Array<String> = ['Simple','Hard','Insane'];

var checkpointSystemON:Bool;

var blackThing:FlxSprite;
var text:FlxText;

var chapterThingyText:FlxText;

var finishedZoom:Bool = false;

public var weekList:StoryWeeklist;

static var curWeek:Int = 0;

function create() {
	DiscordUtil.changePresence('In the Story Mode', null);
	
	weeklist = StoryWeeklist.get(true, false);
	trace(weeklist.weeks[1].songs);
	window.title = "Computerized Conflict - Story Menu - Theme by: DangDoodle";

	camGame = new FlxCamera();
	camHUD = new FlxCamera();
	camHUD.bgColor = 0;
	FlxG.cameras.reset(camGame);
	FlxCamera.defaultCameras = [camGame];
	FlxG.cameras.add(camHUD, false);
	checkpointSystemON = FlxG.save.data.checkpoint != null;

	FlxG.camera.zoom = 1.5;
	camHUD.zoom = 1.5;

	bgSprite = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/week1BG'));
	bgSprite.updateHitbox();
	bgSprite.screenCenter();
	bgSprite.antialiasing = Options.antialiasing;

	scrollingThing = new FlxBackdrop(Paths.image('menus/storymenu/scroll'), FlxAxes.XY, 0, 0);
	scrollingThing.scrollFactor.set(0, 0.07);

	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.alpha = 0.85;

	circleTiles = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/circlesTiles'));
	circleTiles.updateHitbox();
	circleTiles.screenCenter();
	circleTiles.antialiasing = Options.antialiasing;

	fires = new FlxSprite();
	fires.frames = Paths.getSparrowAtlas('menus/storymenu/StoryMenuFire');
	fires.animation.addByPrefix('tCoGoesInsane', 'StoryMenuFire', 24, true);
	fires.animation.play('tCoGoesInsane');
	fires.setGraphicSize(Std.int(fires.width * 0.9));
	fires.updateHitbox();
	fires.screenCenter();
	fires.y += 200;
	fires.alpha = 0.0001;
	fires.antialiasing = Options.antialiasing;

	spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;

	upperBar = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/upperBar'));
	upperBar.updateHitbox();
	upperBar.screenCenter();
	upperBar.antialiasing = Options.antialiasing;

	spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);

	songsBG = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/songBG'));
	songsBG.updateHitbox();
	songsBG.x = 0;
	songsBG.y = FlxG.height - songsBG.height - 90;
	songsBG.antialiasing = Options.antialiasing;

	scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("VCR OSD Mono", 32);

	chapterThingyText = new FlxText(10, 15, 0, weeklist.weeks[curWeek].name, 36);
	chapterThingyText.setFormat("VCR OSD Mono", 32);

	txtTracklist = new FlxText(FlxG.width * 0.05, songsBG.y + 60, 0, "", 32);
	txtTracklist.alignment = 'center';
	txtTracklist.color = 0xFFe55777;

	txtTracklist.text = 'Tracks:';
	txtTracklist.font = Paths.font("Small Print.ttf");

	for (i in weeklist.weeks[curWeek].songs) {
		txtTracklist.text = txtTracklist.text + '\n' + i.name;
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

	changeDifficulty(0);
	changeWeek(0);

	if(FlxG.save.data.crt_cc){FlxG.camera.addShader(crtShader);
	camHUD.addShader(crtShader);
	}

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxTween.tween(camHUD, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	camHUD.fade(FlxColor.BLACK, 0.8, true, function() {
		finishedZoom = true;
	});
}

function update(elapsed:Float) {
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;

	scoreText.text = "WEEK SCORE:" + "Placeholderegb";
	scoreText.screenCenter(FlxAxes.X);
	scoreText.y = FlxG.height - scoreText.height - 15;

	chapterThingyText.x = FlxG.width - chapterThingyText.width - 60;

	if (!selectedSmth && finishedZoom) {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxTween.tween(camHUD, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			camHUD.fade(FlxColor.BLACK, 0.8, false, function() {
				FlxG.switchState(new ModState('tco/MainMenuState'));
			});
		}
		if (controls.UP_P||controls.DOWN_P){
			changeWeek(controls.DOWN_P ? 1 : -1);
		}
		else if (controls.RIGHT_P) {
			changeDifficulty(1, checkpointSystemON);
		}
		else if (controls.LEFT_P) {
			changeDifficulty(-1, checkpointSystemON);
		}
		else if (controls.ACCEPT) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(FlxG.camera, {zoom: 3}, 1, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				play();
			});
		}
	}
}

function changeDifficulty(change:Int = 0, ?stop:Bool = false):Void {
	if(stop) return;
		
	FlxG.sound.play(Paths.sound('scrollMenu'));

	curDifficulty_storymode += change;

	if (curDifficulty_storymode < 0) curDifficulty_storymode = difficulties.length-1;
	if (curDifficulty_storymode >= difficulties.length) curDifficulty_storymode = 0;

	var diff:String = difficulties[curDifficulty_storymode];

	sprDifficulty.loadGraphic(Paths.image('menus/storymenu/difficulties/'+diff));
	sprDifficulty.antialiasing = Options.antialiasing;
	sprDifficulty.x = 40;
	sprDifficulty.y = 230;

	weekImages.loadGraphic(Paths.image('menus/storymenu/chapterImages/'+curWeek+"-"+curDifficulty_storymode));
	weekImages.screenCenter(FlxAxes.Y);
	weekImages.x = FlxG.width - weekImages.width;
	weekImages.antialiasing = Options.antialiasing;
	weekImages.setGraphicSize(Std.int(weekImages.width * 0.8));

	switch(curDifficulty_storymode) {
		case 0: FlxG.cameras.flash(FlxColor.BLACK, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = FlxColor.WHITE;
		circleTiles.color = FlxColor.WHITE;
		scrollingThing.color = FlxColor.WHITE;
		FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
		case 1: FlxG.cameras.flash(FlxColor.WHITE, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = FlxColor.WHITE;
		circleTiles.color = FlxColor.WHITE;
		scrollingThing.color = FlxColor.WHITE;
		case 2: FlxG.cameras.flash(FlxColor.RED, 0.50);
		fires.alpha = 1;
		bgSprite.color = 0xFF2C2425;
		circleTiles.color = 0xFF2C2425;
		scrollingThing.color = 0xFF2C2425;
	}
	lastDifficultyName = diff;
}

function changeWeek(change:Int = 0, ?stop:Bool = false):Void {
	if(stop) return;

	curWeek += change;

	if (curWeek < 0) curWeek = weeklist.weeks.length-1;
	if (curWeek >= weeklist.weeks.length) curWeek = 0;

	weekImages.loadGraphic(Paths.image('menus/storymenu/chapterImages/'+curWeek+"-"+curDifficulty_storymode));
	weekImages.screenCenter(FlxAxes.Y);
	weekImages.x = FlxG.width - weekImages.width;
	weekImages.antialiasing = Options.antialiasing;
	weekImages.setGraphicSize(Std.int(weekImages.width * 0.8));
	txtTracklist.text="";
	for (i in weeklist.weeks[curWeek].songs) {
		txtTracklist.text = txtTracklist.text + '\n' + i.name;
		txtTracklist.updateHitbox();
	}
	chapterThingyText.text = weeklist.weeks[curWeek].name;
}

function play() {
	PlayState.loadWeek(weeklist.weeks[curWeek], difficulties[curDifficulty_storymode]);
	FlxG.switchState(new PlayState());
}