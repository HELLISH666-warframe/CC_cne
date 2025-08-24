import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;

var songList = FreeplaySonglist.get();
var leSongs = songList.songs;

var checkForInput = true;
var paintingSelected = false;
var curSelected = 0;

var bg;
var painting;
var paintingHitbox;
var bf;
var gf;
var arrows:Array<FlxSprite> = [];

var songTxt;

for (sogn in leSongs) graphicCache.cache(Paths.image("menus/freeplay/paintings/" + sogn.name));
graphicCache.cache(Paths.image("menus/freeplay/bg/room"));
graphicCache.cache(Paths.image("menus/freeplay/bg/roomEVIL"));

function create() {
    trace(leSongs[0].name);

    painting = new FunkinSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/paintings/" + leSongs[curSelected].name));
    painting.scale.set(0.35, 0.35);
    painting.updateHitbox();
    painting.scrollFactor.set(0.9, 0.9);
    painting.zoomFactor = 0.8;
    painting.screenCenter();
    add(painting);

    bg = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/freeplay/bg/room"));
    bg.scale.set(0.35, 0.35);
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    paintingHitbox = new FlxSprite(305, 80).makeSolid(350, 340, 0xFFFFFFFF); 
    paintingHitbox.color = 0xFFFF0000;
    paintingHitbox.alpha = 0.5;
    paintingHitbox.updateHitbox();
    add(paintingHitbox);

    songTxt = new FlxText(paintingHitbox.x, paintingHitbox.y - 30, paintingHitbox.width, leSongs[curSelected].displayName);
    songTxt.setFormat(Paths.font("sm64v2.ttf"), 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songTxt.borderSize = 4;
    songTxt.alpha = 0;
    add(songTxt);

    for (i in 0...2) {
        var butt = new FunkinSprite().loadGraphic(Paths.image("menus/freeplay/bg/arrowCropped"));
        butt.flipX = (i == 0);
        butt.scale.set(0.2, 0.2);
        butt.updateHitbox();
        butt.zoomFactor = 1.1;
        butt.setPosition(paintingHitbox.x + (i == 0 ?  - 100 : paintingHitbox.width + 30), paintingHitbox.y + (paintingHitbox.height / 2) - (butt.height / 2));
        butt.alpha = 0;
        add(butt);
        arrows.push(butt);

        var hitbox = new FunkinSprite(butt.x, butt.y).makeSolid(butt.width, butt.height, 0xFFFFFFFF);
        hitbox.scrollFactor.set(butt.scrollFactor.x, butt.scrollFactor.y);
        hitbox.color = 0xFFFF0000;
        hitbox.updateHitbox();
        insert(members.indexOf(butt) - 1, hitbox);
    }

    bf = new FunkinSprite(0, 10).loadGraphic(Paths.image("menus/freeplay/bfAndGf/bf"));
    bf.scale.set(0.35, 0.35);
    bf.updateHitbox();
    bf.screenCenter(FlxAxes.X);
    bf.scrollFactor.set(1.3, 1.3);
    bf.zoomFactor = 1.4;
    add(bf);

    gf = new FunkinSprite(0, 10).loadGraphic(Paths.image("menus/freeplay/bfAndGf/gf" + FlxG.random.int(1, 4)));
    gf.scale.set(0.35, 0.35);
    gf.updateHitbox();
    gf.screenCenter(FlxAxes.X);
    gf.scrollFactor.set(1.3, 1.3);
    gf.zoomFactor = 1.4;
    add(gf);
}


function update(elapsed) {
    var justPressedDir = controls.LEFT_P || controls.RIGHT_P;
    var dirs = [controls.LEFT, controls.RIGHT];
    if (checkForInput) {
        if (justPressedDir) changeSelection(controls.LEFT_P ? -1 : 1);

        paintingSelected = FlxG.mouse.overlaps(paintingHitbox);
        if (FlxG.mouse.overlaps(paintingHitbox)) {
        }

        if (FlxG.mouse.justPressed) {
            for (l=> i in arrows) {
                if (FlxG.mouse.overlaps(i)) changeSelection(l == 0 ? -1 : 1);
            }
        }

        if (controls.BACK) {
            new FlxTimer().start(1, ()->{ FlxG.log.add("The FlxTimer has finished"); FlxG.switchState(new ModState("marioStates/classifiedMenu"));});
        }
    }

    camera.zoom = CoolUtil.fpsLerp(camera.zoom, paintingSelected ? 1.3 : 1, 0.04);
    camera.scroll.x = CoolUtil.fpsLerp(camera.scroll.x, (FlxG.mouse.x / FlxG.width) * 50 - 25, 0.04);
    camera.scroll.y = CoolUtil.fpsLerp(camera.scroll.y, (FlxG.mouse.y / FlxG.height) * 40 + (paintingSelected ? -80 : 0) - 25, 0.04);
    for (l=>i in arrows) {
        i.alpha = CoolUtil.fpsLerp(i.alpha, paintingSelected ? 1 : 0.6, 0.04);
        i.scale.x = CoolUtil.fpsLerp(i.scale.x, dirs[l] ? 0.18 : FlxG.mouse.overlaps(i) ? FlxG.mouse.pressed ? 0.18 : 0.25 : 0.2, 0.12);
        i.scale.y = CoolUtil.fpsLerp(i.scale.y, dirs[l] ? 0.18 : FlxG.mouse.overlaps(i) ? FlxG.mouse.pressed ? 0.18 : 0.25 : 0.2, 0.12);
    }
    songTxt.alpha = CoolUtil.fpsLerp(songTxt.alpha, paintingSelected ? 1 : 0.4, 0.04);
}
var lastSel = curSelected;
function changeSelection(?fuck) {
    fuck ??= 0;
    if (fuck != 0) FlxG.sound.play(Paths.sound("menu/scroll"), 1);
    curSelected = FlxMath.wrap(curSelected + fuck, 0, leSongs.length - 1);
    
        // for (i in 0...optionGrp.length) {  
        //     var obj:FlxSprite = optionGrp[i];
        // }
    // if (useMouse) curSelected = fuck;
    songTxt.text = leSongs[curSelected].displayName;
    painting.loadGraphic(Paths.image("menus/freeplay/paintings/" + leSongs[curSelected].name));
    if (leSongs[curSelected].name == "shrouded") {
        bg.loadGraphic(Paths.image("menus/freeplay/bg/roomEVIL"));
        bf.visible = false;
        gf.visible = false;
        FlxTween.cancelTweensOf(FlxG.sound.music);
        FlxG.sound.music.volume = 0;
    } else if (curSelected != lastSel && leSongs[lastSel].name == "shrouded") {
        bg.loadGraphic(Paths.image("menus/freeplay/bg/room"));
        bf.visible = true;
        gf.visible = true;
        FlxTween.tween(FlxG.sound.music, {volume: 0.7}, 2, {ease:FlxEase.sineInOut});
        // FlxG.sound.music.volume = 0.7;
    }
    lastSel = curSelected;
}