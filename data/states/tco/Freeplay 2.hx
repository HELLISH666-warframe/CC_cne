import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.graphics.FlxGraphic;
import funkin.backend.chart.Chart;

import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import Shaders;

songs = [];
var songRealList = [	
	["adobe","outrage","end-process","morality","stick-em-up","artistry","proficiency","masterpiece"],
	["trojan","conflict","dashpulse","time-travel","cubify","kickstarter","contrivance","messenger","amity","royalty","voltagen","doombringer","issue","tune-in","unfaithful","rombie","fancy-funk","powerup","justice","catto"],
	["enmity","doppelganger","aurora","phantasm"],
	["adobe-(old)","outrage-(older)","alan-(old)","outrage-(old)","end-process-(old)","catto-(old)"],
	["operation","rewrite"]//41_songs_holy_shit.
];

if(FlxG.save.data.alanUnlocked)
songRealList[1].push("alan");

for(s in songRealList[FlxG.save.data.freeplaything_cc])
	songs.push(Chart.loadChartMeta(s, "hard", true));

static var curSelFP:Int = 0;
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

var bg:FlxSprite;
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
	
public static var crtShader = new CRTShader();
var shaderFilter = new ShaderFilter(crtShader);
public static var fishEyeshader = new FishEyeShader();
var shaderFilter2 = new ShaderFilter(fishEyeshader);

public static var alanSongs:Array<String> = ['trojan', 'conflict', 'dashpulse', 'time travel', 'cubify', 'kickstarter', 'contrivance', 'messenger', 'amity', 'tune in', 'unfaithful', 'rombie', 'fancy funk', 'catto', 'enmity', 'phantasm', 'aurora'];

public static var alreadyShowedSongs:Array<String> = ['adobe', 'outrage', 'end process', 'practice time', 'adobe (old)', 'outrage (old)', 'alan (old)'];

var precacheList:Map<String, String> = new Map<String, String>();
public static var minimizeWindowArray:Array<String> = ['dashpulse', 'messenger', 'rombie', 'powerup'];

function create() {
	DiscordUtil.changePresenceSince("In the Freeplay Song Selection", null);

	checkIfAlanIsLocked();

	FlxG.camera.zoom = 1.5;

	bg = new FlxSprite();
	add(bg);

	scrollingThing = new FlxBackdrop(Paths.image('menus/FAMenu/scroll'),FlxAxes.XY,0,0);
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.antialiasing = Options.antialiasing;
	add(scrollingThing);

	for (i in 0...songs.length) precacheList.set('freeplayArt/freeplayImages/bgs/' + songs[i].songName, 'image');

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
		var songText:FlxText = new FlxText(500, 650, songs[i].songName.toUpperCase(), 44);
		songText.setFormat(Paths.font("phantommuff.ttf"), 44, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		songText.scrollFactor.set(1, 0);
		add(songText);
		grpSongs.add(songText);

		var icon = new HealthIcon(songs[i].songCharacter);
		icon.y -= 70;
		icon.sprTracker = songText;
		icon.yAdd -= 10;

		iconArray.push(icon);
		icon.x -= 380;
		add(icon);
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

	if (curSelFP >= songs.length) curSelFP = 0;
	scrollingThing.color = songs[curSelFP].color;
	intendedColor = scrollingThing.color;

	changeSelection(0);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.9, true, ()->{finishedZoom = true;});
		
	if (FlxG.save.data.shaders) FlxG.camera.setFilters([shaderFilter, shaderFilter2]);
	fishEyeshader.MAX_POWER.value = [0.05];

	for (key => type in precacheList) {
		switch(type) {
			case 'image':Paths.image(key);
		}
	}
}

function closeSubState() {
	changeSelection(0, false);
	persistentUpdate = true;
	super.closeSubState();
}

function checkIfAlanIsLocked() {
	for (i in 0...alanSongs.length-1) {
		if(CoolUtil.songsUnlocked.data.alanSongs.get(alanSongs[i]) == false) {
			CoolUtil.songsUnlocked.data.alanUnlocked = false;
			return;
		}
	}

	CoolUtil.songsUnlocked.data.alanUnlocked = true;
}
	
function beatHit() FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type: FlxTween.BACKWARD})

