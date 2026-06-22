import funkin.backend.utils.FunkinParentDisabler;
import funkin.options.keybinds.KeybindsOptions;
import flixel.addons.display.FlxBackdrop;
import funkin.editors.charter.Charter;
import flixel.text.FlxTextBorderStyle;
import funkin.options.OptionsMenu;

var grpMenuShit = new FlxTypedGroup();

var menuItems:Array<String> = [];
var menuItemsOG:Array<String> = ['RESUME','RESTART SONG','CHANGE CONTROLS','CHANGE OPTIONS','CHANGE DIFFICULTY','EXIT TO MENU'];
var difficultyChoices = [];
var curSelPSS:Int = 0;

var pauseMusic = FlxG.sound.load(Paths.music('pauseTCO'), 0, true);
var portrait:FlxSprite;
var coolDown:Bool = true;
var gfMoment:Bool = MainMenuState.gfMoment;//FlxG.save.data_anyone?

function create() {
	add(pD = new FunkinParentDisabler());
	if(PlayState.SONG.meta.difficulties.length < 2) menuItemsOG.remove('Change Difficulty');

	if(PlayState.chartingMode) {
		menuItemsOG.insert(2, 'Leave Charting Mode');
		menuItemsOG.insert(3, 'End Song');
		menuItemsOG.insert(4, 'Toggle Practice Mode');
		menuItemsOG.insert(5, 'Toggle Botplay');
	}
	menuItems = menuItemsOG;

	for (i in 0...PlayState.SONG.meta.difficulties.length) difficultyChoices.push(PlayState.SONG.meta.difficulties[i]);
	difficultyChoices.push('BACK');

	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

	add(scrollingThing = new FlxBackdrop(Paths.image('menus/pauseMenu/scroll'),FlxAxes.XY)).color = PlayState.instance.dad.iconColor;
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));

	add(vignette = new FlxSprite().loadGraphic(Paths.image('menus/pauseMenu/vignette'))).scrollFactor.set();
	add(bar = new FlxSprite().loadGraphic(Paths.image('menus/pauseMenu/bar'))).scrollFactor.set();
		
	add(spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'),FlxAxes.X)).y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;

	portrait = new FlxSprite(250, 0).loadGraphic(Paths.image('menus/pauseMenu/chars/' + PlayState.instance.dad.curCharacter));
	portrait.scrollFactor.set();
	portrait.antialiasing = Options.antialiasing;
	portrait.setGraphicSize(Std.int(portrait.width * 0.8));
	if (portrait != null) add(portrait);

	add(pauseText = new FlxSprite(0, -150).loadGraphic(Paths.image('menus/pauseMenu/text'))).scrollFactor.set();
	add(arrow = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/pauseMenu/arrow'))).scrollFactor.set();

	add(spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'),FlxAxes.X)).y += 630;
	spikes2.scrollFactor.set(0, 0);

	for(i in [spikes2,pauseText,portrait,spikes1,bar,vignette,scrollingThing]) i.alpha=0;

	if (PlayState.instance.scripts.get('oldVideoResolution')) {bar.x -= 270; portrait.x -= 270; arrow.alpha = 0;}

	add(practiceText = new FlxText(1009,116,0,"PRACTICE MODE")).visible = PlayState.instance.scripts.get('practiceMode');
	practiceText.scrollFactor.set();
	practiceText.setFormat(Paths.font('vcr.ttf'), 32);

	add(chartingText = new FlxText(1009,667, 0, "CHARTING MODE")).visible = PlayState.chartingMode;
	chartingText.scrollFactor.set();
	chartingText.setFormat(Paths.font('vcr.ttf'), 32);

	FlxTween.tween(scrollingThing, {alpha:0.9}, 0.4, {ease: FlxEase.quartInOut});
	for(i in [spikes1,spikes2,bar,pauseText])
	FlxTween.tween(i, {alpha:1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(vignette, {alpha: 0.75}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(portrait, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(arrow, {x: arrow.x + 10}, 1, {ease:FlxEase.smoothStepInOut, type: FlxTween.PINGPONG});
	FlxTween.tween(pauseText, {y: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(portrait, {x: PlayState.instance.scripts.get('oldVideoResolution')?-140:128}, 0.4, {ease:FlxEase.smoothStepInOut});

	add(grpMenuShit);

	new FlxTimer().start(0.4, ()->{coolDown = false;});

	regenMenu();
	cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
}

var holdTime:Float = 0;
var cantUnpause:Float = 0.1;
function update(elapsed:Float) {
	if(PlayState.instance.scripts.get('oldVideoResolution')) FlxG.fullscreen = false;
	cantUnpause -= elapsed;
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

	scrollingThing.y -= 0.16 * 60 * elapsed;
	scrollingThing.x = spikes1.x = spikes2.x -= 0.45 * 60 * elapsed;

	if (controls.UP_P||controls.DOWN_P) changeSelection(controls.UP_P?-1:1);

	if (controls.ACCEPT && cantUnpause <= 0 && !coolDown) {
		if (menuItems == difficultyChoices) {
			if(menuItems.length - 1 != curSelPSS && difficultyChoices.contains(menuItems[curSelPSS])) {
				PlayState.loadSong(PlayState.SONG.meta.name, PlayState.SONG.meta.difficulties[curSelPSS]);
				//PlayState.storyDifficulty = curSelPSS;
				FlxG.resetState();
				PlayState.changedDifficulty = true;
				PlayState.chartingMode = false;
				return;
			}
		}

		switch (menuItems[curSelPSS]) {
			case "RESUME":goodByePortrait();coolDown=true;
			new FlxTimer().start(0.4, ()->{close();
				if (PlayState.SONG.meta.displayName.toLowerCase() == 'end process'
				&& PlayState.instance.popUpTimer != null) PlayState.instance.popUpTimer.active = true;
			});
			case 'CHANGE DIFFICULTY':menuItems = difficultyChoices; regenMenu();
			case "BACK":menuItems = menuItemsOG; regenMenu();
			case 'Toggle Practice Mode':
			PlayState.instance.scripts.set('practiceMode',!PlayState.instance.scripts.get('practiceMode'));
			PlayState.changedDifficulty = true;
			practiceText.visible = PlayState.instance.scripts.get('practiceMode');
			case "RESTART SONG":FlxG.resetState();
			case "CHANGE CONTROLS":persistentDraw = false; openSubState(new KeybindsOptions());
			case "CHANGE OPTIONS": FlxG.switchState(new OptionsMenu((_) -> FlxG.switchState(new PlayState())));
			case "Leave Charting Mode":FlxG.resetState();
			PlayState.chartingMode = false;
			case "End Song":close(); PlayState.instance.endSong();
			case 'Toggle Botplay':
			PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
			PlayState.changedDifficulty = true;
			PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
			PlayState.instance.botplayTxt.alpha = 1;
			PlayState.instance.botplaySine = 0;
			case "EXIT TO MENU":
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			if (PlayState.chartingMode && Charter.undos.unsaved) PlayState.instance.saveWarn(false);
			else if(PlayState.isStoryMode)FlxG.switchState(new StoryMenuState());
			else if(gfMoment) {
				FlxG.switchState(new MainMenuState());
				MainMenuState.gfMoment = false;
			} else FlxG.switchState(new ModState('tco/FreeplayMenu'));
			PlayState.cancelMusicFadeTween();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
			PlayState.chartingMode = false;
		}
	}
}

function destroy() {FlxG.sound.destroySound(pauseMusic);}

function changeSelection(change:Int = 0) {
	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

	curSelPSS = FlxMath.wrap(curSelPSS+change,0,menuItems.length-1);

	for (i in grpMenuShit.members) {
		i.alpha = 0.6;
		if(scrollingThing.color == -1) i.color = 0xFF000000; //if the bg is white, make the things black
		else i.color = 0xFFFFFFFF; //else, make it white
		FlxTween.tween(i, {x: i.ID==curSelPSS?100:90}, 0.3, {ease:FlxEase.smoothStepInOut});

		if (i.ID== curSelPSS) {
			i.alpha = 1;
			i.color = 0xFFFFF777;

			arrow.y = i.y - 20;
		}
	}
}

function regenMenu() {
	for (i in 0...grpMenuShit.members.length) {
		var obj = grpMenuShit.members[0];
		obj.kill();
		grpMenuShit.remove(obj, true);
		obj.destroy();
	}

	for (i in 0...menuItems.length) {
		var item = new FlxText(90, (i * 100) + 280,null,menuItems[i]);
		item.setFormat(Paths.font("Small Print.ttf"), 54, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		item.scrollFactor.set();
		if(scrollingThing.color == -1) item.color = 0xFF000000; //if the bg is white, make the things black

		if (menuItems.length > 4){item.scale.y = 4 / menuItems.length; item.scale.x = 8/menuItems.length;}

		item.y = ((i * 100) * item.scale.y) + 230;

		item.width = item.width*item.scale.y;
		item.updateHitbox();
		item.ID=i;

		grpMenuShit.add(item);
	}
	curSelPSS = 0;
	changeSelection(0);
}

function goodByePortrait() {
	FlxTween.cancelTweensOf(arrow);
	for (i in grpMenuShit.members) {FlxTween.tween(i, {x: i.x - 500}, 0.4, {ease:FlxEase.smoothStepInOut});
	FlxTween.tween(i, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});}
	FlxTween.tween(pauseText, {y: -150}, 0.4, {ease:FlxEase.smoothStepInOut});
	FlxTween.tween(portrait, {x: 250}, 0.4, {ease:FlxEase.smoothStepInOut});
	for(i in [scrollingThing,vignette,bar,portrait,spikes1,spikes2])
	FlxTween.tween(i, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
}