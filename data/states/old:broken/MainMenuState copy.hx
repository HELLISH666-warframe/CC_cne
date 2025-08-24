import flixel.addons.text.FlxTypeText;
import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import openfl.Lib;
import flixel.addons.display.FlxBackdrop;
//import flixel.system.FlxAssets.FlxShader;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
//import Shaders;
import flixel.util.FlxAxes;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import funkin.menus.ModSwitchMenu;
import flixel.text.FlxTextBorderStyle;
var elapsed:Float = 0;

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var camGame:FlxCamera;
	var camGF:FlxCamera;

	var optionShit:Array<String> = [
		'freeplay',
		'storymode',
		'credits',
		#if !web 'art_gallery', #end //I know that this mod is not getting ported to web but uh I was bored
		'vault',
		'options'
	];

	var optionShit_NO_STORY:Array<String> = [
		#if !web 'art_gallery', #end
		'storymode',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var scrollingThing:FlxBackdrop;
	var spikes1:FlxBackdrop;
	var spikes2:FlxBackdrop;
	var colorTween:FlxTween;
	var bg:FlxSprite;
	var vignette:FlxSprite;
	public var camHUD:FlxCamera;
	var typin:String;
	var KONAMI:String = 'up up down down left right left right b a ';
	var codeClearTimer:Float;

	public static var showTyping:Bool = false;
	var typinText:FlxText;
	var menuText:FlxText;
	var itemsText:FlxText;
	var glitchBG:BGSprite;
	var shaderFloat:Float = 0;

	public var camGameShaders:Array<ShaderEffect> = [];

	var recentMouseOption:Int;

	var newToTheMod:Bool = false;

	var gfPopup:FlxSprite;
	var blackThingIG:FlxSpriteExtra;
	var textPopup:FlxText;
	public static var POPUP_TEXT = 'Hey!, Would you like to sing with me on my new Tutorial song?, before starting a new game of course. \n\n Press enter to play the tutorial or escape to continue normally';
	public static var gfMoment:Bool;
	var targetAlphaCamPopup:Int = 0;

	var chrom:ChromaticAberrationEffect;
	var crtShader:CustomShader = new CustomShader("CRT"); 
	//var shaderFilter = new ShaderFilter(crtShader);
	var finishedZoom = false;
	var star:FlxSprite;

	var colorsMap:Map<String, FlxColor> =
	[
		'storymode' => FlxColor.ORANGE,
		'freeplay' => FlxColor.CYAN,
		'credits' => 0xFF3de66f,
		'art_gallery' => FlxColor.YELLOW,
		'vault' => FlxColor.BLACK,
		'options' => FlxColor.WHITE,
	];

	var starThingOpened = false;

	override function create()
	{

		camGame = new FlxCamera();
		camGame.bgColor = 0x00000000;
		camGF = new FlxCamera();
		camGF.bgColor = 0x00000000;
		//camGF.bgColor.alpha = 0;

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x00000000;
		//camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camGF, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		camGF.alpha = targetAlphaCamPopup;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

	    Lib.application.window.title = "Computerized Conflict - Main Menu - Theme by: DangDoodle";

		FlxG.camera.zoom = 5;

		bg = new FlxSprite(-80, 75).loadGraphic(Paths.image('menus/mainmenu/bg'));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		//bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		scrollingThing = new FlxBackdrop(Paths.image('menus/mainmenu/scroll'), FlxAxes.XY, 0, 0);
		scrollingThing.alpha = 0.9;
		scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.7));
		add(scrollingThing);

		var circVignette:FlxSprite = new FlxSprite();
		circVignette.loadGraphic(Paths.image('menus/mainmenu/circVig'));
		circVignette.scrollFactor.set();
		add(circVignette);

		vignette = new FlxSprite();
		vignette.loadGraphic(Paths.image('menus/mainmenu/vignette'));
		vignette.scrollFactor.set();
		add(vignette);


		spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
		spikes1.y -= 60;
		spikes1.scrollFactor.set();
		spikes1.flipY = true;
		add(spikes1);

		spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
		spikes2.y += 630;
		spikes2.scrollFactor.set();
		add(spikes2);

		menuText = new FlxText(0, 0, FlxG.width, 'MAIN MENU', 29);
		menuText.setFormat(Paths.font("phantommuff.ttf"), 39, FlxColor.WHITE, 'CENTER', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		menuText.x -= 630;
		menuText.y -= 340;
		add(menuText);

		itemsText = new FlxText(0, 0, FlxG.width, '', 18);
		itemsText.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.WHITE, 'CENTER', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		itemsText.y += 300;
		itemsText.x -= 630;
		add(itemsText);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		FlxG.mouse.visible = true;

		#if !web FlxG.mouse.load(Paths.image("menus/EProcess/alt").bitmap, 1.5, 0); #end

		/*if (CoolUtil.songsUnlocked == null)
		{
			trace('null null null');
			CoolUtil.songsUnlocked = new FlxSave();
			//CoolUtil.songsUnlocked.bind("Computarized-Conflict");

			if (CoolUtil.songsUnlocked.data.songs == null)
			{
				CoolUtil.songsUnlocked.data.songs = new Map();
				//CoolUtil.songsUnlocked.data.songs = new Map<String, Bool>();
				for (i in 0...VaultState.codesAndShit.length){
					CoolUtil.songsUnlocked.data.songs.set(VaultState.codesAndShit[i][1], false);
				}
			}

			if (CoolUtil.songsUnlocked.data.alanSongs == null)
			{
				//CoolUtil.songsUnlocked.data.alanSongs = new Map<String, Bool>();
				CoolUtil.songsUnlocked.data.alanSongs = new Map();
				for (i in 0...FreeplayState.alanSongs.length)
				{
					CoolUtil.songsUnlocked.data.alanSongs.set(FreeplayState.alanSongs[i], false);
				}
				
				CoolUtil.songsUnlocked.data.cutsceneSeen = false;
			}

			if (CoolUtil.songsUnlocked.data.mainWeek == null)
			{
				CoolUtil.songsUnlocked.data.mainWeek = false;

				newToTheMod = true;
			}

			if (CoolUtil.songsUnlocked.data.songsPlayed == null)
			{
				//CoolUtil.songsUnlocked.data.songsPlayed = new Array<String>();
				CoolUtil.songsUnlocked.data.songsPlayed = new Array();

				for (i in 0...FreeplayState.alreadyShowedSongs.length)
				{
					CoolUtil.songsUnlocked.data.songsPlayed.push(FreeplayState.alreadyShowedSongs[i]);
				}
			}

			if (CoolUtil.songsUnlocked.data.weeksData == null)
			{
				//CoolUtil.songsUnlocked.data.weeksData = new Map<String, Int>();
				CoolUtil.songsUnlocked.data.weeksData = new Map();
			}

			CoolUtil.songsUnlocked.flush();
		}*/

		/*if(CoolUtil.songsUnlocked.data.seenCredits != null && CoolUtil.songsUnlocked.data.mainWeek)
		{
			blackThingIG = new FlxSpriteExtra().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
			blackThingIG.cameras = [camGF];
			blackThingIG.screenCenter();
			blackThingIG.alpha = 0.5;
			add(blackThingIG);

			var TEXT_THANKS = 
			'
			Star:\n\n
			You have done something amazing!\n
			You have beaten this mod\'s main week,\n
			and now you are one more in the gang who reached this achievement.\n
			You have proven that with effort, you can do anything.\n
			We are proud of you.
			';

			textPopup = new FlxText(0, 0, FlxG.width, TEXT_THANKS, 22);
			textPopup.setFormat('VCR OSD Mono', 22, FlxColor.WHITE, 'CENTER', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			textPopup.borderSize = 1.25;
			textPopup.cameras = [camGF];
			textPopup.screenCenter();
			add(textPopup);

			star = new FlxSprite(1200, 15).loadGraphic(Paths.image('mainmenu/star'));
			star.scrollFactor.set();
			//star.antialiasing = ClientPrefs.globalAntialiasing;
			star.cameras = [camHUD];

			add(star);
		}*/

		//if (!CoolUtil.songsUnlocked.data.mainWeek) optionShit = optionShit_NO_STORY;

		//menuItems = new FlxTypedGroup<FlxSprite>();
		menuItems = new FlxTypedGroup();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(50, 50); //with this the positions will never work
			menuItem.loadGraphic(Paths.image('menus/mainmenu/' + optionShit[i]));
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
			//if(CoolUtil.songsUnlocked.data.mainWeek) off = -100;
			/*else*/ {off_NO_STORY = -50; fuckOPTIONS = 250;}

			switch(i)
			{
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

			menuItem.scale.x = 0.25;
			menuItem.scale.y = 0.25;

			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		if (showTyping){
			typinText = new FlxText(0, FlxG.height / 16, 0, "", 12);
			typinText.scrollFactor.set();
			typinText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, 'CENTER', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(typinText);
		}

		glitchBG = new FlxSprite(450, 215).loadGraphic(Paths.image('menus/vault/newGlitchBG'));
		//glitchBG = new BGSprite('vault/newGlitchBG', 450, 215, 0.9, 0.9, ['g'], true);
		glitchBG.cameras = [camHUD];
		glitchBG.screenCenter();
		//glitchBG.antialiasing = ClientPrefs.globalAntialiasing;
		glitchBG.alpha = 0.0001;
		add(glitchBG);

		//chrom = new ChromaticAberrationEffect(0);

		//if (ClientPrefs.shaders) addShaderToCamera('camgame', chrom);

		changeItem();

		//if (ClientPrefs.shaders) FlxG.camera.setFilters([shaderFilter]);
		
		FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function()
		{
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
		blackThingIG.cameras = [camGF];
		blackThingIG.screenCenter();
		blackThingIG.alpha = 0.3;
		add(blackThingIG);

		gfPopup = new FlxSprite().loadGraphic(Paths.image('menus/gfDialog/gfDialog'));
		gfPopup.cameras = [camGF];
		gfPopup.screenCenter();
		//gfPopup.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfPopup);

		textPopup = new FlxText(0, 0, gfPopup.width - 80, POPUP_TEXT, 22);
		textPopup.setFormat(Paths.font("phantommuff.ttf"), 22, FlxColor.WHITE, 'CENTER', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textPopup.borderSize = 1.25;
		textPopup.cameras = [camGF];
		textPopup.screenCenter();
		textPopup.x += 5;
		textPopup.y = gfPopup.y + textPopup.height + 10;
		add(textPopup);

		FlxG.sound.play(Paths.sound('ping'), 1);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		elapsed += elapsed;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		scrollingThing.x -= 0.45 * 60 * elapsed;
		scrollingThing.y -= 0.16 * 60 * elapsed;

		scrollingThing.alpha = 0.9;

		spikes1.x -= 0.45 * 60 * elapsed;
		spikes2.x -= 0.45 * 60 * elapsed;

		menuItems.forEach(function(menuItem:FlxSprite){
			menuItem.updateHitbox();
		});

		if (!selectedSomethin && finishedZoom)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UP_P || controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				var targetOption:Int = curSelected + 3;
				if (curSelected > 2) targetOption = curSelected - 3;
				/*if (!CoolUtil.songsUnlocked.data.mainWeek)
				{
					if(curSelected == 3) //options menu
					{
						targetOption = 1;
					}
					else*/
					
					{
						targetOption = 3;
					}
				//}

				changeItem(targetOption-curSelected);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
				{
					MusicBeatState.switchState(new TitleState());
				});
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if (controls.ACCEPT)
			{
				loadState();
			}
			if (FlxG.keys.justPressed.SEVEN) {
				persistentUpdate = false;
				persistentDraw = true;
				import funkin.editors.EditorPicker;
				openSubState(new EditorPicker());
			}
			if (controls.SWITCHMOD) {
				openSubState(new ModSwitchMenu());
				persistentUpdate = false;
				persistentDraw = true;
			}

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (FlxG.mouse.overlaps(spr) && !selectedSomethin && spr.ID != recentMouseOption)
				{
					curSelected = spr.ID;

					changeItem();
					recentMouseOption = curSelected;
				}

				if (FlxG.mouse.justPressed){
					FlxG.sound.play(Paths.sound('mouseClick'));
					loadState();
				}

				spr.alpha = 0.5;
				spr.updateHitbox();


				if (spr.ID != curSelected){
					spr.scale.x += (0.23-spr.scale.x)/(250*elapsed);
					spr.scale.y = spr.scale.x;
				}else{
					spr.alpha = 1;

					spr.scale.x += (0.26-spr.scale.x)/(250*elapsed);
					spr.scale.y = spr.scale.x;

					spr.centerOffsets();
				}

				if (optionShit[curSelected] == 'vault')
				{
					FlxG.camera.shake(0.0035, 0.15);
					FlxG.camera.zoom = FlxMath.lerp(1.2, FlxG.camera.zoom, 0.7);
					FlxTween.tween(bg, {alpha:0}, 0.4);
					FlxTween.tween(vignette, {alpha:0}, 0.4);

					/*shaderFloat += elapsed * 0.0015;
					chrom.setChrome(shaderFloat);
				    if (shaderFloat > 0.0085) shaderFloat = 0.0085;*/

					FlxG.sound.music.fadeIn(1, 0, 1);
				}
				else
				{
					FlxG.camera.zoom = 1;
					FlxTween.tween(bg, {alpha:1}, 0.4);
					FlxTween.tween(vignette, {alpha:1}, 0.4);
					/*shaderFloat -= elapsed * 0.0015;
					if (shaderFloat < 0) shaderFloat = 0;
					chrom.setChrome(shaderFloat);*/

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

			/*if (typin.toLowerCase() == KONAMI && CoolUtil.songsUnlocked.data.mainWeek){
				CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
				selectedSomethin = true;
				typin = 'LOADING REDZONE ERROR';
				PlayState.storyDifficulty = 2;
				PlayState.SONG = Song.loadFromJson('redzone-error-insane', 'redzone-error');
				PlayState.isStoryMode = false;
				LoadingState.loadAndSwitchState(new PlayState(), true);
			}

			if (typinText != null){
				typinText.text = typin.toLowerCase() + '_';
				typinText.screenCenter(FlxAxes.X);
				typinText.y = FlxG.height / 16;
			}*/
		}

		if(selectedSomethin && starThingOpened)
		{
			if (controls.BACK)
			{
				starThingOpened = false;
				selectedSomethin = false;
				targetAlphaCamPopup = 0;
			}
		}

		camGF.alpha = FlxMath.lerp(camGF.alpha, targetAlphaCamPopup, lerpVal);

		if (gfMoment)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				targetAlphaCamPopup = 0;

				gfMoment = false;
				MusicBeatState.switchState(new TCOStoryState());
			}

			if (controls.ACCEPT)
			{
				loadTutorial();
			}
		}
	}

	function loadState()
	{
		if(starThingOpened) return;

		if(star != null && FlxG.mouse.overlaps(star) && FlxG.mouse.justPressed)
		{
			trace('star');
			startShitLolz();
			return;
		}

		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		if(star != null) FlxTween.tween(star, {alpha: 0}, 0.4, {ease: FlxEase.expoIn});

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{

				if (optionShit[curSelected] == 'vault')
				{
					glitchBG.alpha = 1;
					var shit:FlxSound = new FlxSound().loadEmbedded(Paths.sound('glitch'));
					shit.play(true);
					shit.onComplete = function() {
						FlxG.switchState(new VaultState());
					}
				}

				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					var daChoice:String = optionShit[curSelected];

					switch (daChoice)
					{
						case 'storymode':
							if (newToTheMod) createGFPopup();
							else MusicBeatState.switchState(new TCOStoryState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayMenu());
						case 'awards':
							MusicBeatState.switchState(new AchievementsMenuState());
						case 'art_gallery':
							#if !web MusicBeatState.switchState(new FanArtState()); #end
						case 'credits':
							MusicBeatState.switchState(new TCOCreditsState());
						case 'options':
							LoadingState.loadAndSwitchState(new options.OptionsState());
					}
				});
			}
		});
	}

	function startShitLolz()
	{
		selectedSomethin = true;

		starThingOpened = true;
		targetAlphaCamPopup = 1;

		FlxG.sound.play(Paths.sound('mouseClick'));
	}

	function loadTutorial()
	{
		targetAlphaCamPopup = 0;

		FlxG.sound.play(Paths.sound('confirmMenu'));

		PlayState.storyPlaylist = ['practice time'];
		PlayState.isStoryMode = false;
		PlayState.vaultSong = false;
		PlayState.storyDifficulty = 1; //hard (I think?)

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
		LoadingState.loadAndSwitchState(new PlayState(), true);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		if(colorTween != null) {
			colorTween.cancel();
		}

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

    public function addShaderToCamera(cam:String, effect:ShaderEffect){//STOLE FROM ANDROMEDA

		switch(cam.toLowerCase()) {
			case 'camgame' | 'game':
					camGameShaders.push(effect);
					var newCamEffects:Array<BitmapFilter>=[];
					for(i in camGameShaders){
					  newCamEffects.push(new ShaderFilter(i.shader));
					}
					camGame.setFilters(newCamEffects);
		}
	}

	public function removeShaderFromCamera(cam:String, effect:ShaderEffect){
		switch(cam.toLowerCase()) {
			case 'camgame' | 'game':
				camGameShaders.remove(effect);
				var newCamEffects:Array<BitmapFilter> = [];
				for (i in camGameShaders){
					newCamEffects.push(new ShaderFilter(i.shader));
				}
				camGame.setFilters(newCamEffects);
		}
	}

	function textChange(tag:String)
	{
		switch(tag)
		{
			case 'storymode': return 'Face off against Alan Becker stick figures with the power of music!';

			case 'freeplay': return 'Play bonus songs and meet other stick figures, will you recognize them?';

			case 'credits': return 'Meet the people behind this mod!';

			case 'art_gallery': return 'Look at some art made by our followers!';

			case 'options': return 'Configure your controls and more to your preference!';
			
			case 'vault': return '...';
		}

		return '';
	}