//dashpulse:
var otakuBG:FlxSprite;
var time:Float = 0;

function create()
{
	//defaultCamZoom = 0.7;

	rsod = new FlxSprite(-100, -90).loadGraphic(Paths.image('menus/EProcess/rsod'));
	rsod.scrollFactor.set(1, 1);
	rsod.setGraphicSize(Std.int(rsod.width * 2));
	rsod.antialiasing = true;
	rsod.shader = new CustomShader("CRT");

	insert(1,rsod);

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
function update(elapsed:Float) {
	time += elapsed;
	rsod.shader.data.iTime.value = [time];
}