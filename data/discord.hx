import funkin.backend.utils.DiscordUtil;

function onGameOver() {
	DiscordUtil.changePresence('Game Over', PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")");
}

function onDiscordPresenceUpdate(e) {
	var data = e.presence;

	if(data.button1Label == null)data.button1Label = "Download The Mod";
	if(data.button1Url == null)data.button1Url = "ttps://gamebanana.com/mods/468922";
}

function onPlayStateUpdate() {
	DiscordUtil.changePresenceAdvanced({
		state:(PlayState.instance.paused ? "Paused - " : "") + PlayState.SONG.meta.displayName + " (" + PlayState.difficulty + ")",
		smallImageKey: "icon-" +PlayState.instance.getIconRPC()
	});
}
