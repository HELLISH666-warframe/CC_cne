import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import funkin.options.OptionsMenu;
import openfl.display.BlendMode;

public static var initialized:Bool = false;
var socialItems = new FlxTypedGroup<FlxSprite>();

var socialMedia = [['gamebanana','x','gamejolt'],['https://gamebanana.com/mods/468922','https://x.com/FNFCompConflict','https://gamejolt.com/games/VsTheChosenOne/687592']];
var credGroup = new FlxGroup();
var textGroup = new FlxGroup();
var doNotZoom:Bool = false;

var titleTextAlphas:Array<Float> = [1, .64];

var curWacky:Array<String> = [];

var optionShortCut:FlxSprite;

public var titleOptions:Bool = false;

var zoomLerpTo:Float = 1;
var zoomPerSec:Float = 1;

function create(){
	curWacky = FlxG.random.getObject(getIntroTextShit());

	FlxG.mouse.visible = false;
		
	if(FlxG.save.data.flashing_cc == null && !FlashingState.leftState) {
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlxG.switchState(new ModState('Psych/FlashingState'));
	} else {
		if (initialized) startIntro();
		else new FlxTimer().start(0.1, ()->{startIntro();});
	}
}

function startIntro() {
	if (!initialized) CoolUtil.playMenuSong(true);

	add(bg = new FlxSprite().loadGraphic(Paths.image('menus/title/background'))).alpha = 0.00001;

	add(bg2 = CoolUtil.loadAnimatedGraphic(new FlxSprite(-7,-4),Paths.image('menus/title/background2'),60)).blend = BlendMode.MULTIPLY;//this shit uses like 230MB and I am not even joking

	add(vignette = new FlxSprite().loadGraphic(Paths.image('menus/title/vignetteThings'))).alpha = 0.00001;

	add(chosenOne = new FlxSprite(0, 800).loadGraphic(Paths.image('menus/title/chosenOne')));

	add(darkLord = new FlxSprite((FlxG.width / 2), 800).loadGraphic(Paths.image('menus/title/darkLord')));

	smite = CoolUtil.loadAnimatedGraphic(new FlxSprite(), Paths.image('menus/title/thing'));
	smite.setGraphicSize(Std.int(smite.width * 0.8));
	smite.screenCenter();
	add(smite);

	add(logoBl = new FlxSprite(-1280,-55).loadGraphic(Paths.image('menus/title/logo')));
	logoBl.setGraphicSize(Std.int(logoBl.width * 0.45));

	add(titleText = new FlxSprite(430,545).loadGraphic(Paths.image('menus/title/startText'))).alpha = 0.00001;
		
	add(spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'),FlxAxes.X,0,0)).y -= 60;
	spikes1.flipY = true;

	add(spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0)).y += 630;
	for(i in [spikes1,spikes2])i.scrollFactor.set(0, 0);

	add(socialItems);

	for (i in 0...socialMedia[0].length){
		var socialItem = new FlxSprite(500,650).loadGraphic(Paths.image('menus/title/'+socialMedia[0][i]));
		socialItem.ID = i;
		socialItem.x += i * 100;
		socialItem.alpha = 0;
		socialItem.setGraphicSize(Std.int(socialItem.width * 0.85));
		socialItems.add(socialItem).antialiasing = Options.antialiasing;
	}

	optionShortCut = new FlxSprite(1200, 15).loadGraphic(Paths.image('menus/title/optionsShortcut'));
	add(optionShortCut).setGraphicSize(Std.int(optionShortCut.width * 0.85));

	add(credGroup);

	credGroup.add(blackScreen = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK));

	add(alanSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/title/alanCursor'))).visible = false;
	alanSpr.screenCenter(FlxAxes.X);

	for(i in [bg2,chosenOne,darkLord,smite,optionShortCut,])i.alpha=0.00001;
	for(i in [bg,bg2,chosenOne,darkLord,smite,logoBl,titleText,optionShortCut,alanSpr]) i.antialiasing = Options.antialiasing;

	if (initialized)skipIntro();
	else initialized = true;
}
function getIntroTextShit(){
	var firstArray = Assets.getText(Paths.txt('config/introText')).split('\n');
	var swagGoodArray = [];

	for (i in firstArray) swagGoodArray.push(i.split('--'));
	return swagGoodArray;
}

var transitioning:Bool = false;

var newTitle:Bool = true;//Why_was_this_false_anyway.
var titleTimer:Float = 0;

function update(elapsed:Float) {
	var lerpVal:Float = FlxMath.bound(elapsed * zoomPerSec, 0, 1);
	FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, zoomLerpTo, lerpVal);

	for (i in 0...socialMedia[0].length) {
		checkIfClicked(socialItems.members[i], i);

		if(i == 1) { //Twitter/X (ew X)
			if(FlxG.keys.justPressed.SHIFT)  {
				socialItems.members[i].ID = socialItems.members[i].ID == 0 ? 1 : 0; //change between twitter and X
				socialItems.members[i].loadGraphic(Paths.image('menus/title/${['twitter','x'][socialItems.members[i].ID]}')); //dumb but I think it works
			}
		}
	}

	if(optionShortCut != null && FlxG.mouse.overlaps(optionShortCut) && FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound('mouseClick'));
		FlxG.switchState(new OptionsMenu((_) -> FlxG.switchState(new TitleState())));
		titleOptions = true;
		closedState = true;
	}

	var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

	if (initialized && !transitioning && skippedIntro) {
		if (newTitle && !pressedEnter) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
			var timer:Float = titleTimer;
			if (timer >= 1) timer = (-timer) + 2;

			timer = FlxEase.quadInOut(timer);

			titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
		}

		if(pressedEnter) {
			titleText.alpha = 1;

			FlxG.camera.flash(FlxG.save.data.flashing_cc ? FlxColor.WHITE : 0x4CFFFFFF, 0.7);
			FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

			if(FlxG.save.data.screenShake_cc) FlxG.camera.shake(0.0045, 1);
			zoomLerpTo = 3;
			zoomPerSec = 1.5;

			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
				FlxG.switchState(new MainMenuState());
				titleOptions = false;
				doNotZoom = false;
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
		if(credGroup != null && textGroup != null) {
			credGroup.add(money);
			textGroup.add(money);
			FlxTween.tween(money, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}
	}
}

