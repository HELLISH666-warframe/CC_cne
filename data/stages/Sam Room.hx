import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.addons.display.FlxBackdrop;

var bbgColor:FlxColor = 0xFF000000;
function create()
{
	//defaultCamZoom = 0.7;

	bg = new FlxSprite(-500, -150).loadGraphic(Paths.image('stages/SAM/sam_room'));
	bg.scrollFactor.set(1, 1);
	bg.updateHitbox();
	bg.setGraphicSize(Std.int(bg.width * 0.85));
	insert(1,bg);
	
	shine = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/world1/shine'));
	shine.scrollFactor.set(1, 1);
	shine.screenCenter();
	shine.antialiasing = true;
	shine.updateHitbox();
	
	blackBG = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), bbgColor);
	blackBG.scrollFactor.set();
	blackBG.alpha = 0;
	blackBG.screenCenter();
	insert(4,blackBG);
	
	whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	whiteScreen.alpha = 0;
	add(whiteScreen);
		
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
	
	var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(-400, 1000);
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.scale.set(2, 2, 2, 2, 0, 0, 0, 0);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.alpha.set(0, 0);
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.color.set(FlxColor.BLACK, FlxColor.BLACK);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	add(particleEmitter);

	silhouettes = new FlxBackdrop(Paths.image('stages/extras/silhouettes'), FlxAxes.X, 0, 0);
	silhouettes.setGraphicSize(Std.int(silhouettes.width * 0.9));
	//silhouettes.cameras = [camBars];
	silhouettes.cameras = [camHUD];
	silhouettes.screenCenter();
	silhouettes.x += 350;
	silhouettes.alpha = 0.0001;
	add(silhouettes);

	topBars = new FlxSprite().makeSolid(2700, 320, FlxColor.BLACK);
	//topBars.cameras = [camBars];
	topBars.cameras = [camHUD];
	topBars.screenCenter();
	topBars.y -= 850;
	topBars.x -= 10;
	insert(1,topBars);

	bottomBars = new FlxSprite().makeSolid(2700, 320, FlxColor.BLACK);
	//bottomBars.cameras = [camBars];
	bottomBars.cameras = [camHUD];
	bottomBars.screenCenter();
	bottomBars.y += 850;
	bottomBars.x -= 10;
	insert(1,bottomBars);
			
	topBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	//topBarsALT.cameras = [camBars];
	topBarsALT.cameras = [camHUD];
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	insert(1,topBarsALT);

	bottomBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	//bottomBarsALT.cameras = [camBars];
	bottomBarsALT.cameras = [camHUD];
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	insert(1,bottomBarsALT);

	//camBars.x += 0.5;

		
	tipDay = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/SAM/tipOfTheDay'));
	tipDay.scrollFactor.set(1, 1);
	tipDay.setGraphicSize(Std.int(tipDay.width * 2));
	//tipDay.cameras = [camOther];
	tipDay.cameras = [camHUD];
	tipDay.screenCenter();
	tipDay.antialiasing = true;
	add(tipDay);
}

function postCreate()
{
	add(glow);
	add(glowDad);
}
function stepHit(curStep:Int) {
	switch(curStep) {
		case 15:
			FlxTween.tween(camHUD, {alpha: 1}, 0.7);
		case 412:
			blackBars(1);
			
		case 144:
			FlxTween.tween(blackBG, {alpha: 0.8}, 0.4);
		case 160:
			blackBG.alpha = 0;
		case 416:
			FlxTween.tween(camHUD, {alpha: 0}, 1);
		case 418:
			dialogOnSong("So, you never give shit about what you do?", 7, 0xFF3A3A3A);
		case 446:
			dialogOnSong("Rapping out on randoms like you've never met them in life?", 7, 0xFF3A3A3A);
			for (i in 0...opponentStrums.length) {
				opponentStrums.members[i].visible = false;
				opponentStrums.members[i].x -= 1200;
			}
		case 448:
			FlxTween.tween(silhouettes, {alpha: 1}, 0.4);
			silhouettes.velocity.set(-254,0);
		case 472:
			FlxTween.tween(silhouettes, {alpha: 0}, 0.4);
		case 476:
			blackBars(0);
			FlxTween.tween(camHUD, {alpha: 1}, 1);
			boyfriend.playAnim('hey', true);
			boyfriend.specialAnim = true;
			cameraLocked = true;
			camFollowPos.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y);
			FlxG.camera.focusOn(camFollowPos.getPosition());
			
		case 480:
			cameraLocked = false;
		case 482:
			dialogOnSong("Well, I'll tell you what", 1, 0xFF3A3A3A);
		case 494:
			dialogOnSong("ya better get off track.", 1.5, 0xFF3A3A3A);
		case 496:
			for (i in 0...opponentStrums.length) {
				opponentStrums.members[i].alpha = 0;
				opponentStrums.members[i].visible = true;
			}
		case 504:
			for (i in 0...opponentStrums.length) {
				if (!ClientPrefs.middleScroll) {
					FlxTween.tween(opponentStrums.members[i], {alpha: ClientPrefs.middleScroll ? 0 : 1}, 1);
					FlxTween.tween(opponentStrums.members[i], {x: opponentStrums.members[i].x + 1200}, 2, {ease: FlxEase.sineInOut});
				}else{
					FlxTween.tween(opponentStrums.members[i], {alpha: ClientPrefs.middleScroll ? 0 : 0.35}, 1);
					opponentStrums.members[i].x += 1200;
				}
			}
			
		case 544:
			FlxTween.tween(blackBG, {alpha: 0.8}, 0.4);
			
		case 672:
			glowBeat = true;
		case 800:
			glowSuperBeat = true;
			glowBeat = false;
			
		case 928:
			camHUD.fade(FlxColor.BLACK, 0.5, false);
			glowSuperBeat = false;
			
		case 935:
			glow.alpha = 0;
			glowDad.alpha = 0;
		case 944:
			if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);

			if (ClientPrefs.shaders) FlxG.camera.setFilters([new ShaderFilter(nightTimeShader.shader)]);
			whiteScreen.alpha = 1;
			objectColor([dad, boyfriend], FlxColor.BLACK);
			camHUD.fade(FlxColor.BLACK, 1.5, true);
			boyfriend.alpha = 0;
			blackBG.alpha = 0;
			shine.alpha = 0;
		case 1071:
			boyfriend.alpha = 1;
			particleEmitter.alpha.set(1, 1);
			if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 0.5);
		case 1384:
			for (i in 0...opponentStrums.length) {
				FlxTween.tween(opponentStrums.members[i], {alpha: 0}, 1);
			}
		case 1392:
			blackBars(1);
			dialogOnSong("AAAA- *ROFLCOPTER NOISES*", 3, 0xFF3A3A3A);
			colorTween([dad], 0.3, FlxColor.BLACK, FlxColor.WHITE);
		case 1416:
			dialogOnSong("Fuck this shit I'm off to read out error messages in my computer.", 7, 0xFF3A3A3A);
		case 1454:
			dialogOnSong("Now...", 2, 0xFF3A3A3A);
		case 1466:
			dialogOnSong("Get out!", 3, 0xFF3A3A3A);
		case 1476:
			camGame.alpha = 0;
			camHUD.alpha = 0;
			camLYRICS.alpha = 0;
}
}