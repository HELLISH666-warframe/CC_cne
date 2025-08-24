//catto:
var cattoBG:FlxSprite;
//Intro Catto:
var bgStage:FlxSprite;
var stageFront:FlxSprite;
var stageLight1:FlxSprite;
var stageLight2:FlxSprite;
var stageCurtains:FlxSprite;
var time:Float = 0;

function create()
{
	defaultCamZoom = 0.5;
	bgStage = new FlxSprite(-100, -200).loadGraphic(Paths.image('stages/stageback'));
	bgStage.scrollFactor.set(0.9, 0.9);
	bgStage.setGraphicSize(Std.int(bgStage.width * 1.4));
    insert(1, bgStage);

	stageFront = new FlxSprite(-850, 600).loadGraphic(Paths.image('stages/stagefront'));
	stageFront.scrollFactor.set(1, 1);
	stageFront.setGraphicSize(Std.int(stageFront.width * 1.25));
	stageFront.updateHitbox();
	insert(2, stageFront);

	stageLight1 = new FlxSprite(-325, -100).loadGraphic(Paths.image('stages/stage_light'));
	stageLight1.scrollFactor.set(0.9, 0.9);
	stageLight1.setGraphicSize(Std.int(stageLight1.width * 1.25));
	stageLight1.updateHitbox();
	insert(3, stageLight1);

	cattoBG = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/extras/Wong_Mau'));
	cattoBG.scrollFactor.set(1, 1);
	cattoBG.scale.x = 7;
	cattoBG.scale.y = 7;
	cattoBG.y += 250;
	cattoBG.screenCenter();
	cattoBG.shader = new CustomShader("NTSCShader copy");
	cattoBG.alpha = 0;
	insert(4, cattoBG);
	
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
	time += elapsed;
	cattoBG.shader.data.iTime.value = [time];
	cattoBG.shader.data.frequency.value = [time];
	cattoBG.shader.data.amplitude.value = [time];
}
function stepHit(curStep:Int) {
	switch(curStep) {
		case 638:
			FlxTween.tween(camHUD, {alpha: 0}, 0.7);
		case 699:
			FlxTween.tween(camHUD, {alpha: 1}, 0.7);
			FlxTween.tween(cattoBG, {alpha: 1}, 0.7);
	}
}