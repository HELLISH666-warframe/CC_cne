import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import sys.FileSystem;
import openfl.Lib;

public var image = new FlxSprite();
public var coolArtistArray:Array<String> = [];
public var actualNum = 0;

var selectedSmth:Bool = false;
var firstImage:Float = 0;
var textArtists:FlxText;
var scrollingThing = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'), FlxAxes.XY, 0, 0);
var downBar = new FlxSprite(0, 794).loadGraphic(Paths.image('menus/FAMenu/downBar'));
var textSquare = new FlxSprite(250, 0).loadGraphic(Paths.image('menus/FAMenu/squaretext'));
var menuText = new FlxSprite(0,-150).loadGraphic(Paths.image('menus/FAMenu/art-gallery-bar'));
var arrow = new FlxSprite(815, 250);
var flippedArrow = new FlxSprite(-15, 250);
var coolDown:Bool = true;

var totalMap:Map<String, Int> = [];

function create() {
	DiscordUtil.changePresence('In the Art Gallery', null);

	Lib.application.window.title = "Computerized Conflict - Art Gallery Menu - Theme by: DangDoodle";

	var thing:Array<String> = FileSystem.readDirectory(Assets.getPath('assets/images/menus/fan-arts/ingame-fanart'));
	for (i in 0...thing.length){
		coolArtistArray.push(thing[i]);
	}

	FlxG.camera.zoom = 2;

	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.antialiasing = true;
	add(scrollingThing);

	vignette = new FlxSprite().loadGraphic(Paths.image('menus/FAMenu/vignette'));
	vignette.scrollFactor.set();
	vignette.antialiasing = true;
	add(vignette);

	vignette2 = new FlxSprite().loadGraphic(Paths.image('menus/FAMenu/vig2'));
	vignette2.scrollFactor.set();
	vignette2.antialiasing = true;
	add(vignette2);

	downBar.scrollFactor.set();
	downBar.antialiasing = true;
	downBar.alpha = 0.00001;
	add(downBar);

	textSquare.scrollFactor.set();
	textSquare.antialiasing = true;
	textSquare.alpha = 0.000001;
	add(textSquare);

	menuText.scrollFactor.set();
	menuText.antialiasing = true;
	menuText.alpha = 0.00001;
	add(menuText);

	image.antialiasing = true;
	add(image);

	bgText = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/FAMenu/artist-text-BG'));
	bgText.scrollFactor.set();
	bgText.antialiasing = true;
	add(bgText);

	textArtists = new FlxText(45, 30, 0, 'null', 46);
	textArtists.setFormat(Paths.font("phantommuff.ttf"), 46, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textArtists.scrollFactor.set();
	textArtists.antialiasing = true;
	add(textArtists);

	arrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	arrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	arrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	arrow.setGraphicSize(Std.int(arrow.width * 0.55));
	arrow.scrollFactor.set();
	arrow.antialiasing = true;
	add(arrow);

	flippedArrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	flippedArrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	flippedArrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	flippedArrow.setGraphicSize(Std.int(flippedArrow.width * 0.55));
	flippedArrow.scrollFactor.set();
	flippedArrow.flipX = true;
	flippedArrow.antialiasing = true;
	add(flippedArrow);

	FlxG.mouse.visible = true;
	FlxG.mouse.unload();
	FlxG.mouse.load(Paths.image("EProcess/alt", 'chapter1').bitmap, 1.5, 0);
	//@:privateAccess FlxG.mouse._cursor.smoothing = true;

	FlxTween.tween(menuText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(menuText, {y: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(downBar, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(downBar, {y: 644}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(textSquare, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(textSquare, {x: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

	var i:Int = 0;
	for(artist in coolArtistArray) {
		// TODO: Fixing this like what
		var total = FileSystem.readDirectory(Assets.getPath('assets/images/menus/fan-arts/ingame-fanart/' + coolArtistArray[i] + '/')).length;
		totalMap[artist] = total;
		trace(total);
		i++;
	}

	changeImage(0);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.9, true, function() {coolDown = false;});
}
function update(elapsed:Float) {
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	if (!selectedSmth && !coolDown) {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				FlxG.switchState(new ModState('MainMenuState'));
			});
			goodBye();
			selectedSmth = true;
		}
		if (controls.RIGHT_P||controls.LEFT_P){
			changeImage(controls.RIGHT_P ? 1 : -1);
			controls.RIGHT_P ? arrow.animation.play('smash') : flippedArrow.animation.play('smash');
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.DOWN_P||controls.UP_P){
			changeNo(controls.UP_P ? 1 : -1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (FlxG.mouse.overlaps(downBar) && FlxG.mouse.justPressed) {
			FlxG.sound.play(Paths.sound('mouseClick'));
			CoolUtil.openURL('https://twitter.com/' + coolArtistArray[actualNum]);
		}
	}
	image.screenCenter();
}

function changeImage(number:Int = 0) {
	actualNum += number;
	firstImage = 0;

	if (actualNum >= coolArtistArray.length) actualNum = 0;
	if (actualNum < 0) actualNum = coolArtistArray.length - 1;

	updateImage();
}

function changeNo(change:Int = 0) {
	var total = totalMap[coolArtistArray[actualNum]];
	trace(total, coolArtistArray[actualNum], actualNum, firstImage);
	firstImage += change;

	if(firstImage >= total) firstImage = 0;
	else if(firstImage < 0) firstImage = total - 1;

	updateImage();
}

function updateImage() {
	image.loadGraphic(Paths.image('menus/fan-arts/ingame-fanart/' + coolArtistArray[actualNum] + '/' + (firstImage+1)));
	textArtists.text = '@' + coolArtistArray[actualNum];
}

function goodBye() {
	FlxTween.tween(menuText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(menuText, {y: -150}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(downBar, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(downBar, {y: 794}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(textSquare, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(textSquare, {x: 250}, 0.4, {ease:FlxEase.smoothStepInOut});
}