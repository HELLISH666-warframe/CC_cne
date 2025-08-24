function beatHit()
{
    switch(curBeat)
    {
        case 4:
            camHUD.fade(FlxColor.BLACK, 3, true);
        case 32:
            FlxTween.tween(camHUD, {alpha:1}, 1);
        case 383:
            camHUD.fade(FlxColor.BLACK, 0.5, false);
        case 416:
            camHUD.fade(FlxColor.BLACK, 1, true);
            scoreTxt.alpha = 0;
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
            iconP1.alpha = 0;
            iconP2.alpha = 0;
        case 640:
            opponentStrums.forEach(function(spr:StrumNote) {spr.alpha = 0;});
            playerStrums.forEach(function(spr:StrumNote) {spr.alpha = 0;});
    }
}