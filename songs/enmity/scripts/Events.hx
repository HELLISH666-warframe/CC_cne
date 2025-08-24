var strums = [];

function postCreate() {
	strumLines.members[2].characters[0].x = 240;
	strumLines.members[2].characters[0].y = -280;
	for(i in 0...strumLines.members[3].members.length) {
        var strum = strumLines.members[3].members[i];
        strums.push(strum);
	}
	for(i in strumLines.members[0].members) {
		i.x=i.x-500;
		i.y=i.y-2;
	}
	for(i in strumLines.members[2].members) {
		i.x=i.x-50;
		i.y=i.y-2;
	}
}

function onPostStrumCreation(e){
    if(e.player == 0||e.player == 2){
        e.strum.camera = camGame;
        e.strum.scrollFactor.x = e.strum.scrollFactor.y = 1;
    }
}

function fuck(){
	for(i in strumLines.members[0].members) {
		i.y=i.y-600;
	}
	for(i in strumLines.members[2].members) {
		i.y=i.y-200;
	}
}