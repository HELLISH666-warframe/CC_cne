function create()
{
	whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	insert(0,whiteScreen);

	flashTop.screenCenter();
	flashTop.y -= 1000;
	flashTop.antialiasing = true;

	tcoPlataform.screenCenter();
	tcoPlataform.x -= 1000;
	tcoPlataform.y -= 100;
	tcoPlataform.antialiasing = true;

	tcoPlataform2.screenCenter();
	tcoPlataform2.x -= 400;
	tcoPlataform2.y += 100;
	tcoPlataform2.antialiasing = true;

	bfGfPlataform.screenCenter();
	bfGfPlataform.x += 530;
	bfGfPlataform.y -= 30;
	bfGfPlataform.antialiasing = true;

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