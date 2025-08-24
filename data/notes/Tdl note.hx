function onNoteCreation(event)
    if (event.noteType == "Tdl note") {
        event.noteSprite = "game/notes/tdl_blade";
        event.note.avoid = true;

        if (FlxG.save.data.ps_hard) event.note.alpha = 0.5;
        event.note.latePressWindow = 0.25;
    }

function onPlayerMiss(event)
    if (event.noteType == "Tdl note") {        health -= 0.8; }
dad.playAnim('attack', true);
trace('you_fucking_suck');

function onPlayerHit(event)
    if (event.noteType == "Tdl note") {
        event.countAsCombo = event.showRating = event.showSplash = false;
        event.strumGlowCancelled = true;
        FlxG.sound.play(Paths.sound("darkLordAttack"));
        boyfriend.animation.play("stab");

    }