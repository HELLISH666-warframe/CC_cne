var angleshit = 1;
var anglevar = 2;
var doSilly:Bool = true;
var eventNum = 0;

var active:Bool = false;

var chris_pratt:FlxTween;

function onBeatHit(){
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
		chris_pratt.cancel();
		FlxG.camera.angle=0;
	}
}