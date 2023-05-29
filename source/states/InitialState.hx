package states;

// since a substate can't be the inital state, we make a temporary state
class InitialState extends flixel.FlxState {
    override function create() {
        flixel.FlxG.switchState(new states.MainMenuState());
        super.create();
    }
}