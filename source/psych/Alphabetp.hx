import funkin.menus.ui.ClassicAlphabet;
class Alphabetp extends ClassicAlphabet {
	public var forceX:Float = Math.NEGATIVE_INFINITY;
	public var trackingSpr:FlxSprite;
	public var autoOffset:Bool = true;
	public var targetY:Float = 0;
	public var yMult:Float = 120;
	public var yAdd:Float = 0;
	var xAdd:Float = 0;


	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false, ?typingSpeed:Float = 0.05, ?textSize:Float = 1) {
		super(x, y,text,bold,typed,typingSpeed,textSize);
		forceX = Math.NEGATIVE_INFINITY;
		refreshAlphabetXML('data/alphabet/bold.xml');
	}

	function update(elapsed:Float) {
		if (trackingSpr != null) {
			trackingSpr.setPosition(forceX - (25 + trackingSpr.width), y + (height / 2) - (trackingSpr.height / 2));
		}
		var it:Int = 0;
		if (autoOffset)
			for (i in this.members) {
				if (it != 0 && i != null) i.offset.x = ((1 - i.scale.x) * 50) * it;
				it++;
			}
		if (forceX != Math.NEGATIVE_INFINITY)  x = forceX;
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			var lerpVal:Float = FlxMath.bound(elapsed * 8., 0, 1);
			y = FlxMath.lerp(y, (scaledY * yMult) + (FlxG.height * 0.48) + yAdd, lerpVal);
			if(forceX == Math.NEGATIVE_INFINITY) {
				x = FlxMath.lerp(x, (targetY * 20) + 90 + xAdd, lerpVal);
			}
		}
		//super.update(elapsed);
	}
}