//tdl note
var slashing:Bool = false;

function postCreate() {
	strumLines.forEach((s) -> {s.onNoteUpdate.add(onNoteUpdate);});
}

function onNoteCreation(e)
	switch(e.noteType){
		case 'fire-note':e.noteSprite = "game/notes/dangerNotes/fire";
        e.note.avoid = true;
		case 'Hurt Note':e.noteSprite = "game/notes/hurt";
		case 'AV':e.noteSprite = "game/notes/dangerNotes/av";
        e.note.avoid = true;
		case 'Tdl note':e.noteSprite = "game/notes/dangerNotes/tdl_blade";
		e.note.extra.set("checkedSlash",false);
	}

function onNoteUpdate(e)
	switch(e.note.noteType){
		case 'Tdl note':if (!e.note.extra.get('checkedSlash') && (e.note.strumTime-Conductor.songPosition) < 180) {
			if (!slashing){slashing = true;
				if(dad.hasAnim('attack') != null) {
					dad.playAnim('attack', true);
					trace('attack!');
					new FlxTimer().start(1, ()->{slashing = false;});
					}
				}
			e.note.extra.set('checkedSlash',true);
		}
}

function onPlayerMiss(e)
	switch(e.noteType){
		case 'fire-note':e.cancel(true); e.note.strumLine.deleteNote(e.note);
		case 'Hurt Note':e.cancel(true); e.note.strumLine.deleteNote(e.note);
		case 'AV':e.cancel(true); e.note.strumLine.deleteNote(e.note);
		case 'Tdl note':health -= PlayState.difficulty.toLowerCase()=='insane'?1.5:0.8;
		dad.playAnim('attack', true);
	}

function onPlayerHit(e){
	switch(e.noteType){
		case 'fire-note':e.healthGain=0;
		e.countAsCombo = e.showRating = e.showSplash = false;
        e.misses=e.strumGlowCancelled = true;
        FlxG.sound.play(Paths.sound("burnSound"));

        health -= 0.5; 
		case 'Hurt Note':e.healthGain=0;
        if(e.note.isSustainNote) health -= 0.1;
		else health -= 0.3;
        e.score=0;
        e.accuracy=0;
        e.countAsCombo = e.showRating = false;
        if(boyfriend.hasAnim('hurt')) {
            e.cancelAnim();
			boyfriend.playAnim('hurt', true);
		}
		e.misses=true;
		case 'AV':e.misses=e.strumGlowCancelled = true;
        e.countAsCombo = e.showRating = e.showSplash = false;
		trace(e.strumID);
		//ALSO_CAUSES_THE_LANE_TO_BE_UNABLE_TO_HIT_ANYTHING.
		case 'gf-sing':e.cancelAnim();
        gf.playSingAnim(e.direction, e.animSuffix);
		case 'Tdl note':FlxG.sound.play(Paths.sound("darkLordAttack"));

		if(boyfriend.hasAnim('dodge')) {
			e.cancelAnim();
			boyfriend.playAnim('dodge', true);
		}
	}
}

function onDadHit(e){
	if(dad.getAnimName()== 'attack')e.cancelAnim();
}