package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import alphabet.Alphabet;

using StringTools;

class PlayState extends FlxState
{
    public var bg:FlxSprite;

    public var disc:FlxSprite;
    public var musplayer:FlxSprite;
    public var playerneedle:FlxSprite;

    public var testTxt:Alphabet;

    override public function create()
    {
        super.create();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        bg.scale.set(10, 10);
	bg.screenCenter();
        add(bg);
        
        musplayer = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/musplayer'));
        musplayer.screenCenter();
        musplayer.antialiasing = true;
        add(musplayer);
        disc = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/disk'));
        disc.setPosition(musplayer.x + 268, musplayer.y + 13);
        disc.antialiasing = true;
        disc.angularVelocity = 30;
        add(disc);
        playerneedle = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/playerneedle'));
        playerneedle.screenCenter();
        playerneedle.antialiasing = true;
        add(playerneedle);

        testTxt = new Alphabet(musplayer.x + 90, musplayer.y - 120, 'This is a test.', true);
        add(testTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
		FlxG.switchState(new states.MainMenuState());
        }
    }
}