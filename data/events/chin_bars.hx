var upperBar:FunkinSprite = new FunkinSprite(0, -120).makeGraphic(1280, 120, 0xFF000000);
var lowerBar:FunkinSprite = new FunkinSprite(0, 720).makeGraphic(1280, 120, 0xFF000000);
function create() {
	upperBar.camera = camHUD;
    lowerBar.camera = camHUD;
	insert(0,upperBar);
    insert(1,lowerBar);
}
function onEvent(_) {
	if (_.event.name == 'chin_bars') {
		var speed = _.event.params[0];
		var distance = +_.event.params[1];
		var distance2 = -_.event.params[2];
		FlxTween.tween(upperBar, {y: +_.event.params[1]}, _.event.params[0], {ease: FlxEase.linear});
		FlxTween.tween(lowerBar, {y: -_.event.params[2]}, _.event.params[0], {ease: FlxEase.linear});
	}
}