
import funkin.editors.ui.UIText;
import funkin.menus.ModSwitchMenu;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIState;
import flixel.addons.display.FlxBackdrop;
import hxvlc.flixel.FlxVideoSprite;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.DiscordUtil;
var list = [
    'videos' => ['song', 'tune-in','hard'],
    'hatred' => ['song', 'unfaithful','hard'],
    'joe' => ['song', 'rombie','hard'],
    'world1' => ['song', 'fancy-funk','hard'],
    'skrunkly' => ['song', 'catto','hard'],

    'ohmygod' => ['image', 'dreamybull'],
    'alanb' => ['image', 'alanb'],
    'fiend folio' => ['image', 'twinkle of contagion'],
    'da alien' => ['image', 'war crimes'],
    'jerry' => ['image', 'jerry'],
    ':)' => ['image', 'happy'],
    'ok' => ['image', 'shark-plane'],
    'd1t1l1g' => ['image', 'what the fuck']
];
var isWriting:Bool = false;

var wrongTween:FlxTween;
var wrongTimer:FlxTimer;
	
//random easter eggs
var goofyImage:FlxSprite;
var goofyTween:FlxTween;

//normal code yeahhhh



var tipPopUp:FlxSprite;
var convertPopUp:FlxSprite;
var glitchBG:FlxSprite;
var glitchBGHUD:FlxSprite;
var daStatic:FlxSprite;
var barTitle:FlxSprite;
var downBarText:FlxSprite;
var vignette:FlxSprite;
public var camHUD:FlxCamera;
var vignette2:FlxSprite;
var selectedSmth:Bool = false;
var inputText:UITextBox;
var coolDown:Bool = true;
var modesText:FlxText;
var curDifficulty = 1;
var whiteScreen:FlxSprite;
//public static var crtShader = new CRTShader();
//var shaderFilter = new ShaderFilter(crtShader);
var spikes1:FlxBackdrop;
var spikes2:FlxBackdrop;
var secretCounter:Int = 0;
var itemsText:FlxText;

var wrongTextArray:Array<String> =  ['Please, insert a valid symbol.',
	'You are supposed to put something else there, come on.',
	'Try again.',
	'You should totally translate the morse codes you have seen.',
	'Computerized Conflict: Coming to PS5, Xbox Series X and Nintendo Switch soon.',
	'verycool_errortext_5.txt'
];

var wrong:FlxText;

