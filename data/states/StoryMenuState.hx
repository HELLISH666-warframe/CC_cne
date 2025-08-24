import flixel.addons.display.FlxBackdrop;
import Alphabet_hopfully_working;

var bgSprite:FlxSprite;
var fires = new FlxSprite();
var scrollingThing:FlxBackdrop;
var upperBar:FlxSprite;
var downBar:FlxSprite;
var circleTiles:FlxSprite;
var songsBG:FlxSprite;
var weekImages:FlxSprite;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;
var chris_pratt_is_so_cool:FlxSprite;

var finishedZoom:Bool = false;
function create() {
	FlxG.camera.zoom = 1.5;
	//camHUD.zoom = 1.5;
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
}
function postCreate() {
	for(e in difficultySprites)e.x = 40;
	insert(7,bgSprite);
	insert(8,scrollingThing);
	insert(9,circleTiles);
	insert(10,fires);
	insert(11,spikes1);
	insert(12,upperBar);
	insert(13,spikes2);
	insert(14,songsBG);
	scoreText = new FlxText(10, FlxG.height - scoreText.height - 15, 0, "SCORE: 49324858", 36);
	scoreText.setFormat("VCR OSD Mono", 32);
	tracklist.color = 0xFFe55777;
	tracklist.setFormat(Paths.font("Small Print.ttf"),32,0xFFe55777,'center');

	insert(15,scoreText);
	insert(16,tracklist);
	remove(weekTitle);
	insert(17,weekTitle);
	chris_pratt_is_so_cool = new FlxSprite().loadGraphic(Paths.image('menus/storymenu/chapterImages/'+ curWeek + "-"+curDifficulty));
	chris_pratt_is_so_cool.screenCenter(FlxAxes.Y);
	chris_pratt_is_so_cool.setGraphicSize(Std.int(chris_pratt_is_so_cool.width * 0.8));
	chris_pratt_is_so_cool.x = FlxG.width - chris_pratt_is_so_cool.width;
	insert(18,chris_pratt_is_so_cool);

	tracklist.y = songsBG.y + (songsBG.height - tracklist.height) / 2;
	tracklist.x -= 50;

	var outline:FlxSprite;

	var difficultyText = new Alphabet_hopfully_working(50, 100, 'Difficulty:', false);
	difficultyText.fontColor = 0xFFFFFFFF;
	difficultyText.outline = 10;
	/*difficultyText.outlineColor = 0xFF000000;*/
	insert(19,difficultyText);

	weekImages = new FlxSprite();
	add(weekImages);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	/*FlxTween.tween(camHUD, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	camHUD.fade(FlxColor.BLACK, 0.8, true, function()
	{
		finishedZoom = true;
	});*/
}

function update(elapsed:Float) {
	for(e in difficultySprites) e.y = 200;
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;
	spikes1.x = spikes2.x -= 0.45 * 60 * elapsed;

	scoreText.screenCenter(FlxAxes.X);
}
//I'm_lazy_and_doing_it_like_this_WHY_NOT.
function shadering(){
	switch(curWeek+"-"+curDifficulty) {
		case '0-0':
		FlxG.cameras.flash(FlxColor.BLACK, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = circleTiles.color = scrollingThing.color = FlxColor.WHITE;
		FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
		case '0-1':
		FlxG.cameras.flash(FlxColor.WHITE, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = circleTiles.color = scrollingThing.color = FlxColor.WHITE;
		case '0-2':
		FlxG.cameras.flash(FlxColor.RED, 0.50);
		fires.alpha = 1;
		bgSprite.color = circleTiles.color = scrollingThing.color = 0xFF2C2425;
		default:
		FlxG.cameras.flash(FlxColor.BLACK, 0.50);
		fires.alpha = 0.0001;
		bgSprite.alpha = 1;
		bgSprite.color = circleTiles.color = scrollingThing.color = FlxColor.WHITE;
		FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
	}
}
function onChangeDifficulty(event){
	//Need_to_have_it_in_a_tween_or_it_will_be_one_off....GRRR.
	FlxTween.tween(weekTitle, {y: weekTitle.y + 0}, 0.00001, {onComplete: function(twn:FlxTween) {
		shadering();
		chris_pratt_is_so_cool.loadGraphic(Paths.image('menus/storymenu/chapterImages/'+ curWeek + "-"+curDifficulty));
	}});
}
function changeWeek(event){
	shadering();
}