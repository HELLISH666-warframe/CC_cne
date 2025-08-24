import funkin.backend.utils.DiscordUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.Lib;
import Alphabet_but_gooder;
import AttachedSprite;

var credits:Array<CreditsMetadata> = [];

static var curSelected:Int = 0;

var grpCredits:FlxTypedGroup<Alphabet>;

var grpIcons:FlxTypedGroup<AttachedSprite>;

var bg:FlxSprite;
var scrollingThing:FlxBackdrop;
var arrow:FlxSprite;
var flippedArrow:FlxSprite;

var outlineWidth:Float = 10;

var camDefault:FlxCamera;
var camTexts:FlxCamera;
var camSpecialThanks:FlxCamera;

var prompt:FlxSprite;
var prompttext:FlxText;

var descText:FlxText;
var moveTween:FlxTween;
var descBox:AttachedSprite;

var specialThanks:FlxSprite;

var crtShader:CustomShader = new CustomShader("CRT");

var moveCredits:Bool = true;

override function create()
{
	persistentUpdate = true;

	DiscordUtil.changePresence('In the Credits Menu', null);

	Lib.application.window.title = "Computerized Conflict - Credits Menu - Theme by: DangDoodle";

	camDefault = new FlxCamera();
	camTexts = new FlxCamera();
	camTexts.bgColor = 0x00000000;
	camSpecialThanks = new FlxCamera();
	camSpecialThanks.bgColor = 0x00000000;

	FlxG.cameras.reset(camDefault);
	FlxG.cameras.add(camTexts, false);
	FlxG.cameras.add(camSpecialThanks, false);

	//CustomFadeTransition.nextCamera = camSpecialThanks;

	credits = [
		//Tco Dev Team

		new CreditsMetadata("JetTRG", "jet", "Director, Concept Artist & Main Charter.", 0xbd3185, "what's 6 × 3? 21."),
		new CreditsMetadata("MijaeLio", "mijae", "Co-Director & Main Coder.", 0xFF5F5D5D, "Saludos a mi vieja"),
		new CreditsMetadata("Tiburones202", "Tiburones202", "Coder & Charter.", 0xFFFF0000, "Twinkle of Contagion is a Passive Item added in the Spitshine update.\nFlavor text: \"Take the Shot\"\nItem Pool: Treasure, Drug Dealer\nQuality: 2\nItem Tags: Syringe, Summonable, Offensive"),
		new CreditsMetadata("Ne_Eo", "Ne_Eo", "Coder.", 0xFF533a38, "Hello, I bet you live on earth"),
		new CreditsMetadata("amaarzadjali", "amaar", "Musician.", 0xFFA75027, "this is my finest hour"),
		new CreditsMetadata("joa", "joa", "Musician.", 0xFF0000FF, "If Eevee is exposed to a Water Stone and evolves into Vaporeon, it will be an excellent swimmer, capable of becoming invisible in water, and will have great aquatic abilities. He will become calm, mature, his wisdom will grow with great prominence, since he knows as much about things on land as those of the sea. It has a peaceful and open character. It also has a good sense of leadership and is a very self-assured Pokémon. He loves to attract attention: in fact, he does anything to feel cared for and to be the center of attention, even on others, making his pride known. However, despite being a calm Pokémon, if it gets too proud it can become proud, something that can be compared to Jolteon, another evolution of Eevee. Vaporeon's body is mostly blue. It has pointed yellow ears that help propel it when it dives, with which it can hear underwater. It has a fin on its head similar to that of a shark, and a white ruff on its neck. It has scaly spikes on its spine that extend the length of its back. Its physical constitution is adapted to marine subsistence, mainly thanks to its tail topped by a caudal fin that helps it swim. It is not easy to see it when it swims because it is confused with water due to the bluish tone of its skin covered with scales. In addition to having the unique ability to become invisible in the water, leaving predators behind. Vaporeon can live in fresh water, especially in calm lagoons, and due to its biology it is sometimes found in not very rough seas and oceans, although it has been seen in cities. This Pokémon is capable of staying underwater for more than two hours without needing to breathe. In fact, the Pokédex mentions that it even has gills. Although he is better adapted to swimming, he is an excellent runner and has enormous agility on dry land. In Pokémon Contests, Vaporeon's fancy Water-type moves would put on a wonderful show."),
		new CreditsMetadata("SharkFaceGaming", "shark", "Musician.", 0xFF4ECDFF, "microwaveable pizza"),
		new CreditsMetadata("JaceLOL", "Jace", "Musician.", 0xFF0000FF, "popeyes fried chicken"),
		new CreditsMetadata("TheNatz", "natz", "Musician.", 0xFFFF7B22, "dont search toy in discord gif search worst mistake of my life"),
		new CreditsMetadata("Prod.kxri", "prodkxri", "Musician.", 0xFFFF0000, "Bald kxrai will exist In August"),
		new CreditsMetadata("Eclyptic", "eclyptic", "Musician.", 0xFF0000FF, "Keep doing it, even if nobody cares"),
		new CreditsMetadata("Magbros", "magbros", "Musician.", 0xFFFF7B22, "a thing you can trust"),
		new CreditsMetadata("Puppet Master", "puppet master", "Musician.", 0xFFFFB032, "1100010 1100001 1101100 1101100 1110011"),
		new CreditsMetadata("DangDoodle", "dangDoodle", "Musician.", 0xFFFF6D63, "Fuck it, we ball."),
		new CreditsMetadata("SwoleBoi", "swole", "Musician.", 0xFFFF6D63, "am i fortnite balls or am i fortnite ballin"),
		new CreditsMetadata("Splat", "splat", "Sprite Artist.", 0xFF6D6767, "eating is a privilege"),
		new CreditsMetadata("noogai9876", "noogai", "Sprite Artist & Cutscene Maker (Adobe)", 0xFF5BFFDC, "alan hire me pls i animate"),
		new CreditsMetadata("Plagee", "plage", "Sprite Artist.", 0xFF8DF1DC, "hello everyone"),
		new CreditsMetadata("Dittosactualoreo", "Ditto", "Sprite/Background Artist.", 0xFFFF00AA, "the person below me kisses men"),
		new CreditsMetadata("Noddles", "noodles", "Background Artist.", 0xFFFF3CBE, "Hello Neighbor is a stealth horror game about sneaking into your neighbor's house to figure out what horrible secrets he's hiding in the basement. You play against an advanced AI that learns from your every move. Really enjoying climbing through that backyard window? Expect a bear trap there."),
		new CreditsMetadata("UnnamedPersonXP", "UnnamedPerson", "Concept Artist.", 0xFF8F562E, "Stickman go beep boop"),
		new CreditsMetadata("NizzyWitch", "nep", "Portrait Artist.", 0xFF0000FF, "I love men"),
		new CreditsMetadata("NexusLoaf", "nexusLoaf", "Portrait Artist.", 0xFFA9D4E6, "what am i even supposed to quote here"),
		new CreditsMetadata("Hexal", "hexal", "Cutscene Maker (Outrage and End Process).", 0xFF585454, "im animator :poop emoji:"),
		new CreditsMetadata("Xyriax", "xyriax", "Extra Charter (Insane Difficulty).", 0xFF0000FF, "charters are overrated"),
		new CreditsMetadata("Shammal", "shammal", "Extra Charter.", 0xFF7AFF7A, "TRANS RIGHTS GRAAAH\n\n(I charted the hard difficulties for End Process, Trojan, Conflict, Cubify, Kickstarter. Phantasm, and Aurora!)"),
		new CreditsMetadata("LeLazyOne", "lelazyone", "Trailer Editor & Animator.", 0xFFFFBA7A, "i like girls"),

		//Contributers (no icons)
		//Also try making credit sections if you can lol

		new CreditsMetadata("Scorpzie", "scorpzie", "Original vocals for \"Adobe (Old)\".", 0xFFFFFFFF, ""),
		new CreditsMetadata("XG_Chris", "chris", "Old Artist.", 0xFFFFFFFF, ""),
		new CreditsMetadata("03Cube", "cheese", "Virabot, fires and social media burning sprites.", 0xFFFFFFFF, ""),
		new CreditsMetadata("ROCKY", "rocky", "\"Dashpulse\" vocals composer.", 0xFFFFFFFF, ""),
		new CreditsMetadata("Deltom", "deltom", "Composed \"Trojan\"", 0xFFFFFFFF, ""),
		new CreditsMetadata("ProfessorBonnie", "profesorbonnie", "Composed \"Time Travel\".", 0xFFFFFFFF, ""),
		new CreditsMetadata("DTunes", "", "A composer of \"Alan (Remake)\"", 0xFFFFFFFF, ""),
		new CreditsMetadata("atpx8", "", "Helped with the End Process pop-ups mechanic.", 0xFFFFFFFF, ""),
		new CreditsMetadata("Tentilog", "tenti", "3D STICK Sprite.", 0xFFFFFFFF, ""),
		new CreditsMetadata("Koi", "koi", "Rombie BG Artist.", 0xFFFFFFFF, ""),
		new CreditsMetadata("Blonic", "blonic", "Logo Artist.", 0xFFFFFFFF, ""),

		//new CreditsMetadata("", "jet", "", 0xFF, ""),
	];

	bg = new FlxSprite().loadGraphic(Paths.image('menus/creditsmenu/background'));
	bg.scrollFactor.set();
	bg.updateHitbox();
	bg.screenCenter();
	//bg.antialiasing = ClientPrefs.globalAntialiasing;
	add(bg);

	scrollingThing = new FlxBackdrop(Paths.image('menus/creditsmenu/Main_Checker'), FlxAxes.XY, 0, 0);
	scrollingThing.scrollFactor.set(0, 0.07);
	scrollingThing.alpha = 0.7;
	scrollingThing.setGraphicSize(Std.int(scrollingThing.width * 0.4));
	//scrollingThing.antialiasing = ClientPrefs.globalAntialiasing;
	add(scrollingThing);

	var vignette = new FlxSprite();
	vignette.loadGraphic(Paths.image('menus/creditsmenu/ok'));
	vignette.scrollFactor.set();
	//vignette.antialiasing = ClientPrefs.globalAntialiasing;
	add(vignette);

	grpCredits = new FlxTypedGroup();
	add(grpCredits);
	//grpIcons = new FlxTypedGroup<AttachedSprite>();
	grpIcons = new FlxTypedGroup();
	add(grpIcons);

	var topbar = new FlxSprite();
	topbar.loadGraphic(Paths.image('menus/creditsmenu/upperBar'));
	topbar.scrollFactor.set();
	//topbar.antialiasing = ClientPrefs.globalAntialiasing;
	topbar.cameras = [camTexts];
	add(topbar);

	var creditsbar = new FlxSprite();
	creditsbar.loadGraphic(Paths.image('menus/creditsmenu/creditsBar'));
	creditsbar.scrollFactor.set();
	creditsbar.x = FlxG.width - creditsbar.width;
	//creditsbar.antialiasing = ClientPrefs.globalAntialiasing;
	creditsbar.cameras = [camTexts];
	add(creditsbar);

	var downBar = new FlxSprite();
	downBar.loadGraphic(Paths.image('menus/creditsmenu/downBar'));
	downBar.scrollFactor.set();
	downBar.y = FlxG.height - downBar.height;
	//downBar.antialiasing = ClientPrefs.globalAntialiasing;
	downBar.cameras = [camTexts];
	add(downBar);

	prompt = new FlxSprite();
	prompt.loadGraphic(Paths.image('menus/creditsmenu/popup'));
	prompt.scrollFactor.set();
	prompt.x = FlxG.width - prompt.width - 100;
	prompt.screenCenter(FlxAxes.Y);
	//prompt.antialiasing = ClientPrefs.globalAntialiasing;
	prompt.cameras = [camTexts];
	add(prompt);

	prompttext = new FlxText();
	prompttext.scrollFactor.set();
	prompttext.fieldWidth = prompt.frameWidth - 120;
	prompttext.font = Paths.font("ARIAL.TTF");
	prompttext.size = 20;
	prompttext.color = 0xFF000000;
	prompttext.x = prompt.x;
	prompttext.y = prompt.y;
	//prompttext.antialiasing = ClientPrefs.globalAntialiasing;
	prompttext.cameras = [camTexts];
	add(prompttext);

	for (i in 0...credits.length)
	{
		var creditText = new Alphabet_but_gooder(300, 300, credits[i].name, false);
		creditText.fontColor = credits[i].color;
		creditText.isCreditItem = true;
		//creditText.distancePerItem.x = 0;
		//creditText.distancePerItem.y = 200;
		creditText.targetY = i;
		if(i == 0) {
			creditText.outline = outlineWidth;
		}
		creditText.snapToPosition();
		grpCredits.add(creditText);

		if(credits[i].color & 0xFFFFFF == 0xFFFFFF) {
			creditText.outlineColor = 0xFF000000;
		} else {
			creditText.outlineColor = 0xFFFFFFFF;
		}

		creditText.outlineCameras = [camDefault];
		creditText.cameras = [camTexts];

		var icon = new AttachedSprite("menus/creditsmenu/icons/" + credits[i].icon);
		icon.sprTracker = creditText.letters[0];
		icon.yAdd = -100;
		icon.xAdd = -320;
		icon.origin.set(280, 200);
		icon.antialiasing = true;
		icon.cameras = [camTexts];
		grpIcons.add(icon);
	}

	descBox = new AttachedSprite();
	descBox.makeGraphic(1, 1, 0xFF79c5ff);
	descBox.xAdd = -10;
	descBox.yAdd = -10;
	descBox.alphaMult = 0.6;
	descBox.alpha = 0.6;
	descBox.cameras = [camTexts];
	add(descBox);

	descText = new FlxText(50, FlxG.height + -75 - 25, 0, "", 32);
	descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, 'center');
	descText.scrollFactor.set();
	descText.borderSize = 2.4;
	descBox.sprTracker = descText;
	descText.cameras = [camTexts];
	descText.color = 0xFFffffff;
	add(descText);

	specialThanks = new FlxSprite();
	specialThanks.loadGraphic(Paths.image('menus/creditsmenu/specialThanks'));
	specialThanks.antialiasing = true;
	specialThanks.alpha = 0.0001;
	specialThanks.cameras = [camSpecialThanks];
	add(specialThanks);

	changeSelection(0);

	FlxG.camera.addShader(crtShader);
	camTexts.addShader(crtShader);
	//if (ClientPrefs.shaders) camSpecialThanks.setFilters([shaderFilter]);
}

