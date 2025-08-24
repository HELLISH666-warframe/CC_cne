//i_know_most_of_this_is_copy_and_pasted_BUT_at_least_i_tried_to_re-format_and_optimise_it.
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.FlxObject;
import openfl.Lib;

static var curSelected:Int = 0;
var bg = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/bgAngled'));
var scrollingThing = new FlxBackdrop(Paths.image('menus/Main_Checker'), FlxAxes.XY, 0, 0);
var vignette = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/vignette'));
var freeplayMenuText = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/freeplay-text'));
var littleBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/bar'));
var infoBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/textShit'));
var folderGroup = new FlxTypedGroup();
var spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
var folders:Array<String> = ['story','extra','cover','old'];

var selectedSmth:Bool = false;
var camFollow = new FlxObject(0, 0, 1, 1);
var camFollowPos = new FlxObject(0, 0, 1, 1);
var finishedZoom = false;
var menuText = new FlxText(0, 0, FlxG.width, '', 29);
var yellowSquare = new FlxSprite(0, 0).makeSolid(50, 50, 0xFFfeff95);
var crtShader = new CustomShader("CRT"); 

function create() {
	DiscordUtil.changePresence('In the Freeplay Menu', null);

	Lib.application.window.title = "Computerized Conflict - Freeplay Menu - Theme by: DangDoodle";

	FlxG.camera.zoom = 1.5;

	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);

	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.alpha = 0.8;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.4));
	add(scrollingThing);

	add(vignette);
	add(folderGroup);
		
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);

	for (i in 0...folders.length) {
		var folderItem:FlxSprite = new FlxSprite(150, (i * 330)  + 70);
		folderItem.loadGraphic(Paths.image('menus/freeplayArt/selectMenu/' + folders[i] + '-folder'));
		folderItem.ID = i;
		folderItem.scrollFactor.set(0, 1);
		folderGroup.add(folderItem);
		bg.antialiasing = true;

		folderItem.updateHitbox();
	}

	add(camFollow);
	add(camFollowPos);

	var leftBar:FlxSprite = new FlxSprite().makeSolid(50, 720, FlxColor.WHITE);
	add(leftBar);

	add(yellowSquare);
	add(littleBar);
	add(freeplayMenuText);

	for(i in [bg,vignette,leftBar,yellowSquare,littleBar,freeplayMenuText,infoBar])
		i.scrollFactor.set();
	add(infoBar);

	menuText.setFormat(Paths.font("phantommuff.ttf"), 26, FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	menuText.angle -= 1.5;
	add(menuText);

	FlxG.camera.follow(camFollowPos, null, 1);

	changeItem(0);

	FlxG.camera.addShader(crtShader);

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function() {
		finishedZoom = true;
	});
}

function update(elapsed:Float) {
	scrollingThing.y -= 0.16 * 60 * elapsed;
		
	scrollingThing.x = spikes1.x = spikes2.x -= 0.45 * 60 * elapsed;

	var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

	folderGroup.forEach(function(spr:FlxSprite){
		switch(spr.ID){
			case 0:
				spr.x = 150;
				spr.y = 70;
			case 1:
				spr.x = 150;
				spr.y = 400;
			case 2:
				spr.x = 70;
				spr.y = 730;
			case 3:
				spr.x = 150;
				spr.y = 1060;
		}

		var a:Float;
		if (spr.ID == curSelected){
			a = 1;
		}else{
			a = 0.85;
		}

		spr.scale.x = FlxMath.lerp(spr.scale.x, a, lerpVal);
		spr.scale.y = spr.scale.x;

		spr.updateHitbox();
	});

	if (!selectedSmth && finishedZoom) {
		if (controls.UP_P||controls.DOWN_P){
			changeItem(controls.DOWN_P ? 1 : -1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if(FlxG.mouse.wheel != 0) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			changeItem(-FlxG.mouse.wheel);
		}
		if (controls.BACK) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
			{FlxG.switchState(new ModState('MainMenuState'));});
		}
		else if (controls.ACCEPT) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			folderGroup.forEach(function(spr:FlxSprite) {
				if (curSelected != spr.ID)
				{FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{spr.kill();}});

					FlxTween.tween(FlxG.camera, {zoom: 3}, 1.5, {ease: FlxEase.expoIn});
					FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
					{FlxG.switchState(new FreeplayState());
						FlxG.save.data.freeplaything_cc = curSelected;});
				}
			});
		}
	}
}

function changeItem(huh:Int = 0) {
	curSelected += huh;

	if (curSelected >= folderGroup.length) curSelected = 0;
	if (curSelected < 0) curSelected = folderGroup.length - 1;

	switch(folders[curSelected]) {
		case 'story':
			menuText.text = '
			Rap Battle Against The Chosen One and\n
			other characters from the\n
			"Animator vs. Animation" Series!';
			yellowSquare.y = 210;
		case 'extra':
			menuText.text = '
			Want more than this mod can offer?\n
			This folder is made for you!';
			yellowSquare.y = 310;
		case 'cover':
			menuText.text = '
			Are you looking for the collab songs?\n
			Or the covers?\n
			All of them are here!';
			yellowSquare.y = 410;
		case 'old':
			menuText.text = '
			Feeling to play the legacy songs, huh?\n
			This folder section is for ya!';
			yellowSquare.y = 510;
	}

	menuText.x = FlxG.width - menuText.width - 3;
	menuText.screenCenter(FlxAxes.Y);
	menuText.scrollFactor.set(0,0);
	menuText.y += 30;

	folderGroup.forEach(function(spr:FlxSprite) {
		spr.alpha = 0.5;

		if (spr.ID == curSelected) {
			spr.alpha = 1;
			var add:Float = 0;

			if(folderGroup.length > 4) {
				add = folderGroup.length * 8;
			}
			camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
			spr.centerOffsets();
		}
	});
}