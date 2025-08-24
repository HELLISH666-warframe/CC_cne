import flixel.graphics.FlxGraphic;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.text.FlxTextAlign;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import openfl.Lib;
 
var portrait:FlxSprite = new FlxSprite();
 var background:FlxSprite = new FlxSprite();
 var preload = [];
 var preload2 = [];
 var time:Float = 0;
 var arrow:FlxSprite;
 var flippedArrow:FlxSprite;
 var zoomTween:FlxTween;
 var grpSongs2 = new FlxTypedGroup();
 var iconArray2:Array<HealthIcon> = [];
function shadering() 
{
	trace('FUCKER_WHY_NO_WORKY');
}
function create() {
	add(grpSongs2);
	for (i in 0...songs.length)
	{
		var songText:FlxText = new FlxText(500, 650, 500, songs[i].displayName.toUpperCase(),44);
		songText.setFormat(Paths.font("phantommuff.ttf"), 44, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		songText.scrollFactor.set(1, 0);
		add(songText);
		grpSongs2.add(songText);

		var icon:HealthIcon = new HealthIcon(songs[i].icon);
		icon.y -= 70;
		icon.sprTracker = songText;
		//icon.yAdd -= 10;

		iconArray2.push(icon);
		icon.x -= 380;
		add(icon);
	}
	for(i in grpSongs2.members)
	trace(i);
	portrait.scale.set(0.51,0.51);
	portrait.updateHitbox();
	
	background.updateHitbox();
	background.scale.set(0.7,0.7);
}
function postCreate() {
	Lib.application.window.title = "Computerized Conflict - Main Menu - gonna_have_this_say_the_cursong_later";
	remove(grpSongs);
	remove(grpSongs2);
	for(i in iconArray) remove(i);
	//FlxG.camera.zoom = 1.5;

	insert(66,background);

	bg = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'), FlxAxes.XY, 0, 0);
	bg.scrollFactor.set(0, 0.07);
	bg.setGraphicSize(Std.int(bg.width * 0.8));
	bg.antialiasing = true;
	bg.alpha = 0.7;
	insert(67,bg);

	var vignetteCircle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/dea'));
	vignetteCircle.antialiasing = true;
	vignetteCircle.scale.set(0.70,0.70);
	insert(68,vignetteCircle);
	vignetteCircle.screenCenter();

	var upBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/upBar'));
	upBar.antialiasing = true;
	upBar.screenCenter();
	add(upBar);

	insert(778789789,portrait);

	var downBar:FlxSprite = new FlxSprite(0,-90).loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/downBar'));
	downBar.antialiasing = true;
	add(downBar);

	arrow = new FlxSprite(958, 494);
	arrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	arrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	arrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	arrow.setGraphicSize(Std.int(arrow.width * 0.4));
	arrow.scrollFactor.set();
	arrow.antialiasing = true;
	add(arrow);

	flippedArrow = new FlxSprite(200, 494);
	flippedArrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	flippedArrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	flippedArrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	flippedArrow.setGraphicSize(Std.int(flippedArrow.width * 0.4));
	flippedArrow.scrollFactor.set();
	flippedArrow.flipX = true;
	flippedArrow.antialiasing = true;
	add(flippedArrow);

	freeplayMenuText = new FlxSprite(0,-70);
	freeplayMenuText.scale.set(0.51,0.51);
	freeplayMenuText.loadGraphic(Paths.image('menus/freeplayArt/selectMenu/freeplay-text'));
	freeplayMenuText.scrollFactor.set();
	add(freeplayMenuText);

	scoreText = new FlxText(FlxG.width * 0.7, 405, 0, "bleh", 24);
	scoreText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "center");
	scoreText.x = 4354954839489;
	add(scoreText);

	scoreBG = new FlxSprite(543534, 400).makeSolid(1, 126, 0xFF000000);
	scoreBG.alpha = 0.6;
	add(scoreBG);

	insert(70,grpSongs2);

	diffText = new FlxText(scoreText.x, scoreText.y + 48, 0, "", 24);
	diffText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, "center");
	add(diffText);

for (i in songs) {
	var graphic = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/art/' + i.name));
	var graphic2 = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/bgs/' + i.name));
	graphic.persist = true;
	graphic2.persist = true;
	preload.push(graphic);
	preload2.push(graphic2);
}
}
function onChangeSelection(event) {
	if (event.change == 0) event.playMenuSFX = false;
	FlxTween.globalManager.completeTweensOf(portrait);
	FlxTween.globalManager.completeTweensOf(background);
	var val = event.value;
	FlxTween.tween(portrait, {x: portrait.x + 45}, 0.2, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
		portrait.loadGraphic(preload[val]);
		portrait.updateHitbox();
		portrait.screenCenter();
		var mfwY = portrait.x;
		portrait.x -= 20;
		FlxTween.tween(portrait, {x: mfwY}, 0.4, {ease: FlxEase.elasticOut});
		var bullShit:Int = 0;
		for (item in grpSongs2) {
			var shit = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;

				zoomTween = FlxTween.tween(item, {"scale.x": 0.85, "scale.y": 0.85}, 0.2, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween) {
						zoomTween = null;
					}
				});
			if (shit == 0)
			{
				item.alpha = 1;

					zoomTween = FlxTween.tween(item, {"scale.x": 1, "scale.y": 1}, 0.2, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween) {
						zoomTween = null;
					}
				});
			}
		}
	}});
	FlxTween.tween(background, {x: background.x + 45}, 0.2, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
		background.loadGraphic(preload2[val]);
		background.updateHitbox();
		background.screenCenter();
		var mfwY = background.x;
		background.x -= 20;
		FlxTween.tween(background, {x: mfwY}, 0.4, {ease: FlxEase.elasticOut});
		shadering();
	}});
}
function update(elapsed:Float) {
	bg.x -= 0.45 * 60 * elapsed;
	bg.y -= 0.16 * 60 * elapsed;
}
override function postUpdate(elapsed:Float) {
	if (controls.LEFT_P)
	{
		changeDiff(0, true);
		flippedArrow.animation.play('smash');
	}
	if (controls.RIGHT_P)
	{
		changeDiff(0, true);
		arrow.animation.play('smash');
	}
}/*
function shadering() 
{
	var bullShit:Int = 0;
	for (i in grpSongs2)
	{
		var shit = bullShit - curSelected;
		bullShit++;
		trace(bullShit);

		i.alpha = 0;

			zoomTween = FlxTween.tween(i, {"scale.x": 0.85, "scale.y": 0.85}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					zoomTween = null;
				}
			});
		if (shit == 0)
		{
			i.alpha = 1;

				zoomTween = FlxTween.tween(i, {"scale.x": 1, "scale.y": 1}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					zoomTween = null;
				}
			});
		}
	}
}*/