var Crowd:FlxSprite;
var Background1:FlxSprite;
var shine:FlxSprite;
var Floor:FlxSprite;
var spotlightdad:FlxSprite;
var spotlightbf:FlxSprite;
function create()
{
	bg = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/cubify/cubify_bg'));
	bg.scrollFactor.set(1, 1);
	bg.setGraphicSize(Std.int(bg.width * 1.2));
	bg.screenCenter();
	insert(1,bg);

	overlayCubify = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/cubify/overlay'));
	overlayCubify.scrollFactor.set(1, 1);
	overlayCubify.scale.x = 4072;
	overlayCubify.screenCenter(FlxAxes.Y);
	overlayCubify.x = 1600 + (FlxG.width - 3072) / 2;
	//insert(2,overlayCubify);
	add(overlayCubify);

	
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

	
	whiteScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));
	whiteScreen.color =  FlxColor.WHITE;
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	add(whiteScreen);

	blackBG = new FlxSprite(-120, -120).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 150));
	blackBG.scrollFactor.set();
	blackBG.alpha = 0;
	blackBG.screenCenter();
	add(blackBG);

}
function stepHit(curStep:Int) {
	switch(curStep)
	{
		case 112:
			FlxTween.tween(whiteScreen, {alpha:0}, 1.6);
		case 128:
		//	if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0025));
		case 320:
			FlxTween.tween(blackBG, {alpha:0.8}, 0.3);
		//	if (ClientPrefs.shaders) FlxG.camera.setFilters([new ShaderFilter(nightTimeShader.shader)]);
			
		case 384:
			FlxTween.tween(blackBG, {alpha:0}, 0.5);
			if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0.0025));
		case 640:
			if(ClientPrefs.flashing) camHUD.flash(FlxColor.WHITE, 1);
			whiteScreen.alpha = 1;
			boyfriendGroup.alpha = 0;
			iconP1.alpha = 0;
			playerStrums.forEach(function(spr:StrumNote) spr.alpha = 0);
			if (ClientPrefs.shaders) FlxG.camera.setFilters([new ShaderFilter(new BloomShader())]);

		case 768:
			FlxTween.tween(dadGroup, {alpha:1}, 0.5);
			FlxTween.tween(boyfriend, {alpha:0}, 0.5);
			FlxTween.tween(iconP1, {alpha:0}, 0.5);
			FlxTween.tween(iconP2, {alpha:1}, 0.5);
			opponentStrums.forEach(function(spr:StrumNote)  FlxTween.tween(spr, {alpha:ClientPrefs.middleScroll ? 0 : 1}, 0.5));
			playerStrums.forEach(function(spr:StrumNote)  FlxTween.tween(spr, {alpha:0}, 0.5));

		case 700 | 828:
			playerStrums.forEach(function(spr:StrumNote)  FlxTween.tween(spr, {alpha:1}, 0.5));


		case 704 | 832:
			FlxTween.tween(boyfriend, {alpha:1}, 0.5);
			FlxTween.tween(dadGroup, {alpha:0}, 0.5);
			FlxTween.tween(iconP1, {alpha:1}, 0.5);
			FlxTween.tween(iconP2, {alpha:0}, 0.5);
			opponentStrums.forEach(function(spr:StrumNote)  FlxTween.tween(spr, {alpha:0}, 0.5));
		case 896:
			camHUD.fade(FlxColor.BLACK, 1, false);
		case 912:
			if(ClientPrefs.flashing) camHUD.flash(FlxColor.WHITE, 0.8);
			whiteScreen.alpha = 0;
			camHUD.fade(FlxColor.BLACK, 0, true);
			dadGroup.alpha = 1;
			opponentStrums.forEach(function(spr:StrumNote) spr.alpha = ClientPrefs.middleScroll ? 0 : 1);
			iconP2.alpha = 1;
			if (ClientPrefs.shaders) addShaderToCamera(['camgame', 'camhud'], new ChromaticAberrationEffect(0));
		case 1168:
			if(ClientPrefs.flashing) camHUD.flash(FlxColor.WHITE, 1);
			FlxTween.tween(whiteScreen, {alpha:1}, 3);
			if (ClientPrefs.shaders) FlxG.camera.setFilters([new ShaderFilter(new BloomShader())]);
		case 1296:
			camHUD.fade(FlxColor.BLACK, 0, false);
	}
}