import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.utils.DiscordUtil;
import flixel.text.FlxTextBorderStyle;
import flixel.FlxObject;

static var curSelFS:Int = 0;
var folderGroup = new FlxTypedGroup<FlxSprite>();
var folders = ['story','extra','cover','old'];

var selectedSmth:Bool = false;
var camFollow = new FlxObject(0, 0, 1, 1);
var camFollowPos = new FlxObject(0, 0, 1, 1);
var finishedZoom = false;

function create() {
	CoolUtil.playMenuSong(true);
	DiscordUtil.changePresenceSince("In the Freeplay Menu", null);

	window.title = "Computerized Conflict - Freeplay Menu - Theme by: DangDoodle";

	FlxG.camera.zoom = 1.5;

	add(bg = new FlxSprite(0,0).loadGraphic(Paths.image('menus/freeplayArt/selectMenu/bgAngled'))).scrollFactor.set();
	bg.antialiasing = Options.antialiasing;

	add(scrollingThing = new FlxBackdrop(Paths.image('menus/Main_Checker'),FlxAxes.XY,0,0)).scrollFactor.set(0, 0.07);
	scrollingThing.alpha = 0.8;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.4));

	add(vignette = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/vignette'))).scrollFactor.set();

	add(folderGroup);
		
	add(spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'),FlxAxes.X,0,0)).y -= 60;
	spikes1.flipY = true;
	add(spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'),FlxAxes.X,0,0)).y += 630;
	for(i in [spikes1,spikes2])i.scrollFactor.set(0, 0);

	for (i in 0...folders.length) {
		var folderItem = new FlxSprite(150, (i * 330)  + 70);
		folderItem.loadGraphic(Paths.image('menus/freeplayArt/selectMenu/' + folders[i] + '-folder'));
		folderItem.ID = i;
		folderItem.scrollFactor.set(0, 1);
		folderGroup.add(folderItem);
		folderItem.antialiasing = Options.antialiasing;
		folderItem.updateHitbox();
	}

	add(camFollow);
	add(camFollowPos);

	add(leftBar = new FlxSprite().makeSolid(50, 720, FlxColor.WHITE)).scrollFactor.set();
	add(yellowSquare = new FlxSprite(0, 0).makeSolid(50, 50, 0xFFfeff95)).scrollFactor.set();

	add(littleBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/bar'))).scrollFactor.set();

	add(freeplayMenuText = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/freeplay-text'))).scrollFactor.set();

	add(infoBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplayArt/selectMenu/textShit'))).scrollFactor.set();

	add(menuText = new FlxText(0, 0, FlxG.width, '', 29).setFormat(Paths.font("phantommuff.ttf"), 26, FlxColor.WHITE, 'right', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT)).angle -= 1.5;

	FlxG.camera.follow(camFollowPos, null, 1);

	changeItem(0);

	if (ccSSC.shaders) FlxG.camera.addShader(crtShader = new CustomShader("CRTShader"));

	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.expoIn});
	FlxG.camera.fade(FlxColor.BLACK, 0.8, true, function(){finishedZoom = true;});
}

function update(elapsed:Float) {
	scrollingThing.y -= 0.16 * 60 * elapsed;
	scrollingThing.x = spikes1.x = spikes2.x -= 0.45 * 60 * elapsed;

	var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);
	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

	folderGroup.forEach(function(spr:FlxSprite){
		switch(spr.ID){
			case 0:spr.x = 150; spr.y = 70;
			case 1:spr.x = 150; spr.y = 400;
			case 2:spr.x = 70; spr.y = 730;
			case 3:spr.x = 150; spr.y = 1060;
		}

		spr.scale.x = FlxMath.lerp(spr.scale.x, spr.ID==curSelFS?1:0.85, lerpVal);
		spr.scale.y = spr.scale.x;

		spr.updateHitbox();
	});

	if (!selectedSmth && finishedZoom) {
		if (controls.UP_P||controls.DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(controls.UP_P?-1:1);
		}

		if(FlxG.mouse.wheel != 0) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			changeItem(-FlxG.mouse.wheel);
		}

		if (controls.BACK) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxTween.tween(FlxG.camera, {zoom: -2}, 1.5, {ease: FlxEase.expoIn});
			FlxG.camera.fade(FlxColor.BLACK, 0.8, false, ()-> {FlxG.switchState(new MainMenuState());});
		}
		else if (controls.ACCEPT) {
			selectedSmth = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			folderGroup.forEach(function(spr:FlxSprite) {
				if (curSelFS != spr.ID) {
					FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut,onComplete: function(twn:FlxTween){spr.kill();}});

					FlxTween.tween(FlxG.camera, {zoom: 3}, 1.5, {ease: FlxEase.expoIn});
					FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function() {
						FlxG.switchState(new FreeplayState());
						FlxG.save.data.freeplaything_cc = curSelFS;
					});
				}
			});
		}
	}
}

function changeItem(huh:Int = 0) {curSelFS = FlxMath.wrap(curSelFS + huh, 0, folderGroup.length - 1);
	yellowSquare.y=[210,310,410,510][curSelFS];
	switch(curSelFS) {
		case 0:menuText.text = 'Rap Battle Against The Chosen One and\nother characters from the\n"Animator vs. Animation" Series!';
		case 1:menuText.text = 'Want more than this mod can offer?\nThis folder is made for you!';
		case 2:menuText.text = 'Are you looking for the collab songs?\nOr the covers?\nAll of them are here!';
		case 3:menuText.text = 'Feeling to play the legacy songs, huh?\nThis folder section is for ya!';
	}

	menuText.x = FlxG.width - menuText.width - 3;
	menuText.screenCenter(FlxAxes.Y);
	menuText.scrollFactor.set(0,0);
	menuText.y += 30;

	folderGroup.forEach(function(spr:FlxSprite) {
		spr.alpha = 0.5;

		if (spr.ID == curSelFS) {
			spr.alpha = 1;

			camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			spr.centerOffsets();
		}
	});
}