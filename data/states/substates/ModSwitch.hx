import funkin.backend.assets.ModsFolder;

var mods = CoolUtil.sortAlphabetically(ModsFolder.getModsList(), true);
var alphabets = new FlxTypedGroup<Alphabet>();
var curSelMs:Int = 0;

var subCam:FlxCamera;

function create() {
	camera = subCam = new FlxCamera();
	subCam.bgColor = 0;
	FlxG.cameras.add(subCam, false);

	var bg = new FlxSprite(0, 0).makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	bg.updateHitbox();
	bg.scrollFactor.set();
	add(bg).alpha = 0;
	FlxTween.tween(bg, {alpha: 0.5}, 0.25, {ease: FlxEase.cubeOut});

	mods.push(null);

	for(mod in mods) {
		var a = new Alphabet(0, 0, mod ==null ?"disableMods": mod, "bold");
		if(mod == ModsFolder.currentModFolder) a.color = FlxColor.LIME;
		a.isMenuItem = true;
		a.scrollFactor.set();
		alphabets.add(a);
	}
	add(alphabets);
	changeSelection(0, true);
}
function update(elapsed:Float) {
	changeSelection((controls.DOWN_P ? 1 : 0) + (controls.UP_P ? -1 : 0) - FlxG.mouse.wheel);

	if (controls.ACCEPT||controls.BACK) {
		if(controls.ACCEPT) ModsFolder.switchMod(mods[curSelMs]);
		close();
	}
}

function changeSelection(change:Int, force:Bool = false) {
	if (change == 0 && !force) return;

	curSelMs = FlxMath.wrap(curSelMs + change, 0, alphabets.length-1);

	CoolUtil.playMenuSFX('scroll',0.7);

	for(k=>alphabet in alphabets.members) {
		k==curSelMs?alphabet.alpha =1:alphabet.alpha =0.6;
		alphabet.targetY = k - curSelMs;
	}
}

function destroy() if (FlxG.cameras.list.contains(subCam)) FlxG.cameras.remove(subCam);