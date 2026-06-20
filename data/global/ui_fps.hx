import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.system.System;

public static var customText:TextField; // VECHETT WORKED OUT ALL THE CUSTOM FPS SHIT I JUST ADJUSTED/RECODED IT
var customFormat:TextFormat = new TextFormat(Paths.getFontName(Paths.font('vcr.ttf')), 15, FlxColor.WHITE);

function new() {
    Framerate.debugMode=1;
    // custom fps shit
	Main.instance.addChild(customText = new TextField()).defaultTextFormat = customFormat;
	customText.x = customText.y = 5;
	Options.fpsCounter = true;
    updateCurStyle('Default');
}
function update() {
    //if(customText!=null&&Framerate.debugMode==0)
    if(Framerate.debugMode<2||Framerate.debugMode==0) Framerate.debugMode=1;
    if(curStyle=='CNE')return;
    customText.text = "FPS: " + Framerate.fpsCounter.fpsNum.text + "\nMemory: "+StringTools.replace(CoolUtil.getSizeString(Framerate.memoryCounter.memory),'MB', ' MB');
    customText.width = customText.textWidth;
}
function preStateSwitch() {
    updateCurStyle('Default');
}
public static var curStyle = "Default";
public static var curStyle_2;
public static function updateCurStyle(e){
    if(e==curStyle_2)return;
    for(i in [Framerate.codenameBuildField,Framerate.memoryCounter.memoryText,Framerate.memoryCounter.memoryPeakText,Framerate.fpsCounter.fpsNum])
        if(i!=null) i.visible = Framerate.fpsCounter.fpsLabel.visible = false;
	curStyle = e;
	switch (curStyle) {
		case 'CNE':
        Framerate.codenameBuildField.visible = Framerate.memoryCounter.memoryText.visible = Framerate.memoryCounter.memoryPeakText.visible = Framerate.fpsCounter.fpsNum.visible = Framerate.fpsCounter.fpsLabel.visible = true;
        Framerate.codenameBuildField.text = 'Codename Engine ';
        customText.visible=false;
    }
    curStyle_2=e;
}

public static function changeFpsFont(theFuckingFont:String,?size:Float=15) {
    for(i in [/*Framerate.fpsCounter.fpsNum,Framerate.fpsCounter.fpsLabel,Framerate.memoryCounter.memoryText,
    Framerate.memoryCounter.memoryPeakText,Framerate.codenameBuildField,*/customText])
    if(i!=null)
    i.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font(theFuckingFont)),size);
}

function destroy(){
    updateCurStyle('CNE');
    Main.instance.removeChild(customText);
    changeFpsFont(Framerate.fontName);
}