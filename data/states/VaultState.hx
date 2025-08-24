import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.graphics.FlxGraphic;
import funkin.backend.utils.DiscordUtil;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import flixel.FlxSubState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxInputText;
import Shaders;

import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import Shaders;

#if !flash
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

var tipPopUp:FlxSprite;
var convertPopUp:FlxSprite;
var glitchBG:BGSprite;
var glitchBGHUD:BGSprite;
var daStatic:FlxSprite;
var barTitle:FlxSprite;
var downBarText:FlxSprite;
var vignette:FlxSprite;
public var camHUD:FlxCamera;
var vignette2:FlxSprite;
var selectedSmth:Bool = false;
var inputText:FlxInputText;
var coolDown:Bool = true;
var scrollingThing:FlxBackdrop;
var modesText:FlxText;
var curDifficulty = 1;
var whiteScreen:FlxSprite;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;
var secretCounter:Int = 0;
var itemsText:FlxText;
var wrongTextArray:Array<String> = 
[
	'Please, insert a valid symbol.',
	'You are supposed to put something else there, come on.',
	'Try again.',
	'You should totally translate the morse codes you have seen.',
	'Computerized Conflict: Coming to PS5, Xbox Series X and Nintendo Switch soon.',
	'verycool_errortext_5.txt'
];
var wrong:FlxText;
	
public static var codesAndShit:Array<Array<String>> = //1: Code, 2: Song
[
	['videos', 'Tune In'],
	['hatred', 'Unfaithful'],
	['joe', 'Rombie'],
	['world1', 'Fancy Funk'],
	['skrunkly', 'catto']
];

public static var randomImages:Array<Array<String>> = //1: Code, 2: Image name
[
	['ohmygod', 'dreamybull'],
	['alanb', 'alanb'],
	['fiend folio', 'twinkle of contagion'],
	['da alien', 'war crimes'],
	['jerry', 'jerry'],
	[':)', 'happy'],
	['ok', 'shark-plane'],
	['d1t1l1g', 'what the fuck'],
];

var isWriting:Bool = false;
var letterWritten:String;

var wrongTween:FlxTween;
var wrongTimer:FlxTimer;
	
//random easter eggs
var goofyImage:FlxSprite;
var goofyTween:FlxTween;

//normal code yeahhhh

