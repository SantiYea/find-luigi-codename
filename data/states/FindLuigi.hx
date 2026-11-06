import flixel.group.FlxSpriteGroup;

// simple config
var speedMult:Float = 0.5;
var amount:Int = 600;

var vlcX:Float = 250;
var vlcY:Float = 180;
// end

var icons:FlxSpriteGroup<FlxSprite> = new FlxSpriteGroup();
var luigi:FlxSprite = new FlxSprite().loadGraphic(Paths.image('luigi/luigi'));
var found:Bool = false;

function getRdmX(sprWidth:Float):Int
    return FlxG.random.int(0, (FlxG.width - sprWidth));

function getRdmY(sprHeight:Float):Int
    return FlxG.random.int(0, (FlxG.height - sprHeight));

function getRmdDir(total, rmd:Bool):Int
{
    var vlc:Int = FlxG.random.int(total / 4, total) * speedMult;
    if (rmd)
        return (FlxG.random.bool() ? vlc : -vlc)
    else
        return vlc;
}
function create() {
    CoolUtil.playMusic(Paths.music('luigi'));

    // Caching ig?
    var images:Array<String> = [Paths.image('luigi/mario'), Paths.image('luigi/wario'), Paths.image('luigi/yoshi')];
    add(icons);

    for (i in 0...amount) {
        var icon:FlxSprite = new FlxSprite().loadGraphic(FlxG.random.getObject(images));
        icon.scale.set(1.2, 1.2);
        icon.updateHitbox();
        icon.velocity.set(getRmdDir(vlcX, true), getRmdDir(vlcY, true));
        icon.setPosition(getRdmX(icon.width), getRdmY(icon.height));
        icons.add(icon);
    }

    luigi.scale.set(1.2, 1.2);
    luigi.updateHitbox();
    luigi.velocity.set(getRmdDir(vlcX, true), getRmdDir(vlcY, true));
    luigi.setPosition(getRdmX(luigi.width), getRdmY(luigi.height));
    icons.insert(FlxG.random.int(0, icons.members.length), luigi);
}

function update() if (!found) {
    for (icon in icons) {
        if (icon.x <= 0) {
            icon.x = 0;
            icon.velocity.x = Math.abs(getRmdDir(vlcX, false));
        }
        else if ((icon.x + icon.width) >= FlxG.width) {
            icon.x = FlxG.width - icon.width;
            icon.velocity.x = -Math.abs(getRmdDir(vlcX, false));
        }

        if (icon.y <= 0) {
            icon.y = 0;
            icon.velocity.y = Math.abs(getRmdDir(vlcY, false));
        }
        else if ((icon.y + icon.height) >= FlxG.height) {
            icon.y = FlxG.height - icon.height;
            icon.velocity.y = -Math.abs(getRmdDir(vlcY, false));
        }
    }

    if (CoolUtil.mouseOverlaps(luigi) && FlxG.mouse.justPressed) {
        trace('found');
        for (icon in icons) {
            icon.active = false;
            icon.visible = false;
        }
        luigi.visible = true;
        found = true;
    }
}