var holdTime:Float = 0;

override function update(elapsed:Float)
{
	if (FlxG.sound.music.volume < 0.7)
	{
		FlxG.sound.music.volume += 0.5 * elapsed;
	}

	scrollingThing.x -= 0.45 * 60 * elapsed;
	scrollingThing.y -= 0.16 * 60 * elapsed;

	var shiftMult:Int = 1;
	if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

	if(credits.length > 1)
	{
		if (controls.UP_P)
		{
			changeSelection(-shiftMult);
			holdTime = 0;
		}
		if (controls.DOWN_P)
		{
			//arrow.animation.play('smash');
			changeSelection(shiftMult);
			holdTime = 0;
		}
		if(controls.UP_P || controls.DOWN_P)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP_P ? -shiftMult : shiftMult));
			}
		}
		if(FlxG.mouse.wheel != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			changeSelection(-shiftMult * FlxG.mouse.wheel, false);
		}
	}
	if(FlxG.keys.justPressed.SPACE) 
	{
		specialThanks.alpha = specialThanks.alpha == 1 ? 0.0001 : 1;
		moveCredits = !moveCredits;
	}
	if (controls.BACK)
	{
		persistentUpdate = false;
		FlxG.sound.play(Paths.sound('cancelMenu'));
		//CustomFadeTransition.nextCamera = camSpecialThanks;
		FlxG.switchState(new ModState('MainMenuState'));
	}
}

