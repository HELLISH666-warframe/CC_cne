package;

import flixel.FlxCamera;
import flixel.math.FlxPoint;
import openfl.geom.ColorTransform;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class FlxOutlineSprite extends FlxSprite
{
	public var outline:Float = 0;
	public var outlineColor:FlxColor = 0;
	public var outlineAlpha:Float = 1;
	public var outlineCameras:Array<FlxCamera> = [];

	var points:Array<FlxPoint> = [];

	function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);

		var TO_RAD = Math.PI / 180;

		var total = 16;
		var angleOff = 360/total;

		for(i in 0...total) {
			var point = new FlxPoint(0, 0);
			var angle = angleOff * i * TO_RAD;
			point.x = Math.sin(angle);
			point.y = Math.cos(angle);
			points.push(point);
		}
	}

	override function draw() {
		var oldX = x;
		var oldY = y;

		if(outline > 0 && outlineAlpha > 0) {
			var orig = colorTransform;
			var oldShader = shader;
			var oldAlpha = alpha;
			var oldCameras = cameras;
			shader = null;
			//alpha = 1;
			colorTransform = new ColorTransform();
			colorTransform.color = outlineColor;
			colorTransform.alphaMultiplier = oldAlpha * outlineAlpha;
			cameras = outlineCameras;
			for(point in points) {
				x = oldX + point.x * outline;
				y = oldY + point.y * outline;
				super.draw();
			}

			colorTransform = orig;
			shader = oldShader;
			alpha = oldAlpha;
			cameras = oldCameras;
			x = oldX;
			y = oldY;
		}
		super.draw();
		x = oldX;
		y = oldY;
	}
}