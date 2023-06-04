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
    var song:String;
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
        {name:"Arcadia Mania", song:"arcadia-mania", disc:"arcadia", bpm:125},
        {name:"Christmas Wishes",  song:"christmas-wishes", disc:"christmas", bpm:130},
        {name:"Creepy Ol Forest", song:"creepy-ol-forest", disc:"creepy", bpm:100},
        {name:"Dreamy Lo-fi Beats", song:"dreamy-lo-fi-beats", disc:"dreamy", bpm:120},
        {name:"Game Development", song:"game-development", disc:"game", bpm:130},
        {name:"GBA Cliche", song:"gba-cliche", disc:"gba", bpm:100},
        {name:"Nighttime Gaming", song:"nighttime-gaming", disc:"nighttime", bpm:120},
        {name:"Nighttime Gaming REMIX", song:"nighttime-gaming-remix", disc:"nighttimere", bpm:130},
        {name:"Pure Indian Vibes", song:"pure-indian-vibes", disc:"pure", bpm:100},
        {name:"Relaxing Evening Lo-fi", song:"relaxing-evening-lo-fi", disc:"relaxing", bpm:120},
        {name:"Silver Candy", song:"silver-candy", disc:"silver", bpm:135},
        {name:"Universal Questioning", song:"universal-questioning", disc:"universal", bpm:125},
        {name:"Untitled Lo-fi Song", song:"untitled-lo-fi-song", disc:"untitled", bpm:130}
    ];

    override public function create()
    {
        openfl.system.System.gc();

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

        songTxt = new Alphabet(0, 0, songs[curSelected].name, true);
        songTxt.setPosition(50, musplayer.y - 120);
        add(songTxt);

        changeSong();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) 
        {
            FlxG.sound.play(Paths.sound('switchbtn'));
	    changeSong(FlxG.keys.justPressed.LEFT ? -1 : 1);
        }

        if (FlxG.keys.justPressed.ESCAPE) 
        {
            FlxG.switchState(new states.MainMenuState());
            FlxG.sound.music.volume = 0;
        }

        if(FlxG.sound.music != null)
        {
            Conductor.songPosition = FlxG.sound.music.time;
            if (FlxG.keys.justPressed.ENTER)
            {
                FlxG.sound.play(Paths.sound('playbtn'));
                if(!FlxG.sound.music.playing)
                {
                    FlxG.sound.music.play();
                }
                else
                {
                    FlxG.sound.music.pause();
                }  
            }   
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
        }
        else 
        {
	   trace('ohno its dont exist');
        }

        songTxt.text = '< ${songs[curSelected].name} >';
        Conductor.changeBPM(songs[curSelected].bpm);
       
        var songName:String = songs[curSelected].song == null ? songs[curSelected].name.toLowerCase() : songs[curSelected].song;

        if(!loadedSongs.contains(songName))
        {
            loadedSongs.push(songName);
            FlxG.sound.playMusic(Paths.music(songName), 1);
            FlxG.sound.music.pause();
        }
        else
        {
            FlxG.sound.playMusic(Paths.music(songName), 1);
            FlxG.sound.music.pause();
        }
    }
}
