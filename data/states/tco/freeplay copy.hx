//This DESPRATELYYLYLY needs tweaks , ok?
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.graphics.FlxGraphic;
import funkin.backend.chart.Chart;
import openfl.Lib;

var grpSongs2 = new FlxTypedGroup();
var iconArray2:Array<HealthIcon> = [];

songs = [];
var songRealList = [	
	["adobe","outrage","end-process","morality","stick-em-up","artistry","proficiency","masterpiece"],
	["trojan","conflict","dashpulse","time-travel","contrivance","messenger","amity","voltagen","tune-in","unfaithful","rombie","fancy-funk","catto","alan"],
	["enmity","doppelganger","aurora","phantasm"]
	[""]
];

for(s in songRealList[FlxG.save.data.freeplaything_cc])
	songs.push(Chart.loadChartMeta(s, "hard", true));

var diffText:FlxText;

static var curSelected_freeplay:Int = 0;
var curDifficulty:Int = -1;
static var lastDifficultyName:String = '';

var bg = new FlxSprite();
var scrollingThing:FlxBackdrop;
var featuredChar = new FlxSprite();
var intendedColor:Int;
var colorTween:FlxTween;
var zoomTween:FlxTween;
var tweenX:FlxTween;
var alphaTween:FlxTween;
var barName:FlxSprite;
var arrow:FlxSprite;
var flippedArrow:FlxSprite;
var selectedSmth:Bool = false;
var finishedZoom = false;

var preload = [];
var preload2 = [];
 
function create() {
	add(bg);

	scrollingThing = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'), FlxAxes.XY, 0, 0);
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	//scrollingThing.antialiasing = ClientPrefs.globalAntialiasing;
	add(scrollingThing);

	add(featuredChar);

	var vignetteCircle:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/dea'));
	//vignetteCircle.antialiasing = ClientPrefs.globalAntialiasing;
	add(vignetteCircle);
	vignetteCircle.screenCenter();

	var upBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/upBar'));
	//upBar.antialiasing = ClientPrefs.globalAntialiasing;
	add(upBar);
	upBar.screenCenter();

	var downBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/downBar'));
	//downBar.antialiasing = ClientPrefs.globalAntialiasing;
	add(downBar);
	downBar.screenCenter();

	barName = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/type of freeplay/'+FlxG.save.data.freeplaything_cc));
	//barName.antialiasing = ClientPrefs.globalAntialiasing;
	add(barName);
	barName.screenCenter();
		
	add(grpSongs2);
	for (i in 0...songs.length){
		var chris_pratt:FlxText = new FlxText(500, 650, 500, songs[i].displayName.toUpperCase(),44);
		chris_pratt.screenCenter(FlxAxes.X);
		chris_pratt.setFormat(Paths.font("phantommuff.ttf"), 44, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		chris_pratt.scrollFactor.set(1, 0);
		add(chris_pratt);
		grpSongs2.add(chris_pratt);

		var icon:HealthIcon = new HealthIcon(songs[i].icon);
		icon.y -= 70;
		icon.sprTracker = chris_pratt;
		//icon.yAdd -= 10;

		iconArray2.push(icon);
		icon.x -= 380;
		add(icon);
	}

	arrow = new FlxSprite(1150, 593);
	arrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	arrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	arrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	arrow.setGraphicSize(Std.int(arrow.width * 0.4));
	arrow.scrollFactor.set();
	//arrow.antialiasing = ClientPrefs.globalAntialiasing;
	add(arrow);

	flippedArrow = new FlxSprite(0, 593);
	flippedArrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	flippedArrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	flippedArrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	flippedArrow.setGraphicSize(Std.int(flippedArrow.width * 0.4));
	flippedArrow.scrollFactor.set();
	flippedArrow.flipX = true;
	//flippedArrow.antialiasing = ClientPrefs.globalAntialiasing;
	add(flippedArrow);

	diffText = new FlxText(1000, 500 + 48, 0, "", 24);
	diffText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center');
	add(diffText);

	if (curSelected_freeplay >= songs.length) curSelected_freeplay = 0;
	scrollingThing.color = songs[curSelected_freeplay].color;
	intendedColor = scrollingThing.color;

	//if(lastDifficultyName == '') lastDifficultyName = CoolUtil.defaultDifficulty;
	//curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.9, true, function()
	{
		finishedZoom = true;
	});

	for (i in songs) {
		var graphic = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/art/' + i.portrait));
	    var graphic2 = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/bgs/' + i.background));
	    graphic.persist =  graphic2.persist = true;
	    preload.push(graphic);
	    preload2.push(graphic2);
	}

	changeSelection(0);
	changeDiff(0);
	curSelected_freeplay=0;
}
function update(elapsed:Float) {
	if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * elapsed;

	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	scrollingThing.alpha = 0.7;
	if(!selectedSmth && finishedZoom) {
		if (controls.LEFT_P||controls.RIGHT_P){
			changeSelection(controls.RIGHT_P ? 1 : -1);
			controls.LEFT_P ?flippedArrow.animation.play('smash') :arrow.animation.play('smash');
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.UP_P||controls.DOWN_P){
			changeDiff(controls.DOWN_P ? 1 : -1);
		}
		if (controls.BACK) {
			persistentUpdate = false;
			if(colorTween != null) colorTween.cancel();
			if(zoomTween != null) zoomTween.cancel();
			if(tweenX != null) tweenX.cancel();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			selectedSmth = true;
			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
			{
				FlxG.switchState(new ModState('FreeplayMenu'));
			});
		}
		if (controls.ACCEPT){
			PlayState.loadSong(songs[curSelected_freeplay].name, songs[curSelected_freeplay].difficulties[curDifficulty].toLowerCase());

			selectedSmth = true;
		
				FlxTween.tween(FlxG.camera, {zoom: 3}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
				{
					if (songs[curSelected_freeplay].name == "amity".toLowerCase()) MusicBeatState.switchState(new MinusCharSelector());
					else {
						FlxG.switchState(new PlayState());

						/*if(minimizeWindowArray.contains(songs[curSelected].songName.toLowerCase()) && !ClientPrefs.wideScreenSongs) {
							Lib.application.window.resizable = false;
							FlxG.scaleMode = new StageSizeScaleMode();
							FlxG.resizeGame(360, 720);
							FlxG.resizeWindow(960, 720);
						}*/
					}
				});
		}
	}
	if(controls.BACK) FlxG.switchState(new ModState('FreeplayMenu'));
}

