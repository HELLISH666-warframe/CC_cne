import funkin.options.keybinds.KeybindsOptions;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;

var options:Array<String> = ['Note Colors', 'Controls', 'Graphics', 'Visuals and UI', 'Gameplay'];
private var grpOptions:FlxTypedGroup<Alphabet>;
private static var curSelOS:Int = 0;
public static var menuBG:FlxSprite;
var finishedZoom = false;

function openSelectedSubstate(label:String) {
	switch(label) {
		case 'Note Colors':openSubState(new options.NotesSubState());
		case 'Controls':persistentDraw = false; openSubState(new KeybindsOptions());
		case 'Graphics':openSubState(new ModSubState('Psych/options/BaseOptionsMenu',{"menu":'Graphics'}));
		case 'Visuals and UI':openSubState(new ModSubState('Psych/options/BaseOptionsMenu',{"menu":'Visuals and UI'}));
		case 'Gameplay':openSubState(new ModSubState('Psych/options/BaseOptionsMenu',{"menu":'Gameplay'}));
	}
}

var selectorLeft:Alphabet;
var selectorRight:Alphabet;
var scrollingThing:FlxBackdrop;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;
var vignette:FlxSprite;

function create() {
	DiscordUtil.changePresenceSince("Options Menu", null);

	window.title = "Computerized Conflict - Options Menu - Theme by: DangDoodle";

	FlxG.camera.zoom = 3;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFFea71fd;
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = Options.antialiasing;
	add(bg);
		
	scrollingThing = new FlxBackdrop(Paths.image('menus/mainmenu/scroll'), FlxAxes.XY);
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
		
	spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

	spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);

	grpOptions = new FlxTypedGroup<Alphabet>();
	add(grpOptions);

	for (i in 0...options.length) {
		var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
		optionText.screenCenter();
		optionText.y += (100 * (i - (options.length / 2))) + 50;
		grpOptions.add(optionText);
	}

	selectorLeft = new Alphabet(0, 0, '>', true);
	add(selectorLeft);
	selectorRight = new Alphabet(0, 0, '<', true);
	add(selectorRight);

	changeSelection(0);
	//ClientPrefs.saveSettings();

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function(){finishedZoom = true;});
}

override function closeSubState() {
	super.closeSubState();
	ClientPrefs.saveSettings();
}

public var exitCallback:Dynamic->Void;
function update(elapsed:Float) {
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;

	if(finishedZoom) {
		if (controls.UP_P||controls.DOWN_P) changeSelection(controls.UP_P?-1:1);
	
		if (controls.BACK) {
			finishedZoom = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {exit();});
		}
	
		if (controls.ACCEPT) {
			persistentUpdate = false;
			openSelectedSubstate(options[curSelOS]);
		}
	}
	if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.K)
        openSubState(new ModSubState('Psych/options/BaseOptionsMenu',{"exitState":(_) ->  FlxG.switchState(new TitleState())}));
}

function exit() {
	if (data != null) {
		exitCallback=data.exitState;
		return exitCallback(data.exitState);
	}
	FlxG.switchState(new MainMenuState());
}
function changeSelection(change:Int = 0) {
	curSelOS = FlxMath.wrap(curSelOS + change, 0, options.length - 1);

	var bullShit:Int = 0;

	for (item in grpOptions.members) {
		item.targetY = bullShit - curSelOS;
		bullShit++;

		item.alpha = 0.6;
		if (item.targetY == 0) {
			item.alpha = 1;
			selectorLeft.x = item.x - 63;
			selectorLeft.y = item.y;
			selectorRight.x = item.x + item.width + 15;
			selectorRight.y = item.y;
		}
	}
	FlxG.sound.play(Paths.sound('scrollMenu'));
}