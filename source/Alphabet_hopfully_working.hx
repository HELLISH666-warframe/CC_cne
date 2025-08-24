import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import openfl.geom.ColorTransform;
import flixel.system.FlxSound;

class Alphabet_hopfully_working extends Alphabet
{
	public var outline_FOR_OTHER_CLASS:Float = 10;
	public var points_FOR_THER_CLASS:Array<FlxPoint> = [];
	public var outlineAlpha:Float=1;
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);

		public var TO_RAD = Math.PI / 180;

		public var total = 16;
		public var angleOff = 360/total;

		for(i in 0...total) {
			public var point = new FlxPoint(0, 0);
			public var angle = angleOff * i * TO_RAD;
			/*point.x = Math.sin(angle);
			point.y = Math.cos(angle);*/
			points_FOR_THER_CLASS.push(point);
		}
	}
	public override function update() {
		public var oldX = x;
		public var oldY = y;

		if(outline_FOR_OTHER_CLASS > 0 && outlineAlpha > 0) {
			public var orig = colorTransform;
			colorTransform = new ColorTransform();
			colorTransform.color = 0xFF000000;
			for(point in points_FOR_THER_CLASS) {
				x = oldX + point.x * outline_FOR_OTHER_CLASS;
				y = oldY + point.y * outline_FOR_OTHER_CLASS;
			}

			colorTransform = orig;
			x = oldX;
			y = oldY;
		}
		x = oldX;
		y = oldY;
	}
	public var fontColor:FlxColor = 0x000000;
	public var outline:Float=10;

	public function setFontColor(letter:AlphaCharacter, color:FlxColor) {
		if(!letter.isBold) {
			letter.colorTransform.color = color;
		}
	}
	public function set_fontColor(newColor:FlxColor) {
		for(i in this.members) {
			setFontColor(i, newColor);
		}
		return fontColor = newColor;
	}
	public function setoutline(letter:AlphaCharacter, val:String) {
		letter.outline_FOR_OTHER_CLASS = val;
	}
	public function set_outline(val:Float) {
		for(i in this.members)
		setoutline(i, val);
		return outline = val;
	}
}