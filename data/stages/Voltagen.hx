//dashpulse:
var otakuBG:FlxSprite;

function create()
{
	//defaultCamZoom = 0.7;

	bg = new FlxSprite(-500, -150).loadGraphic(Paths.image('stages/voltagen/electric'));
	bg.scrollFactor.set(1, 1);
	bg.setGraphicSize(Std.int(bg.width * 1.1));
	bg.updateHitbox();
	insert(1,bg);

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