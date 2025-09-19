var realHealthbar;
function postCreate() {
	remove(healthBarBG);
	//healthBar.setGraphicSize(600, 40);

	realHealthbar = new FlxSprite(500,625).loadGraphic(Paths.image('game/cc/healthBar'));
	realHealthbar.camera = camHUD;
	realHealthbar.screenCenter(FlxAxes.X);
	insert(members.indexOf(healthBar)+1, realHealthbar); 

	healthBar.setGraphicSize(410,20);
	realHealthbar.setGraphicSize(Std.int(realHealthbar.width * 0.7));
}