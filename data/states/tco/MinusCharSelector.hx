package;

import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import haxe.Json;
import flixel.addons.display.FlxBackdrop;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import Shaders;
import FlxSpriteExtra;

using StringTools;

class MinusCharSelector extends MusicBeatState
{
	public var boyfriend:Character = null;
	public static var bfSkins:Array<String> = ['betaBF', 'blueBF', 'meanBF'];
	public static var bfIcons:Array<String> = ['bf', 'bf-old', 'mean-bf'];
	public static var actualNum = 0;
	var bfs = new FlxTypedGroup<FlxSprite>();
	var selectedSmth:Bool = false;
	var bg:FlxSprite;
	var arrows:FlxSprite;
	var scrollingThing:FlxBackdrop;
	var colorTween:FlxTween;
	var topBars:FlxSprite;
	var bottomBars:FlxSprite;
	var LittleTopBars:FlxSprite;
	var LittleBottomBars:FlxSprite;
	var namesText:Alphabet;
	var CharMenuText:FlxText;
	public static var crtShader = new CRTShader();
	var shaderFilter = new ShaderFilter(crtShader);

	var charNames:Array<String> =
	[
	'Beta\nBoyfriend',
	'Blue\nBoyfriend',
	'Mean\nBoyfriend'
	];

	var iconP1:HealthIcon;
	var finishedZoom:Bool = false;

	override public function create()
	{
		Paths.clearStoredMemory();

		FlxG.camera.zoom = 5;

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		scrollingThing = new FlxBackdrop(Paths.image('Main_Checker'), XY, 0, 0);
		scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.35));
		scrollingThing.alpha = 0.8;
		add(scrollingThing);

		topBars = new FlxSpriteExtra().makeSolid(2580, 320, FlxColor.BLACK);
		topBars.screenCenter();
		topBars.y -= 400;
		topBars.angle -= 8;
		add(topBars);

		bottomBars = new FlxSpriteExtra().makeSolid(2580, 320, FlxColor.BLACK);
		bottomBars.screenCenter();
		bottomBars.y += 420;
		bottomBars.angle -= 8;
		add(bottomBars);

		LittleTopBars = new FlxSpriteExtra().makeSolid(2580, 20, FlxColor.BLACK);
		LittleTopBars.screenCenter();
		LittleTopBars.y -= 225;
		LittleTopBars.angle -= 8;
		add(LittleTopBars);

		LittleBottomBars = new FlxSpriteExtra().makeSolid(2580, 20, FlxColor.BLACK);
		LittleBottomBars.screenCenter();
		LittleBottomBars.y += 245;
		LittleBottomBars.angle -= 8;
		add(LittleBottomBars);

		arrows = new FlxSprite().loadGraphic(Paths.image('arrowSelection'));
		arrows.updateHitbox();
		arrows.screenCenter();
		arrows.antialiasing = ClientPrefs.globalAntialiasing;
		add(arrows);

		CharMenuText = new FlxText(0, 0, "Choose your character!", 52);
		CharMenuText.setFormat(Paths.font("phantommuff.ttf"), 52, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(CharMenuText);

		Paths.setCurrentLevel('shared');

		bfs = new FlxTypedGroup<FlxSprite>();
		add(bfs);

        boyfriend = new Character(0, 0, bfSkins[actualNum], true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.85));
		boyfriend.screenCenter();
		boyfriend.x += 350;
		boyfriend.updateHitbox();
		boyfriend.dance();
		insert(2, boyfriend);

		namesText = new Alphabet(0, 0, "", true);
		namesText.alignment = CENTERED;
		namesText.screenCenter();
		namesText.x -= 200;
		namesText.y -= 50;
		add(namesText);


		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = 580;
		iconP1.x += 1050;
		add(iconP1);

		for (anim in boyfriend.animOffsets.keys()) {
			boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]* 0.85,boyfriend.animOffsets[anim][1]* 0.85];
		}

		changeBF();

		for (i in 0...bfSkins.length) preloadChar(bfSkins[i], i);
		if (ClientPrefs.shaders) FlxG.camera.setFilters([shaderFilter]);

		super.create();

		FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function()
		{
			finishedZoom = true;
		});
	}

	override function update(elapsed:Float)
	{
		scrollingThing.x -= 0.45 * 60 * elapsed;
		scrollingThing.y -= 0.16 * 60 * elapsed;

		if (!selectedSmth && finishedZoom)
		{
			if(boyfriend != null && boyfriend.animation.curAnim.finished) {
				boyfriend.dance();
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
				{
                    MusicBeatState.switchState(new FreeplayMenu());
				});
			}
			else if (controls.ACCEPT)
			{
				selectedSmth = true;

				if(ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'));
				boyfriend.animation.play('hey');
				trace(bfSkins[actualNum]);
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
					FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				});

				PlayState.SONG.player1 = bfSkins[actualNum];
				PlayState.amityChar = bfSkins[actualNum];
			}


			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeBF(1);
			}
			else if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeBF(-1);
			}
		}
		super.update(elapsed);
	}

	function changeBF(number:Int = 0)
	{

		actualNum += number;

		if (actualNum >= bfSkins.length)
			actualNum = 0;
		if (actualNum < 0)
			actualNum = bfSkins.length - 1;


		if(colorTween != null) {
			colorTween.cancel();
		}

		namesText.text = charNames[actualNum];

		remove(boyfriend);
		boyfriend = new Character(0, 0, bfSkins[actualNum], true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.85));
		boyfriend.screenCenter();
		boyfriend.x += 350;
		boyfriend.updateHitbox();
		boyfriend.dance();
		insert(2, boyfriend);
		iconP1.changeIcon(boyfriend.healthIcon);

		switch(actualNum) //shittest code ever fr
		{
			case 0:
				colorTween = FlxTween.color(bg, 1, bg.color, 0xFFE1F63F, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
			    });

			case 1:
				colorTween = FlxTween.color(bg, 1, bg.color, 0xFF28A8C8, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
			    });
			case 2:
				colorTween = FlxTween.color(bg, 1, bg.color, 0xFFD60600, {
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
			    });
		}
	}

	function preloadChar(character:String, i:Int)
	{
		var bf:FlxSprite = new FlxSprite();
		bf.frames = Paths.getSparrowAtlas('characters/CC/extras/minus/' + character);
		bf.alpha = 0.0001;
		bfs.add(bf);
	}
}