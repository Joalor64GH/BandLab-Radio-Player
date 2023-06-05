package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.MainMenuState;
import base.CoolUtil;

class OutdatedState extends FlxState
{
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
			Thanks for playing!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
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
		super.update(elapsed);
	}
}