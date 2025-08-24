//This DESPRATELYYLYLY needs tweaks , ok?
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.graphics.FlxGraphic;
import funkin.backend.chart.Chart;
import openfl.Lib;
 
var portrait:FlxSprite = new FlxSprite(0,-150);
var background:FlxSprite = new FlxSprite();
var preload = [];
var preload2 = [];
var arrow = new FlxSprite(1150, 593);
var flippedArrow = new FlxSprite(0, 593);
var zoomTween:FlxTween;
var grpSongs2 = new FlxTypedGroup();
var iconArray2:Array<HealthIcon> = [];
var crtShader:CustomShader = new CustomShader("CRT"); 

//Ronald mcslide https://github.com/Frakits/vs-ron-code/blob/main/data/states/FreeplayState.hx
songs = [];
songRealList = [["adobe","outrage","end-process","morality","stick-em-up","artistry","proficiency","masterpiece"],
	["trojan","conflict","dashpulse","time-travel","contrivance","messenger","amity","voltagen","tune-in","unfaithful","rombie","fancy-funk","catto","alan"],
	["enmity","doppelganger","aurora","phantasm"],[""]];
rsongsFound = songRealList[FlxG.save.data.freeplaything_cc];

for(s in rsongsFound)
	songs.push(Chart.loadChartMeta(s, "hard", true));
function create() {
	if (FlxG.save.data.freeplaything_cc == null) FlxG.save.data.screenShake_cc = 3;
	add(grpSongs2);
	for (i in 0...songs.length)
	{
		var chris_pratt:FlxText = new FlxText(500, 650, 500, songs[i].displayName.toUpperCase(),44);
		chris_pratt.screenCenter(FlxAxes.X);
		chris_pratt.setFormat(Paths.font("phantommuff.ttf"), 44, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		chris_pratt.scrollFactor.set(1, 0);
		add(chris_pratt);
		grpSongs2.add(chris_pratt);

		var icon:HealthIcon = new HealthIcon(songs[i].icon);
		icon.y -= 3757487;
		icon.sprTracker = chris_pratt;
		//icon.yAdd -= 10;

		iconArray2.push(icon);
		icon.x -= 380;
		add(icon);
	}
	portrait.updateHitbox();
	for(i in iconArray2)remove(i);
	
	background.updateHitbox();
	//Stops it from selecting a value bigger then the amount of songs , HOPEFULLY.
	curSelected = 0;
	//If_it_still_craches...uhh_delete_the_songs_list.
}
function postCreate() {
	FlxG.camera.addShader(crtShader);
	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});

	remove(grpSongs);
	remove(grpSongs2);
	for(i in iconArray) remove(i);
	FlxG.camera.zoom = 1.5;

	insert(58,background);

	bg = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'), FlxAxes.XY, 0, 0);
	bg.scrollFactor.set(0, 0.07);
	bg.antialiasing = true;
	bg.alpha = 0.7;
	insert(59,bg);

	var vignetteCircle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/dea'));
	vignetteCircle.antialiasing = true;
	insert(60,vignetteCircle);
	vignetteCircle.screenCenter();

	var upBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/upBar'));
	upBar.antialiasing = true;
	upBar.screenCenter();
	insert(61,upBar);

	insert(62,portrait);

	var downBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/downBar'));
	downBar.antialiasing = true;
	insert(63,downBar);

	arrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	arrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	arrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	arrow.setGraphicSize(Std.int(arrow.width * 0.4));
	arrow.scrollFactor.set();
	arrow.antialiasing = true;
	arrow.angle=90;
	insert(64,arrow);

	flippedArrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	flippedArrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	flippedArrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	flippedArrow.setGraphicSize(Std.int(flippedArrow.width * 0.4));
	flippedArrow.scrollFactor.set();
	flippedArrow.angle=90;
	flippedArrow.flipX = flippedArrow.antialiasing = true;
	insert(65,flippedArrow);

	barName = new FlxSprite(0,-70).loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/type of freeplay/'+FlxG.save.data.freeplaything_cc));
	barName.screenCenter();
	insert(66,barName);

	scoreText = new FlxText(FlxG.width * 0.7, 405, 0, "bleh", 24).setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, "center");
	insert(67,scoreText);

	scoreBG = new FlxSprite(0, 400).makeSolid(1, 126, 0xFF000000);
	scoreBG.alpha = 0.6;
	insert(68,scoreBG);

	insert(69,grpSongs2);
	changeSelection(0, true);
	diffText = new FlxText(scoreText.x, scoreText.y + 48, 0, songs[curSelected].difficulties[curDifficulty], 24);
	diffText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, "center");
	insert(70,diffText);

	for(i in iconArray2) insert(3333,i);

    for (i in songs) {
		//Gets the art names from the song's meta so theres no dulpicate assets also means YOU HAVE TO ADD THE META STUFF.
	    var graphic = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/art/' + i.portrait));
	    var graphic2 = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/bgs/' + i.background));
	    graphic.persist =  graphic2.persist = true;
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
		Lib.application.window.title = "Computerized Conflict - Freeplay Menu - "+songs[val].name +" By: "+songs[val].composer;
		portrait.setGraphicSize(Std.int(portrait.width * 0.8));
		portrait.loadGraphic(preload[val]);
		portrait.screenCenter();
		var mfwY = portrait.x;
		portrait.x -= 20;
		FlxTween.tween(portrait, {x: mfwY}, 0.4, {ease: FlxEase.elasticOut});
		var bullShit:Int = 0;
		for (i in 0...iconArray2.length) {
			iconArray2[i].alpha = 0;
			iconArray2[i].scale.x = iconArray2[i].scale.y = 0.55;
		}
		iconArray2[val].alpha = 1;

		FlxTween.tween(iconArray2[val], {"scale.x": 0.75, "scale.y": 0.75}, 0.2, {
				ease: FlxEase.quadOut
			});
		for (item in grpSongs2.members)
		{
			var shit = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;

				FlxTween.tween(item, {"scale.x": 0.85, "scale.y": 0.85}, 0.2, {
					ease: FlxEase.quadOut
				});
			if (shit == val)
			{
				item.alpha = 1;

					FlxTween.tween(item, {"scale.x": 1, "scale.y": 1}, 0.2, {
					ease: FlxEase.quadOut
				});
			}
		}
	}});
	FlxTween.tween(background, {x: background.x + 45}, 0.2, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
		background.loadGraphic(preload2[val]);
		background.screenCenter();
		var mfwY = background.x;
		background.x -= 20;
		FlxTween.tween(background, {x: mfwY}, 0.4, {ease: FlxEase.elasticOut});
	}});
}
function postUpdate(elapsed:Float) {
	bg.x -= 0.45 * 60 * elapsed;
	bg.y -= 0.16 * 60 * elapsed;
	if(controls.BACK) FlxG.switchState(new ModState('FreeplayMenu'));
	if (controls.UP_P||controls.DOWN_P) flippedArrow.animation.play('smash');
}