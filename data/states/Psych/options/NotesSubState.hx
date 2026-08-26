import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import funkin.menus.ui.ClassicAlphabet;
import Psych.ColorSwapTest;

private static var curSelNSS:Int = 0;
private static var typeSelected:Int = 0;
private var grpNumbers:FlxTypedGroup<ClassicAlphabet>;
private var grpNotes:FlxTypedGroup<FlxSprite>;
private var shaderArray:Array<ColorSwap> = [];
var curValue:Float = 0;
var holdTime:Float = 0;
var nextAccept:Int = 5;

var blackBG:FlxSprite;
var hsbText:Alphabet;

var posX = 230;

function setHue(shader,val)shader.data.uHsv.value[0]=val;
function setSaturation(shader,val)shader.data.uHsv.value[1]=val;
function setBrightness(shader,val)shader.data.uHsv.value[2]=val;
function create() {
	blackBG = new FlxSprite(posX - 25).makeSolid(870, 200, FlxColor.BLACK);
	blackBG.alpha = 0.4;
	add(blackBG);

	grpNotes = new FlxTypedGroup<FlxSprite>();
	add(grpNotes);
	grpNumbers = new FlxTypedGroup<ClassicAlphabet>();
	add(grpNumbers);

	for (i in 0...ccSSC.arrowHSV.length) {
		var yPos:Float = (165 * i) + 35;
		for (j in 0...3) {
			var optionText = new ClassicAlphabet(posX + (225 * j) + 250, yPos + 60, Std.string(ccSSC.arrowHSV[i][j]), true);
			optionText.refreshAlphabetXML('data/alphabet.xml');
			grpNumbers.add(optionText);
		}

		var note = new FlxSprite(posX, yPos);
		note.frames = Paths.getSparrowAtlas('game/notes/default');
		var animations:Array<String> = ['purple0', 'blue0', 'green0', 'red0'];
		note.animation.addByPrefix('idle', animations[i]);
		note.animation.play('idle');
		note.antialiasing = ccSSC.globalAntialiasing;
		grpNotes.add(note);

		var newShader = new CustomShader("psych/ColorSwapShader");
		newShader.data.uHsv.value=[0, 0, 0];
		note.shader = newShader;
		shaderArray.push(newShader);
	}

	hsbText = new Alphabet(480, 0, "Hue      Saturation   Brightness", false);
	hsbText.scale.set(0.6,0.6);
	hsbText.updateHitbox();
	add(hsbText);
		
	changeSelection(0);
}

var changingNote:Bool = false;
function update(elapsed:Float) {
	if(changingNote) {
		if(holdTime < 0.5) {
			if(controls.LEFT_P||controls.RIGHT_P) {
				updateValue(controls.LEFT_P?-1:1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			} else if(controls.RESET) {
				resetValue(curSelNSS, typeSelected);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			if(controls.LEFT_R || controls.RIGHT_R)holdTime = 0;
			else if(controls.LEFT || controls.RIGHT) holdTime += elapsed;
		} else {
			var add:Float = 90;
			switch(typeSelected) {case 1 | 2: add = 50;}
			if(controls.LEFT) updateValue(elapsed * -add);
			else if(controls.RIGHT) updateValue(elapsed * add);
			if(controls.LEFT_R || controls.RIGHT_R) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				holdTime = 0;
			}
		}
	} else {
		if (controls.UP_P||controls.DOWN_P) {
			changeSelection(controls.UP_P?-1:1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.LEFT_P||controls.RIGHT_P) {
			changeType(controls.LEFT_P?-1:1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if(controls.RESET) {
			for (i in 0...3) resetValue(curSelNSS, i);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.ACCEPT && nextAccept <= 0) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changingNote = true;
			holdTime = 0;
			for (i in 0...grpNumbers.length) {
				var item = grpNumbers.members[i];
				item.alpha = 0;
				if ((curSelNSS * 3) + typeSelected == i) item.alpha = 1;
			}
			for (i in 0...grpNotes.length) {
				var item = grpNotes.members[i];
				item.alpha = 0;
				if (curSelNSS == i) item.alpha = 1;
			}
			return;
		}
	}

	if (controls.BACK || (changingNote && controls.ACCEPT)) {
		if(!changingNote) close();
		else changeSelection(0);
		changingNote = false;
		FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	if(nextAccept > 0) nextAccept -= 1;
}

function changeSelection(change:Int = 0) {
	curSelNSS = FlxMath.wrap(curSelNSS + change, 0, ccSSC.arrowHSV.length - 1);

	curValue = ccSSC.arrowHSV[curSelNSS][typeSelected];
	updateValue(0);

	for (i in 0...grpNumbers.length) {
		var item = grpNumbers.members[i];
		item.alpha = 0.6;
		if ((curSelNSS * 3) + typeSelected == i) item.alpha = 1;
	}
	for (i in 0...grpNotes.length) {
		var item = grpNotes.members[i];
		item.alpha = 0.6;
		item.scale.set(0.75, 0.75);
		if (curSelNSS == i) {
			item.alpha = 1;
			item.scale.set(1, 1);
			hsbText.y = item.y - 10;
			blackBG.y = item.y - 20;
		}
	}
	FlxG.sound.play(Paths.sound('scrollMenu'));
}

function changeType(change:Int = 0) {
	typeSelected = FlxMath.wrap(typeSelected + change, 0, 2);

	curValue = ccSSC.arrowHSV[curSelNSS][typeSelected];
	updateValue(0);

	for (i in 0...grpNumbers.length) {
		var item = grpNumbers.members[i];
		item.alpha = 0.6;
		if ((curSelNSS * 3) + typeSelected == i) item.alpha = 1;
	}
}

function resetValue(selected:Int, type:Int) {
	curValue = 0;
	ccSSC.arrowHSV[selected][type] = 0;
	switch(type) {
		case 0:setHue(shaderArray[selected],0);
		case 1:setSaturation(shaderArray[selected],0);
		case 2:setBrightness(shaderArray[selected],0);
	}

	var item = grpNumbers.members[(selected * 3) + type];
	item.text = '0';

	var add = (40 * (item.letters.length - 1)) / 2;
	for (letter in item.letters) letter.offset.x += add;
}
function updateValue(change:Float = 0) {
	curValue += change;
	var roundedValue:Int = Math.round(curValue);
	var max:Float = (typeSelected==0?180:100);

	if(roundedValue < -max) curValue = -max;
	else if(roundedValue > max) curValue = max;
	roundedValue = Math.round(curValue);
	ccSSC.arrowHSV[curSelNSS][typeSelected] = roundedValue;

	switch(typeSelected) {
		case 0:setHue(shaderArray[curSelNSS],roundedValue / 360);
		case 1:setSaturation(shaderArray[curSelNSS],roundedValue / 100);
		case 2:setBrightness(shaderArray[curSelNSS],roundedValue / 100);
	}

	var item = grpNumbers.members[(curSelNSS * 3) + typeSelected];
	item.text = Std.string(roundedValue);

	var add = (40 * (item.members.length - 1)) / 2;
	for (letter in item.members) {
		letter.offset.x += add;
		if(roundedValue < 0) letter.offset.x += 10;
	}
}