function addMoreText(text:String, ?offset:Float = 0) {
	if(textGroup != null && credGroup != null) {
		var coolText:FlxText = new FlxText(0, 0, FlxG.width, text, 48);
		coolText.setFormat("vcr.ttf", 48, FlxColor.WHITE, 'center');
		coolText.screenCenter(FlxAxes.X);
		coolText.y += (textGroup.length * 60) + 200 + offset;
		coolText.alpha =  0.00001;
		FlxTween.tween(coolText, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		credGroup.add(coolText);
		textGroup.add(coolText);
	}
}

function deleteCoolText() {
	while (textGroup.members.length > 0) {
		credGroup.remove(textGroup.members[0], true);
		textGroup.remove(textGroup.members[0], true);
	}
}

private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
public static var closedState:Bool = false;
function beatHit() {
	if (!closedState && !doNotZoom) {zoomLerpTo = 1.02; zoomPerSec = 0.3;}

	if(!closedState) {
		sickBeats++;
		switch (sickBeats) {
			case 1:FlxG.sound.music.fadeIn(4, 0, 0.7);
			case 2:createCoolText(['A lot of people'], 15);
			case 3:addMoreText('proudly presents...', 15);
			case 4:deleteCoolText();
			createCoolText(['A stickfigure mod'], 15);
			case 5:addMoreText('very cool huh?', 15);
			case 6:deleteCoolText();
			createCoolText(['el pepe'], 15);
			case 7:deleteCoolText();
			createCoolText(['Animator vs. Animation'], 15);
			case 8:addMoreText('by: Alan Becker', 15);
			alanSpr.visible = true;
			case 9:alanSpr.visible = false;
			deleteCoolText();
			createCoolText(['Mod is meant to'], 15);
			case 10:addMoreText('be played with shaders', 15);
			case 11:deleteCoolText();
			createCoolText(['Timeline FNF'], 15);
			case 12:addMoreText('cool song', 15);
			case 13:deleteCoolText();
			createCoolText(['Guys sorry'], 15);
			case 14:addMoreText('for the 1 year waiting', 15);
			case 15:deleteCoolText();
			createCoolText(['so retro...'], 15);
			case 16:addMoreText('do you guys like this title screen?', 15);
			case 17:deleteCoolText();
			createCoolText(['you should also play'], 15);
			case 18:addMoreText('(insert mod name here)', 15);
			case 19:deleteCoolText();
			createCoolText(['This is not'], 15);
			case 20:addMoreText('an only AvA mod.', 15);
			case 21:deleteCoolText();
			createCoolText([curWacky[0]]);
			case 22:addMoreText(curWacky[1]);
			case 23:deleteCoolText();
			createCoolText(['Vs. The Chosen One?'], 15);
			case 24:addMoreText('More like...', 15);
			case 25:if (credGroup != null) remove(credGroup);
			if (logoBl != null) FlxTween.tween(logoBl, {x: 166}, 2, {type: FlxTween.ONESHOT, ease: FlxEase.backInOut});
			case 28:if(!skippedIntro) {
				doNotZoom = true;
				zoomLerpTo = 0.7;
				zoomPerSec = 3;

				new FlxTimer().start(3, ()->{zoomLerpTo = 1; zoomPerSec = 1000;});
			}
			case 30:if(!skippedIntro) FlxG.cameras.fade(FlxColor.WHITE, 1, false);
			case 33:FlxG.cameras.fade(FlxColor.WHITE, 0, true);
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
		if (credGroup != null) remove(credGroup);
		logoBl.screenCenter();
		FlxG.camera.flash(FlxColor.WHITE, 1.2);
		for(i in [vignette,bg,bg2,titleText,smite,chosenOne,darkLord,optionShortCut]) zoomLerpTo = i.alpha = 1;
		FlxG.cameras.fade(FlxColor.WHITE, 0, true);
		zoomPerSec = 1000;
		chosenOne.y = darkLord.y = 0;
		doNotZoom = false;
		socialItems.forEach(function(socialItem:FlxSprite) socialItem.alpha = 1);
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = false;
		mouseShit('cursors/EProcess',1.5);
				
		skippedIntro = true;
	}
}

function checkIfClicked(object:FlxSprite, id:Int) {
	if(!FlxG.mouse.justPressed||!FlxG.mouse.overlaps(object)) return;
	FlxG.sound.play(Paths.sound('mouseClick'));
	CoolUtil.openURL(socialMedia[1][id]);
}