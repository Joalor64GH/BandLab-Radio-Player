package;

import flixel.FlxG;
import flixel.FlxState;
import lime.app.Application;
import states.MainMenuState;
import haxe.Http;

using StringTools;

// since a substate can't be the initial state, we make a temporary state
class Init extends FlxState 
{
    var mustUpdate:Bool = false;
    public static var updateVersion:String = '';

    override function create() 
    {
        #if desktop
	trace('checking for update');
	var http = new Http("https://raw.githubusercontent.com/Joalor64GH/BandLab-Radio-Player/main/embed/gitVersion.txt");

	http.onData = function(data:String) 
	{
	    updateVersion = data.split('\n')[0].trim();
	    var curVersion:String = MainMenuState.gameVersion.trim();
	    trace('version online: ' + updateVersion + ', your version: ' + curVersion);
	    if(updateVersion != curVersion) 
	    {
	        trace('versions arent matching!');
		mustUpdate = true;
	    }
	}

	http.onError = function (error) 
	{
	    trace('error: $error');
	}

	http.request();
	#end

        if (mustUpdate) {
            FlxG.switchState(new states.OutdatedState());
        } else {
            FlxG.switchState(new states.MainMenuState());
        }
        super.create();
    }
}