function create() {
    DiscordUtil.changePresence('In the Vault', null);

    window.title = "Computerized Conflict - Vault - Theme by: JaceLOL";

    camHUD = new FlxCamera();
	camHUD.bgColor = 0;
	FlxG.cameras.add(camHUD, false);

    Conductor.changeBPM(115);

    FlxG.sound.playMusic(Paths.music('secret_menu'));

    glitchBG = new FlxSprite(450,215);
    glitchBG.scrollFactor.set(0.9, 0.9);
    glitchBG.frames = Paths.getSparrowAtlas('menus/vault/newGlitchBG');
    glitchBG.animation.addByPrefix('g', 'g', 24, true);
    glitchBG.animation.play('g');
	glitchBG.screenCenter();
	glitchBG.antialiasing = Options.antialiasing;
	add(glitchBG);

    glitchBGHUD = new FlxSprite(450,215);
    glitchBGHUD.scrollFactor.set(0.9, 0.9);
    glitchBGHUD.frames = Paths.getSparrowAtlas('menus/vault/newGlitchBG');
    glitchBGHUD.animation.addByPrefix('g', 'g', 24, true);
    glitchBGHUD.animation.play('g');
	glitchBGHUD.screenCenter();
	glitchBGHUD.antialiasing = Options.antialiasing;
	glitchBGHUD.cameras = [camHUD];
	glitchBGHUD.alpha = 0;
	add(glitchBGHUD);

    vignette2 = new FlxSprite().loadGraphic(Paths.image('menus/vault/vig2'));
	vignette2.antialiasing = Options.antialiasing;
	add(vignette2);

    daStatic = new FlxSprite().loadGraphic(Paths.image('menus/vault/static'));
	daStatic.antialiasing = Options.antialiasing;
	add(daStatic);

    spikes1 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes1.y -= 60;
	spikes1.scrollFactor.set(0, 0);
	spikes1.flipY = true;
	add(spikes1);

    spikes2 = new FlxBackdrop(Paths.image('menus/mainmenu/spikes'), FlxAxes.X, 0, 0);
	spikes2.y += 630;
	spikes2.scrollFactor.set(0, 0);
	add(spikes2);

    var bksp:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/vault/bksp'));
	bksp.setGraphicSize(Std.int(bksp.width * 0.5));
	bksp.antialiasing = Options.antialiasing;
	add(bksp);

    /*for (i in 0...codesAndShit.length) {
		if (CoolUtil.songsUnlocked.data.songs.get(codesAndShit[i][1])) secretCounter++;
	}*/

    wrong = new FlxText(20, 550, FlxG.width, '', 18);
	wrong.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.RED, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	wrong.alpha = 0;
	add(wrong);

    itemsText = new FlxText(35, 655, FlxG.width, 'Unlocked Secrets: ' + secretCounter + '/5', 18);
	itemsText.setFormat(Paths.font("phantommuff.ttf"), 34, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
	add(itemsText);

    barTitle = new FlxSprite(0, -150).loadGraphic(Paths.image('menus/vault/barTitle'));
	barTitle.antialiasing = Options.antialiasing;
	barTitle.alpha = 0.000001;
	add(barTitle);

    vignette = new FlxSprite().loadGraphic(Paths.image('menus/vault/blueVig'));
	vignette.antialiasing = Options.antialiasing;
	add(vignette);

    tipPopUp = new FlxSprite(250, 0).loadGraphic(Paths.image('menus/vault/tip'));
	tipPopUp.antialiasing = Options.antialiasing;
	tipPopUp.alpha = 0.000001;
	add(tipPopUp);

    convertPopUp = new FlxSprite(-250, 0).loadGraphic(Paths.image('menus/vault/convertToSymbol'));
	convertPopUp.antialiasing = Options.antialiasing;
	convertPopUp.alpha = 0.000001;
	add(convertPopUp);

    /*inputText = new FlxInputText(235, 326, FlxG.width, "", 20, FlxColor.BLACK, FlxColor.TRANSPARENT, true);
	inputText.setFormat(Paths.font("tahoma.ttf"), 20, FlxColor.BLACK, FlxTextBorderStyle.OUTLINE,FlxColor.TRANSPARENT);
	inputText.hasFocus = true;
	inputText.maxLength = 32;
	inputText.borderSize = 0.1;
	add(inputText);*/

    modesText = new FlxText(FlxG.width * 0.7, 5, 0, "", 42);
	modesText.setFormat(Paths.font("Small Print.ttf"), 42, FlxColor.WHITE, 'center');
	modesText.y += 580;
	modesText.x -= 730;
	modesText.alpha = 1;
	add(modesText);

    whiteScreen = new FlxSprite(0, 0).makeSolid(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
	whiteScreen.scrollFactor.set();
	whiteScreen.screenCenter();
	whiteScreen.alpha = 0;
	add(whiteScreen);

    /*inputText.callback = function(text, action) {
		if (action == 'enter') enteredCode(text);
		isWriting = true;
	}*/

    if(FlxG.sound.music == null) {
		FlxG.sound.playMusic(Paths.music('secret_menu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 1);
	}

    FlxTween.tween(barTitle, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(barTitle, {y: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

    FlxTween.tween(tipPopUp, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(tipPopUp, {x: 0}, 0.4, {ease:FlxEase.smoothStepInOut,
		onComplete: function(tween:FlxTween) {
			FlxTween.tween(tipPopUp, {y: tipPopUp.y + 15}, 3, {ease:FlxEase.smoothStepInOut, type: FlxEase.PINGPONG});
		}
	});

    FlxTween.tween(convertPopUp, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(convertPopUp, {x: 0}, 0.4, {ease:FlxEase.smoothStepInOut});

    new FlxTimer().start(0.4, function(lol:FlxTimer) {coolDown = false;});

    goofyImage = new FlxSprite(0,0);
	goofyImage.screenCenter();
	goofyImage.alpha = 0;
	add(goofyImage);

    FlxG.mouse.visible = true;
	FlxG.mouse.load(Assets.getBitmapData(Paths.image('menus/EProcess/alt')), 1, 1,1);

    var eskdgjoerigjeio = new CustomShader("CRT");
    if (FlxG.save.data.crt_cc) FlxG.camera.addShader(eskdgjoerigjeio);
}

function postCreate() {
    
    inputText = new UITextBox(235, 326, '', 280, 20, false);
    inputText.multiline = false;
	inputText.label.setFormat(Paths.font('tahoma.ttf'), 20, FlxColor.BLACK,FlxTextBorderStyle.OUTLINE,FlxColor.TRANSPARENT);

    /*inputText = new FlxInputText(235, 326, FlxG.width, "", 20, FlxColor.BLACK, FlxColor.TRANSPARENT, true);
	inputText.setFormat(Paths.font("tahoma.ttf"), 20, FlxColor.BLACK, FlxTextBorderStyle.OUTLINE,FlxColor.TRANSPARENT);
	inputText.hasFocus = true;
	inputText.maxLength = 32;
	inputText.borderSize = 0.1;
	add(inputText);*/

	inputText.caretSpr.color = FlxColor.BLACK;
	inputText.caretSpr.scale.set(1, 30);
	inputText.caretSpr.offset.set(0, -14);
    trace(inputText.caretSpr);
    add(inputText);
}

function beatHit() {
	if (!selectedSmth)
		FlxTween.tween(FlxG.camera, {zoom:1.02}, 0.3, {ease: FlxEase.quadOut, type:FlxEase. BACKWARD}); //lol
}

function update(elapsed:Float) {
    spikes1.x -= 0.45 * 60 * elapsed;
	spikes2.x -= 0.45 * 60 * elapsed;

    if (!selectedSmth && !coolDown) {
		if (FlxG.keys.justPressed.ANY) FlxG.sound.play(Paths.sound('keyboardPress'));

		if (FlxG.keys.justPressed.ESCAPE && !isWriting) {
			glitchBGHUD.alpha = 1;
			FlxG.sound.music.fadeOut();
				
			var shit:FlxSound = new FlxSound().loadEmbedded(Paths.sound('glitch'));
			shit.play(true);
			shit.onComplete = function() {
				FlxG.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
				
			escapeTween();
				
			selectedSmth = true;
		}
	}
    if (controls.ACCEPT) {
        var t = list[inputText.label.text];

        if (t != null) {
            switch(t[0]) {
                case 'song':
                    PlayState.loadSong(t[1], t[2]);
                    FlxG.switchState(new PlayState());
            }
        }
    }
}

function escapeTween() {
	FlxTween.tween(barTitle, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(barTitle, {y: -150}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(tipPopUp, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
	FlxTween.tween(tipPopUp, {x: 250}, 0.4, {ease:FlxEase.smoothStepInOut});

	FlxTween.tween(convertPopUp, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
	FlxTween.tween(convertPopUp, {x: -250}, 0.4, {ease:FlxEase.smoothStepInOut});
}