//
import funkin.menus.TitleState;

function new()
{   
    if (FlxG.save.data.songsUnlocked_seenCredits == null) FlxG.save.data.songsUnlocked_seenCredits = false;
    if (FlxG.save.data.songsUnlocked_mainWeek == null) FlxG.save.data.songsUnlocked_mainWeek = false;
}

var redirectStates:Map<FlxState, String> = [
    MainMenuState => "MainMenuState", 
	TitleState => "TitleState"
];

function preStateSwitch() {
	for (redirectState in redirectStates.keys())
		if (FlxG.game._requestedState is redirectState)
			FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}