package alphabet;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

import base.CoolUtil;

using StringTools;

class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;
	public var forceX:Float = Math.NEGATIVE_INFINITY;
	public var targetY:Float = 0;
	public var yMult:Float = 120;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var isMenuItem:Bool = false;
	public var textSize:Float = 1.0;
	public var text:String = "";
	public var curRow:Int = 0;
	public var lettersArray:Array<AlphabetCharacter> = [];
	public var finishedText:Bool = false;
	public var typed:Bool = false;
	public var typingSpeed:Float = 0.05;

	private var _finalText:String = "";
	private var yMulti:Float = 1;
	private var lastSprite:AlphabetCharacter;
	private var xPosResetted:Bool = false;
	private var splitWords:Array<String> = [];
	private var isBold:Bool = false;
	private var loopNum:Int = 0;
	private var xPos:Float = 0;
	private var consecutiveSpaces:Int = 0;
	private var typeTimer:FlxTimer = null;
	private final LONG_TEXT_ADD:Float = -24;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false, ?typingSpeed:Float = 0.05, ?textSize:Float = 1)
	{
		super(x, y);

		forceX = Math.NEGATIVE_INFINITY;
		this.textSize = textSize;

		_finalText = text;
		this.text = text;
		this.typed = typed;
		isBold = bold;

		if (text != "")
		{
			if (typed)
				startTypedText(typingSpeed);
			else
				addText();
		}
		else
			finishedText = true;
	}

	public function changeText(newText:String, newTypingSpeed:Float = -1)
	{
		for (i in 0...lettersArray.length)
		{
			remove(lettersArray[0]);
			lettersArray.remove(lettersArray[0]);
		}
		lettersArray = [];
		splitWords = [];
		loopNum = 0;
		xPos = 0;
		curRow = 0;
		consecutiveSpaces = 0;
		xPosResetted = false;
		finishedText = false;
		lastSprite = null;

		var lastX = x;
		x = 0;
		_finalText = newText;
		text = newText;
		if (newTypingSpeed != -1)
			typingSpeed = newTypingSpeed;

		if (text != "")
		{
			if (typed)
				startTypedText(typingSpeed);
			else
				addText();
		}
		else
			finishedText = true;
		x = lastX;
	}

	public function addText()
	{
		doSplitWords();

		var xPos:Float = 0;
		for (character in splitWords)
		{
			var spaceChar:Bool = (character == " " || character == "_");
			if (spaceChar)
				consecutiveSpaces++;

			var isNumber:Bool = AlphabetCharacter.numbers.indexOf(character) != -1;
			var isSymbol:Bool = AlphabetCharacter.symbols.indexOf(character) != -1;
			var isAlphabet:Bool = AlphabetCharacter.alphabet.indexOf(character.toLowerCase()) != -1;
			if ((isAlphabet || isSymbol || isNumber) && (!isBold || !spaceChar))
			{
				if (lastSprite != null)
					xPos = lastSprite.x + lastSprite.width;
				if (consecutiveSpaces > 0)
					xPos += 40 * consecutiveSpaces * textSize;

				consecutiveSpaces = 0;

				var letter:AlphabetCharacter = new AlphabetCharacter(xPos, 0, textSize);
				if (isNumber)
					letter.createNumber(character, isBold);
				else if (isSymbol)
					letter.createSymbol(character, isBold);
				else
					letter.createLetter(character, isBold);
				add(letter);
				lettersArray.push(letter);
				lastSprite = letter;
			}
		}
	}

	private function doSplitWords():Void
		splitWords = _finalText.split('');

	public function startTypedText(speed:Float):Void
	{
		_finalText = text;
		doSplitWords();

		if (speed <= 0)
		{
			while (!finishedText)
				timerCheck();
		}
		else
		{
			typeTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				typeTimer = new FlxTimer().start(speed, timerCheck, 0);
			});
		}
	}

	public function timerCheck(?tmr:FlxTimer = null)
	{
		var autoBreak:Bool = false;
		if ((loopNum <= splitWords.length - 2 && splitWords[loopNum] == "\\" && splitWords[loopNum + 1] == "n")
			|| ((autoBreak = true) && xPos >= FlxG.width * 0.65 && splitWords[loopNum] == ' '))
		{
			if (autoBreak)
			{
				if (tmr != null)
					tmr.loops -= 1;
				loopNum += 1;
			}
			else
			{
				if (tmr != null)
					tmr.loops -= 2;
				loopNum += 2;
			}
			yMulti += 1;
			xPosResetted = true;
			xPos = 0;
			curRow += 1;
			if (curRow == 2)
				y += LONG_TEXT_ADD;
		}

		if (loopNum <= splitWords.length && splitWords[loopNum] != null)
		{
			var spaceChar:Bool = (splitWords[loopNum] == " " || splitWords[loopNum] == "_");
			if (spaceChar)
				consecutiveSpaces++;

			var isNumber:Bool = AlphabetCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = AlphabetCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			var isAlphabet:Bool = AlphabetCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1;

			if ((isAlphabet || isSymbol || isNumber) && (!isBold || !spaceChar))
			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
				}
				else
					xPosResetted = false;

				if (consecutiveSpaces > 0)
					xPos += 20 * consecutiveSpaces * textSize;

				consecutiveSpaces = 0;

				var letter:AlphabetCharacter = new AlphabetCharacter(xPos, 55 * yMulti, textSize);
				letter.curRow = curRow;

				if (isNumber)
					letter.createNumber(splitWords[loopNum], isBold);
				else if (isSymbol)
					letter.createSymbol(splitWords[loopNum], isBold);
				else
					letter.createLetter(splitWords[loopNum], isBold);

				letter.x += 90;
				add(letter);

				lastSprite = letter;
			}
		}

		loopNum++;
		if (loopNum >= splitWords.length)
		{
			if (tmr != null)
			{
				typeTimer = null;
				tmr.cancel();
				tmr.destroy();
			}
			finishedText = true;
		}
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY:Float = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
			y = FlxMath.lerp(y, (scaledY * yMult) + (FlxG.height * 0.48) + yAdd, lerpVal);
			if (forceX != Math.NEGATIVE_INFINITY)
				x = forceX;
			else
				x = FlxMath.lerp(x, (targetY * 20) + 90 + xAdd, lerpVal);
		}

		super.update(elapsed);
	}

	public function killTheTimer()
	{
		if (typeTimer != null)
		{
			typeTimer.cancel();
			typeTimer.destroy();
		}
		typeTimer = null;
	}
}

class AlphabetCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
	public static var numbers:String = "1234567890";
	public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";

	public var curRow:Int = 0;

	private var textSize:Float = 1;

	public function new(x:Float, y:Float, textSize:Float)
	{
		super(x, y);

		this.textSize = textSize;

		frames = Paths.getSparrowAtlas('alphabet');
		setGraphicSize(Std.int(width * textSize));
		updateHitbox();
	}

	public function createLetter(letter:String, isBold:Bool = false):Void
	{
		if (isBold)
		{
			animation.addByPrefix(letter, letter.toUpperCase() + " bold", 24);
			animation.play(letter);
			updateHitbox();
		}
		else
		{
			var letterCase:String = "lowercase";
			if (letter.toLowerCase() != letter)
				letterCase = 'capital';

			animation.addByPrefix(letter, letter + " " + letterCase, 24);
			animation.play(letter);
			updateHitbox();

			y = (110 - height);
			y += curRow * 60;
		}
	}

	public function createNumber(letter:String, isBold:Bool = false):Void
	{
		if (isBold)
		{
			animation.addByPrefix(letter, "bold" + letter, 24);
			animation.play(letter);
			updateHitbox();
		}
		else
		{
			animation.addByPrefix(letter, letter, 24);
			animation.play(letter);
			updateHitbox();

			y = (110 - height);
			y += curRow * 60;
		}
	}

	public function createSymbol(letter:String, isBold:Bool = false):Void
	{
		if (isBold)
		{
			switch (letter)
			{
				case '.':
					animation.addByPrefix(letter, 'PERIOD bold', 24);
					animation.play(letter);
					updateHitbox();
				case "'":
					animation.addByPrefix(letter, 'APOSTRAPHIE bold', 24);
					animation.play(letter);
					updateHitbox();
				case "?":
					animation.addByPrefix(letter, 'QUESTION MARK bold', 24);
					animation.play(letter);
					updateHitbox();
				case "!":
					animation.addByPrefix(letter, 'EXCLAMATION POINT bold', 24);
					animation.play(letter);
					updateHitbox();
				case "(":
					animation.addByPrefix(letter, 'bold (', 24);
					animation.play(letter);
					updateHitbox();
				case ")":
					animation.addByPrefix(letter, 'bold )', 24);
					animation.play(letter);
					updateHitbox();
				default:
					animation.addByPrefix(letter, 'bold ' + letter, 24);
					animation.play(letter);
					updateHitbox();
			}
	
			switch (letter)
			{
				case "'":
					y -= 20 * textSize;
				case '-':
					y += 20 * textSize;
				case '(':
					x -= 65 * textSize;
					y -= 5 * textSize;
					offset.x = -58 * textSize;
				case ')':
					x -= 20 / textSize;
					y -= 5 * textSize;
					offset.x = 12 * textSize;
				case '.':
					y += 45 * textSize;
					x += 5 * textSize;
					offset.x += 3 * textSize;
			}
		}
		else
		{
			switch (letter)
			{
				case '#':
					animation.addByPrefix(letter, 'hashtag', 24);
					animation.play(letter);
					updateHitbox();
				case '.':
					animation.addByPrefix(letter, 'period', 24);
					animation.play(letter);
					updateHitbox();
				case "'":
					animation.addByPrefix(letter, 'apostraphie', 24);
					animation.play(letter);
					updateHitbox();
				case "?":
					animation.addByPrefix(letter, 'question mark', 24);
					animation.play(letter);
					updateHitbox();
				case "!":
					animation.addByPrefix(letter, 'exclamation point', 24);
					animation.play(letter);
					updateHitbox();
				case ",":
					animation.addByPrefix(letter, 'comma', 24);
					animation.play(letter);
					updateHitbox();
				default:
					animation.addByPrefix(letter, letter, 24);
					animation.play(letter);
					updateHitbox();
			}
	
			y = (110 - height);
			y += curRow * 60;
			switch (letter)
			{
				case "'":
					y -= 20;
				case '-':
					y -= 16;
			}
		}
	}
}