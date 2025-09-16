import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;

function postCreate() {
	//defaultCamZoom = 0.7;
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));

	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;

	fires1.setGraphicSize(Std.int(fires1.width * 1.6));

	fires2.setGraphicSize(Std.int(fires2.width * 1.6));

	bsod.setGraphicSize(Std.int(bsod.width * 1.25));
	bsod.screenCenter();
	bsod.x += 1250;
	//bsod.antialiasing = ClientPrefs.globalAntialiasing;
	bsod.alpha = 0.0001;

	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/victim/vignette'));
	//redthing.antialiasing = ClientPrefs.globalAntialiasing;
	redthing.camera = camBars;
	add(redthing);

	topBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	topBars.cameras = [camBars];
	topBars.screenCenter();
	topBars.y -= 850;
	add(topBars);

	bottomBars = new FlxSprite().makeSolid(2580, 320, FlxColor.BLACK);
	bottomBars.cameras = [camBars];
	bottomBars.screenCenter();
	bottomBars.y += 850;
	add(bottomBars);

	topBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	topBarsALT.cameras = [camBars];
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	add(topBarsALT);

	bottomBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	bottomBarsALT.cameras = [camBars];
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	add(bottomBarsALT);
}