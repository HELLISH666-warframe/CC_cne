import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;

var canExit:Bool = false;

function create() {
	add(scrollingThing = new FlxBackdrop(Paths.image('menus/mainmenu/scroll'), FlxAxes.XY)).alpha = 0.9;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.7));
		
	add(redPortrait = new FlxSprite(60, 70).loadGraphic(Paths.image('menus/warning/redWarn'))).antialiasing = ccSSC.globalAntialiasing;
	redPortrait.setGraphicSize(Std.int(redPortrait.width * 0.8));
		
	add(spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X)).scrollFactor.set(0, 0);
	spikes1.y -= 60;
	spikes1.flipY = true;

	add(spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X)).scrollFactor.set(0, 0);
	spikes2.y += 630;
		
	var flashText = new FlxText(250, 125, FlxG.width, "Shaders, Screen Shake and Flashing Lights\nare enabled by default.\n(There are also advanced shaders which\nmight be too laggy)", 42);
	flashText.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(flashText);
		
	var Text2 = new FlxText(250, 300, FlxG.width, "If you don't feel comfortable,\ndisable these options on the\nMain Menu.", 42);
	Text2.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(Text2);
		
	var Text3 = new FlxText(250, 550, FlxG.width, "Hope you enjoy this mod!", 42);
	Text3.setFormat(Paths.font("phantommuff.ttf"), 30, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(Text3);
		
	var OverHereText = new FlxText(0, 15, FlxG.width, "Hey! Over here!", 45);
	OverHereText.setFormat(Paths.font("phantommuff.ttf"), 35, 0xFFff324A, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(OverHereText);

	var startText = new FlxText(0, 655, FlxG.width, "Press ENTER to continue.", 45);
	startText.setFormat(Paths.font("phantommuff.ttf"), 35, FlxColor.YELLOW, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(startText);

	FlxG.camera.fade(FlxColor.BLACK, 1.5, true, function(){canExit = true;});
}

function update(elapsed:Float) {
	scrollingThing.y -= 0.16 * 60 * elapsed;
		
	scrollingThing.alpha = 0.9;

	spikes1.x = spikes2.x = scrollingThing.x -= 0.45 * 60 * elapsed;

	if (controls.ACCEPT && canExit) {
		canExit = false;
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		goinToTitleState();
		ccSSC.flashing = true;
	}
}

function goinToTitleState() {
	saveMyShit();
	FlxG.sound.play(Paths.sound('confirmMenu'));
		
	FlxG.camera.fade(FlxColor.BLACK, 1.2, false, ()->{FlxG.switchState(new TitleState());});
}