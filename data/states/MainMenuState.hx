import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import funkin.menus.credits.CreditsMain;
import flixel.text.FlxTextBorderStyle;
import flixel.addons.text.FlxTypeText;
import funkin.menus.StoryMenuState;
import funkin.options.OptionsMenu;
import flixel.math.FlxMath;
import flixel.FlxObject;
import openfl.Lib;

static var curSelected:Int = 0;

var menuItems = new FlxTypedGroup();
var camGF = new FlxCamera();
var optionShit:Array<String> = [
	'freeplay','storymode',
	'credits','art_gallery',
	'vault','options'
];
var optionShit_NO_STORY:Array<String> = [
	'art_gallery','storymode',
	'credits','options'
];

var camFollow = new FlxObject(0, 0, 1, 1);
var camFollowPos = new FlxObject(0, 0, 1, 1);
var scrollingThing = new FlxBackdrop(Paths.image('menus/mainmenu/scroll'), FlxAxes.XY, 0, 0);
var spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var colorTween:FlxTween;
var bg = new FlxSprite(-80, 75).loadGraphic(Paths.image('menus/mainmenu/bg'));
var vignette = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/vignette'));
public var camHUD = new FlxCamera();
var typin:String;
var KONAMI:String = 'up up down down left right left right b a ';
var codeClearTimer:Float;

public static var showTyping:Bool = false;
var typinText:FlxText;
var menuText = new FlxText(0, 0, FlxG.width, 'MAIN MENU', 29);
var itemsText = new FlxText(0, 0, FlxG.width, '', 18);
var glitchBG = new FlxSprite(450, 215);
var shaderFloat:Float = 0;

var recentMouseOption:Int;

var newToTheMod:Bool = false;

var gfPopup = new FlxSprite().loadGraphic(Paths.image('menus/gfDialog/gfDialog'));
var blackThingIG = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
var textPopup:FlxText;
public static var POPUP_TEXT = 'Hey!, Would you like to sing with me on my new Tutorial song?, before starting a new game of course. \n\n Press enter to play the tutorial or escape to continue normally';
public static var gfMoment:Bool;
var targetAlphaCamPopup:Int = 0;

var chromb = new CustomShader("ChromaticAberrationShader");
var crtShader = new CustomShader("CRT"); 
var finishedZoom:Bool = false;
var star = new FlxSprite(1200, 15).loadGraphic(Paths.image('menus/mainmenu/star'));

var colorsMap:Map<String, FlxColor> = [
	'storymode' => FlxColor.ORANGE, 'freeplay' => FlxColor.CYAN,
	'credits' => 0xFF3de66f, 'art_gallery' => FlxColor.YELLOW,
	'vault' => FlxColor.BLACK, 'options' => FlxColor.WHITE,
];

var starThingOpened = false;

