import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import funkin.savedata.FunkinSave;
import flixel.graphics.FlxGraphic;
import funkin.backend.chart.Chart;

songs = [];
var songRealList = [	
	["adobe","outrage","end-process","morality","stick-em-up","artistry","proficiency","masterpiece"],
	["trojan","conflict","dashpulse","time-travel","cubify","kickstarter","contrivance","messenger","amity","voltagen","issue","tune-in","unfaithful","rombie","fancy-funk","powerup","catto"],
	["enmity","doppelganger","aurora","phantasm"],
	["adobe-(old)","outrage-(older)","alan-(old)","outrage-(old)","end-process-(old)"],
	["rewrite"]//35_songs_holy_shit.
];

if(FlxG.save.data.songsUnlocked.contains('redzone-error'))songRealList[1].push("redzone-error");
if(FlxG.save.data.alanUnlocked)songRealList[1].push("alan");
if(FlxG.save.data.songsUnlocked.contains('catto'))songRealList[3].push("catto-(old)");

for(s in songRealList[FlxG.save.data.freeplaything_cc])
	songs.push(Chart.loadChartMeta(s, "hard", true));

static var curSelFP:Int = 0;
static var curSelFPR = [0,0,0,0];
var curDiffFP:Int = -1;

var scoreBG:FlxSprite;
var scoreText:FlxText;
var diffText:FlxText;
var lerpScore:Int = 0;
var lerpRating:Float = 0;
var intendedScore:Int = 0;
var intendedRating:Float = 0;

var grpSongs:FlxTypedGroup<FlxText>;

var iconArray:Array<HealthIcon> = [];

var bg = new FlxSprite();
var scrollingThing:FlxBackdrop;
var featuredChar:FlxSprite;
var intendedColor:Int;
var colorTween:FlxTween;
var zoomTween:FlxTween;
var tweenX:FlxTween;
var alphaTween:FlxTween;
var weeks:Null<Array<String>>;
var barName:FlxSprite;
var arrow:FlxSprite;
var flippedArrow:FlxSprite;
var selectedSmth:Bool = false;
var finishedZoom = false;
	
var fishEyeshader = new CustomShader("fishEyeshader"); 

public static var alanSongs:Array<String> = ['trojan', 'conflict', 'dashpulse', 'time travel', 'cubify', 'kickstarter', 'contrivance', 'messenger', 'amity', 'tune in', 'unfaithful', 'rombie', 'fancy funk', 'catto', 'enmity', 'phantasm', 'aurora'];

public static var minimizeWindowArray:Array<String> = ['dashpulse', 'messenger', 'rombie', 'powerup'];

var preload = [];
var preload2 = [];

