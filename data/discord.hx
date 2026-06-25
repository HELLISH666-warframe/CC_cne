import funkin.backend.utils.DiscordUtil;

function onGameOver() {
	DiscordUtil.changePresence('Game Over', PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")");
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)data.button1Label = "Download The Mod";
	if(data.button1Url == null)data.button1Url = "https://gamebanana.com/mods/468922";
	
	if(data.button2Label == null)data.button2Label = "Download The Unoffical CNE Port";
	if(data.button2Url == null)data.button2Url = "https://github.com/HELLISH666-warframe/CC_cne";
}

function onPlayStateUpdate() {
	DiscordUtil.changePresenceAdvanced({
		state:(PlayState.instance.paused ? "Paused - " : "") + PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")",
		smallImageKey: "icon-" +PlayState.instance.getIconRPC()
	});
}
