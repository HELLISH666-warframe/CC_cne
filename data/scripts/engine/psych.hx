import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;
import psych.AttachedSprite;
import flixel.ui.FlxBar;

var timeBarBG:AttachedSprite;
var timeBar:FlxBar;
var timeTxt:FlxText;

var fakeScoreText; //To simulate the changes in score.

var newTimerBar;

var rankingTexts = [
	['You Suck!', 0.2], //From 0% to 19%
	['Shit', 0.4], //From 20% to 39%
	['Bad', 0.5], //From 40% to 49%
	['Bruh', 0.6], //From 50% to 59%
	['Meh', 0.69], //From 60% to 68%
	['Nice', 0.7], //69%
	['Good', 0.8], //From 70% to 79%
	['Great', 0.9], //From 80% to 89%
	['Sick!', 1], //From 90% to 99%
	['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
];
var songPercent:Float = 0;
var uiType:String = 'default';

function postCreate() {
	var showTime:Bool = (ccSSC.timeBarType != 'Disabled');
	timeTxt = new FlxText(42 + (FlxG.width / 2) - 248, 9, 400, "", 32);
	timeTxt.setFormat(Paths.font("phantommuff.ttf"), 32, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	timeTxt.scrollFactor.set();
	timeTxt.alpha = 0;
	timeTxt.borderSize = 2;
	timeTxt.visible = showTime;

	if(StringTools.endsWith(PlayState.SONG.meta.name.toLowerCase(), '(old)'))timeTxt.font = "vcr.ttf";

	timeBarBG = new AttachedSprite('game/healthBars/oldHealthBar');
	timeBarBG.x = timeTxt.x;
	timeBarBG.y = 10 + (timeTxt.height / 4);
	timeBarBG.setGraphicSize(Std.int(timeBarBG.width * 0.85));
	timeBarBG.screenCenter(FlxAxes.X);
	add(timeBarBG);

	timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, 'LEFT_TO_RIGHT', Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,songPercent, 0, 1);
	timeBar.setParent(Conductor, "songPosition");
	timeBar.setRange(0, Math.max(inst.length, 1000));

	timeBarBG.scrollFactor.set();
	timeBarBG.alpha = 0;
	timeBarBG.color = FlxColor.BLACK;
	timeBarBG.visible = showTime;
	timeBar.scrollFactor.set();
	timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
	timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
	timeBar.alpha = 0;
	timeBar.visible = showTime;
	add(timeBar);

	if (uiType == 'default') {
		timeBar.setGraphicSize(Std.int(timeBar.width * 0.85));
		reloadTimeBarColors();
	}
		
	add(timeTxt);

	if(ccSSC.timeBarType == 'Song Name') {
		timeTxt.size = 24;
		timeTxt.y += 3;
	}

	timeBar.cameras = [camHUD];
	timeBarBG.cameras = [camHUD];
	timeTxt.cameras = [camHUD];
	remove(healthBar);

	switch (uiType){
		case 'psychDef':healthBarB = new AttachedSprite('game/healthBars/healthBarLarger');
		healthBarB.y = FlxG.height * 0.89;
		healthBarB.screenCenter(FlxAxes.X);
		healthBarB.scrollFactor.set();
		healthBarB.visible = !ccSSC.hideHud;
		healthBarB.xAdd = -4;
		healthBarB.yAdd = -4;
		add(healthBarB);
		default:healthBarB = new AttachedSprite('game/healthBars/healthBar');
		healthBarB.y = FlxG.height * 0.89;
		healthBarB.screenCenter(FlxAxes.X);
		healthBarB.scrollFactor.set();
		healthBarB.visible = !ccSSC.hideHud;
		healthBarB.xAdd = -4;
		healthBarB.yAdd = -4;
		healthBarB.xAdd = -26;
		healthBarB.yAdd = -12;
		healthBarB.x += 150;

		healthBar = new FlxBar(healthBarB.x + 4, healthBarB.y + 8, FlxBarFillDirection.RIGHT_TO_LEFT, Std.int(healthBarB.width - 50), Std.int(healthBarB.height - 28), this,'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ccSSC.hideHud;
		healthBar.alpha = ccSSC.healthBarAlpha;
		healthBar.screenCenter(FlxAxes.X);
		healthBar.x += 150;
		healthBar.y += 10;

		healthBar.scale.set(0.7, 0.4);

		healthBarB.setGraphicSize(Std.int(healthBarB.width * 0.7));

		healthBarB.sprTracker = healthBar;
	}
	var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (opponentMode ? 0xFF66FF33 : 0xFFFF0000);
	var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
	healthBar.createFilledBar(leftColor, rightColor);
	insert(members.indexOf(healthBarBG), healthBar).camera=camHUD;
	add(healthBarB).camera=camHUD;

	switch (uiType){
		case 'psychDef':fakeScoreText = new FlxText(0, healthBarB.y + 36, FlxG.width, "", 20);
		fakeScoreText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fakeScoreText.borderSize = 1.25;
		fakeScoreText.visible = !ccSSC.hideHud;
		default:fakeScoreText = new FlxText(20, 0, 0, "", 20);
		fakeScoreText.setFormat(Paths.font("phantommuff.ttf"), 22, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fakeScoreText.borderSize = 2;
		fakeScoreText.screenCenter(FlxAxes.Y);
		fakeScoreText.y += 270;
	}

	add(fakeScoreText).camera = camHUD;
	fakeScoreText.alpha = 0;
	healthBar.alpha = 0;
	healthBarB.alpha = 0;
	calculateRating();
	fakeScoreText.text = 'Score: ' + songScore + '\nCombo Breaks: ' + misses + '\nAccuracy: 0% (?)';

	scoreTxt.visible = false;
	accuracyTxt.visible=false;
	missesTxt.visible=false;
	healthBarBG.visible=false;

	iconP1.alpha = 0;
	iconP2.alpha = 0;

	//Ratingssss.
	ratingManager.hitWindows.clear();
	hits.clear();
	ratingManager.addRating({name:"sick", accuracy:1, window:45, score:350, splash:true});
	ratingManager.addRating({name:"good", accuracy:0.7, window:90, score:200, splash:false});
	ratingManager.addRating({name:"bad", accuracy:0.4, window:135, score:100, splash:false});
	ratingManager.addRating({name:"shit", accuracy:0, window:180, score:50, splash:false});
	for (i in ratingManager.ratingData) hits[i.name]=0;

	fuck = new FlxSprite().loadGraphic(Paths.image("Screenshot 2026-06-25 at 01.33.48"));
	fuck.setGraphicSize(FlxG.width,FlxG.height);
	fuck.updateHitbox();
	fuck.screenCenter();
	add(fuck).camera=camHUD;
	fuck.alpha=0.0;

	for(i in 0...iconArray.length){
		iconArray[i].y = healthBar.y - 50;
	}
}

function beatHit() {
	for(i in [iconP1,iconP2])FlxTween.cancelTweensOf(i,['angle']);
	if (curBeat % 4 == 0 && uiType != 'psychDef') {// icon bop coollll shittt t t t t
		FlxTween.angle(iconP1, -30, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
		FlxTween.angle(iconP2, -30, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
	}

	var funny:Float = (healthBar.percent * 0.01) + 0.01;

	iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
	iconP2.setGraphicSize(Std.int(iconP1.width + (50 * funny)), Std.int(iconP2.height - (25 * funny)));
	iconP1.updateHitbox();
	iconP2.updateHitbox();
}

function onSongStart() {
	if (PlayState.SONG.meta.name.toLowerCase() != 'time travel' && PlayState.SONG.meta.name.toLowerCase()!= 'messenger'){
		for(i in [timeBar,timeTxt,healthBar,iconP1,iconP2,fakeScoreText])
		FlxTween.tween(i, {alpha:1}, 0.5, {ease: FlxEase.circOut});
	}
}

function postUpdate(elapsed:Float) {
	//if(updateTime) {
		var curTime:Float = Conductor.songPosition;
		if(curTime < 0) curTime = 0;
		songPercent = (curTime / FlxG.sound.music.length);

		var songCalc:Float = (FlxG.sound.music.length - curTime);
		if(ccSSC.timeBarType == 'Time Elapsed') songCalc = curTime;

		var secondsTotal:Int = Math.floor(songCalc / 1000);
		if(secondsTotal < 0) secondsTotal = 0;

		if(ccSSC.timeBarType != 'Song Name') timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
	//}

	switch(uiType) {
		case 'psychDef':
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, FlxMath.bound(1 - (elapsed * 30), 0, 1))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, FlxMath.bound(1 - (elapsed * 30), 0, 1))));
		default:
		var mult:Float = FlxMath.lerp(0.75, iconP1.scale.x, FlxMath.bound(1 - (elapsed * 9/* * playbackRate*/), 0, 1));
		iconP1.scale.set(mult, mult);

		var mult:Float = FlxMath.lerp(0.75, iconP2.scale.x, FlxMath.bound(1 - (elapsed * 9/* * playbackRate*/), 0, 1));
		iconP2.scale.set(mult, mult);
	}
		
	iconP1.updateHitbox();
	iconP2.updateHitbox();

	iconP1.x = (healthBar.x + 80) + ((healthBar.width - 160) * FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) + (150 * iconP1.scale.x - 150) / 2 - Flags.ICON_OFFSET;
	iconP2.x = (healthBar.x + 80) + ((healthBar.width - 160) * FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - (150 * iconP2.scale.x) / 2 - Flags.ICON_OFFSET * 2;
}

var accuracyText = '?';
function onPostPlayerMiss(e) {
	calculateRating();
}

var scoreTxtTween;
function onPlayerHit(e) {
	calculateRating();
	if(scoreTxtTween != null) scoreTxtTween.cancel();
	fakeScoreText.scale.x = 1.075;
	fakeScoreText.scale.y = 1.075;
	scoreTxtTween = FlxTween.tween(fakeScoreText.scale, {x: 1, y: 1}, 0.2, {
		onComplete: function(twn:FlxTween) {
			scoreTxtTween = null;
		}
	});
}

function onDadHit(e){
	if(dad.getAnimName()== 'attack')e.cancelAnim();
}

function calculateRating() {
	var ratingName = '';

	if (accuracy >= 1) ratingName = rankingTexts[rankingTexts.length - 1][0];
	else {
		for (i in 0...rankingTexts.length-1)
		{
			if(accuracy < rankingTexts[i][1])
			{
				ratingName = rankingTexts[i][0];
				break;
			}
		}
	}

	var advancedRating = "";
    if (misses == 0) {
		if(accuracy==1)advancedRating="SFC";
		else if(hits['good']>0)advancedRating="GFC";
		else if(hits['good']>0||hits['shit']>0)advancedRating="FC";
    }
	else if (misses < 10) advancedRating = "SDCB"
	else if (misses > 0) advancedRating = "Clear";

	accuracyText = ratingName + ' (' + (Math.floor(accuracy * 10000) / 100) + '%) - ' + advancedRating;
	fakeScoreText.text = 'Score: ' + songScore + '\nCombo Breaks: ' + misses+ '\nAccuracy: '+ (Math.floor(accuracy * 10000) / 100) + '% (' + advancedRating+')';
	remove(comboGroup, true); 
	add(comboGroup);
}

function reloadTimeBarColors() {
	timeBar.createFilledBar(FlxColor.BLACK, dad.iconColor);
	timeBar.updateBar();
}

function onGamePause(event) {
    event.cancel();
    persistentUpdate = false;
    persistentDraw = true;
    paused = true;
        
    openSubState(new ModSubState("tco/substates/PauseSubState"));
}

/*
Strum_pos_shit.

scale=0.8
strum0.x=0.2
strum1.x=0.8
*/