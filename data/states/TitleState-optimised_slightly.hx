import flixel.addons.display.FlxBackdrop;
import funkin.options.OptionsMenu;
import openfl.display.BlendMode;
//Don't_make_this_staic_if_your_testing.
public var initialized:Bool = false;

var blackScreen = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
var spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var chosenOne = new FlxSprite(0, 810).loadGraphic(Paths.image('menus/titlescreen/chosenOne'));
var darkLord:FlxSprite;
var socialItems = new FlxTypedGroup();
var alanSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/titlescreen/alanCursor'));

var socialMedia:Array<String> = ['gamebanana','x','gamejolt'];
var textGroup = new FlxGroup();
var smite:FlxSprite;
var doNotZoom:Bool = false;

var curWacky:Array<String> = [];

var optionShortCut = new FlxSprite(1200, 15).loadGraphic(Paths.image('menus/titlescreen/optionsShortcut'));

public var titleOptions:Bool = false;

var zoomLerpTo:Float = 1;
var zoomPerSec:Float = 1;

function create() {
	curWacky = FlxG.random.getObject(getIntroTextShit());

	if(!initialized) persistentDraw = persistentUpdate = true;

	FlxG.mouse.visible = false;
	if (initialized) startIntro();
	else new FlxTimer().start(0.1, function(tmr:FlxTimer) startIntro());
}

var logoBl = new FlxSprite(-1280, -55).loadGraphic(Paths.image('menus/titlescreen/logo'));
var titleText = new FlxSprite().loadGraphic(Paths.image('menus/titlescreen/startText'));
var bg = new FlxSprite().loadGraphic(Paths.image('menus/titlescreen/background'));
var bg2:FlxSprite;
var vignette = new FlxSprite().loadGraphic(Paths.image('menus/titlescreen/vignetteThings'));

function startIntro() {
	if (!initialized)
		if(FlxG.sound.music == null) 
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

	Conductor.changeBPM(126);

	add(bg);
	//Lowkey_peak_function.
	bg2 = CoolUtil.loadAnimatedGraphic(new FlxSprite(), Paths.image('menus/titlescreen/background2'),60); //this shit uses like 230MB and I am not even joking
	bg2.screenCenter();
	bg2.blend = BlendMode.MULTIPLY;
	add(bg2);

	vignette.alpha = 0.00001;
	add(vignette);
	add(chosenOne);

	darkLord = new FlxSprite((FlxG.width / 2), 800).loadGraphic(Paths.image('menus/titlescreen/darkLord'));
	add(darkLord);

	smite = CoolUtil.loadAnimatedGraphic(new FlxSprite(), Paths.image('menus/titlescreen/thing'));
	smite.setGraphicSize(Std.int(smite.width * 0.8));
	smite.screenCenter();
	add(smite);

	logoBl.antialiasing = true;
	logoBl.setGraphicSize(Std.int(logoBl.width * 0.45));
	add(logoBl);

	titleText.screenCenter();
	titleText.y += 200;
	add(titleText);
		
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);
	add(socialItems);

	for (i in 0...socialMedia.length) {
		var socialItem = new FlxSprite(500, 650);
		socialItem.loadGraphic(Paths.image('menus/titlescreen/' + socialMedia[i]));
		socialItem.ID = i;
		socialItem.x += i * 100;
		socialItem.alpha = 0;
		socialItem.setGraphicSize(Std.int(socialItem.width * 0.85));
		socialItems.add(socialItem);
		socialItem.antialiasing = true;
	}

	optionShortCut.setGraphicSize(Std.int(optionShortCut.width * 0.85));
	add(optionShortCut);

	for(i in [bg,bg2,chosenOne,darkLord,smite,titleText,optionShortCut]){
	i.alpha = 0.00001;
	i.antialiasing = true;
	}

	add(textGroup);

	textGroup.add(blackScreen);

	add(alanSpr);
	alanSpr.visible = false;
	alanSpr.updateHitbox();
	alanSpr.screenCenter(FlxAxes.X);
	alanSpr.antialiasing = true;

	if (initialized) skipIntro();
	else initialized = true;
}
function getIntroTextShit():Array<Array<String>> {
	var fullText:String = Assets.getText(Paths.txt('titlescreen/introText'));

	var firstArray:Array<String> = fullText.split('\n');
	var swagGoodArray:Array<Array<String>> = [];

	for (i in firstArray) swagGoodArray.push(i.split('--'));
	return swagGoodArray;
}