function create() {
	CoolUtil.playMenuSong(true);
	DiscordUtil.changePresenceSince("In the Freeplay Song Selection", null);

	checkIfAlanIsLocked();

	FlxG.camera.zoom = 1.5;

	add(bg);

	scrollingThing = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'),FlxAxes.XY,0,0);
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.antialiasing = Options.antialiasing;
	add(scrollingThing);

	featuredChar = new FlxSprite();
	add(featuredChar);

	var vignetteCircle = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/dea'));
	vignetteCircle.antialiasing = Options.antialiasing;
	add(vignetteCircle);
	vignetteCircle.screenCenter();

	var upBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/upBar'));
	upBar.antialiasing = Options.antialiasing;
	add(upBar);
	upBar.screenCenter();

	var downBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/downBar'));
	downBar.antialiasing = Options.antialiasing;
	add(downBar);
	downBar.screenCenter();

	barName = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/freeplayImages/type of freeplay/'+FlxG.save.data.freeplaything_cc));
	barName.antialiasing = Options.antialiasing;
	add(barName);
	barName.screenCenter();

	grpSongs = new FlxTypedGroup<FlxText>();
	add(grpSongs);

	for (i in 0...songs.length) {
		var wasPlayed:Bool = FlxG.save.data.songsUnlocked.contains(songs[i].name);
		var songText = new FlxText(500, 650,500, wasPlayed ? songs[i].name.toUpperCase() : '???').setFormat(Paths.font("phantommuff.ttf"), 44, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		songText.screenCenter(FlxAxes.X);
		songText.scrollFactor.set(1, 0);
		if(songs[i].name.toLowerCase()=='trojan'&&wasPlayed&&FlxG.random.int(1, 4) == 1)songText.text='POWER-GAIN';
		add(songText);
		grpSongs.add(songText);

		var icon = new HealthIcon(wasPlayed ? songs[i].icon : 'interrogaciones');
		icon.y -= 70;
		icon.sprTracker = songText;
		icon.sprTrackerOffset.set(0,-40);

		iconArray.push(icon);
		icon.x -= 380;
		add(icon);
	}
	for (i in songs) {
		var graphic = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/art/' + i.portrait));
	    var graphic2 = FlxGraphic.fromAssetKey(Paths.image('menus/freeplayArt/freeplayImages/bgs/' + i.background));
	    graphic.persist =  graphic2.persist = true;
	    preload.push(graphic);
	    preload2.push(graphic2);
	}

	arrow = new FlxSprite(1150, 593);
	arrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	arrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	arrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	arrow.setGraphicSize(Std.int(arrow.width * 0.4));
	arrow.scrollFactor.set();
	arrow.antialiasing = Options.antialiasing;
	add(arrow);

	flippedArrow = new FlxSprite(0, 593);
	flippedArrow.frames = Paths.getSparrowAtlas('menus/FAMenu/arrows');
	flippedArrow.animation.addByPrefix('idle', 'arrow0', 24, false);
	flippedArrow.animation.addByPrefix('smash', 'arrow press', 24, false);
	flippedArrow.setGraphicSize(Std.int(flippedArrow.width * 0.4));
	flippedArrow.scrollFactor.set();
	flippedArrow.flipX = true;
	flippedArrow.antialiasing = Options.antialiasing;
	add(flippedArrow);

	scoreText = new FlxText(FlxG.width * 0.7, 405, 0, "", 24);
	scoreText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, 'center');

	scoreBG = new FlxSprite(scoreText.x - 6, 400).makeSolid(1, 126, 0xFF000000);
	scoreBG.alpha = 0.6;
	add(scoreBG);

	diffText = new FlxText(scoreText.x, scoreText.y + 48, 0, "", 24);
	diffText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, 'center');
	add(diffText);

	add(scoreText);

	curSelFP=curSelFPR[FlxG.save.data.freeplaything_cc];
	scrollingThing.color = songs[curSelFP].color;
	intendedColor = scrollingThing.color;

	changeSelection(0);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.9, true, ()->{finishedZoom = true;});

	if (FlxG.save.data.shaders) {FlxG.camera.addShader(crtShader = new CustomShader("CRTShader"));
	FlxG.camera.addShader(fishEyeshader);
	fishEyeshader.MAX_POWER = 0.05;}
}

function closeSubState() {
	changeSelection(0, false);
	persistentUpdate = true;
	super.closeSubState();
}

function checkIfAlanIsLocked() {
	for (i in 0...alanSongs.length-1) {
		if(FlxG.save.data.songsUnlocked.contains(alanSongs[i]) == false) {
			FlxG.save.data.alanUnlocked = false;
			return;
		}
	}

	FlxG.save.data.alanUnlocked = true;
}
	
function beatHit() if(finishedZoom&&!selectedSmth)FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type: FlxTween.BACKWARD});

