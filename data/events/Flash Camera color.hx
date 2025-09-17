function onEvent(_) {
	if (_.event.name == 'Flash Camera color') {
		var val2:Float = Std.parseFloat(_.event.params[1]);
		var eventEase = switch(_.event.params[0]) {
			case 'BLACK': FlxColor.BLACK;
			case 'WHITE': FlxColor.WHITE;
			case 'RED': FlxColor.RED;
        }
		if(FlxG.save.data.flashing_cc) FlxG.camera.flash(eventEase, val2);
	}
}