function create() {
	//Stops_it_from_soft-locking_when_exiting_the_editors.
	if(FlxG.sound.music == null) 
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

	camGF.bgColor = 0x00000000;
	camHUD.bgColor = 0x00000000;
	FlxG.cameras.add(camHUD, false);
	FlxG.cameras.add(camGF, false);

	camGF.alpha = targetAlphaCamPopup;

	transIn = FlxTransitionableState.defaultTransIn;
	transOut = FlxTransitionableState.defaultTransOut;

	persistentUpdate = persistentDraw = true;

	Lib.application.window.title = "Computerized Conflict - Main Menu - Theme by: DangDoodle";
	FlxG.camera.zoom = 5;

	bg.scrollFactor.set();
	bg.updateHitbox();
	bg.screenCenter();
	//bg.antialiasing = ClientPrefs.globalAntialiasing;
	add(bg);

	scrollingThing.alpha = 0.9;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.7));
	add(scrollingThing);

	var circVignette = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/circVig'));
	circVignette.scrollFactor.set();
	add(circVignette);

	vignette.scrollFactor.set();
	add(vignette);

	spikes1.y -= 60;
	spikes1.scrollFactor.set();
	spikes1.flipY = true;
	add(spikes1);

	spikes2.y += 630;
	spikes2.scrollFactor.set();
	add(spikes2);

	menuText.setFormat(Paths.font("phantommuff.ttf"), 39, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	menuText.x -= 630;
	menuText.y -= 340;
	add(menuText);

	itemsText.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	itemsText.y += 300;
	itemsText.x -= 630;
	add(itemsText);

	add(camFollow);
	add(camFollowPos);

	FlxG.mouse.visible = true;

	FlxG.mouse.load(Paths.image("EProcess/alt", 'chapter1').bitmap, 1.5, 0);

	/*if (CoolUtil.songsUnlocked == null) {
		trace('null null null');
		CoolUtil.songsUnlocked = new FlxSave();
		CoolUtil.songsUnlocked.bind("Computarized-Conflict");

		if (CoolUtil.songsUnlocked.data.songs == null) {
			CoolUtil.songsUnlocked.data.songs = new Map<String, Bool>[];
			for (i in 0...VaultState.codesAndShit.length){
				CoolUtil.songsUnlocked.data.songs.set(VaultState.codesAndShit[i][1], false);
			}
		}
		if (CoolUtil.songsUnlocked.data.alanSongs == null) {
			CoolUtil.songsUnlocked.data.alanSongs = new Map<String, Bool>();
			for (i in 0...FreeplayState.alanSongs.length) {
				CoolUtil.songsUnlocked.data.alanSongs.set(FreeplayState.alanSongs[i], false);
			}
				
			CoolUtil.songsUnlocked.data.cutsceneSeen = false;
		}
		if (CoolUtil.songsUnlocked.data.mainWeek == null) {
			CoolUtil.songsUnlocked.data.mainWeek = false;

			newToTheMod = true;
		}
		if (CoolUtil.songsUnlocked.data.songsPlayed == null) {
			CoolUtil.songsUnlocked.data.songsPlayed = new Array<String>();

			for (i in 0...FreeplayState.alreadyShowedSongs.length) {
				CoolUtil.songsUnlocked.data.songsPlayed.push(FreeplayState.alreadyShowedSongs[i]);
			}
		}
		if (CoolUtil.songsUnlocked.data.weeksData == null) {
			CoolUtil.songsUnlocked.data.weeksData = new Map<String, Int>();
		}
		CoolUtil.songsUnlocked.flush();
	}*/

	if(FlxG.save.data.songsUnlocked_seenCredits != null && FlxG.save.data.songsUnlocked_mainWeek) {
		blackThingIG.camera = camGF;
		blackThingIG.screenCenter();
		blackThingIG.alpha = 0.5;
		add(blackThingIG);

		var TEXT_THANKS = 
		'Star:\n\n
		You have done something amazing!\n
		You have beaten this mod\'s main week,\n
		and now you are one more in the gang who reached this achievement.\n
		You have proven that with effort, you can do anything.\n
		We are proud of you.';

		textPopup = new FlxText(0, 0, FlxG.width, TEXT_THANKS, 22);
		textPopup.setFormat('VCR OSD Mono', 22, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textPopup.borderSize = 1.25;
		textPopup.camera = camGF;
		textPopup.screenCenter();
		add(textPopup);

		star.scrollFactor.set();
		//star.antialiasing = ClientPrefs.globalAntialiasing;
		star.camera = camHUD;

		add(star);
		trace("You_winner");
	}

	if (!FlxG.save.data.songsUnlocked_mainWeek) optionShit = optionShit_NO_STORY;

	add(menuItems);

	for (i in 0...optionShit.length) {
		var menuItem:FlxSprite = new FlxSprite(50, 50).loadGraphic(Paths.image('menus/mainmenu/' + optionShit[i]));
		menuItem.ID = i;
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 4) * 0.135;
		if(optionShit.length < 6) scr = 0;
		menuItem.scrollFactor.set(0, scr);
		//menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.setGraphicSize(Std.int(menuItem.width * 0.2));

		var off = 0;
		var off_NO_STORY = 0;
		var fuckOPTIONS = 0;
		if(FlxG.save.data.songsUnlocked_mainWeek) off = -100;
		else {off_NO_STORY = -50; fuckOPTIONS = 250;}

		switch(i) {
			case 0:
				menuItem.x = 100 + off_NO_STORY;
				menuItem.y = 100 + off;
			case 1:
				menuItem.x = 500 + off_NO_STORY;
				menuItem.y = 150 + off;
			case 2:
				menuItem.x = 930 + off_NO_STORY;
				menuItem.y = 130 + off;
			case 3:
				menuItem.x = 245 + off + off_NO_STORY + fuckOPTIONS;
				menuItem.y = 385 + off;
			case 4:
				menuItem.x = 610 + off;
				menuItem.y = 385 + off;
			case 5:
				menuItem.x = 950 + off;
				menuItem.y = 385 + off;
		}

		menuItem.scale.x = menuItem.scale.y = 0.25;

		menuItem.updateHitbox();
	}

	FlxG.camera.follow(camFollowPos, null, 1);

	if (showTyping) {
		typinText = new FlxText(0, FlxG.height / 16, 0, "", 12);
		typinText.scrollFactor.set();
		typinText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(typinText);
		trace("ShowTyping");
	}

	glitchBG.frames = Paths.getSparrowAtlas('menus/vault/newGlitchBG');
	glitchBG.animation.addByPrefix('g', 'g', 24, true);
	glitchBG.animation.play('g');
	glitchBG.scrollFactor.set(0.9,0.9);
	glitchBG.camera = camHUD;
	glitchBG.screenCenter();
	//glitchBG.antialiasing = ClientPrefs.globalAntialiasing;
	glitchBG.alpha = 0.0001;
	add(glitchBG);


	FlxG.camera.addShader(chromb);

	changeItem(0);

	FlxG.camera.addShader(crtShader);

	FlxTween.tween(FlxG.camera, {zoom:1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function() {
		finishedZoom = true;
	});
}

function createGFPopup()
{
	if (!newToTheMod) return; //why would you need to play the tutorial if you already know how to play like duh

	selectedSomethin = true;
	gfMoment = true;
	targetAlphaCamPopup = 1;

	blackThingIG = new FlxSpriteExtra().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
	blackThingIG.camera = camGF;
	blackThingIG.screenCenter();
	blackThingIG.alpha = 0.3;
	add(blackThingIG);

	gfPopup.camera = camGF;
	gfPopup.screenCenter();
	//gfPopup.antialiasing = ClientPrefs.globalAntialiasing;
	add(gfPopup);

	textPopup = new FlxText(0, 0, gfPopup.width - 80, POPUP_TEXT, 22);
	textPopup.setFormat(Paths.font("phantommuff.ttf"), 22, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	textPopup.borderSize = 1.25;
	textPopup.camera = camGF;
	textPopup.screenCenter();
	textPopup.x += 5;
	textPopup.y = gfPopup.y + textPopup.height + 10;
	add(textPopup);

	FlxG.sound.play(Paths.sound('ping'), 1);
}

var selectedSomethin:Bool = false;

var time:Float = 0;

override function update(elapsed:Float){time += elapsed;
	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		persistentDraw = true;
		import funkin.editors.EditorPicker;
		openSubState(new EditorPicker());
	}
	if (FlxG.keys.justPressed.SIX) {
		FlxG.switchState(new FreeplayState());
		FlxG.save.data.songsUnlocked_mainWeek=true;
		trace("DON'T_FORGET_TO_REMOVE_THIS_IN_THE_FINAL");
	}
	if (controls.SWITCHMOD) {
		import funkin.menus.ModSwitchMenu;
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}
	if (FlxG.sound.music.volume < 0.8)  FlxG.sound.music.volume += 0.5 * elapsed;

	var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

	scrollingThing.y -= 0.16 * 60 * elapsed;

	scrollingThing.x = spikes2.x = spikes1.x -= 0.45 * 60 * elapsed;

	menuItems.forEach(function(menuItem:FlxSprite){
		menuItem.updateHitbox();
	});

	if (!selectedSomethin && finishedZoom) {
		if (controls.RIGHT_P||controls.LEFT_P){
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(controls.RIGHT_P ? 1 : -1);
		}
		if (controls.UP_P||controls.DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			var targetOption:Int = curSelected + 3;
			if (curSelected > 2) targetOption = curSelected - 3;
			if (!FlxG.save.data.songsUnlocked_mainWeek) {
				if(curSelected == 3) //options menu
					targetOption = 1;
				else
					targetOption = 3;
			}
			changeItem(targetOption-curSelected);
		}
		if (controls.BACK) {
			selectedSomethin = true;
			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function(){
				FlxG.switchState(new ModState('TitleState'));});
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		if (controls.ACCEPT) loadState();

		menuItems.forEach(function(spr:FlxSprite) {
			if (FlxG.mouse.overlaps(spr) && !selectedSomethin && spr.ID != recentMouseOption){
				curSelected = spr.ID;

				changeItem(0);
				recentMouseOption = curSelected;
			}

			if (FlxG.mouse.justPressed){
				FlxG.sound.play(Paths.sound('mouseClick'));
				loadState();
			}

			spr.alpha = 0.5;
			spr.updateHitbox();

			if (spr.ID != curSelected){
				spr.scale.x += (0.23-spr.scale.x)/(1*time);
				spr.scale.y = spr.scale.x;
			}else{
				spr.alpha = 1;

				spr.scale.x += (0.26-spr.scale.x)/(1*time);
				spr.scale.y = spr.scale.x;

				spr.centerOffsets();
			}
			if (optionShit[curSelected] == 'vault') {
				FlxG.camera.shake(0.0035, 0.15);
				FlxG.camera.zoom = FlxMath.lerp(1.2, FlxG.camera.zoom, 0.7);
				FlxTween.tween(bg, {alpha:0}, 0.4);
				FlxTween.tween(vignette, {alpha:0}, 0.4);

				shaderFloat += Math.sin(time)* 0.00003;
				chromb.rOffset=shaderFloat;
				chromb.bOffset=shaderFloat*-1;
			    if (shaderFloat > 0.000001) shaderFloat = 0.000001;

				FlxG.sound.music.fadeIn(1, 0, 1);
			}
			else {
				FlxG.camera.zoom = 1;
				FlxTween.tween(bg, {alpha:1}, 0.4);
				FlxTween.tween(vignette, {alpha:1}, 0.4);
				shaderFloat -= time * 0.0015;
				if (shaderFloat < 0) shaderFloat = 0;
				chromb.rOffset=shaderFloat;
				chromb.bOffset=shaderFloat*-1;

				FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume * 1);
			}
		});

		if(codeClearTimer>0)codeClearTimer-=elapsed;
		if(codeClearTimer<=0)typin='';
		if(codeClearTimer<0)codeClearTimer=0;

		/*if(FlxG.keys.firstJustPressed()!=-1){
			var key:FlxKey = FlxG.keys.firstJustPressed();
			key = key.toString();

			typin += key + ' ';

			trace(key + ' // ' + typin);

			codeClearTimer = 1;
		}
		if (typin == KONAMI && FlxG.save.data.songsUnlocked_mainWeek){
			CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
			selectedSomethin = true;
			typin = 'LOADING REDZONE ERROR';
			PlayState.storyDifficulty = 2;
			PlayState.SONG = Song.loadFromJson('redzone-error-insane', 'redzone-error');
			PlayState.isStoryMode = false;
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}*/
		if (typinText != null){
			typinText.text = typin.toLowerCase() + '_';
			typinText.screenCenter(FlxAxes.X);
			typinText.y = FlxG.height / 16;
		}
	}

	if(selectedSomethin && starThingOpened) {
		if (controls.BACK) {
			starThingOpened = false;
			selectedSomethin = false;
			targetAlphaCamPopup = 0;
		}
	}

	camGF.alpha = FlxMath.lerp(camGF.alpha, targetAlphaCamPopup, lerpVal);

	if (gfMoment) {
		if (controls.BACK) {
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			targetAlphaCamPopup = 0;

			gfMoment = false;
			MusicBeatState.switchState(new TCOStoryState());
		}
		if (controls.ACCEPT) loadTutorial();
	}
}

