package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.MainMenuState;
import base.CoolUtil;

import flixel.input.gamepad.FlxGamepad;

class OutdatedState extends FlxState
{
	public static var gamepad:FlxGamepad;

	var warnText:FlxText;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey! You're running an outdated version of \n 
			BandLab Radio Player! \n
            	        Your current version is (" + MainMenuState.gameVersion + ")! \n
			Press ENTER to update to " + Init.updateVersion + "!\n
			Otherwise, press ESCAPE.\n
			If you have a game controller, press START or BACK/SELECT.\n
			Thanks for playing!",
			32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER) 
		{
			CoolUtil.browserLoad("https://github.com/Joalor64GH/BandLab-Radio-Player/releases/latest");
		} 
		else if (FlxG.keys.justPressed.ESCAPE) 
		{
			FlxG.switchState(new MainMenuState());
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        	if (gamepad != null) {
            		trace("controller detected! :D");

            		if (gamepad.justPressed.START) 
			{
                		CoolUtil.browserLoad("https://github.com/Joalor64GH/BandLab-Radio-Player/releases/latest");
			}
            		else if (gamepad.justPressed.BACK) 
			{
                		FlxG.switchState(new MainMenuState());
			}
		} else {
            		trace("oops! no controller detected!");
            		trace("probably bc it isnt connected or you dont have one at all.");
		}
		super.update(elapsed);
	}
}
