function stepHit(curStep:Int) {
	switch(curStep) {
		case 1: FlxG.camera.fade(FlxColor.BLACK, 3, true);
		stage.getSprite("crowd").color = 0xFF3A3A3A;
		gf.color = 0xFF3A3A3A;
		stage.getSprite("background1").color = 0xFF3A3A3A;
		whiteScreen.color = 0xFF3A3A3A;

		spotlightdad.alpha = 0.7;
		spotlightbf.alpha = 0.7;
		case 256:
		stage.getSprite("crowd").color = 0xFFFFFFFF;
		gf.color = 0xFFFFFFFF;
		stage.getSprite("background1").color = 0xFFFFFFFF;
		whiteScreen.color = 0xFFFFFFFF;
		FlxG.camera.flash(FlxColor.WHITE, 1);
		spotlightdad.alpha = 0;
		spotlightbf.alpha = 0;
		case 576:
		FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5);
		case 768:
		FlxG.camera.flash(FlxColor.WHITE, 1);
		FlxG.camera.shake(0.0175, 0.15);
		blackBars(1);
		colorTween([gf, dad, stage.getSprite("crowd"), stage.getSprite("background1"), stage.getSprite("floor")], 0.7, FlxColor.WHITE, 0xFF191919);
		spotlightdad.alpha = 0.8;
		spotlightbf.alpha = 0.8;
		case 1024:
		chromaticAberration.rOffset=0;
		chromaticAberration.bOffset=0;
		FlxG.camera.flash(FlxColor.WHITE, 1);
		colorTween([gf, dad, boyfriend, stage.getSprite("crowd"), stage.getSprite("background1"), stage.getSprite("floor")], 0.7, 0xFF191919, FlxColor.WHITE);
		blackBars(0);
		spotlightdad.alpha = 0;
		spotlightbf.alpha = 0;
	}
}
