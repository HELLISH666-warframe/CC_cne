import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
var Crowd:FlxSprite;
var Background1:FlxSprite;
var shine:FlxSprite;
var Floor:FlxSprite;
var spotlightdad:FlxSprite;
var spotlightbf:FlxSprite;
function postCreate() {
	//camZooming = true;
	aolBG.updateHitbox();

	aolBack.x += 980;
	aolBack.updateHitbox();
	add(aolBack);
	
	var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(0, 1000);
	particleEmitter.scale.set(2, 2, 2, 2, 0, 0, 0, 0);
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.alpha.set(0, 0);
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.loadParticles(Paths.image('particle'), 500, 16, true);
	particleEmitter.color.set(FlxColor.YELLOW, FlxColor.YELLOW);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	insert(members.indexOf(aolBack)+1,particleEmitter);

	aolFloor.y += 625;
	aolFloor.x -= 200;
	aolFloor.updateHitbox();
	scanline = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/aol/scanline'));
	scanline.cameras = [camOther];
	scanline.screenCenter();
	scanline.updateHitbox();
	scanline.alpha = 0.05;
	add(scanline);
}