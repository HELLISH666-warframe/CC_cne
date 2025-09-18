import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.addons.display.FlxBackdrop;

var bbgColor:FlxColor = 0xFF000000;
public var silhouettes:FlxBackdrop;
public var topBars:FlxSprite;
public var bottomBars:FlxSprite;
public var blackBG:FlxSprite;
public var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(-400, 1000);
public var glowDad:FlxSprite;
public var glow:FlxSprite;
public var whiteScreen:FlxSprite;
public var shine:FlxSprite;
function create(){
	bg.updateHitbox();
	
	shine = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/world1/shine'));
	shine.scrollFactor.set(1, 1);
	shine.screenCenter();
	shine.antialiasing = true;
	shine.updateHitbox();

	//needsBlackBG = true;
	
	blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), bbgColor);
	blackBG.scrollFactor.set();
	blackBG.alpha = 0;
	blackBG.screenCenter();
	insert(4,blackBG);
	
	whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	insert(2,whiteScreen).alpha = 0;
		
	glowDad = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/extras/Glow'));
	glowDad.scrollFactor.set(1, 1);
	glowDad.cameras = [camHUD];
	glowDad.antialiasing = true;
	glowDad.scale.y = 1440;
	glowDad.alpha = 0;
	glowDad.color = FlxColor.RED;
			
	glow = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/extras/Glow'));
	glow.scrollFactor.set(1, 1);
	glow.cameras = [camHUD];
	glow.antialiasing = true;
	glow.scale.y = 1440;
	glow.flipX = true;
	glow.color = FlxColor.CYAN;
	glow.alpha = 0;
	
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.scale.set(2, 2, 2, 2, 0, 0, 0, 0);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.alpha.set(0, 0);
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.color.set(FlxColor.BLACK, FlxColor.BLACK);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	add(particleEmitter);
}

function postCreate(){
	silhouettes = new FlxBackdrop(Paths.image('stages/extras/silhouettes'), FlxAxes.X, 0, 0);
	silhouettes.setGraphicSize(Std.int(silhouettes.width * 0.9));
	silhouettes.cameras = [camBars];
	silhouettes.screenCenter();
	silhouettes.x += 350;
	silhouettes.alpha = 0.0001;
	add(silhouettes);

	topBars = new FlxSprite().makeSolid(2700, 320, FlxColor.BLACK);
	topBars.cameras = [camBars];
	topBars.screenCenter();
	topBars.y -= 850;
	topBars.x -= 10;
	add(topBars);

	bottomBars = new FlxSprite().makeSolid(2700, 320, FlxColor.BLACK);
	bottomBars.cameras = [camBars];
	bottomBars.screenCenter();
	bottomBars.y += 850;
	bottomBars.x -= 10;
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

	camBars.x += 0.5;

	add(shine);
	add(glow);
	add(glowDad);
}