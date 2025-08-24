function onNoteHit(e){
    if (e.noteType == "gf-sing"){
        e.cancelAnim();
        gf.playSingAnim(e.direction, e.animSuffix);
    }
}