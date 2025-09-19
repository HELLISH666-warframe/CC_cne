function onEvent(_) {
	if (_.event.name == 'Tween Zoom') {
		var val1:Float = Std.parseFloat(_.event.params[0]);
		var val2:Float = Std.parseFloat(_.event.params[1]);
		tweenZoomEvent = FlxTween.tween(FlxG.camera, {zoom: val1}, val2, {
		ease: FlxEase.quadInOut, onComplete: function(twn) {
			defaultCamZoom = val1;
			},
		});
	}
}