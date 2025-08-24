var angleshit = 1;
var anglevar = 2;

var active:Bool = false;

var chris_pratt:FlxTween;
function create() {
	oldVideoResolution=true;
}
function postCreate() {
	noCurLight = true;
	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vignette'));
	vignetteTrojan.antialiasing = true;
	vignetteTrojan.cameras = [camBars];
	if(oldVideoResolution) vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 0;
	vignetteTrojan.color = FlxColor.CYAN;
	add(vignetteTrojan);
}

function beatHit(curBeat:Int) {
	if (curBeat == 100 || curBeat == 260 || curBeat == 288){
		active = true;
	}
	if (curBeat == 160 || curBeat == 284 || curBeat == 336){
		active = false;
	}
	
	if (active){
		if (curBeat % 2 == 0){
			angleshit = anglevar;
		}else{
			angleshit = -anglevar;
		}
		FlxG.camera.angle=angleshit*3;
		chris_pratt=FlxTween.tween(FlxG.camera, {angle: angleshit}, Conductor.stepCrochet*0.002, {ease: FlxEase.circOut});
		}else{
		//chris_pratt.cancel();
		FlxG.camera.angle=0;
	}
	switch(curBeat)
	{
		case 32:
			FlxTween.tween(camHUD, {alpha:1}, 1, {ease: FlxEase.sineInOut});
		case 28 | 84:
			FlxTween.tween(FlxG.camera, {zoom:1.3}, 1.5, {ease: FlxEase.sineInOut});
		case 99:
			FlxTween.tween(FlxG.camera, {zoom:FlxG.camera.zoom - 0.2}, 3, {ease: FlxEase.sineInOut});
		case 100:
			gf.color = 0xFFFFFFFF;
			FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet/1000);
		case 256:
			defaultCamZoom = 1.1;
			bestPart2 = lossingHealth = true;
			multiplierDrain = 1.5;
		case 320:
			defaultCamZoom = 0.65;
			bestPart2 = lossingHealth = false;
		case 354:
			FlxTween.tween(camHUD, {alpha:0}, 1, {ease: FlxEase.sineInOut});
		case 364:
			camGame.alpha = 0;
	}
}