override public function create()
{		
	DiscordUtil.changePresence('In the Vault', null);

	Lib.application.window.title = "Computerized Conflict - Vault - Theme by: JaceLOL";
		
	camHUD = new FlxCamera();
	camHUD.bgColor.alpha = 0;
	FlxG.cameras.add(camHUD, false);
		
	Conductor.changeBPM(115);

	CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		
	FlxG.sound.playMusic(Paths.music('secret_menu'));

	glitchBG = new BGSprite('vault/newGlitchBG', 450, 215, 0.9, 0.9, ['g'], true);
	glitchBG.screenCenter();
	glitchBG.antialiasing = true;
	add(glitchBG);
		
	glitchBGHUD = new BGSprite('vault/newGlitchBG', 450, 215, 0.9, 0.9, ['g'], true);
	glitchBGHUD.screenCenter();
	glitchBGHUD.antialiasing = true;
	glitchBGHUD.cameras = [camHUD];
	glitchBGHUD.alpha = 0;
	add(glitchBGHUD);

	scrollingThing = new FlxBackdrop(Paths.image('FAMenu/scroll'), XY, 0, 0);
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	scrollingThing.alpha = 0.5;
	scrollingThing.antialiasing = true;
	//add(scrollingThing);

	vignette2 = new FlxSprite().loadGraphic(Paths.image('vault/vig2'));
	vignette2.antialiasing = true;
	add(vignette2);

	daStatic = new FlxSprite().loadGraphic(Paths.image('vault/static'));
	daStatic.antialiasing = true;
	add(daStatic);

	spikes1 = new FlxBackdrop(Paths.image('mainmenu/spikes'), X, 0, 0);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

	spikes2 = new FlxBackdrop(Paths.image('mainmenu/spikes'), X, 0, 0);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);

	var bksp:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bksp'));
	bksp.setGraphicSize(Std.int(bksp.width * 0.5));
	bksp.antialiasing = true;
	add(bksp);
		
	for (i in 0...codesAndShit.length)
	{
		if (CoolUtil.songsUnlocked.data.songs.get(codesAndShit[i][1])) secretCounter++;
	}

	wrong = new FlxText(20, 550, FlxG.width, '', 18);
	wrong.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.RED, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	wrong.alpha = 0;
	add(wrong);

	itemsText = new FlxText(35, 655, FlxG.width, 'Unlocked Secrets: ' + secretCounter + '/5', 18);
	itemsText.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(itemsText);

	barTitle = new FlxSprite(0, -150).loadGraphic(Paths.image('vault/barTitle'));
	barTitle.antialiasing = true;
	barTitle.alpha = 0.000001;
	add(barTitle);

	vignette = new FlxSprite().loadGraphic(Paths.image('vault/blueVig'));
	vignette.antialiasing = true;
	add(vignette);

	tipPopUp = new FlxSprite(250, 0).loadGraphic(Paths.image('vault/tip'));
	tipPopUp.antialiasing = true;
	tipPopUp.alpha = 0.000001;
	add(tipPopUp);

	convertPopUp = new FlxSprite(-250, 0).loadGraphic(Paths.image('vault/convertToSymbol'));
	convertPopUp.antialiasing = true;
	convertPopUp.alpha = 0.000001;
	add(convertPopUp);

	inputText = new FlxInputText(235, 326, FlxG.width, "", 20, FlxColor.BLACK, FlxColor.TRANSPARENT, true);
	inputText.setFormat(Paths.font("tahoma.ttf"), 20, FlxColor.BLACK, FlxTextBorderStyle.OUTLINE,FlxColor.TRANSPARENT);
	inputText.hasFocus = true;
	inputText.maxLength = 32;
	inputText.borderSize = 0.1;
	add(inputText);

	modesText = new FlxText(FlxG.width * 0.7, 5, 0, "", 42);
	modesText.setFormat(Paths.font("Small Print.ttf"), 42, FlxColor.WHITE, 'center');
	modesText.y += 580;
	modesText.x -= 730;
	modesText.alpha = 1;
	add(modesText);

	whiteScreen = new FlxSpriteExtra(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	whiteScreen.alpha = 0;
	add(whiteScreen);
					
	inputText.callback = function(text, action)
	{
		if (action == 'enter')
		{
			enteredCode(text);
		}
		isWriting = true;
	}

	if(FlxG.sound.music == null) {
		FlxG.sound.playMusic(Paths.music('secret_menu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 1);
	}

	FlxTween.tween(barTitle, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(barTitle, {y: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(tipPopUp, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(tipPopUp, {x: 0}, 0.4, {ease:FlxEase.smoothStepInOut,
		onComplete: function(tween:FlxTween)
		{
			FlxTween.tween(tipPopUp, {y: tipPopUp.y + 15}, 3, {ease:FlxEase.smoothStepInOut, type: FlxEase.PINGPONG});
		}
	});

	FlxTween.tween(convertPopUp, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(convertPopUp, {x: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

	new FlxTimer().start(0.4, function(lol:FlxTimer)
	{
		coolDown = false;
	});

	goofyImage = new FlxSprite(0,0);
	goofyImage.screenCenter();
	goofyImage.alpha = 0;
	add(goofyImage);

	FlxG.mouse.visible = true;
	FlxG.mouse.unload();
	FlxG.mouse.load(Paths.image("EProcess/alt", 'chapter1').bitmap, 1.5, 0);
		
	if (ClientPrefs.shaders) FlxG.camera.setFilters([shaderFilter]);
}
	
override function beatHit()
{

	if (!selectedSmth) {
		FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD}); //lol
	}
}
override function update(elapsed:Float)
{
	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;
		
	Conductor.songPosition = FlxG.sound.music.time;

	if (!selectedSmth && !coolDown)
	{
		if (FlxG.keys.justPressed.ANY) FlxG.sound.play(Paths.sound('keyboardPress'));

		if (controls.BACK && !isWriting)
		{
			glitchBGHUD.alpha = 1;
			FlxG.sound.music.fadeOut();
				
			var shit:FlxSound = new FlxSound().loadEmbedded(Paths.sound('glitch'));
			shit.play(true);
			shit.onComplete = function() {
				FlxG.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Paths.clearUnusedMemory();
			}
				
			escapeTween();
				
			selectedSmth = true;
		}
	}

	isWriting = false;
}

function escapeTween()
{
	FlxTween.tween(barTitle, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(barTitle, {y: -150}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(tipPopUp, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(tipPopUp, {x: 250}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(convertPopUp, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(convertPopUp, {x: -250}, 0.4, {ease:FlxEase.smoothStepInOut});
}

function enteredCode(text:String)
{
	if (selectedSmth) return;

	for (i in 0...codesAndShit.length){
		if (text.toLowerCase() == codesAndShit[i][0]){
			trace('the code ' + codesAndShit[i][0] + ' is correct and it unlocks the song ' + codesAndShit[i][1] + '!');

			CoolUtil.songsUnlocked.data.songs.set(codesAndShit[i][1], true);
			CoolUtil.songsUnlocked.flush();
			secretCounter += 1;

			PlayState.storyPlaylist = [codesAndShit[i][1]];
			PlayState.isStoryMode = false;
			PlayState.vaultSong = true;

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());

			selectedSmth = true;
						
			FlxG.sound.music.stop();
			if(ClientPrefs.screenShake) FlxG.camera.shake(0.035, 7);
			FlxTween.tween(whiteScreen, {alpha:1}, 3, { onComplete: function(twn:FlxTween) {
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
				{
					if (FreeplayState.minimizeWindowArray.contains(codesAndShit[i][1].toLowerCase()))
					{
						Lib.application.window.resizable = false;
						FlxG.scaleMode = new StageSizeScaleMode();
						FlxG.resizeGame(360, 720);
						FlxG.resizeWindow(960, 720);
					}

					LoadingState.loadAndSwitchState(new PlayState(), true);
					FreeplayState.destroyFreeplayVocals();
				});
			}});
			return;
		}
	}

	for (i in 0...randomImages.length){
		if (text.toLowerCase() == randomImages[i][0]){
			if (goofyTween != null) goofyTween.cancel();

			goofyImage.loadGraphic(Paths.image('vault/secrets/${randomImages[i][1]}'));
			goofyImage.screenCenter();
			goofyImage.alpha = 1;
			FlxG.sound.play(Paths.sound('vine-boom'), 1);
			goofyTween = FlxTween.tween(goofyImage, {alpha: 0}, 0.5, {
				startDelay: 0.5,
				onComplete: function(twn:FlxTween) {
					goofyTween = null;
				}
			});

			return;
		}
	}

	if (wrongTimer != null) wrongTimer.cancel();
	if (wrongTween != null) wrongTween.cancel();

	var wrongInt = FlxG.random.int(0, wrongTextArray.length-1);
	if(ClientPrefs.screenShake) FlxG.camera.shake(0.015, 0.5);
	FlxG.sound.play(Paths.sound('fault'), 0.3);
	if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.RED, 0.4);

	wrong.alpha = 1;
	wrong.text = wrongTextArray[wrongInt];

	wrongTimer = new FlxTimer().start(2, function(tmr:FlxTimer) {
		wrongTimer = null;

		wrongTween = FlxTween.tween(wrong, {alpha:0}, 1, 
		{
			onComplete: function(twn:FlxTween) {
				wrongTween = null;
			}
		});
	});
}