function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions) {
	if(Object == null) return;
	FlxTween.cancelTweensOf(Object);
	FlxTween.tween(Object, Values, Duration, Options);
}

function changeSelection(change:Int = 0, playSound:Bool = true)
{
	if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	if(!moveCredits) return;

	curSelected += change;

	if (curSelected < 0)
		curSelected = credits.length - 1;
	if (curSelected >= credits.length)
		curSelected = 0;

	prompttext.visible = prompt.visible = credits[curSelected].desc != "";
	if(prompttext.visible) {
		prompttext.text = credits[curSelected].desc;
		prompttext.updateHitbox();
		prompttext.x = prompt.x + 110;
		prompttext.y = prompt.y + 90;
	}

	descText.text = credits[curSelected].auth;
	descText.updateHitbox();
	descText.screenCenter();
	descText.y = FlxG.height - descText.height + -75 - 60;

	if(moveTween != null) moveTween.cancel();
	moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

	descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
	descBox.updateHitbox();

	for (i in 0...grpIcons.members.length)
	{
		tween(grpIcons.members[i], {"scale.x": 0.35, "scale.y": 0.35, xAdd: -300}, 0.2, {
			ease: FlxEase.quadOut
		});
	}

	tween(grpIcons.members[curSelected], {"scale.x": 0.6, "scale.y": 0.6, xAdd: -320}, 0.2, {
		ease: FlxEase.quadOut
	});

	for (i=>item in grpCredits.members)
	{
		var shit = i - curSelected;
		var scale = shit == 0 ? 0.75 : 0.375;
		var outline:Float = shit == 0 ? outlineWidth : 0;
		var outlineAlpha:Float = shit == 0 ? 1.0 : 0.0;

		tween(item, {scaleX: scale, "scale.y": scale, #if !web outline: outline, outlineAlpha: outlineAlpha #end}, 0.2, {
				ease: FlxEase.quadOut
			});

		item.targetY = shit;

		if (shit == 0) {
			item.alpha = 1;
		} else {
			item.alpha = 0.4;
		}
	}
}

class CreditsMetadata
{
	public var name:String = "";
	public var icon:String = "";
	public var auth:String = "";
	public var color:FlxColor;
	public var desc:String = "";

	public function new(name:String, icon:String, auth:String, color:FlxColor = 0xffffff, desc:String = "")
	{
		this.name = name;
		if (icon == "") this.icon = "no";
		else this.icon = icon;
		this.auth = auth;
		this.color = color;
		this.desc = desc;
	}
}