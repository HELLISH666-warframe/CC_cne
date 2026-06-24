function postCreate() {
	healthBar.createFilledBar(FlxColor.TRANSPARENT, 0x31B0D1);
	healthBar.updateBar();
	iconP1.setIcon('bf');
	iconP2.visible = false;
}