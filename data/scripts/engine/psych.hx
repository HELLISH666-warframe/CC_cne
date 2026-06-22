import flixel.text.FlxTextBorderStyle;
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

function postCreate() {
	var showTime:Bool = (FlxG.save.data.TimeBar != 'Disabled');
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

	//if (uiType == 'default') {
		timeBar.setGraphicSize(Std.int(timeBar.width * 0.85));
		reloadTimeBarColors();
	//}
		
	add(timeTxt);

	if(FlxG.save.data.TimeBar == 'Song Name') {
		timeTxt.size = 24;
		timeTxt.y += 3;
	}

	timeBar.cameras = [camHUD];
	timeBarBG.cameras = [camHUD];
	timeTxt.cameras = [camHUD];

	fakeScoreText = new FlxText(healthBar.x + (healthBar.width * 0.28), 0, FlxG.width, "A", 20);
	fakeScoreText.setFormat(Paths.font('phantommuff.ttf'), Std.int(20), 0xFFFFFFFF, 'center', FlxTextBorderStyle.OUTLINE, 0xFF000000);
	fakeScoreText.borderSize = 1.5;
	fakeScoreText.camera = camHUD;
	fakeScoreText.screenCenter();
	fakeScoreText.y = healthBarBG.y + 30;
	add(fakeScoreText);
	fakeScoreText.alpha = 0;
	FlxTween.tween(fakeScoreText, {alpha: 1}, 0.75, {ease: FlxEase.quartInOut});
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ?';

	scoreTxt.visible = false;
	accuracyTxt.visible=false;
	missesTxt.visible=false;

	remove(comboGroup, true); 
	comboGroup.scale.set(0.7,0.7);
	comboGroup.updateHitbox();
	comboGroup.x -= 420;
	comboGroup.y += 320;
	//Ratingssss.
	ratingManager.hitWindows.clear();
	hits.clear();
	ratingManager.addRating({name:"sick", accuracy:1, window:45, score:350, splash:true});
	ratingManager.addRating({name:"good", accuracy:0.7, window:90, score:200, splash:false});
	ratingManager.addRating({name:"bad", accuracy:0.4, window:135, score:100, splash:false});
	ratingManager.addRating({name:"shit", accuracy:0, window:180, score:50, splash:false});
	for (i in ratingManager.ratingData) hits[i.name]=0;
}

function onSongStart() {
	FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
}

function postUpdate(elapsed:Float) {
	//if(updateTime) {
		var curTime:Float = Conductor.songPosition;
		if(curTime < 0) curTime = 0;
		songPercent = (curTime / FlxG.sound.music.length);

		var songCalc:Float = (FlxG.sound.music.length - curTime);
		if(FlxG.save.data.timeBarType == 'Time Elapsed') songCalc = curTime;

		var secondsTotal:Int = Math.floor(songCalc / 1000);
		if(secondsTotal < 0) secondsTotal = 0;

		if(FlxG.save.data.timeBarType != 'Song Name') timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
	//}
	comboGroup.cameras = [camHUD];
    add(comboGroup);
}

var accuracyText = '?';
function onPlayerMiss(e) {
	calculateRating();
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses+ ' | Rating: ' + accuracyText;
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
	fakeScoreText.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ' + accuracyText;
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
    if (misses > 0) {
        if (misses == 0) {
            var t = "FC";
            for (r in ratings) {
                if (hits[r.name] > 0 && r.fcRating != null) {
                    t = r.fcRating;
                    }
                }
            advancedRating = t;
        }
    	else if (misses < 10) advancedRating = "SDCB"
		else if (misses > 0) advancedRating = "Clear";
    }


	accuracyText = ratingName + ' (' + (Math.floor(accuracy * 10000) / 100) + '%) - ' + advancedRating;
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