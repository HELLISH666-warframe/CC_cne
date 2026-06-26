var defaultPlayerStrumX=[0,0,0,0];
var defaultPlayerStrumY=[0,0,0,0];

var defaultOpponentStrumX=[0,0,0,0];
var defaultOpponentStrumY=[0,0,0,0];

function postCreate() {
    for (i in 0...playerStrums.length) {
        defaultPlayerStrumX[i]=playerStrums.members[i].x;
        defaultPlayerStrumY[i]=playerStrums.members[i].y;
	}
    for (i in 0...cpuStrums.length) {
        defaultOpponentStrumX[i]=cpuStrums.members[i].x;
        defaultOpponentStrumY[i]=cpuStrums.members[i].y;
	}
}

var strumTweens:Map<String, FlxTween>=[];
function update(elapsed:Float) {
    if (curBeat <= 192)return;
    var currentBeat = (Conductor.songPosition/3000)*(Conductor.bpm/30);

    for(i in 0...4){
    if (strumTweens.exists('pSX'+i)) strumTweens.get('pSX'+i).cancel();
    if (strumTweens.exists('pSY'+i)) strumTweens.get('pSY'+i).cancel();
    if (strumTweens.exists('cSX'+i)) strumTweens.get('cSX'+i).cancel();
    if (strumTweens.exists('cSY'+i)) strumTweens.get('cSY'+i).cancel();
    }
    strumTweens.set('pSX0',FlxTween.tween(playerStrums.members[0], {x: defaultPlayerStrumX[0] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSX1',FlxTween.tween(playerStrums.members[1], {x: defaultPlayerStrumX[1] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSX2',FlxTween.tween(playerStrums.members[2], {x: defaultPlayerStrumX[2] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSX3',FlxTween.tween(playerStrums.members[3], {x: defaultPlayerStrumX[3] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));

    strumTweens.set('pSY0',FlxTween.tween(playerStrums.members[0], {y: defaultPlayerStrumY[0] - 40*Math.sin((currentBeat+4*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSY1',FlxTween.tween(playerStrums.members[1], {y: defaultPlayerStrumY[1] - 40*Math.sin((currentBeat+5*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSY2',FlxTween.tween(playerStrums.members[2], {y: defaultPlayerStrumY[2] - 40*Math.sin((currentBeat+6*0.25)*Math.PI)}, 0.5));
    strumTweens.set('pSY3',FlxTween.tween(playerStrums.members[3], {y: defaultPlayerStrumY[3] - 40*Math.sin((currentBeat+7*0.25)*Math.PI)}, 0.5));

    strumTweens.set('cSY0',FlxTween.tween(cpuStrums.members[0], {y: defaultOpponentStrumY[0] + 40*Math.sin((currentBeat+0*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSY1',FlxTween.tween(cpuStrums.members[1], {y: defaultOpponentStrumY[1] + 40*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSY2',FlxTween.tween(cpuStrums.members[2], {y: defaultOpponentStrumY[2] + 40*Math.sin((currentBeat+2*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSY3',FlxTween.tween(cpuStrums.members[3], {y: defaultOpponentStrumY[3] + 40*Math.sin((currentBeat+3*0.25)*Math.PI)}, 0.5));

    strumTweens.set('cSX0',FlxTween.tween(cpuStrums.members[0], {x: defaultOpponentStrumX[0] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSX1',FlxTween.tween(cpuStrums.members[1], {x: defaultOpponentStrumX[1] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSX2',FlxTween.tween(cpuStrums.members[2], {x: defaultOpponentStrumX[2] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
    strumTweens.set('cSX3',FlxTween.tween(cpuStrums.members[3], {x: defaultOpponentStrumX[3] - 50*Math.sin((currentBeat+1*0.25)*Math.PI)}, 0.5));
}