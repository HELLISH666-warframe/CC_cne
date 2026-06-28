function onNoteCreation(e){
    if(e.note.strumTime>=193333&&e.strumLineID==0){e.noteSprite = "game/notes/GH"; e.noteScale=0.9;}
    if(e.note.strumTime>=247032&&e.strumLineID==1){e.noteSprite = "game/notes/GH"; e.noteScale=0.9;}
}