function changeSelection(change:Int = 0, playSound:Bool = true){
	if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

	curSelected_freeplay += change;

	if (curSelected_freeplay < 0)
		curSelected_freeplay = songs.length - 1;
	if (curSelected_freeplay >= songs.length)
		curSelected_freeplay = 0;

	if(zoomTween != null) zoomTween.cancel();
	if(tweenX != null) tweenX.cancel();
	if(alphaTween != null) alphaTween.cancel();

	var newColor:Int = songs[curSelected_freeplay].color;

	if(newColor != intendedColor) {
		if(colorTween != null) colorTween.cancel();
		intendedColor = newColor;
		colorTween = FlxTween.color(scrollingThing, 1, scrollingThing.color, intendedColor, {
			onComplete: function(twn:FlxTween) {
				colorTween = null;
			}
		});
	}

	bg.loadGraphic(preload2[curSelected_freeplay]);
	//bg.antialiasing = ClientPrefs.globalAntialiasing;
	bg.screenCenter();

	featuredChar.loadGraphic(preload[curSelected_freeplay]);
	//featuredChar.antialiasing = ClientPrefs.globalAntialiasing;
	featuredChar.setGraphicSize(Std.int(featuredChar.width * 0.8));
	featuredChar.screenCenter();
	featuredChar.x -= 150;
	featuredChar.alpha = 0.0001;

	tweenX = FlxTween.tween(featuredChar, {x: 0}, 0.25, {
		type: FlxTween.ONESHOT, ease: FlxEase.quadInOut,
		onComplete: function (twn:FlxTween) {
			tweenX = null;
		}
	});

	alphaTween = FlxTween.tween(featuredChar, {alpha: 1}, 0.25, {
		ease: FlxEase.sineInOut,
		onComplete: function (twn:FlxTween) {
			alphaTween = null;
		}
	});

	var bullShit:Int = 0;

	for (i in 0...iconArray2.length)	{
		iconArray2[i].alpha = 0;

		iconArray2[i].scale.x = 0.55;
		iconArray2[i].scale.y = 0.55;
	}

	iconArray2[curSelected_freeplay].alpha = 1;
	zoomTween = FlxTween.tween(iconArray2[curSelected_freeplay], {"scale.x": 0.75, "scale.y": 0.75}, 0.2, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				zoomTween = null;
			}
		});

	for (item in grpSongs2.members) {
		var shit = bullShit - curSelected_freeplay;
		bullShit++;

		item.alpha = 0;

		zoomTween = FlxTween.tween(item, {"scale.x": 0.85, "scale.y": 0.85}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					zoomTween = null;
				}
			});

		if (shit == 0) {
			item.alpha = 1;

				zoomTween = FlxTween.tween(item, {"scale.x": 1, "scale.y": 1}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					zoomTween = null;
				}
			});
		}
	}
}

function beatHit(){
	FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type: FlxEase.BACKWARD});
}

function changeDiff(change:Int = 0) {
	curDifficulty += change;

	if (curDifficulty < 0) curDifficulty = songs[curSelected_freeplay].difficulties.length-1;
	if (curDifficulty >= songs[curSelected_freeplay].difficulties.length) curDifficulty = 0;


	//lastDifficultyName = CoolUtil.difficulties[curDifficulty];

	diffText.text = '^ \n' + songs[curSelected_freeplay].difficulties[curDifficulty]+ '\nv';
}