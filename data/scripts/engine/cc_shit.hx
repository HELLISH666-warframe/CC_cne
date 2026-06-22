public var camBars = new FlxCamera();

function new() {
	trace("Loaded_CCSHIT.");
	camBars.bgColor = 0;

	var songsWithCamChar:Array<String> = ['amity', 'trojan', 'alan', 'proficiency'];
	if (songsWithCamChar.contains(PlayState.SONG.meta.name.toLowerCase())) FlxG.cameras.add(camChar, false);

	FlxG.cameras.add(camBars, false);//Before_camHUD.
}

function postCreate() {
	window.title = "Computerized Conflict -"+curSong+ " - [" + PlayState.SONG.meta.difficulties[PlayState.difficulty]
		+"] - Composed by: " +curSong.composer;
}

function beatHit() {
	if (zoomType1) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}
	if (curBeat % 2 == 0 && zoomType2) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}
	if (curBeat % 1 == 0 && zoomType3) {
		FlxG.camera.zoom += 0.06;
		camHUD.zoom += 0.08;
	}
}

function update(elapsed:Float) {
    healthDrainLolz(0.09 * elapsed, 0.2, multiplierDrain);
}

public var lossingHealth:Bool = false;

public var multiplierDrain:Float = 1;

public function healthDrainLolz(drain:Float, min:Float, mult:Float) {
	if(!lossingHealth) return;
	if(PlayState.difficulty.toUpperCase() == 'SIMPLE') return;
	if(PlayState.difficulty.toUpperCase()== 'HARD' && FlxG.save.data.noMechanics_cc) return;
	if(health <= min) return;

	health -= drain * multiplierDrain;
}

public var zoomType1:Bool = false;
public var zoomType2:Bool = false;
public var zoomType3:Bool = false;

public function zoomtype(number:String) {
    switch(number){
		case '0': zoomType1 = !zoomType1;
		case '1': zoomType2 = !zoomType2;
		case '2': zoomType3 = !zoomType3;
	}
}