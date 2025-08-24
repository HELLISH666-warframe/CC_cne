//I want to add the diff change stuff but can't be bothered to do it right now.
import funkin.backend.utils.FunkinParentDisabler;
import funkin.options.keybinds.KeybindsOptions;
import flixel.addons.display.FlxBackdrop;
import funkin.editors.charter.Charter;
import flixel.text.FlxTextBorderStyle;
import funkin.options.OptionsMenu;
import funkin.options.TreeMenu;

var grpMenuShit = new FlxTypedGroup();

var menuItems:Array<String> = ['RESUME','RESTART SONG','CHANGE CONTROLS','CHANGE OPTIONS','EXIT TO MENU'];
static var curSelected:Int = 0;

var pauseMusic = FlxG.sound.load(Paths.music('pauseTCO'), 0, true);
var scrollingThing = new FlxBackdrop(Paths.image('menus/pauseMenu/scroll'), FlxAxes.XY, 0, 0);
var bar = new FlxSprite().loadGraphic(Paths.image('menus/pauseMenu/bar'));
var vignette = new FlxSprite().loadGraphic(Paths.image('menus/pauseMenu/vignette'));
//COULD_make_this_a_song_meta_thing_if_you_wanted.
var portrait = new FlxSprite(250, 0).loadGraphic(Paths.image('menus/pauseMenu/chars/' + PlayState.instance.dad.curCharacter));
var pauseText = new FlxSprite(0, -150).loadGraphic(Paths.image('menus/pauseMenu/text'));
var arrow = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/pauseMenu/arrow'));
var coolDown:Bool = true;
var arrowTween:FlxTween;
var spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var camPause = new FlxCamera();

