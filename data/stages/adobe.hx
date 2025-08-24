var Crowd:FlxSprite;
var Background1:FlxSprite;
var shine:FlxSprite;
var Floor:FlxSprite;
var spotlightdad:FlxSprite;
var spotlightbf:FlxSprite;
var time:Float = 0;
function create()
{
	Background1 = new FlxSprite(-600, -600).loadGraphic(Paths.image('stages/adobe/bg'));
	Background1.scrollFactor.set(0.9, 0.9);
	Background1.antialiasing = true;
	insert(1,Background1);
}

function postCreate()
{
	
	whiteScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));
	whiteScreen.color =  FlxColor.WHITE;
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	whiteScreen.alpha = 0;
	add(whiteScreen);
	whiteScreen.cameras = [camHUD];

	whiteScreen.color = Background1.color;
if (curSong.toLowerCase() == 'outrage' || (curSong == 'phantasm')) 
	{
		FlxG.camera.fade(FlxColor.BLACK, 0, true);
	}
	if (curSong.toLowerCase() == 'end-process') 
	{
		fires1 = new FlxSprite(870, -240);
		fires1.frames = Paths.getSparrowAtlas('stages/victim/BGFire');
		fires1.setGraphicSize(Std.int(fires1.width * 1.4));
		fires1.animation.addByPrefix('1', 'Symbol 1 instance ', 24, true);
		fires1.scrollFactor.set(0.9, 0.9);
		fires1.animation.play("1");
		insert(2, fires1);

		fires2 = new FlxSprite(-1500, -240);
		fires2.frames = Paths.getSparrowAtlas('stages/victim/BGFire');
		fires2.setGraphicSize(Std.int(fires2.width * 1.4));
		fires2.animation.addByPrefix('1', 'Symbol 1 instance ', 24, true);
		fires2.scrollFactor.set(0.9, 0.9);
		fires2.animation.play("1");
		insert(3, fires2);

		virabot1 = new FlxSprite(-50, 455);
		virabot1.frames = Paths.getSparrowAtlas('menus/EProcess/virabop');
		virabot1.setGraphicSize(Std.int(virabot1.width * 1.3));
		virabot1.animation.addByPrefix('ViraBop', 'ViraBop', 24, true);
		virabot1.scrollFactor.set(0.9, 0.9);
		virabot1.animation.play("ViraBop");
		insert(4, virabot1);

		virabot4 = new FlxSprite(-650, 455);
		virabot4.frames = Paths.getSparrowAtlas('menus/EProcess/virabop');
		virabot4.setGraphicSize(Std.int(virabot4.width * 1.3));
		virabot4.animation.addByPrefix('ViraBop', 'ViraBop', 24, true);
		virabot4.scrollFactor.set(0.9, 0.9);
		virabot4.animation.play("ViraBop");
		insert(5, virabot4);

		virabot2 = new FlxSprite(1250, 455);
		virabot2.frames = Paths.getSparrowAtlas('menus/EProcess/virabop');
		virabot2.setGraphicSize(Std.int(virabot2.width * 1.3));
		virabot2.animation.addByPrefix('ViraBop', 'ViraBop', 24, true);
		virabot2.scrollFactor.set(0.9, 0.9);
		virabot2.animation.play("ViraBop");
		virabot2.flipX = true;
		insert(6, virabot2);

		virabot3 = new FlxSprite(1750, 455);
		virabot3.frames = Paths.getSparrowAtlas('menus/EProcess/virabop');
		virabot3.setGraphicSize(Std.int(virabot3.width * 1.3));
		virabot3.animation.addByPrefix('ViraBop', 'ViraBop', 24, true);
		virabot3.scrollFactor.set(0.9, 0.9);
		virabot3.animation.play("ViraBop");
		virabot3.flipX = true;
		insert(7, virabot3);

		googleBurn = new FlxSprite(0, -1100);
		googleBurn.frames = Paths.getSparrowAtlas('menus/EProcess/GoogleBurning');
		googleBurn.animation.addByPrefix('idle', 'Symbol 2 instance 10', 16, true);
		googleBurn.animation.play('idle');
		googleBurn.scale.set(0.7, 0.7);
		googleBurn.screenCenter();
		googleBurn.y -= 900;
		googleBurn.x += 250;
		googleBurn.angle = -4;
		insert(8, googleBurn);
		FlxTween.angle(googleBurn, googleBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		twitterBurn = new FlxSprite(1300, -820);
		twitterBurn.frames = Paths.getSparrowAtlas('menus/EProcess/TwitterBurning');
		twitterBurn.animation.addByPrefix('idle', 'Symbol 4 instance 10', 16, true);
		twitterBurn.animation.play('idle');
		twitterBurn.scale.set(0.7, 0.7);
		twitterBurn.angle = -4;
		insert(9, twitterBurn);
		FlxTween.angle(twitterBurn, twitterBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		newgroundsBurn = new FlxSprite(-1000, -1020);
		newgroundsBurn.frames = Paths.getSparrowAtlas('menus/EProcess/NewgroundsBurning');
		newgroundsBurn.animation.addByPrefix('idle', 'Symbol 3 instance 10', 16, true);
		newgroundsBurn.animation.play('idle');
		newgroundsBurn.scale.set(0.7, 0.7);
		newgroundsBurn.angle = -4;
		insert(10, newgroundsBurn);
		FlxTween.angle(newgroundsBurn, newgroundsBurn.angle, 4, 2, {ease: FlxEase.quartInOut, type: FlxEase.PINGPONG});

		corruptBG = new FlxSprite(-650, -600).loadGraphic(Paths.image('stages/chapter1/bgCorrupted'));
		corruptBG.scrollFactor.set(0.9, 0.9);
		corruptBG.setGraphicSize(Std.int(corruptBG.width * 1.1));
		corruptBG.color = 0xFF7B6CAD;
		corruptBG.alpha = 0.0001;
		corruptBG.shader = new CustomShader("CRT");
		insert(11,corruptBG);

		corruptFloor = new FlxSprite(-750, -405).loadGraphic(Paths.image('stages/chapter1/floorCorrupted'));
		corruptFloor.scrollFactor.set(1, 1);
		corruptFloor.setGraphicSize(Std.int(corruptFloor.width * 1.2));
		corruptFloor.color = 0xFF7B6CAD;
		corruptFloor.alpha = 0.0001;
		corruptFloor.shader = new CustomShader("CRT");

		bsodStatic = new FlxSprite(-50, -90).loadGraphic(Paths.image('menus/EProcess/error_3rdsong'));
		bsodStatic.scrollFactor.set(1, 1);
		bsodStatic.setGraphicSize(Std.int(bsodStatic.width * 2.4));
		bsodStatic.antialiasing = true;
		bsodStatic.alpha = 0.0001;
		bsodStatic.shader = new CustomShader("CRT");

		rsod = new FlxSprite(-50, -90).loadGraphic(Paths.image('stages/chapter1/EProcess/rsod'));
		rsod.scrollFactor.set(1, 1);
		rsod.setGraphicSize(Std.int(rsod.width * 2.4));
		rsod.antialiasing = true;
		rsod.alpha = 0.0001;

		redthing = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/victim/vignette'));
		redthing.antialiasing = true;
		//redthing.cameras = [camBars];
		redthing.cameras = [camHUD];
		redthing.alpha = 0.0001;
		add(redthing);
	}
}

function update(elapsed)
{
	time += elapsed;
	corruptBG.shader.data.iTime.value = [time];
}
function stepHit(curStep:Int) {
	if (curSong.toLowerCase() == 'end-process') 
		{				switch(curStep)
			{
			//	case 1:
			//		if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 1}, 2);
			//	case 192:
			//		if(popupsExplanation != null) FlxTween.tween(popupsExplanation, {alpha: 0}, 1);
			//		FlxG.camera.fade(FlxColor.BLACK, 1, true);
				case 1344:
					FlxTween.tween(redthing, {alpha: 0}, 0.4);
					showUpCorruptBackground(true);
					dad.color = 0xFF7A006A;
					boyfriend.color = 0xFF7B6CAD;
				case 1536:
					endProcessBSODS(true, 1);
					FlxTween.color(dad, 1, 0xFF7A006A, FlxColor.WHITE);
					FlxTween.color(boyfriend, 1, 0xFF7B6CAD, FlxColor.WHITE);
				case 1580:
					showUpCorruptBackground(false);
				case 1600:
					endProcessBSODS(false, 1);
					FlxTween.tween(redthing, {alpha: 1}, 0.8);
			}
		}
}
function beatHit(curBeat:Int) {
if (curSong.toLowerCase() == 'end-process') 
	{	
		switch(curBeat)
		{
			case 76:
				defaultCamZoom += 0.3;

			case 78 | 79:
				defaultCamZoom -= 0.075;

			case 80:
				defaultCamZoom -= 0.15;
				FlxG.camera.zoom = defaultCamZoom;

				FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000);

			case 144:
				defaultCamZoom += 0.2;
			case 192:
				defaultCamZoom += 0.2;

			case 176:
				defaultCamZoom -= 0.2;

			case 208:
				defaultCamZoom -= 0.2;

			case 336:
				var epRTween1:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
				stopTweens.push(epRTween1);
			case 368:
				var epRTween2:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom - 0.4}, Conductor.crochet / 1000, {ease: FlxEase.linear});

				stopTweens.push(epRTween2);
			case 398:
				var epRTween3:FlxTween = FlxTween.tween(this, {defaultCamZoom: defaultCamZoom + 0.4}, Conductor.crochet / 1000 * 16, {ease: FlxEase.linear});
				stopTweens.push(epRTween3);

			case 400:
				defaultCamZoom -= 0.4;
			case 80:
				FlxTween.tween(redthing, {alpha: 1}, 0.6);

			//	if (!ClientPrefs.lowQuality)
			//	{
					var epTween1:FlxTween = FlxTween.tween(newgroundsBurn, {y:newgroundsBurn.y +2300}, 2, {ease: FlxEase.linear, type:LOOPING});
					var epTween2:FlxTween = FlxTween.tween(twitterBurn, {y:twitterBurn.y +1800}, 1.6, {ease: FlxEase.linear, type:LOOPING});
					var epTween3:FlxTween = FlxTween.tween(googleBurn, {y:googleBurn.y +2900}, 2.5, {ease: FlxEase.linear, type:LOOPING});

					stopTweens.push(epTween1);
					stopTweens.push(epTween2);
					stopTweens.push(epTween3);
			//	}
			case 460:
				FlxG.sound.play(Paths.sound('intro3'), 0.8);
			case 461:
				FlxG.sound.play(Paths.sound('intro2'), 0.8);
			case 462:
				FlxG.sound.play(Paths.sound('intro1'), 0.8);
			case 463:
				FlxG.sound.play(Paths.sound('introGo'), 0.8);
			case 464:
			//	FlxG.camera.setFilters([new ShaderFilter(fishEyeshader)]);

				//fishEyeshader.MAX_POWER.value = [0.10];
			/*case 400:
				generateStaticArrows(0);
				generateStaticArrows(1);
				skipArrowStartTween = true;*/
			case 416:
				//FlxTween.tween(redthing, {alpha: 0}, 2);
			/*case 448:
				camFollow.x = 750;
				camFollow.y = 350;
				isCameraOnForcedPos = true;
				defaultCamZoom = 0.6;
				FlxTween.tween(camHUD, {alpha:0}, 1);
			case 456:
				FlxG.camera.fade(FlxColor.BLACK, 2, false);*/
		}
	}
}