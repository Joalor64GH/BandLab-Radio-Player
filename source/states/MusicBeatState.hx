package states;

import flixel.FlxG;
import flixel.FlxState;

class MusicBeatState extends FlxState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function stepHit(step:Int):Void
	{
		if (step % 4 == 0)
			beatHit();
	}

	function beatHit():Void 
    {
        // do nothing
    }
}