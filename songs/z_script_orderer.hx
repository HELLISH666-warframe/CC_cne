//
import haxe.io.Path;
// ! DO NOT FUCK WITH THIS SCRIPT AS IT INSURES THE SCRIPTS CAN INTERACT WITH EACHOTHER PROPERLY -lunar
// ! Also its named z_ with the start so it can be rand last by the engine

for (file in Paths.getFolderContent("data/scripts/engine/")) importScript("data/scripts/engine/"+file.substr(0,file.length-3));

var oldScripts:Array<Script> = PlayState.instance.scripts.scripts;
PlayState.instance.scripts.scripts = [];

var engine_Scripts:Array<Script> = [];
var camera_Scripts:Array<Script> = [];
var event_Scripts:Array<Script> = [];
var stage_Scripts:Array<Script> = [];
var note_Scripts:Array<Script> = [];
var song_Scripts:Array<Script> = [];
var other_Scripts:Array<Script> = [];

// ! SORTS SCRIPTS INTO DA ARRAYS ABOVE
for (script in oldScripts) {
    if (script.fileName == "z_script_orderer.hx") continue;

    function startsWith(str:String, start:String)return StringTools.startsWith(str, start);

    switch (Path.directory(script.path)) {
        case "assets/data/stages": stage_Scripts.push(script);
        case "assets/data/scripts/engine": engine_Scripts.push(script);
        case "assets/data/events": event_Scripts.push(script);
        case "assets/data/notes": note_Scripts.push(script);
        //case "songs": other_Scripts.push(script);
        case "songs/" + PlayState.SONG.meta.name + "/scripts":
            song_Scripts.push(script);
        default: other_Scripts.push(script);
    }
    trace(script.fileName);
}

var finalScripts:Array<Script> = [];
for (g_scripts in [engine_Scripts,camera_Scripts,event_Scripts, stage_Scripts, note_Scripts, other_Scripts,song_Scripts])
    for (script in g_scripts) finalScripts.push(script);
PlayState.instance.scripts.scripts = finalScripts;

// destroy scripts
__script__.didLoad = __script__.active = false;