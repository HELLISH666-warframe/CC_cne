package;

import AttachedText;
import CheckboxThingie;
import options.Option;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var warnText2:FlxText;

	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	var grpOptions:FlxTypedGroup<Alphabet>;
	var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	var grpTexts:FlxTypedGroup<AttachedText>;
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	var redPortrait:FlxSprite;
	var scrollingThing:FlxBackdrop;
	var spikes1:FlxBackdrop;
	var spikes2:FlxBackdrop;
	var canExit:Bool = false;

	override function create()
	{
		super.create();

		camGame = new FlxCamera();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 1;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		
		scrollingThing = new FlxBackdrop(Paths.image('mainmenu/scroll'), XY, 0, 0);
		scrollingThing.alpha = 0.9;
		scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.7));
		add(scrollingThing);
		
		redPortrait = new FlxSprite(60, 70).loadGraphic(Paths.image('warning/redWarn'));
		redPortrait.antialiasing = ClientPrefs.globalAntialiasing;
		redPortrait.setGraphicSize(Std.int(redPortrait.width * 0.8));
		if (redPortrait != null) add(redPortrait);
		
		spikes1 = new FlxBackdrop(Paths.image('mainmenu/spikes'), X, 0, 0);
		spikes1.y -= 60;
		spikes1.scrollFactor.set(0, 0);
		spikes1.flipY = true;
		if (spikes1 != null) add(spikes1);

		spikes2 = new FlxBackdrop(Paths.image('mainmenu/spikes'), X, 0, 0);
		spikes2.y += 630;
		spikes2.scrollFactor.set(0, 0);
		if (spikes2 != null) add(spikes2);
		
		var flashText = new FlxText(250, 125, FlxG.width, "Shaders, Screen Shake and Flashing Lights\nare enabled by default.\n(There are also advanced shaders which\nmight be too laggy)", 42);
		flashText.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		add(flashText);
		
		var Text2 = new FlxText(250, 300, FlxG.width, "If you don't feel comfortable,\ndisable these options on the\nMain Menu.", 42);
		Text2.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		add(Text2);
		
		var Text3 = new FlxText(250, 550, FlxG.width, "Hope you enjoy this mod!", 42);
		Text3.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		add(Text3);
		
		var OverHereText = new FlxText(0, 15, FlxG.width, "Hey! Over here!", 45);
		OverHereText.setFormat(Paths.font("phantommuff.ttf"), 35, 0xFFff324A, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		add(OverHereText);

		var startText = new FlxText(0, 655, FlxG.width, "Press ENTER to continue.", 45);
		startText.setFormat(Paths.font("phantommuff.ttf"), 35, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
		add(startText);

		/*grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		var option:Option = new Option('Do Not Show Me This Again', "", 'shaders', 'bool', true);
		addOption(option);

		var option:Option = new Option('Flashing Lights', "", 'flashing', 'bool', true);
		addOption(option);

		var option:Option = new Option('Screen Shake', "", 'screenShake', 'bool', true);
		addOption(option);

		var option:Option = new Option('Shaders', "", 'shaders', 'bool', true);
		addOption(option);



		for (i in 0...optionsArray.length)
		{
			var optionText:Alphabet = new Alphabet(150, 260, optionsArray[i].name, false);
			optionText.isMenuItem = true;
			/*optionText.forceX = 300;
			optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);
			optionText.cameras = [camGame];

			var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue() == true);
			checkbox.sprTracker = optionText;
			checkbox.ID = i;
			checkboxGroup.add(checkbox);
			checkbox.cameras = [camGame];
		}*/

		//changeSelection();
		//reloadCheckboxes();
		camHUD.fade(FlxColor.BLACK, 1.5, true, function()
		{
			canExit = true;
		});
	}

	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		scrollingThing.x -= 0.45 * 60 * elapsed;
		scrollingThing.y -= 0.16 * 60 * elapsed;
		
		scrollingThing.alpha = 0.9;

		spikes1.x -= 0.45 * 60 * elapsed;
		spikes2.x -= 0.45 * 60 * elapsed;

		/*if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if(controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curOption.setValue((curOption.getValue() == true) ? false : true);
			curOption.change();
			reloadCheckboxes();
		}*/

		if(!leftState) {
			var enter:Bool = FlxG.keys.justPressed.ENTER;
			if (enter && canExit) {
				leftState = true;
				canExit = false;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				goinToTitleState();
				FlxG.save.data.flashing = true;
			}
		}
		super.update(elapsed);
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		for (text in grpTexts) {
			text.alpha = 0.6;
			if(text.ID == curSelected) {
				text.alpha = 1;
			}
		}

		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadCheckboxes() {
		for (checkbox in checkboxGroup) {
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
		}
	}

	function goinToTitleState()
	{
		ClientPrefs.saveSettings();
		FlxG.sound.play(Paths.sound('confirmMenu'));
		
		camHUD.fade(FlxColor.BLACK, 1.2, false, function()
		{
			MusicBeatState.switchState(new TitleState());
		});
	}
}
