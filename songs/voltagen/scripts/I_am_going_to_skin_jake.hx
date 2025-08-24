//THIS_IS_THE_MAX_NUMBER_OF_MISSES!_CAHNGE_THIS!
public var thenumber:Int = 4;
function onPlayerMiss(event) {
    var totalMisses:Int = misses + event.misses;
    if (totalMisses >= thenumber)  health = 0;
}
function postUpdate(elapsed:Float) {
	missesTxt.text=missesTxt.text+"/"+thenumber;
}