package states;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import lime.app.Application;
import alphabet.Alphabet;
import base.Conductor;

using StringTools;

typedef Song = {
    var name:String;
    var ?song:String;
    var disc:String;
    var bpm:Float;
}

class PlayState extends FlxState
{
    public var bg:FlxSprite;
    public var disc:FlxSprite = new FlxSprite(0, 0);
    public var musplayer:FlxSprite;
    public var playerneedle:FlxSprite;

    public var songTxt:Alphabet;

    var curSelected:Int = 0;
    var songs:Array<Song> = [
        {name:"Arcadia Mania", disc:"arcadia", bpm:125},
        {name:"Christmas Wishes",  disc:"christmas", bpm:130},
        {name:"Creepy Ol Forest", disc:"creepy", bpm:100},
        {name:"Dreamy Lo-fi Beats", disc:"dreamy", bpm:120},
        {name:"Game Development", disc:"game", bpm:130},
        {name:"GBA Cliche", disc:"gba", bpm:100},
        {name:"Nighttime Gaming", disc:"nighttime", bpm:120},
        {name:"Nighttime Gaming REMIX", disc:"nighttimere", bpm:130},
        {name:"Pure Indian Vibes", disc:"pure", bpm:100},
        {name:"Relaxing Evening Lo-fi", disc:"relaxing", bpm:120},
        {name:"Silver Candy", disc:"silver", bpm:135},
        {name:"Universal Questioning", disc:"universal", bpm:125},
        {name:"Untitled Lo-fi Song", disc:"untitled", bpm:130}
    ];

    override public function create()
    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image('musicBG'));
        add(bg);
        
        musplayer = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/musplayer'));
        musplayer.screenCenter();
        musplayer.antialiasing = true;
        add(musplayer);
        disc.loadGraphic(Paths.image('discs/default'));
        disc.setPosition(musplayer.x + 268, musplayer.y + 13);
        disc.antialiasing = true;
        disc.angularVelocity = 30;
        add(disc);
        playerneedle = new FlxSprite(0, 0).loadGraphic(Paths.image('radio/playerneedle'));
        playerneedle.screenCenter();
        playerneedle.antialiasing = true;
        add(playerneedle);

        songTxt = new Alphabet(musplayer.x + 90, musplayer.y - 120, "Now Playing:" + songs[0].name, false);
        add(songTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
		FlxG.switchState(new states.MainMenuState());
        }

        if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
        {
		    changeSong(FlxG.keys.justPressed.LEFT ? -1 : 1);
        }
    }

    static var loadedSongs:Array<String> = [];
    function changeSong(change:Int = 0)
    {
        if(FlxG.sound.music != null)
            FlxG.sound.music.stop();

        curSelected += change;
        if(curSelected >= songs.length)
            curSelected = 0;
        else if(curSelected < 0)
            curSelected = songs.length - 1;

        if(FileSystem.exists(Paths.image('discs/${songs[curSelected].disc}')))
        {
            disc.loadGraphic(Paths.image('discs/${songs[curSelected].disc}'));
	    return disc;
        }
        else
        {
           return null;
	   trace('ohno its null');
        }

        songTxt.text = '< ${songs[curSelected].name} >';
        #if (flixel < "5.0.0") Conductor.changeBPM(songs[curSelected].bpm); #end 
       
        var songName:String = songs[curSelected].song == null ? songs[curSelected].name.toLowerCase() : songs[curSelected].song;

        if(!loadedSongs.contains(songName))
        {
            loadedSongs.push(songName);
            FlxG.sound.playMusic(Paths.music(songName), 0.75);
            FlxG.sound.music.pause();
        }
        else
        {
            FlxG.sound.playMusic(Paths.music(songName), 0.75);
            FlxG.sound.music.pause();
        }
    }
}