var transitioning:Bool = false;

function update(elapsed:Float) {
	var lerpVal:Float = FlxMath.bound(elapsed * zoomPerSec, 0, 1);
	FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, zoomLerpTo, lerpVal);

	for (i in 0...socialMedia.length) {
		if (socialItems != null) {
			checkIfClicked(socialItems.members[i], i);

			if(i == 1) {//Twitter/X (ew X)
				if(FlxG.keys.justPressed.SHIFT) {
					socialItems.members[i].ID = socialItems.members[i].ID == 0 ? 1 : 0; //change between twitter and X
					var items:Array<String> = ['twitter','x'];
					socialItems.members[i].loadGraphic(Paths.image('menus/titlescreen/' + items[socialItems.members[i].ID]));
				}
			}
		}
	}
	if(optionShortCut != null && FlxG.mouse.overlaps(optionShortCut) && FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound('mouseClick'));
		FlxG.switchState(new OptionsMenu());
		closedState = titleOptions = true;
	}

	if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

	var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

	if (initialized && !transitioning && skippedIntro) {
		if(pressedEnter) {
			titleText.alpha = zoomLerpTo = 3;

			FlxG.camera.flash(FlxG.save.data.flashing_cc ? FlxColor.WHITE : 0x4CFFFFFF, 0.7);
			FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

			if(FlxG.save.data.screenShake_cc) FlxG.camera.shake(0.0045, 1);
			zoomPerSec = 1.5;

			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				FlxG.switchState(new ModState('MainMenuState'));
				doNotZoom = titleOptions = false;
			});
			FlxG.mouse.visible = false;
			transitioning = closedState = true;
		}
	}
	if (initialized && pressedEnter && !skippedIntro) skipIntro();
	if (initialized) spikes2.x = spikes1.x -= 0.45 * 60 * elapsed;
}
function createCoolText(textArray:Array<String>, ?offset:Float = 0) {
	for (i in 0...textArray.length) {
		var money:FlxText = new FlxText(0, 0, FlxG.width, textArray[i], 48);
		money.setFormat("vcr.ttf", 48, FlxColor.WHITE, 'center');
		money.screenCenter(FlxAxes.X);
		money.y += (i * 60) + 200 + offset;
		money.alpha =  0.00001;
		if(textGroup != null) {
			textGroup.add(money);
			FlxTween.tween(money, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}
	}
}
function addMoreText(text:String, ?offset:Float = 0) {
	if(textGroup != null) {
		var coolText:FlxText = new FlxText(0, 0, FlxG.width, text, 48);
		coolText.setFormat("vcr.ttf", 48, FlxColor.WHITE, 'center');
		coolText.screenCenter(FlxAxes.X);
		coolText.y += (textGroup.length * 60) + 200 + offset;
		coolText.alpha = 0.00001;
		FlxTween.tween(coolText, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		textGroup.add(coolText);
	}
}
function deleteCoolText() {
	while (textGroup.members.length > 0) {
		textGroup.remove(textGroup.members[0], true);
	}
}
var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
public static var closedState:Bool = false;
function beatHit() {
	if (!closedState && !doNotZoom) {
		zoomLerpTo = 1.02;
		zoomPerSec = 0.3;
	}
	if(!closedState) {
		sickBeats++;
		switch (sickBeats) {
			case 1:
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			case 2: createCoolText(['A lot of people'], 15);
			case 3: addMoreText('proudly presents...', 15);
			case 4:
				deleteCoolText();
				createCoolText(['A stickfigure mod'], 15);
			case 5: addMoreText('very cool huh?', 15);
			case 6:
				deleteCoolText();
				createCoolText(['el pepe'], 15);
			case 7:
				deleteCoolText();
				createCoolText(['Animator vs. Animation'], 15);
			case 8:
				addMoreText('by: Alan Becker', 15);
				alanSpr.visible = true;
			case 9:
				alanSpr.visible = false;
				deleteCoolText();
				createCoolText(['Mod is meant to'], 15);
			case 10: addMoreText('be played with shaders', 15);
			case 11:
				deleteCoolText();
				createCoolText(['Timeline FNF'], 15);
			case 12: addMoreText('cool song', 15);
			case 13:
				deleteCoolText();
				createCoolText(['Guys sorry'], 15);
			case 14: addMoreText('for the 1 year waiting', 15);
			case 15:
				deleteCoolText();
				createCoolText(['so retro...'], 15);
			case 16: addMoreText('do you guys like this title screen?', 15);
			case 17:
				deleteCoolText();
				createCoolText(['you should also play'], 15);
			case 18: addMoreText('(insert mod name here)', 15);
			case 19:
				deleteCoolText();
				createCoolText(['This is not'], 15);
			case 20: addMoreText('an only AvA mod.', 15);
			case 21:
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 22: addMoreText(curWacky[1]);
			case 23:
				deleteCoolText();
				createCoolText(['Vs. The Chosen One?'], 15);
			case 24: addMoreText('More like...', 15);
			case 25:
				if (textGroup != null) remove(textGroup);
				if (logoBl != null) FlxTween.tween(logoBl, {x: 166}, 2, {type: FlxTween.ONESHOT, ease: FlxEase.backInOut});
			case 28:
				if(!skippedIntro) {
					doNotZoom = true;
					zoomLerpTo = 0.7;
					zoomPerSec = 3;

					new FlxTimer().start(3, function(tmr:FlxTimer) {
						zoomLerpTo = 1;
						zoomPerSec = 1000;
					});
				}
			case 30: if(!skippedIntro) FlxG.cameras.fade(FlxColor.WHITE, 1, false);
			case 33:
				FlxG.cameras.fade(FlxColor.WHITE, 0, true);
				skipIntro();
				zoomLerpTo = 1;
				zoomPerSec = 1000;
				if (darkLord != null) FlxTween.tween(darkLord, {y: 0}, 1, {type: FlxTween.ONESHOT, ease: FlxEase.backInOut, startDelay: 0.5});
				if (chosenOne != null) FlxTween.tween(chosenOne, {y: 0}, 1, {type: FlxTween.ONESHOT, ease: FlxEase.backInOut, startDelay: 0.5});
		}
	}
}

var skippedIntro:Bool = false;
function skipIntro() {
	if (!skippedIntro) {
		remove(alanSpr);
		if (textGroup != null) remove(textGroup);
		logoBl.screenCenter();
		FlxG.camera.flash(FlxColor.WHITE, 1.2);
		for(i in [vignette,bg,bg2,titleText,smite,chosenOne,darkLord,optionShortCut])
			zoomLerpTo = i.alpha = 1;
		FlxG.cameras.fade(FlxColor.WHITE, 0, true);
		zoomPerSec = 1000;
		chosenOne.y = darkLord.y = 0;
		doNotZoom = false;
		socialItems.forEach(function(socialItem:FlxSprite) socialItem.alpha = 1);
		FlxG.mouse.visible = skippedIntro = true;
	}
}

function checkIfClicked(object:FlxSprite, id:Int) {//the tag is the thing used for the select void
	if(!FlxG.mouse.justPressed) return;
	if(!FlxG.mouse.overlaps(object)) return;

	FlxG.sound.play(Paths.sound('mouseClick'));

	switch(id) {
		case 0: CoolUtil.openURL('https://gamebanana.com/mods/468922');
		case 1: CoolUtil.openURL('https://x.com/FNFCompConflict');
		case 2: CoolUtil.openURL('https://gamejolt.com/games/VsTheChosenOne/687592');
	}
}