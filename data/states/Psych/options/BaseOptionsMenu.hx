import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import psych.CheckboxThingie;
import psych.options.Option;

private var curOption:Option = null;
private var curSelected:Int = 0;
private var optionsArray:Array<Option>;

private var grpOptions:FlxTypedGroup<Alphabet>;
private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
private var grpTexts:FlxTypedGroup<AttachedText>;

private var boyfriend:Character = null;
private var descBox:FlxSprite;
private var descText:FlxText;

public var title:String;
public var rpcTitle:String;
var scrollingThing:FlxBackdrop;
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;
var vignette:FlxSprite;

function new() {
	//TEST.
	var option:Option = new Option('Window Size Changes',
		'If checked, the game window will change its resolution to some specific songs.',
		'wideScreenSongs','bool',false);
	addOption(option);
	//OK?
	if(title == null) title = 'Options';
	if(rpcTitle == null) rpcTitle = 'Options Menu';

	DiscordUtil.changePresenceSince(rpcTitle, null);

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFFea71fd;
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

	// avoids lagspikes while scrolling through menus!
	grpOptions = new FlxTypedGroup<Alphabet>();
	add(grpOptions);

	grpTexts = new FlxTypedGroup<AttachedText>();
	add(grpTexts);

	checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
	add(checkboxGroup);

	descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
	descBox.alpha = 0.6;
	add(descBox);

	var titleText:Alphabet = new Alphabet(75, 40, title, true);
	titleText.scale.set(0.6,0.6);
	titleText.alpha = 0.4;
	add(titleText);

	descText = new FlxText(50, 600, 1180, "", 32);
	descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	descText.scrollFactor.set();
	descText.borderSize = 2.4;
	add(descText);

	for (i in 0...optionsArray.length) {
		var optionText:Alphabet = new Alphabet(290, 260, optionsArray[i].name, false);
		optionText.isMenuItem = true;
		optionText.targetY = i;
		grpOptions.add(optionText);

		if(optionsArray[i].type == 'bool') {
			var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue() == true);
			checkbox.sprTracker = optionText;
			checkbox.ID = i;
			checkboxGroup.add(checkbox);
		} else {
			optionText.x -= 80;
			optionText.startPosition.x -= 80;
			//optionText.xAdd -= 80;
			var valueText:AttachedText = new AttachedText('' + optionsArray[i].getValue(), optionText.width + 80);
			valueText.sprTracker = optionText;
			valueText.copyAlpha = true;
			valueText.ID = i;
			grpTexts.add(valueText);
			optionsArray[i].setChild(valueText);
		}
		//optionText.snapToPosition(); //Don't ignore me when i ask for not making a fucking pull request to uncomment this line ok
			
		updateTextFrom(optionsArray[i]);
	}

	changeSelection();
	reloadCheckboxes();
}

public function addOption(option:Option) {
	if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
	optionsArray.push(option);
}

var nextAccept:Int = 5;
var holdTime:Float = 0;
var holdValue:Float = 0;
function update(elapsed:Float) {
	return;//FUCK_OFF.
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;
		
	if (controls.UP_P||controls.DOWN_P) changeSelection(controls.UP_P?-1:1);

	if (controls.BACK) {
		close();
		FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	if(nextAccept <= 0) {
		var usesCheckbox = true;
		if(curOption.type != 'bool') usesCheckbox = false;

		if(usesCheckbox) {
			if(controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curOption.setValue((curOption.getValue() == true) ? false : true);
				curOption.change();
				reloadCheckboxes();
			}
		} else {
			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
				if(holdTime > 0.5 || pressed) {
					if(pressed) {
						var add:Dynamic = null;
						if(curOption.type != 'string') {
							add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
						}

						switch(curOption.type) {
							case 'int' | 'float' | 'percent':holdValue = curOption.getValue() + add;
								if(holdValue < curOption.minValue) holdValue = curOption.minValue;
								else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

								switch(curOption.type) {
									case 'int':holdValue = Math.round(holdValue);
									curOption.setValue(holdValue);
									case 'float' | 'percent':holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
									curOption.setValue(holdValue);
								}
							case 'string':
								var num:Int = curOption.curOption; //lol
								if(controls.UI_LEFT_P) --num;
								else num++;

								if(num < 0) num = curOption.options.length - 1;
								else if(num >= curOption.options.length) num = 0;

								curOption.curOption = num;
								curOption.setValue(curOption.options[num]); //lol
						}
						updateTextFrom(curOption);
						curOption.change();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					} else if(curOption.type != 'string') {
						holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
						if(holdValue < curOption.minValue) holdValue = curOption.minValue;
						else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

						switch(curOption.type) {
							case 'int':curOption.setValue(Math.round(holdValue));
							case 'float' | 'percent':curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
						}
						updateTextFrom(curOption);
						curOption.change();
					}
				}
				if(curOption.type != 'string') holdTime += elapsed;
			} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
				clearHold();
			}
		}

		if(controls.RESET) {
			for (i in 0...optionsArray.length) {
				var leOption:Option = optionsArray[i];
				leOption.setValue(leOption.defaultValue);
				if(leOption.type != 'bool') {
					if(leOption.type == 'string') leOption.curOption = leOption.options.indexOf(leOption.getValue());
					updateTextFrom(leOption);
				}
				leOption.change();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			reloadCheckboxes();
		}
	}

	if(boyfriend != null && boyfriend.animation.curAnim.finished) boyfriend.dance();

	if(nextAccept > 0) nextAccept -= 1;
}

function updateTextFrom(option:Option) {
	var text:String = option.displayFormat;
	var val:Dynamic = option.getValue();
	if(option.type == 'percent') val *= 100;
	var def:Dynamic = option.defaultValue;
	option.text = StringTools.replace(text,'%v',val);
	option.text = StringTools.replace(option.text,'%d',def);
}

function clearHold() {
	if(holdTime > 0.5) FlxG.sound.play(Paths.sound('scrollMenu'));
	holdTime = 0;
}

function changeSelection(change:Int = 0) {
	curSelected = FlxMath.wrap(curSelected + change, 0, optionsArray.length - 1);

	descText.text = optionsArray[curSelected].description;
	descText.screenCenter(FlxAxes.Y);
	descText.y += 270;

	var bullShit:Int = 0;

	for (item in grpOptions.members) {
		item.targetY = bullShit - curSelected;
		bullShit++;

		item.alpha = 0.6;
		if (item.targetY == 0) item.alpha = 1;
	}
	for (text in grpTexts) {
		text.alpha = 0.6;
		if(text.ID == curSelected) text.alpha = 1;
	}

	descBox.setPosition(descText.x - 10, descText.y - 10);
	descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
	descBox.updateHitbox();
	curOption = optionsArray[curSelected]; //shorter lol
	FlxG.sound.play(Paths.sound('scrollMenu'));
}

function reloadBoyfriend() {
	var wasVisible:Bool = false;
	if(boyfriend != null) {
		wasVisible = boyfriend.visible;
		boyfriend.kill();
		remove(boyfriend);
		boyfriend.destroy();
	}

	boyfriend = new Character(840, 170, 'animator-bf', true);
	boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
	boyfriend.updateHitbox();
	boyfriend.dance();
	insert(1, boyfriend);
	boyfriend.visible = wasVisible;
}

function reloadCheckboxes()
	for (checkbox in checkboxGroup) {checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);}