function loadState() {
	if(starThingOpened) return;

	if(star != null && FlxG.mouse.overlaps(star) && FlxG.mouse.justPressed) {
		trace('star');
		startShitLolz();
		return;
	}

	selectedSomethin = true;
	FlxG.sound.play(Paths.sound('confirmMenu'));

	if(star != null) FlxTween.tween(star, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});

	menuItems.forEach(function(spr:FlxSprite) {
		if (curSelected != spr.ID) {
			FlxTween.tween(spr, {alpha: 0}, 0.4, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween) {
					spr.kill();
				}
			});
		}
		else {
			if (optionShit[curSelected] == 'vault') {
				glitchBG.alpha = 1;
				var shit:FlxSound = new FlxSound().loadEmbedded(Paths.sound('glitch'));
				shit.play(true);
				shit.onComplete = function() {
					//FlxG.switchState(new ModState('VaultState'));
					trace("NO_SOFTLOCK!!!");
					FlxG.resetState();
				}
			}

			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				switch (optionShit[curSelected]) {
					case 'storymode':
						if (newToTheMod) createGFPopup();
						else //FlxG.switchState(new ModState('TCOStoryState'));
						FlxG.switchState(new StoryMenuState());
					case 'freeplay': FlxG.switchState(new ModState('FreeplayMenu'));
					case 'awards': //FlxG.switchState(new ModState('AchievementsMenuState'));
					trace("NO_SOFTLOCK!!!");
					FlxG.resetState();
					case 'art_gallery': FlxG.switchState(new ModState('FanArtState'));
					//trace("NO_SOFTLOCK!!!"); FlxG.resetState();
					case 'credits':FlxG.switchState(new ModState('TCOCreditsState'));
					//trace("NO_SOFTLOCK!!!");FlxG.resetState();
					case 'options': FlxG.switchState(new OptionsMenu());
				}
			});
		}
	});
}

