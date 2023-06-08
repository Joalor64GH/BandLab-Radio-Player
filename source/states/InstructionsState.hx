package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

import flixel.input.gamepad.FlxGamepad;

class InstructionsState extends FlxState
{
    public static var gamepad:FlxGamepad;

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

        DisplayText = new FlxText(0, 200, FlxG.width, 
	            "Use the UP and DOWN keys to" 
		    + "\nnavigate through the menus."
		    + "\nUse LEFT and RIGHT to switch songs."
		    + "\nPress ENTER or SPACE to play the song of your choice."
		    + "\nWhen you are done listening,"
		    + "\npress ESC to go back.", 32);
	DisplayText.setFormat(Paths.font("vcr.ttf"), 54, FlxColor.WHITE, FlxTextAlign.CENTER,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
	add(DisplayText);
	var gamepadTxt:FlxText = new FlxText(5, FlxG.height - 24, 0, "Press G on your keyboard or X on your controller for Gamepad Controls.", 12);
	gamepadTxt.scrollFactor.set();
	gamepadTxt.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	add(gamepadTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

	if (FlxG.keys.justPressed.G)
	    FlxG.switchState(new states.GamepadInstructionsState());
        else if (FlxG.keys.justPressed.ESCAPE)
	    FlxG.switchState(new states.MainMenuState());

	var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (gamepad != null) {
            trace("controller detected! :D");

	    if (gamepad.justPressed.X)
                FlxG.switchState(new states.GamepadInstructionsState());
            else if (gamepad.justPressed.B)
                FlxG.switchState(new states.MainMenuState());
	} else {
            trace("oops! no controller detected!");
            trace("probably bc it isnt connected or you dont have one at all.");
	}
    }
}
