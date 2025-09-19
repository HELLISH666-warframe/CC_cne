function stepHit(curStep:Int) {
	switch(curStep)	{
		case 1|8|16|32|40|48|64|72|80|96|104|112: 
		/*if(ClientPrefs.flashing || !ClientPrefs.lowQuality)*/ FlxG.camera.fade(FlxColor.BLACK, 0.5, false);
		case 120: FlxG.camera.fade(FlxColor.BLACK, 0, true);
		case 767: tcoBSOD(true);
		redthing.color = 0xFFFFFFFF;
		case 1392: defaultCamZoom = 1.45;
		alphaTween([blackBG], 1, 0.75);
		case 1406: tcoStickPage(false);
		tcoBSOD(true);
		stage.getSprite("bsod").alpha = 1; //fixing the bug
		setAlpha([blackBG], 0);
		/*if(ClientPrefs.flashing)*/ FlxG.camera.flash(FlxColor.WHITE, 1);
		case 1025|1670:
		tcoBSOD(false);
	}
}

function beatHit(curBeat:Int) {
	switch(curBeat) {
		case 32: /*if(ClientPrefs.flashing)*/ FlxG.camera.flash(FlxColor.RED, 0.5);
		/*if (ClientPrefs.shaders)*/ chromaticAberration.rOffset=0.0040;
		chromaticAberration.bOffset=0.0040;
		/*if(ClientPrefs.screenShake)*/ FlxG.camera.shake(0.01, 0.20);
		objectColor([boyfriend, gf, stage.getSprite("floor"), stage.getSprite("background1"), stage.getSprite("scaredCrowd"), whiteScreen], 0xFF2C2425);
		setAlpha([redthing], 1);
		setVisible([stage.getSprite("fires1"), stage.getSprite("fires2")], true);
		lossingHealth = true;
		case 288: tcoStickPage(true);
		case 424: /*if(ClientPrefs.flashing)*/ FlxG.camera.flash(FlxColor.WHITE, 0.5);
		/*if(ClientPrefs.screenShake)*/ FlxG.camera.shake(0.01, 0.20);
		colorTween([boyfriend, gf, stage.getSprite("floor"), stage.getSprite("background1"), stage.getSprite("scaredCrowd"), whiteScreen], 0.8, 0xFF2C2425, FlxColor.WHITE);
		lossingHealth = false;
	}
}

//stage.getSprite("background1").color = 0xFF3A3A3A;