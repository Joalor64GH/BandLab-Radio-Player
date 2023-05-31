package;

// since a substate can't be the initial state, we make a temporary state
class Init extends flixel.FlxState {
    override function create() {
        flixel.FlxG.switchState(new states.MainMenuState());
        super.create();
    }
}