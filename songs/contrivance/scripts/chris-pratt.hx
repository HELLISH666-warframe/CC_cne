import openfl.Lib;
import lime.app.Application;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;

var glowBeat:Bool = false;
var glowSuperBeat:Bool = false;
var glowTween:FlxTween;

var frgreger:Bool = true;

#if !windows
var nightTimeShader:CustomShader = new CustomShader("nightTimeShader"); 

#else

var nightTimeShader:CustomShader = new CustomShader("NightTimeShader-unix"); 

#end

function postCreate() {
	nightTimeShader.data.iTime.value=0;
	noCurLight = true;
	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vignette'));
	vignetteTrojan.antialiasing = true;
	vignetteTrojan.cameras = [camBars];
	if(oldVideoResolution) vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0;
	vignetteTrojan.color = FlxColor.CYAN;
	add(vignetteTrojan);

	tipDay = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/sam/tipOfTheDay'));
	tipDay.scale.set(1,1);
	tipDay.setGraphicSize(Std.int(tipDay.width * 2));
	tipDay.cameras = [camOther];
	tipDay.screenCenter();
	//tipDay.antialiasing = Options.antialiasing;
	add(tipDay);
	camGame.fade(FlxColor.BLACK, 0, false);
	camHUD.alpha = 0;
	//precacheList.set('samTip', 'sound');
	//skipCountdown = true;

	var tip:FlxSound = new FlxSound().loadEmbedded(Paths.sound('samTip'));
	vocals.pause();
	new FlxTimer().start(0.08, function(tmr:FlxTimer)
		tip.play(true));
	tip.onComplete = function() {
		frgreger=false;
		startCountdown();
		canReset = true;
		canPause = true;
		camGame.fade(FlxColor.BLACK, 0.5, true);
		remove(tipDay);
		tipDay.destroy();
	}
}

function onStartCountdown(e) {
	if(frgreger)
	e.cancel();
}
function stepHit(curStep:Int) {
	switch(curStep) {
		case 15: FlxTween.tween(camHUD, {alpha: 1}, 0.7);
		case 412: blackBars(1);
		case 144: FlxTween.tween(blackBG, {alpha: 0.8}, 0.4);
		case 160: blackBG.alpha = 0;
		case 416: FlxTween.tween(camHUD, {alpha: 0}, 1);
		case 418: dialogOnSong("So, you never give shit about what you do?", 7, 0xFF3A3A3A);
		case 446: dialogOnSong("Rapping out on randoms like you've never met them in life?", 7, 0xFF3A3A3A);
		for (i in 0...cpuStrums.members.length){
			cpuStrums.members[i].visible=false;
			cpuStrums.members[i].x -= 1200;
		}
		case 448: FlxTween.tween(silhouettes, {alpha: 1}, 0.4);
		silhouettes.velocity.set(-254,0);
		case 472: FlxTween.tween(silhouettes, {alpha: 0}, 0.4);
		case 476: blackBars(0);
		FlxTween.tween(camHUD, {alpha: 1}, 1);
		boyfriend.playAnim('hey', true);
		//boyfriend.specialAnim = true;
		//cameraLocked = true;
		//camFollowPos.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y);
		//FlxG.camera.focusOn(camFollowPos.getPosition());	
		//case 480: cameraLocked = false;
		case 482: dialogOnSong("Well, I'll tell you what", 1, 0xFF3A3A3A);
		case 494: dialogOnSong("ya better get off track.", 1.5, 0xFF3A3A3A);
		case 496: for (i in 0...cpuStrums.members.length){
			cpuStrums.members[i].alpha=0;
			cpuStrums.members[i].visible -= true;
		}
		case 504: for (i in 0...cpuStrums.members.length){
			FlxTween.tween(cpuStrums.members[i],{alpha: 1},1);
			FlxTween.tween(cpuStrums.members[i],{x: cpuStrums.members[i].x + 1200},2,{ease: FlxEase.sineInOut});
		}
		case 544: FlxTween.tween(blackBG, {alpha: 0.8}, 0.4);
		case 672: glowBeat = true;
		case 800: glowSuperBeat = true;
		glowBeat = false;
		case 928: camHUD.fade(FlxColor.BLACK, 0.5, false);
		glowSuperBeat = false;	
		case 935: glow.alpha = 0;
		glowDad.alpha = 0;
		case 944: if(FlxG.save.data.flashing_cc) FlxG.camera.flash(FlxColor.WHITE, 1);
		/*if (ClientPrefs.shaders)*/ FlxG.camera.addShader(nightTimeShader); //the bbpanzu bloom shader is also laggy af and idk if it's actually less laggy lmfao
		whiteScreen.alpha = 1;
		objectColor([dad, boyfriend], FlxColor.BLACK);
		camHUD.fade(FlxColor.BLACK, 1.5, true);
		boyfriend.alpha = 0;
		blackBG.alpha = 0;
		shine.alpha = 0;
		case 1071: boyfriend.alpha = 1;
		particleEmitter.alpha.set(1, 1);
		if(FlxG.save.data.flashing_cc) FlxG.camera.flash(FlxColor.WHITE, 0.5);
		case 1384: for (i in 0...cpuStrums.members.length){
			FlxTween.tween(cpuStrums.members[i],{alpha: 0},1);
		}
		case 1392: blackBars(1);
		dialogOnSong("AAAA- *ROFLCOPTER NOISES*", 3, 0xFF3A3A3A);
		colorTween([dad], 0.3, FlxColor.BLACK, FlxColor.WHITE);
		case 1416: dialogOnSong("Fuck this shit I'm off to read out error messages in my computer.", 7, 0xFF3A3A3A);
		case 1454: dialogOnSong("Now...", 2, 0xFF3A3A3A);
		case 1466: dialogOnSong("Get out!", 3, 0xFF3A3A3A);
		case 1476: camGame.alpha = 0;
		camHUD.alpha = 0;
		camLYRICS.alpha = 0;
	}
}

function beatHit(curBeat:Int) {
	if (glowBeat && curBeat % 2 == 0) {
		if (curCameraTarget==1) {
			glow.alpha = 1;
			glowTween = FlxTween.tween(glow, {alpha:0}, Conductor.crochet * 0.002, {ease: FlxEase.sineIn,
				 onComplete: function(twn:FlxTween) {
					glowTween = null;
					glow.alpha = 0;
				}
			});
		} else if (curCameraTarget==0) {
			glowDad.alpha = 1;
			glowTween = FlxTween.tween(glowDad, {alpha:0}, Conductor.crochet * 0.002, {ease: FlxEase.sineIn,
				onComplete: function(twn:FlxTween) {
					glowTween = null;
					glowDad.alpha = 0;
				}
			});
		}
	}
}
function update(elapsed:Float) {
	nightTimeShader.data.iTime.value += elapsed;
}