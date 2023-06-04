package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import alphabet.Alphabet;
import base.CoolUtil;

import lime.app.Application;
import openfl.Assets;

using StringTools;

class CreditsState extends FlxState
{
	static var curSelected:Int = 0;

	private var grpCredits:FlxTypedGroup<Alphabet>;
	var credits:Array<CreditsMetadata> = [];
	var descText:FlxText;
	var bg:FlxSprite;

	override function create()
	{
		var initCreditlist = CoolUtil.coolTextFile(Paths.txt('creditsList'));

		if (Assets.exists(Paths.txt('creditsList')))
		{
			initCreditlist = Assets.getText(Paths.txt('creditsList')).trim().split('\n');

			for (i in 0...initCreditlist.length)
			{
				initCreditlist[i] = initCreditlist[i].trim();
			}
		}
		else
		{
			trace("OOPS! Could not find 'creditsList.txt'!");
			trace("Replacing it with normal credits...");
			initCreditlist = "Joalor64 YT:Main Programmer".trim().split('\n');

			for (i in 0...initCreditlist.length)
			{
				initCreditlist[i] = initCreditlist[i].trim();
			}
		}

		for (i in 0...initCreditlist.length)
		{
			var data:Array<String> = initCreditlist[i].split(':');
			credits.push(new CreditsMetadata(data[0], data[1]));
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.color = FlxColor.BLUE;
		add(bg);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.text = 'what';
		descText.borderSize = 2.4;
		add(descText);

		initOptions();
		changeSelection();

		var descText:FlxText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		super.create();
	}

	function initOptions()
	{
		grpCredits = new FlxTypedGroup<Alphabet>();
		add(grpCredits);

		for (i in 0...credits.length)
		{
			var creditText:Alphabet = new Alphabet(90, 320, credits[i].modderName, true);
			creditText.isMenuItem = true;
			creditText.targetY = i - curSelected;
			grpCredits.add(creditText);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
			changeSelection(FlxG.keys.justPressed.UP ? -shiftMult : shiftMult);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Std.int(FlxG.mouse.wheel));

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new states.MainMenuState());
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		descText.text = credits[curSelected].desc;

		var bullShit:Int = 0;

		for (item in grpCredits.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class CreditsMetadata
{
	public var modderName:String = "";
	public var desc:String = "";

	public function new(name:String, desc:String)
	{
		this.modderName = name;
		this.desc = desc;
	}
}