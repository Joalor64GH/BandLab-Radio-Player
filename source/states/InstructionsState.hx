package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class InstructionsState extends FlxState
{
    public var DisplayText:FlxText;

    override function create()
    {
	openfl.system.System.gc();
        
	super.create();

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
	bg.scrollFactor.x = 0;
	bg.scrollFactor.y = 0.18;
	bg.setGraphicSize(Std.int(bg.width * 1.1));
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);

        DisplayText = new FlxText(0, 0, FlxG.width, 
	            "Use the UP and DOWN keys to" 
		    + "\nnavigate through the menus."
		    + "\nUse LEFT and RIGHT to switch songs."
		    + "\nPress ENTER to play the song."
		    + "\nWhen you are done listening,"
		    + "\npress ESC to go back.", 32);
	DisplayText.setFormat(Paths.font("vcr.ttf"), 54, FlxColor.WHITE, FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
	add(DisplayText);
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
