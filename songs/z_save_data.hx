function onSongEnd() {
	trace(FlxG.save.data.songsUnlocked);
	if(!FlxG.save.data.songsUnlocked.contains(curSong))
	{
		trace('played'+curSong+'for the first time');

		FlxG.save.data.songsUnlocked.push(curSong);
	}
}