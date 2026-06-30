package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import Shaders;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MessagesState extends MusicBeatState
{
	var freeplayMessage:Bool = false;
	var alanMessage:Bool = false;
	var text:FlxText;
	var canExit:Bool = false;
	public static var crtShader = new CRTShader();
	var shaderFilter = new ShaderFilter(crtShader);
	var bksp:FlxSprite;

	public function new(freeplayMessage:Bool, ?alanMessage:Bool = false)
	{
		super();

		this.freeplayMessage = freeplayMessage;
		this.alanMessage = alanMessage;
	}
	
	override function create()
	{
		Paths.clearStoredMemory();
		super.create();

		FlxG.camera.zoom -= 0.45;

		text = new FlxText(0, 0, "", 62);

		/*switch(TEXTT)
		{
			case freeplayMessage:
				"You have unlocked Freeplay and ";
			case alanMessage:
				"You have unlocked something new in Freeplay";
		}*/

		text.setFormat(Paths.font("vcr.ttf"), 62, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.applyMarkup("You've unlocked $Freeplay$ and\n\n$The Vault$", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED), "$")]);
		text.screenCenter();
		text.borderSize = 5;
		add(text);

		bksp = new FlxSprite().loadGraphic(Paths.image('bksp'));
		bksp.alpha = 0;
		add(bksp);

		//trace ('text is' + text.text);
		//trace('var is' + TEXTT);

		FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.45}, 2.5, {ease: FlxEase.quadIn});
		FlxG.camera.fade(FlxColor.BLACK, 3, true, function()
		{
			bksp.alpha = 1;
			canExit = true;
		});

		if (ClientPrefs.shaders) FlxG.camera.setFilters([shaderFilter]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if(controls.BACK && canExit)
		{
			canExit = false;
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.35}, 2.7, {ease: FlxEase.quadIn});
			FlxG.camera.fade(FlxColor.BLACK, 1.5, false, function()
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				MusicBeatState.switchState(new MainMenuState());
			});
		}
	}
}