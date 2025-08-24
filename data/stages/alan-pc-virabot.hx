import flixel.addons.display.FlxBackdrop;
//trojan:
var scroll:FlxBackdrop;
var viraScroll:FlxBackdrop;
var vignettMid:FlxSprite;
var vignetteFin:FlxSprite;
var SpinAmount:Float = 0;
var isPlayersSpinning:Bool = false;
var filter:FlxSprite;
function postCreate() {
	lightsColors = [0xFFE5BE01, 0xFF00AAE4, 0xFF76BD17, 0xFFFF0000, 0xFFFF8000];
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));

	adobeWindow.setGraphicSize(Std.int(adobeWindow.width * 2));
	adobeWindow.screenCenter();
	adobeWindow.y -= 900;
	adobeWindow.x += 1500;

	sFWindow.screenCenter();
	sFWindow.y -= 900;
	sFWindow.x += 900;
	sFWindow.setGraphicSize(Std.int(sFWindow.width * 1.5));

	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;

	tscseeing.setGraphicSize(Std.int(tscseeing.width * 1.3));
    tscseeing.screenCenter();
	tscseeing.updateHitbox();
	tscseeing.x += 2480;
	tscseeing.y += 95;
	tscseeing.antialiasing = true;

	radialLine.setGraphicSize(Std.int(radialLine.width * 1.7));
	radialLine.cameras = [camBars];
	radialLine.screenCenter();
	radialLine.alpha = 0.0001; //kinda laggy when it changes to an alpha of 1 if it's set to 0

	redthing.antialiasing = true;
	redthing.cameras = [camBars];
	redthing.alpha = 0.0001;
	add(redthing);

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

	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vignette', 'extras'));
	vignetteTrojan.antialiasing = true;
	vignetteTrojan.cameras = [camBars];
	vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0.0001;
	add(vignetteTrojan);

	coolShit = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/cool'));
	coolShit.antialiasing = true;
	coolShit.cameras = [camBars];
	coolShit.scale.set(20, 20);
	coolShit.screenCenter();
	coolShit.alpha = 0.0001;
	add(coolShit);

	filter = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/filterr'));
	filter.antialiasing = true;
	filter.alpha = 0.0001;
	filter.scrollFactor.set();
	filter.cameras = [camChar];
	add(filter);

	scroll = new FlxBackdrop(Paths.image('stages/trojan/scrollmidsong'), FlxAxes.XY, 0, 0);
	scroll.setGraphicSize(Std.int(scroll.width * 0.9));
	scroll.alpha = 0.0001;
	add(scroll);

	vignettMid = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vigMidSong'));
	vignettMid.antialiasing = true;
	vignettMid.alpha = 0.0001;
	vignettMid.scrollFactor.set();
	vignettMid.cameras = [camChar];
	add(vignettMid);

	viraScroll = new FlxBackdrop(Paths.image('stages/trojan/exe'), FlxAxes.XY, 0, 0);
	viraScroll.setGraphicSize(Std.int(viraScroll.width * 0.9));
	viraScroll.alpha = 0.0001;
	add(viraScroll);

	vignetteFin = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vignetteFin'));
	vignetteFin.antialiasing = true;
	vignetteFin.alpha = 0.0001;
	vignetteFin.scrollFactor.set();
	//vignetteFin.cameras = [camChar];
	add(vignetteFin);

	//colorShad = new ColorSwap();
	//if(SONG.song.toLowerCase() == 'trojan') camGame.alpha = 0;
}