var instPlaying:Int = -1;
public static var vocals:FlxSound = null;
var holdTime:Float = 0;
function update(elapsed:Float) {
	return;//FUCK_OFF.
	if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * elapsed;

	lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
	lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));

	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	scrollingThing.alpha = 0.7;

	if (Math.abs(lerpScore - intendedScore) <= 10) lerpScore = intendedScore;
	if (Math.abs(lerpRating - intendedRating) <= 0.01) lerpRating = intendedRating;

	var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
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
				if(instPlaying != curSelFP) {
					#if PRELOAD_ALL
					destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					Paths.currentModDirectory = songs[curSelFP].folder;
					var poop:String = Highscore.formatSong(songs[curSelFP].songName.toLowerCase(), curDiffFP);
					PlayState.SONG = Song.loadFromJson(poop, songs[curSelFP].songName.toLowerCase());
					Conductor.changeBPM((PlayState.SONG.bpm));
					Conductor.songPosition = FlxG.sound.music.time;
		
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
					instPlaying = curSelFP;
					#end
				}
			}
			else if (controls.ACCEPT) {
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelFP].songName);
				var poop:String = Highscore.formatSong(songLowercase, curDiffFP);

				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.vaultSong = false;
				PlayState.storyDifficulty = curDiffFP;

				if(colorTween != null) colorTween.cancel();
		
				if(zoomTween != null) zoomTween.cancel();

				if(tweenX != null) tweenX.cancel();
		
				selectedSmth = true;
		
				FlxTween.tween(FlxG.camera, {zoom: 3}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
					if (songs[curSelFP].songName == "amity".toLowerCase()) FlxG.switchState(new ModState('tco/MinusCharSelector'));
					else {
						LoadingState.loadAndSwitchState(new PlayState());

						if(minimizeWindowArray.contains(songs[curSelFP].songName.toLowerCase()) && !ClientPrefs.wideScreenSongs) {
							window.resizable = false;
							FlxG.scaleMode = new StageSizeScaleMode();
							FlxG.resizeGame(360, 720);
							FlxG.resizeWindow(960, 720);
						}
					}
				});
				FlxG.sound.music.volume = 0;
				destroyFreeplayVocals();
			} else if(controls.RESET) {
				persistentUpdate = false;
				openSubState(new ResetScoreSubState(songs[curSelFP].songName, curDiffFP, songs[curSelFP].songCharacter));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
	}
}

public static function destroyFreeplayVocals() {
	if(vocals != null) {
		vocals.stop();
		vocals.destroy();
	}
	vocals = null;
}

function changeDiff(a) {curDiffFP = FlxMath.wrap(curDiffFP+a,0,songs[curSelFP].difficulties.length - 1);
	intendedScore = FunkinSave.getSongHighscore(songs[curSelFP].name, songs[curSelFP].difficulties[curDiffFP]).score;
	intendedRating = FunkinSave.getSongHighscore(songs[curSelFP].name, songs[curSelFP].difficulties[curDiffFP]).accuracy;

	diffText.text = '^ \n' +songs[curSelFP].difficulties[curDiffFP].toUpperCase()+ '\nv';
	positionHighscore();
}

function changeSelection(a:Int = 0, playSound:Bool = true) {
	if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	curSelFP = FlxMath.wrap(curSelFP+a,0,songs.length-1);

	if(zoomTween != null) zoomTween.cancel();

	if(tweenX != null) tweenX.cancel();

	if(alphaTween != null) alphaTween.cancel();

	var songName:String = songs[curSelFP].songName;
	var songHasBeenPlayed:Bool = CoolUtil.songsUnlocked.data.songsPlayed.contains(songName.toLowerCase());

	var newColor:Int = songs[curSelFP].color;
	if(newColor != intendedColor) {
		if(colorTween != null) colorTween.cancel();
		intendedColor = newColor;
		colorTween = FlxTween.color(scrollingThing, 1, scrollingThing.color, intendedColor, {
			onComplete: function(twn:FlxTween) {colorTween = null;}
		});
	}

	var daBG:String = songHasBeenPlayed ? songName : 'no bg';

	bg.loadGraphic(Paths.image('freeplayArt/freeplayImages/bgs/' + daBG));
	bg.antialiasing = Options.antialiasing;
	bg.screenCenter();

	var featuredImage:String = songHasBeenPlayed ? songName : 'no one';

	featuredChar.loadGraphic(Paths.image('freeplayArt/freeplayImages/art/${featuredImage}'));
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
	zoomTween = FlxTween.tween(iconArray[curSelFP], {"scale.x": 0.75, "scale.y": 0.75}, 0.2, {
			ease: FlxEase.quadOut,onComplete: function(twn:FlxTween) {zoomTween = null;}
		});

	for (item in grpSongs.members) {
		var shit = bullShit - curSelFP;
		bullShit++;

		item.alpha = 0;

		zoomTween = FlxTween.tween(item, {"scale.x": 0.85, "scale.y": 0.85}, 0.2, {
			ease: FlxEase.quadOut,onComplete: function(twn:FlxTween) {zoomTween = null;}
		});

		if (shit == 0) {
			item.alpha = 1;

			zoomTween = FlxTween.tween(item, {"scale.x": 1, "scale.y": 1}, 0.2, {
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