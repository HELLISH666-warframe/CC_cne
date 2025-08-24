import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
function create()
{
	alanBG = new FlxSprite(-80, -1800).loadGraphic(Paths.image('stages/alan/alan_desktop'));
	alanBG.setGraphicSize(Std.int(alanBG.width * 5));
	alanBG.scrollFactor.set(1, 1);
	insert(1,alanBG);

	var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(-400, 1500);
	particleEmitter.scale.set(1.5, 1.5, 1.5, 1.5, 0, 0, 0, 0);
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.loadParticles(Paths.image('particle'), 500, 16, true);
			
	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	//particleEmitter.cameras =  [camChar];
	particleEmitter.color.set(FlxColor.WHITE, FlxColor.WHITE);
	insert(2,particleEmitter);

	googleBurn = new FlxSprite(1280, 85);
	googleBurn.frames = Paths.getSparrowAtlas('menus/EProcess/GoogleBurning');
	googleBurn.animation.addByPrefix('idle', 'Symbol 2 instance 10', 16, true);
	googleBurn.animation.play('idle');
	insert(3,googleBurn);

	daFloor = new FlxSprite(-80, -1800).loadGraphic(Paths.image('stages/chapter2/floor'));
	daFloor.scrollFactor.set(1, 1);
	daFloor.screenCenter();
	daFloor.y += 710;
	daFloor.x += 2300;
	insert(4,daFloor);

	veryEpicVignette = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/chapter2/proficiency/proficiencyOverlay1'));
	veryEpicVignette.scrollFactor.set(1, 1);
	veryEpicVignette.screenCenter();
	veryEpicVignette.updateHitbox();
	//veryEpicVignette.cameras = [camBars];
	veryEpicVignette.cameras = [camHUD];
	add(veryEpicVignette);

	glow = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/chapter2/proficiency/proficiencyOverlay'));
	glow.screenCenter();
	glow.updateHitbox();
	//glow.cameras = [camBars];
	glow.cameras = [camHUD];
	glow.alpha = 0;
	add(glow);

	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/chapter2/proficiency/proficiencyOverlayMid'));
	//vignetteTrojan.cameras = [camBars];
	vignetteTrojan.cameras = [camHUD];
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0;
	add(vignetteTrojan);

	redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/chapter2/proficiency/proficiencyOverlayA'));
	redthing.antialiasing = true;
	//redthing.cameras = [camBars];
	redthing.cameras = [camHUD];
	redthing.alpha = 0.0001;
	add(redthing);

	twitterBurn = new FlxSprite(2850, 500);
	twitterBurn.frames = Paths.getSparrowAtlas('menus/EProcess/TwitterBurning');
	twitterBurn.animation.addByPrefix('idle', 'Symbol 4 instance 10', 16, true);
	twitterBurn.animation.play('idle');
	twitterBurn.scale.set(1.2, 1.2);
	twitterBurn.scrollFactor.set(1.3, 1.3);
	twitterBurn.angle = -20;
	//insert(5,twitterBurn);//??
	add(twitterBurn);

	newgroundsBurn = new FlxSprite(-485,230);
	newgroundsBurn.frames = Paths.getSparrowAtlas('menus/EProcess/NewgroundsBurning');
	newgroundsBurn.animation.addByPrefix('idle', 'Symbol 3 instance 10', 16, true);
	newgroundsBurn.animation.play('idle');
	newgroundsBurn.scale.set(1.2, 1.2);
	newgroundsBurn.scrollFactor.set(1.3, 1.3);
	newgroundsBurn.angle = 40;
	insert(6,newgroundsBurn);//??

	shine = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/world1/shine'));
	shine.scrollFactor.set(1, 1);
	shine.screenCenter();
	shine.antialiasing = true;
	shine.updateHitbox();
	insert(7,shine);//??
	
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

function update(elapsed)
{
}
function beatHit(curBeat:Int) {
	if (curSong.toLowerCase() == 'proficiency') 
		{	
			switch(curBeat)
			{
			case 16:
				FlxTween.tween(camHUD, {alpha:1}, 1);
			case 64:
				veryEpicVignette.alpha = 1;
			case 156:
				FlxTween.tween(blackBG, {alpha:1}, 0.3);
			case 160:
				blackBG.alpha = 0;
				glow.alpha = 1;
				redthing.alpha = 1;
				camChar.alpha = 1;
				veryEpicVignette.alpha = 0;
			case 224:
				veryEpicVignette.alpha = 1;
				glow.alpha = 0;
				redthing.alpha = 0;
				camChar.alpha = 0;
			case 284:
				opponentStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha:ClientPrefs.middleScroll ? 0 : 0}, 1));
			case 288:
				veryEpicVignette.alpha = 0;
				vignetteTrojan.alpha = 1;
			case 316:
				opponentStrums.forEach(function(spr:StrumNote) FlxTween.tween(spr, {alpha:ClientPrefs.middleScroll ? 0 : 1}, 1));
				dad.playAnim('phase3Transition', true);
				dad.specialAnim = true;
			case 320:
				altAnimation2 = true;
				vignetteTrojan.alpha = 0;
				glow.alpha = 1;
				redthing.alpha = 1;
				camChar.alpha = 1;
		}
	}
}