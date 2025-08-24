//dashpulse:
var otakuBG:FlxSprite;
var zoomTweenStart:FlxTween;
public var bestPart2:Bool = false; 
public var lossingHealth:Bool = false;
public var multiplierDrain:Float = 1; //health drain in that one part yeah
//public var NTSCshader:Shaders.NTSCEffect = new NTSCEffect();
var NTSCshader:CustomShader = new CustomShader("NTSCShader"); //fuck
var lowquality:CustomShader = new CustomShader("244p"); 

function create()
{
	defaultCamZoom = 0.7;
}

function postCreate()
{
	otakuBG = new FlxSprite(-874, -255).loadGraphic(Paths.image('stages/dash/dashpulse_bg'));
	otakuBG.scrollFactor.set(1, 1);
	otakuBG.antialiasing = false;
    insert(1, otakuBG);
	
	FlxG.camera.addShader(lowquality);camHUD.addShader(lowquality);

	whiteScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));
	whiteScreen.color =  FlxColor.BLACK;
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	add(whiteScreen);
	whiteScreen.cameras = [camHUD];

	topBarsALT = new FlxSprite().makeGraphic(2580, 320);
	topBarsALT.color =  FlxColor.BLACK;
	topBarsALT.cameras = [camBars];
	topBarsALT.screenCenter();
	topBarsALT.y -= 450;
	insert(1, topBarsALT);

	bottomBarsALT = new FlxSprite().makeGraphic(2580, 320);
	bottomBarsALT.color =  FlxColor.BLACK;
	bottomBarsALT.cameras = [camBars];
	bottomBarsALT.screenCenter();
	bottomBarsALT.y += 450;
	insert(1, bottomBarsALT);
}

function onSongStart()
{
	zoomTweenStart = FlxTween.tween(whiteScreen, {alpha: 0}, Conductor.crochet/1000*32, {
		ease: FlxEase.linear
		});
}
function beatHit(curBeat:Int) {
	switch(curBeat)
    {
        case 100:
            otakuBG.color = 0xFFFFFFFF;
        case 256:
            colorTween([gf, otakuBG], 0.7, FlxColor.WHITE, 0xFF191919);
        case 320:
            colorTween([gf, otakuBG], 1, 0xFF191919, FlxColor.WHITE);
    }
}