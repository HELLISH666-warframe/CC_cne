function onEvent(_) {
	if (_.event.name == 'Set Cam Zoom') {
		var zoom:Float = Std.parseFloat(_.event.params[0]);
		defaultCamZoom=zoom;
	}
}