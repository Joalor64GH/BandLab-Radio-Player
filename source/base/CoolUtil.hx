package base;

import flixel.FlxG;
import flixel.math.FlxMath;
import openfl.utils.Assets;

using StringTools;

class CoolUtil
{
	inline public static function boundTo(value:Float, min:Float, max:Float):Float
		return Math.max(min, Math.min(max, value));
	
	inline public static function coolTextFile(path:String):Array<String> {
		return (Assets.exists(path)) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];
	}
}