function create() {
	if(oldVideoResolution==null){
		//NO_SOFTLOCK!
		var oldVideoResolution:Bool = false; 
		trace("Ronald_mcslide_is_so_cool");
	}
	var parentDisabler = new FunkinParentDisabler();
	add(parentDisabler);

	camPause.bgColor = 0x00000000;
	FlxG.cameras.add(camPause, false);

	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
	FlxG.sound.list.add(pauseMusic);

	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.color = PlayState.instance.dad.iconColor;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.8));
	add(scrollingThing);

	vignette.scrollFactor.set();
	add(vignette);
	bar.scrollFactor.set();
	add(bar);
		
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

	portrait.scrollFactor.set();
	portrait.antialiasing = true;
	portrait.setGraphicSize(Std.int(portrait.width * 0.8));
	if (portrait != null) add(portrait);

	pauseText.scrollFactor.set();
	add(pauseText);
	arrow.scrollFactor.set();
	add(arrow);

	if (oldVideoResolution) arrow.alpha = 0;

	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);

	for(i in [scrollingThing,vignette,bar,spikes1,portrait,pauseText,spikes2])
		i.alpha = 0;
	if (oldVideoResolution) bar.x -= 270;
	if (oldVideoResolution) portrait.x -= 270;

	var chartingText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32).setFormat(Paths.font('vcr.ttf'), 32);
	chartingText.scrollFactor.set();
	chartingText.x = FlxG.width - (chartingText.width + 20);
	chartingText.y = FlxG.height - (chartingText.height + 20);
	chartingText.visible = PlayState.chartingMode;
	add(chartingText);

	for(i in [spikes1,spikes2,bar,pauseText])
		FlxTween.tween(i, {alpha:1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(scrollingThing, {alpha:0.9}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(vignette, {alpha:0.75}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(portrait, {alpha:1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	arrowTween = FlxTween.tween(arrow, {x: arrow.x + 10}, 1, {ease:FlxEase.smoothStepInOut, type: FlxEase.PINGPONG});
	FlxTween.tween(pauseText, {y:0}, 0.4, {ease:FlxEase.smoothStepInOut});

	if (oldVideoResolution) FlxTween.tween(portrait, {x:-140}, 0.4, {ease:FlxEase.smoothStepInOut});
	else FlxTween.tween(portrait, {x:128}, 0.4, {ease:FlxEase.smoothStepInOut});

	add(grpMenuShit);

	new FlxTimer().start(0.4, function(lol:FlxTimer) {
		coolDown = false;
	});

	regenMenu();
	changeSelection(0);
	cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
}
var cantUnpause:Float = 0.1;
function update(elapsed:Float) {
	//if(PlayState.instance.oldVideoResolution) FlxG.fullscreen = false;
	cantUnpause -= elapsed;
	if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

	scrollingThing.y -= 0.16 * 60 * elapsed;
		
	scrollingThing.x = spikes1.x = spikes2.x -= 0.45 * 60 * elapsed;

	if (controls.UP_P||controls.DOWN_P) changeSelection(controls.DOWN_P ? 1 : -1);

	if (controls.ACCEPT && (cantUnpause <= 0) && !coolDown) {
		switch (menuItems[curSelected]) {
			case "RESUME":
				goodByePortrait();
				new FlxTimer().start(0.4, function(lol:FlxTimer) {
					close();
				});
			case "RESTART SONG": FlxG.resetState();
			case "CHANGE CONTROLS":
				persistentDraw = false;
				openSubState(new KeybindsOptions());
			case "CHANGE OPTIONS": TreeMenu.lastState = PlayState;
		        FlxG.switchState(new OptionsMenu());
			case "EXIT TO MENU":  oldVideoResolution=false;
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				if (PlayState.chartingMode && Charter.undos.unsaved)
                    PlayState.instance.saveWarn(false);
				else if(PlayState.isStoryMode)
					FlxG.switchState(new ModState("MainMenuState"));
				else FlxG.switchState(new FreeplayState());
		}
	}
}

function changeSelection(change:Int = 0):Void {
	curSelected += change;

	FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

	if (curSelected < 0) curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length) curSelected = 0;

	for (item in grpMenuShit.members) {
		item.alpha = 0.6;
		if(scrollingThing.color == -1) item.color = 0xFF000000; else item.color = 0xFFFFFFFF; 
		FlxTween.tween(item, {x: 90}, 0.3, {ease:FlxEase.smoothStepInOut});

		if (curSelected == item.ID) {
			item.alpha = 1;
			item.color = 0xFFFFF777;

			FlxTween.tween(item, {x: 100}, 0.3, {ease:FlxEase.smoothStepInOut});

			arrow.y = item.y - 20;
		}
	}
}

function regenMenu():Void {
	for (i in 0...grpMenuShit.members.length) {
		var obj = grpMenuShit.members[0];
		obj.kill();
		grpMenuShit.remove(obj, true);
		obj.destroy();
	}

	for (i in 0...menuItems.length) {
		var item = new FlxText(90, (i * 80), 540, menuItems[i]);
		item.setFormat(Paths.font("Small Print.ttf"), 54, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		item.scrollFactor.set();
		if(scrollingThing.color == -1) item.color = 0xFF000000;
		//Dumb_"fix"_i_did.
		item.y = ((i * 100) * item.scale.y)+230;

		item.width = item.width*item.scale.y;
		item.updateHitbox();
		item.ID = i;

		grpMenuShit.add(item);
	}
	curSelected = 0;
}

function goodByePortrait() {
	arrowTween.cancel();
	for (item in grpMenuShit.members){FlxTween.tween(item, {x: item.x - 500}, 0.4, {ease:FlxEase.smoothStepInOut});
	FlxTween.tween(item, {alpha:0}, 0.4, {ease: FlxEase.quartInOut});
    }
	FlxTween.tween(arrow, {x: arrow.x - 500}, 0.4, {ease:FlxEase.smoothStepInOut});
	FlxTween.tween(pauseText, {y: -150}, 0.4, {ease:FlxEase.smoothStepInOut});
	FlxTween.tween(portrait, {x: 250}, 0.4, {ease:FlxEase.smoothStepInOut});
	for(i in [scrollingThing,vignette,bar,portrait,spikes1,spikes2])
	FlxTween.tween(i, {alpha:0}, 0.4, {ease: FlxEase.quartInOut});
}
function destroy(){
    FlxG.sound.destroySound(pauseMusic);
	//No_extra_cams!!!
	FlxG.cameras.remove(camPause);
}