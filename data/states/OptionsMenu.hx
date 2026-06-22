import flixel.addons.display.FlxBackdrop;
function postCreate() {
	window.title = "Computerized Conflict - Options Menu - Theme by: DangDoodle";
	FlxG.camera.zoom = 3;
	var bg = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
	bg.color = 0xFFea71fd;
	bg.updateHitbox();

	bg.screenCenter();
	bg.scrollFactor.set(0, 0);
	bg.antialiasing = Options.antialiasing;
	add(bg);

	scrollingThing = new FlxBackdrop(Paths.image('menus/mainmenu/scroll'),FlxAxes.XY);
	scrollingThing.alpha = 0.9;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.7));
	add(scrollingThing);

	var circVignette = new FlxSprite();
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

	FlxTween.tween(FlxG.camera, {zoom: 0.7}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, ()->{finishedZoom = true;});
}

function update(elapsed:Float) {
	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;
}