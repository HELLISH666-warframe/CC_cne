import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import psych.CheckboxThingie;
import psych.options.Option;
import psych.AttachedText;

private var curOption:Option = null;
private var curSelBOM:Int = 0;
private var optionsArray:Array<Option>;

private var grpOptions:FlxTypedGroup<Alphabet>;
private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
private var grpTexts:FlxTypedGroup<AttachedText>;

private var boyfriend:Character = null;
private var descBox:FlxSprite;
private var descText:FlxText;

public var title:String;
public var rpcTitle:String;

//It's_fucking_abysmal_but_it's_better_than_3_extra_states.
function tempFuncThing() {
	switch(data.menu){
		case 'Graphics':title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu';

		//First one because it has to load bf
		var option = new Option('Anti-Aliasing','If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.','globalAntialiasing','bool',true);
		option.onChange = onChangeAntiAliasing;
		addOption(option);

		var option = new Option('Low Quality','If checked, disables some background details,\ndecreases loading times and improves performance.','lowQuality','bool',false);
		addOption(option);

		var option = new Option('Shaders','If unchecked, disables shaders.\nIt\'s used for some visual effects, and also CPU intensive for weaker PCs.','shaders','bool',true);
		addOption(option);

		var option = new Option('Advanced Shaders','If checked, enables shaders which might be laggy or even might crash your game.','advancedShaders','bool',true);
		addOption(option);

		var option = new Option('Framerate',"Pretty self explanatory, isn't it?",'framerate','int',60);
		addOption(option);

		option.minValue = 10;
		option.maxValue = 240;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;

		var option = new Option('VRAM-Only Sprites',"If checked, will only store the bitmaps in the GPU, freeing a LOT of memory (EXPERIMENTAL). Turning this off will consume a lot of memory, especially on bigger sprites. If you aren't sure, leave this on.",'gpuOnlyBitmaps','bool',true);
		addOption(option);
		case 'Visuals and UI':title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu';
		
		var option = new Option('Note Splashes',"If unchecked, hitting \"Sick!\" notes won't show particles.",'noteSplashes','bool',true);
		addOption(option);

		var option = new Option('Hide HUD','If checked, hides most HUD elements.','hideHud','bool',false);
		addOption(option);

		var option = new Option('Time Bar:',"What should the Time Bar display?",'timeBarType','string','Time Left',['Time Left','Time Elapsed','Song Name','Disabled']);
		addOption(option);

		var option = new Option('Flashing Lights',"Uncheck this if you're sensitive to flashing lights!",'flashing','bool',true);
		addOption(option);

		var option = new Option('Screen Shake',"Uncheck this if you don't want the screen to shake!",'screenShake','bool',true);
		addOption(option);
		
		var option:Option = new Option('Camera Zooms',"If unchecked, the camera won't zoom in on a beat hit.",'camZooms','bool',true);
		addOption(option);

		var option = new Option('Score Text Zoom on Hit',"If unchecked, disables the Score text zooming\neverytime you hit a note.",'scoreZoom','bool',true);
		addOption(option);

		var option = new Option('Health Bar Transparency','How much transparent should the health bar and icons be.','healthBarAlpha','percent',1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option = new Option('Combo Stacking',"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",'comboStacking','bool',false);
		addOption(option);

		var option = new Option('Laggy Text',"Uncheck this if you don't want that warning text\n telling you to turn off shaders to appear.\n(It can be very annoying sometimes).",'lagText','bool',true);
		addOption(option);
		case 'Gameplay':title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu';
		var option = new Option('Camera Movement','If checked, the game camera will move depending on the animation of a character.','cameraMovement','bool',true);
		addOption(option);

		var option = new Option('Window Size Changes','If checked, the game window will change its resolution to some specific songs.','wideScreenSongs','bool',false);
		addOption(option);

		var option = new Option('Controller Mode','Check this if you want to play with\na controller instead of using your Keyboard.','controllerMode','bool',false);
		addOption(option);

		var option = new Option('Downscroll','If checked, notes go Down instead of Up, simple enough.','downScroll','bool',false);
		addOption(option);

		var option = new Option('Middlescroll','If checked, your notes get centered.','middleScroll','bool',false);
		addOption(option);

		var option = new Option('Disable Mechanics',"If checked, disables the mechanics (ONLY HARD MODE!!!)",'noMechanics','bool',false);
		addOption(option);

		var option = new Option('Enable Judgement Counter',"If checked, a judgement counter will appear on the HUD, wooahh..",'judCounter','bool',false);
		addOption(option);

		var option = new Option('Enable Lane Underlay',"Enables a black underlay behind the notes\nfor better reading!\n(Similar to Funky Friday's Scroll Underlay or osu!mania's thing)",'laneunderlay','bool',true);
		addOption(option);

		var option = new Option('Lane Underlay Transparency','Set the Lane Underlay Transparency (Lane Underlay must be enabled)','laneTransparency','percent',1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option = new Option('Ghost Tapping',"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",'ghostTapping','bool',true);
		addOption(option);

		var option = new Option('Opponent Notes','If unchecked, opponent notes get hidden.','opponentStrums','bool',true);
		addOption(option);

		var option = new Option('Disable Reset Button',"If checked, pressing Reset won't do anything.",'noReset','bool',false);
		addOption(option);

		var option = new Option('Auto Pause',"If checked, switching windows will pause the game.",'autoPause','bool',true);
		addOption(option);

		var option = new Option('Song Offset','Changes the offset that songs should start with.','songOffset','int',0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 50;
		option.minValue = -5000;
		option.maxValue = 5000;
		addOption(option);

		var option = new Option('Streamed Music',"If checked, only musics will have streamed audio, ALSO freeing a LOT of memory with the downside of higher cpu usage if more audio are being streamed at once (EXPERIMENTAL). Turning this off will consume a lot of memory, especially on longer songs. If you aren't sure, leave this on.",'streamedMusic','bool',true);
		addOption(option);

		var option = new Option('Streamed Vocals',"If checked, vocals will also be streamed if Streamed Music is checked, will impact the performance if the song uses alot of vocals (EXPERIMENTAL). If you aren't sure, leave this off.",'streamedVocals','bool',true);
		addOption(option);

		var option = new Option('Hitsound Volume','Funny notes does \"Tick!\" when you hit them."','hitsoundVolume','percent',0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option = new Option('Rating Offset','Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.','ratingOffset','int',0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option = new Option('Sick! Hit Window','Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.','sickWindow','int',45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option = new Option('Good Hit Window','Changes the amount of time you have\nfor hitting a "Good" in milliseconds.','goodWindow','int',90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option = new Option('Bad Hit Window','Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.','badWindow','int',135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option = new Option('Safe Frames','Changes how many frames you have for\nhitting a note earlier or late.','safeFrames','float',10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);
	}
}

function new() {
	tempFuncThing();
	if(title == null) title = 'Options';
	if(rpcTitle == null) rpcTitle = 'Options Menu';

	DiscordUtil.changePresenceSince(rpcTitle, null);

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

	var titleText:Alphabet = new Alphabet(45, 20, title, true);
	titleText.scale.set(0.6,0.6);
	titleText.updateHitbox();
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
			//optionText.startPosition.x -= 80;//LATER.
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
			if(controls.LEFT || controls.RIGHT) {
				var pressed = (controls.LEFT_P || controls.RIGHT_P);
				if(holdTime > 0.5 || pressed) {
					if(pressed) {
						var add:Dynamic = null;
						if(curOption.type != 'string') {
							add = controls.LEFT ? -curOption.changeValue : curOption.changeValue;
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
								if(controls.LEFT_P) --num;
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
						holdValue += curOption.scrollSpeed * elapsed * (controls.LEFT ? -1 : 1);
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
			} else if(controls.LEFT_R || controls.RIGHT_R) {
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
	curSelBOM = FlxMath.wrap(curSelBOM + change, 0, optionsArray.length - 1);

	descText.text = optionsArray[curSelBOM].description;
	descText.screenCenter(FlxAxes.Y);
	descText.y += 270;

	var bullShit:Int = 0;

	for (item in grpOptions.members) {
		item.targetY = bullShit - curSelBOM;
		bullShit++;

		item.alpha = 0.6;
		if (item.targetY == 0) item.alpha = 1;
	}
	for (text in grpTexts) {
		text.alpha = 0.6;
		if(text.ID == curSelBOM) text.alpha = 1;
	}

	descBox.setPosition(descText.x - 10, descText.y - 10);
	descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
	descBox.updateHitbox();
	curOption = optionsArray[curSelBOM]; //shorter lol
	FlxG.sound.play(Paths.sound('scrollMenu'));
}

function reloadCheckboxes()
	for (checkbox in checkboxGroup) {checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);}

//Graphics
function onChangeAntiAliasing() {
	for (sprite in members) {
		var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
		var sprite:FlxSprite = sprite; //Don't judge me ok
		if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
			sprite.antialiasing = ccSSC.globalAntialiasing;
		}
	}
}
function onChangeFramerate(){
	Options.framerate=FlxG.save.data.framerate;
	if (FlxG.updateFramerate < Options.framerate) FlxG.drawFramerate = FlxG.updateFramerate = Options.framerate;
	else FlxG.updateFramerate = FlxG.drawFramerate = Options.framerate;
}

//Gameplay
function onChangeHitsoundVolume() FlxG.sound.play(Paths.sound('hitsound'), FlxG.save.data.hitsoundVolume);