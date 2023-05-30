package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.Lib;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(1280, 720, Init, #if (flixel < "5.0.0") -1, #end 60, 60, false, false));
	}
}