var instPlaying:Int = -1;
var holdTime:Float = 0;
function update(elapsed:Float) {
	if (FlxG.sound.music.volume < 0.7&&!selectedSmth) FlxG.sound.music.volume += 0.5 * elapsed;

	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
	lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));

	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	scrollingThing.alpha = 0.7;

	if (Math.abs(lerpScore - intendedScore) <= 10) lerpScore = intendedScore;
	if (Math.abs(lerpRating - intendedRating) <= 0.01) lerpRating = intendedRating;

	var ratingSplit:Array<String> = Std.string(floorDecimal(lerpRating * 100, 2)).split('.');
	if(ratingSplit.length < 2) ratingSplit.push('');

	while(ratingSplit[1].length < 2) ratingSplit[1] += '0';

	scoreText.text = 'PERSONAL BEST: \n' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
	positionHighscore();

	var shiftMult:Int = 1;
	if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

	if(!selectedSmth && finishedZoom) {
		if(songs.length > 1) {
				if (controls.LEFT_P) {
					flippedArrow.animation.play('smash');
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (controls.RIGHT_P) {
					arrow.animation.play('smash');
					changeSelection(shiftMult);
					holdTime = 0;
				}
		
				if(controls.RIGHT_P || controls.LEFT_P) {
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
		
					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) changeSelection((checkNewHold - checkLastHold) * (controls.UI_LEFT_P ? -shiftMult : shiftMult));
				}
		
				if(FlxG.mouse.wheel != 0) {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}
			}
			if (controls.UP_P||controls.DOWN_P) changeDiff(controls.UP_P?1:-1);
		
			if (controls.BACK) {
				persistentUpdate = false;
				if(colorTween != null) colorTween.cancel();
				if(zoomTween != null) zoomTween.cancel();
				if(tweenX != null) tweenX.cancel();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				selectedSmth = true;
				FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function(){FlxG.switchState(new ModState('tco/FreeplayMenu'));});
			}
		
			if(FlxG.keys.justPressed.CONTROL) {
				persistentUpdate = false;
				openSubState(new ModSubState('Psych/substates/GameplayChangersSubstate'));
			}
			else if(FlxG.keys.justPressed.SPACE) {
				if(!FlxG.save.data.songsUnlocked.contains(songs[curSelFP].name.toLowerCase()))return;
				if(instPlaying != curSelFP) {
					#if PRELOAD_ALL
					FlxG.sound.music.volume = 0;
					Conductor.changeBPM(songs[curSelFP].bpm);
					Conductor.songPosition = FlxG.sound.music.time;
		
					FlxG.sound.playMusic(Paths.inst(songs[curSelFP].name), 0.7);
					instPlaying = curSelFP;
					#end
				}
			}
			else if (controls.ACCEPT) {
				persistentUpdate = false;
				PlayState.loadSong(songs[curSelFP].name, songs[curSelFP].difficulties[curDiffFP]);

				if(colorTween != null) colorTween.cancel();
				if(zoomTween != null) zoomTween.cancel();
				if(tweenX != null) tweenX.cancel();
		
				selectedSmth = true;
		
				FlxTween.tween(FlxG.camera, {zoom: 3}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
					if (songs[curSelFP].name.toLowerCase() == "amity") FlxG.switchState(new ModState('tco/MinusCharSelector'));
					else {
						FlxG.switchState(new PlayState());

						if(minimizeWindowArray.contains(songs[curSelFP].name.toLowerCase()) && !FlxG.save.data.wideScreenSongs) {
							window.resizable = false;
							FlxG.scaleMode = new StageSizeScaleMode();
							FlxG.resizeGame(360, 720);
							FlxG.resizeWindow(960, 720);
						}
					}
				});
				FlxG.sound.music.volume = 0;
			} else if(controls.RESET) {
				persistentUpdate = false;
				openSubState(new ResetScoreSubState(songs[curSelFP].songName, curDiffFP, songs[curSelFP].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
	}
}

function changeDiff(a) {curDiffFP = FlxMath.wrap(curDiffFP+a,0,songs[curSelFP].difficulties.length - 1);
	intendedScore = FunkinSave.getSongHighscore(songs[curSelFP].name, songs[curSelFP].difficulties[curDiffFP]).score;
	intendedRating = FunkinSave.getSongHighscore(songs[curSelFP].name, songs[curSelFP].difficulties[curDiffFP]).accuracy;

	diffText.text = '^ \n' +songs[curSelFP].difficulties[curDiffFP].toUpperCase()+ '\nv';
	positionHighscore();
}

function changeSelection(a:Int = 0, playSound:Bool = true) {
	playSound??=true;
	if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	curSelFP = FlxMath.wrap(curSelFP+a,0,songs.length-1);
	curSelFPR[FlxG.save.data.freeplaything_cc]=curSelFP;

	if(zoomTween != null) zoomTween.cancel();
	if(tweenX != null) tweenX.cancel();
	if(alphaTween != null) alphaTween.cancel();

	var songHasBeenPlayed:Bool = FlxG.save.data.songsUnlocked.contains(songs[curSelFP].name);

	var newColor:Int = songs[curSelFP].color;
	if(newColor != intendedColor) {
		if(colorTween != null) colorTween.cancel();
		intendedColor = newColor;
		colorTween = FlxTween.color(scrollingThing, 1, scrollingThing.color, intendedColor, {
			onComplete: function(twn:FlxTween) {colorTween = null;}
		});
	}

	var daBG:String = songHasBeenPlayed ? preload2[curSelFP] : Paths.image('menus/freeplayArt/freeplayImages/bgs/no bg');

	bg.loadGraphic(daBG);
	bg.antialiasing = Options.antialiasing;
	bg.screenCenter();

	var featuredImage = songHasBeenPlayed ? preload[curSelFP] : Paths.image('menus/freeplayArt/freeplayImages/art/no one');

	featuredChar.loadGraphic(featuredImage);
	featuredChar.antialiasing = Options.antialiasing;
	featuredChar.setGraphicSize(Std.int(featuredChar.width * 0.8));
	featuredChar.screenCenter();
	featuredChar.x -= 150;
	featuredChar.alpha = 0.0001;

	tweenX = FlxTween.tween(featuredChar, { x: 0 }, 0.25, {
		type: FlxTween.ONESHOT, ease: FlxEase.quadInOut,
		onComplete: function (twn:FlxTween) {tweenX = null;}
	});

	alphaTween = FlxTween.tween(featuredChar, { alpha: 1 }, 0.25, {
		ease: FlxEase.sineInOut,
		onComplete: function (twn:FlxTween) {alphaTween = null;}
	});

	var bullShit:Int = 0;

	for (i in 0...iconArray.length) {
		iconArray[i].alpha = 0;
		iconArray[i].scale.set(0.55,0.55);
	}

	iconArray[curSelFP].alpha = 1;
	zoomTween = FlxTween.tween(iconArray[curSelFP].scale, {x: 0.75, y: 0.75}, 0.2, {
			ease: FlxEase.quadOut,onComplete: function(twn:FlxTween) {zoomTween = null;}
		});

	for (item in grpSongs.members) {
		var shit = bullShit - curSelFP;
		bullShit++;

		item.alpha = 0;

		zoomTween = FlxTween.tween(item.scale, {x: 0.85, y: 0.85}, 0.2, {
			ease: FlxEase.quadOut,onComplete: function(twn:FlxTween) {zoomTween = null;}
		});

		if (shit == 0) {
			item.alpha = 1;

			zoomTween = FlxTween.tween(item.scale, {x: 1, y: 1}, 0.2, {
			ease: FlxEase.quadOut,onComplete: function(twn:FlxTween) {zoomTween = null;}
			});
		}
	}
	changeDiff(0);
}

private function positionHighscore() {
	scoreText.x = FlxG.width - scoreText.width - 6;

	scoreBG.scale.x = FlxG.width - scoreText.x + 6;
	scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
	diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
	diffText.x -= diffText.width / 2;
}

public static function floorDecimal(value:Float, decimals:Int):Float{
	if(decimals < 1) return Math.floor(value);

	var tempMult:Float = 1;
	for (i in 0...decimals) tempMult *= 10;
	var newValue:Float = Math.floor(value * tempMult);
	return newValue / tempMult;
}