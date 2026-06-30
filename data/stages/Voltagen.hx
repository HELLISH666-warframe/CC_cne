import psych.BGSprite;

var chromFloat:Float = 0;

var ChromaticAberrationEffect = new CustomShader("ChromaticAberrationShader");
function setChrome(shader:Dynamic,chromeOffset) {
	shader.rOffset=chromeOffset;
	shader.gOffset=0;
	shader.bOffset=chromeOffset * -1;
}

function postNew() {
	var bg:BGSprite = new BGSprite('extras/voltagen/electric', -500, -150, 1, 1);
	//bg.screenCenter();
	bg.setGraphicSize(Std.int(bg.width * 1.1));
	bg.updateHitbox();
	add(bg);

	topBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	topBarsALT.camera = camBars;
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	add(topBarsALT);
			
	bottomBarsALT = new FlxSprite().makeSolid(2580,320, FlxColor.BLACK);
	bottomBarsALT.camera = camBars;
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	add(bottomBarsALT);

	electricCountdown = new BGSprite('extras/voltagen/countdown', 0, 0, 0, 0, ['Symbol 2519'], false);
	electricCountdown.screenCenter();
	add(electricCountdown);

	if (FlxG.save.data.shaders) {camGame.addShader(ChromaticAberrationEffect);
		camHUD.addShader(ChromaticAberrationEffect);
	}
	skipCountdown = true;
}

function postUpdate(elapsed:Float) {
	if(electricCountdown.animation.curAnim.finished) electricCountdown.alpha = 0;
	setChrome(ChromaticAberrationEffect,0.0010+chromFloat);

	if(startedCountdown){
		notes.forEachAlive(function(daNote:Note){
		});
		chromFloat += chromFloat + 0.005 * elapsed;
	}
}