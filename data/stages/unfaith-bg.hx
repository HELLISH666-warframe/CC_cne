import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
var Crowd:FlxSprite;
var Background1:FlxSprite;
var shine:FlxSprite;
var Floor:FlxSprite;
var spotlightdad:FlxSprite;
var spotlightbf:FlxSprite;
function create()
{
	unfaithBG = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/unfaithful/unfaithful_bg'));
	unfaithBG.scale.x = 4.25;
	unfaithBG.scale.y = 4.25;
	unfaithBG.screenCenter();
	unfaithBG.x += 150;
	unfaithBG.scrollFactor.set(0.35, 0.35);
	//if (ClientPrefs.shaders) unfaithBG.shader = wavShader.shader;
	insert(1,unfaithBG);

	unfaithBACK = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/unfaithful/unfaithful_back'));
	unfaithBACK.scrollFactor.set(0.85, 0.85);
	unfaithBACK.setGraphicSize(Std.int(unfaithBACK.width * 0.85));
	unfaithBACK.screenCenter();
	unfaithBACK.updateHitbox();
	unfaithBACK.x += 380;
	insert(2,unfaithBACK);

	FlxTween.tween(unfaithBACK, {y: unfaithBACK.y + 50}, 2, {ease:FlxEase.smoothStepInOut, type: FlxEase.PINGPONG});
						
	blackBGgf = new FlxSprite(-120, -120).makeSolid(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150), FlxColor.BLACK);
	blackBGgf.scrollFactor.set();
	blackBGgf.alpha = 0;
	blackBGgf.screenCenter();
	insert(3,blackBGgf);
	
	var particleEmitter:FlxTypedEmitter = new FlxTypedEmitter(-400, 1000);
	particleEmitter.scale.set(2, 2, 2, 2, 0, 0, 0, 0);
	particleEmitter.velocity.set(-50, -200, 50, -600, -90, 0, 90, -600);
	particleEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	particleEmitter.width = 2787.45;
	particleEmitter.alpha.set(0, 0);
	particleEmitter.lifespan.set(1.9, 4.9);

	particleEmitter.loadParticles(Paths.image('particle'), 500, 16, true);
	particleEmitter.color.set(FlxColor.YELLOW, FlxColor.YELLOW);

	particleEmitter.start(false, FlxG.random.float(.01097, .0308), 1000000);
	insert(4,particleEmitter);
	
	unfaithFloor = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/unfaithful/unfaithful_floor'));
	unfaithFloor.scrollFactor.set(1, 1);
	unfaithFloor.setGraphicSize(Std.int(unfaithFloor.width * 1.85));
	unfaithFloor.screenCenter();
	unfaithFloor.y += 550;
	unfaithFloor.updateHitbox();
	insert(5,unfaithFloor);
		
	unfaithFRONT = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/unfaithful/unfaithful_front'));
	unfaithFRONT.scrollFactor.set(1.3, 1.3);
	unfaithFRONT.setGraphicSize(Std.int(unfaithFRONT.width * 1.2));
	unfaithFRONT.screenCenter();
	unfaithFRONT.x -= 215;
	unfaithFRONT.y += 450;
	unfaithFRONT.updateHitbox();

	FlxTween.tween(unfaithFRONT, {y: unfaithFRONT.y + 50}, 2, {ease:FlxEase.smoothStepInOut, type: FlxEase.PINGPONG});
	insert(6,unfaithFRONT);//??
	
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

	LightsColors = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
	vignetteTrojan = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/trojan/vignette'));
	vignetteTrojan.antialiasing = true;
	//vignetteTrojan.cameras = [camOther];
	vignetteTrojan.cameras = [camHUD];
	vignetteTrojan.scale.set(0.7, 0.7);
	vignetteTrojan.screenCenter();
	vignetteTrojan.alpha = 1;
	//vignetteTrojan.blend = LIGHTEN;
	add(vignetteTrojan);
}

function postCreate()
{
	
add(unfaithFRONT);
}

function update(elapsed)
{
}
function beatHit(curBeat:Int) {
	if (curSong.toLowerCase() == 'unfaithful') 
		{	
	switch(curBeat)
	{
		case 156:
			FlxTween.tween(blackBGgf, {alpha:0.84}, 0.4);
		case 160:
		//	if (ClientPrefs.shaders && ClientPrefs.flashing) FlxG.camera.setFilters([new ShaderFilter(colorShad.shader)]);
			particleEmitter.alpha.set(1, 1);
			blackBGgf.alpha = 0;
			bestPart2 = true;

		case 224:
			camHUD.fade(FlxColor.BLACK, 1, false);
			particleEmitter.alpha.set(0, 0);
			bestPart2 = false;

		case 240:
			camHUD.fade(FlxColor.BLACK, 1, true);
		//	if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0015));
			
		case 288:
			FlxTween.tween(blackBG, {alpha:0.93}, 0.8);
			FlxTween.tween(overlayUnfaith, {alpha:1}, 0.8);
			particleEmitter.alpha.set(1, 1);
		//	if (ClientPrefs.shaders && ClientPrefs.advancedShaders) FlxG.camera.setFilters([new ShaderFilter(new BloomShader())]);
		case 320:
			particleEmitter.alpha.set(0, 0);
			FlxTween.tween(blackBG, {alpha:0}, 0.5);
			FlxTween.tween(overlayUnfaith, {alpha:0}, 0.5);
			camHUD.fade(FlxColor.BLACK, 0.8, false);
	}
}
}