function onNoteCreation(event)
    if (event.noteType == "fire-note") {
        event.noteSprite = "game/notes/fire";
        event.note.avoid = true;

        if (FlxG.save.data.ps_hard) event.note.alpha = 0.5;
        event.note.latePressWindow = 0.25;
    }

function onPlayerMiss(event)
    if (event.noteType == "fire-note") {event.cancel(true); event.note.strumLine.deleteNote(event.note);}

function onPlayerHit(event)
    if (event.noteType == "fire-note") {
        event.countAsCombo = event.showRating = event.showSplash = false;
        event.strumGlowCancelled = true;
        FlxG.sound.play(Paths.sound("burnSound"));

        health -= 0.5; 
    }