function startShitLolz() {
	selectedSomethin = true;

	starThingOpened = true;
	targetAlphaCamPopup = 1;

	FlxG.sound.play(Paths.sound('mouseClick'));
}

function loadTutorial() {
	targetAlphaCamPopup = 0;

	FlxG.sound.play(Paths.sound('confirmMenu'));

	PlayState.vaultSong = false;
	PlayState.loadSong("practice time", "hard");
	//LoadingState.loadAndSwitchState(new PlayState(), true);
}

function changeItem(huh:Int = 0) {
	curSelected += huh;

	if (curSelected >= menuItems.length) curSelected = 0;
	if (curSelected < 0) curSelected = menuItems.length - 1;

	if(colorTween != null) colorTween.cancel();

	var nameOfOptionSelected:String = optionShit[curSelected];

	colorTween = FlxTween.color(scrollingThing, 1, scrollingThing.color, colorsMap.get(nameOfOptionSelected), {
		onComplete: function(twn:FlxTween) {
			colorTween = null;
		}
	});

	colorTween = FlxTween.color(vignette, 1, vignette.color, colorsMap.get(nameOfOptionSelected), {
		onComplete: function(twn:FlxTween) {
			colorTween = null;
		}
	});

	itemsText.text = textChange(nameOfOptionSelected);
}
function textChange(tag:String) {
	switch(tag) {
		case 'storymode': return 'Face off against Alan Becker stick figures with the power of music!';

		case 'freeplay': return 'Play bonus songs and meet other stick figures, will you recognize them?';

		case 'credits': return 'Meet the people behind this mod!';

		case 'art_gallery': return 'Look at some art made by our followers!';

		case 'options': return 'Configure your controls and more to your preference!';
		
		case 'vault': return '...';
	}
	return '';
}