package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

import alphabet.Alphabet;
import base.Conductor;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef Song = {
    var name:String;
    var ?song:String;
    var cover:String;
    var bpm:Float;
}

class PlayState extends FlxState
{
    public var bg:FlxSprite;

    public var disc:FlxSprite;
    public var musplayer:FlxSprite;
    public var playerneedle:FlxSprite;

    public var testTxt:Alphabet;

    var discImg:FlxSprite;

    var curSelected:Int = 0;
    public var songList:Array<String> = [];

    override public function create()
    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('musicBG'));
        add(bg);
        
        musplayer = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/musplayer'));
        musplayer.screenCenter();
        musplayer.antialiasing = true;
        add(musplayer);
        disc = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/disc'));
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

        if (FlxG.keys.justPressed.LEFT)
        {
		    changeSong(-1);
            loadAll();
        }
        else if (FlxG.keys.justPressed.RIGHT)
        {
		    changeSong(1);
            loadAll();
        }
    }

    function loaddisc()
    {
        var discImg:FlxSprite;
        var key:String = Paths.image('discs/' + songName + '_disc');
        if (FileSystem.exists(key))
            discImg = new FlxSprite(0, 0).loadGraphic(key);
        else 
            discImg = null;

        if (discImg != null)
            disc = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/disc'));
    }

    function loadSong() 
    {
        // do nothing
    }

    function loadText()
    {
        // do nothing
    }

    function loadAll()
    {
        loadSong();
        loadDisc();
        loadText();
        Conductor.changeBPM(songbpm);
    }

    function changeSong(number:Int)
    {
        curSelected += number;
        if (curSelected > songList.length - 1)
            curSelected = songList.length - 1;
        if (curSelected < 0)
            curSelected = 0;
    }
}