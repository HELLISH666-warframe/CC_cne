import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;

function create()
{
	//defaultCamZoom = 0.7;

	alanBG = new FlxSprite(-1550, -1800).loadGraphic(Paths.image('stages/trojan/alan_desktop'));
	alanBG.scrollFactor.set(1, 1);
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));

	daFloor = new FlxSprite(-1480, -1800).loadGraphic(Paths.image('stages/trojan/floor'));
	daFloor.scrollFactor.set(1, 1);
	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;

	adobeWindow = new FlxSprite(-80, -1800).loadGraphic(Paths.image('stages/trojan/XD'));
	adobeWindow.scrollFactor.set(1, 1);
	adobeWindow.setGraphicSize(Std.int(adobeWindow.width * 2));
	adobeWindow.screenCenter();
	adobeWindow.y -= 900;
	adobeWindow.x += 1500;
	
	ytBGVideo = new FlxSprite(boyfriend.x - 1150,boyfriend.y + 450).loadGraphic(Paths.image('stages/trojan/alan_desktop'));
	ytBGVideo.scrollFactor.set(0, 0);
	ytBGVideo.setGraphicSize(Std.int(ytBGVideo.width * 1.15));
	ytBGVideo.alpha = 0;
	
	/*bgVideoPrecacher = new MP4Handler();
	bgVideoPrecacher.playVideo(Paths.video('alan-video'), false);
	bgVideoPrecacher.playVideo(Paths.video('alan-video2'), false);
	bgVideoPrecacher.visible = false;
	bgVideoPrecacher.volume = 0;*/

	//needsBlackBG = true;

	insert(1,alanBG);
	insert(2,daFloor);
	insert(3,adobeWindow);
	insert(4,ytBGVideo);
		
	var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(-400, 1500);
	particleEmitter.scale.set(2, 2, 2, 2, 0, 0, 0, 0);
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.alpha.set(1, 1);
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.loadParticles(Paths.image('particle'), 500, 16, true);
	particleEmitter.color.set(FlxColor.YELLOW, FlxColor.YELLOW);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	//particleEmitter.cameras = [camBars];
	particleEmitter.cameras = [camHUD];
	insert(1,particleEmitter);

	veryEpicVignette = new BGSprite('alanvignette', 0, 0, 1, 1);
	veryEpicVignette.screenCenter();
	veryEpicVignette.updateHitbox();
	veryEpicVignette.alpha = 0;
	//veryEpicVignette.cameras = [camBars];
	veryEpicVignette.cameras = [camHUD];
	add(veryEpicVignette);

	topBarsALT = new FlxSprite().makeGraphic(2580, 320);
	topBarsALT.color =  FlxColor.BLACK;
	//topBarsALT.cameras = [camBars];
	topBarsALT.cameras = [camHUD];
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	insert(1, topBarsALT);

	bottomBarsALT = new FlxSprite().makeGraphic(2580, 320);
	bottomBarsALT.color =  FlxColor.BLACK;
	//bottomBarsALT.cameras = [camBars];
	bottomBarsALT.cameras = [camHUD];
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	insert(1, bottomBarsALT);
}

function postCreate()
{
}