function postCreate() {
	healthBar.createFilledBar(FlxColor.TRANSPARENT,strumLines.members[0].characters[0].iconColor);
	healthBar.updateBar();
	iconP1.setIcon('bf');
	iconP2.visible = false;
}