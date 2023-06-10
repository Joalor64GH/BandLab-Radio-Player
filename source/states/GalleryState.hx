package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import alphabet.Alphabet;

import flixel.input.gamepad.FlxGamepad;

class GalleryState extends FlxState
{
    public static var gamepad:FlxGamepad;

    var allowInputs:Bool = false;

    var topText:Alphabet;
    var text:FlxText;

    var image:FlxSprite;
    var leftImage:FlxSprite;
    var rightImage:FlxSprite;
    var arrows:FlxTypedGroup<FlxSprite>;

    var curSelected:Int = 0;
    var images:Array<GalleryImage> = [ // first parameter is the image path, second one is the description, third one is the name
        new GalleryImage('gallery/arcadiamania', 'The cover for Arcadia Mania.', 'Arcadia Mania Cover'),
        new GalleryImage('gallery/christmaswishes', 'The cover for Christmas Wishes.', 'Christmas Wishes Cover'),
        new GalleryImage('gallery/creepyolforest', 'The cover for Creepy Ol Forest.', 'Creepy Ol Forest Cover'),
        new GalleryImage('gallery/dreamylofibeats', 'The cover for Dreamy Lo-fi Beats.', 'Dreamy Lo-fi Beats Cover'),
        new GalleryImage('gallery/gamedevelopment', 'The cover for Game Development.', 'Game Development Cover'),
        new GalleryImage('gallery/gbacliche', 'The cover for GBA Cliche.', 'GBA Cliche Cover'),
        new GalleryImage('gallery/nighttimegaming', 'The cover for Nighttime Gaming.', 'Nighttime Gaming Cover'),
        new GalleryImage('gallery/nighttimegamingremix', 'The cover for Nighttime Gaming REMIX.', 'Nighttime Gaming REMIX Cover'),
        new GalleryImage('gallery/pureindianvibes', 'The cover for Pure Indian Vibes.', 'Pure Indian Vibes Cover'),
        new GalleryImage('gallery/relaxingeveninglofi', 'The cover for Relaxing Evening Lo-fi.', 'Relaxing Evening Lo-fi Cover'),
        new GalleryImage('gallery/silvercandy', 'The cover for Silver Candy.', 'Silver Candy Cover'),
        new GalleryImage('gallery/untitledlofisong', 'The cover for Untitled Lo-fi Song.', 'Untitled Lo-fi Song Cover')
    ];

    override function create()
    {
        super.create();

        var bg:FlxSprite =  new FlxSprite(-686,0).loadGraphic(Paths.image('menuBG'));
        bg.antialiasing = true;
        add(bg);

        leftImage = new FlxSprite(0,0).loadGraphic(Paths.image('galleryPlaceholder'));
        leftImage.antialiasing = true;
        add(leftImage);

        var slash:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('gallerySlash'));
        slash.alpha = 0.65;
        slash.antialiasing = true;
        add(slash);

        topText = new Alphabet(0, 0, images[0].name, true);
        add(topText);

        text = new FlxText(10, 156, Std.int(slash.width - 85), images[0].description, 12);
        text.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE, LEFT);
        add(text);

        image = new FlxSprite(0,0).loadGraphic(Paths.image('galleryPlaceholder'));
        image.antialiasing = true;
        add(image);

        rightImage = new FlxSprite(0,0).loadGraphic(Paths.image('galleryPlaceholder'));
        rightImage.antialiasing = true;
        rightImage.alpha = 0.5;
        add(rightImage);

        arrows = new FlxTypedGroup<FlxSprite>();
        add(arrows);
        for(i in 0...2)
        {
            var arrow:FlxSprite = new FlxSprite(0, 0);
            arrow.frames = Paths.getSparrowAtlas('notes');
            if(i == 0)
            {
                arrow.animation.addByPrefix('idle', 'arrowLEFT');
                arrow.animation.addByPrefix('pressed', 'left press', 24, false);
                arrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
            } else {
                arrow.animation.addByPrefix('idle', 'arrowRIGHT');
                arrow.animation.addByPrefix('pressed', 'right press', 24, false);
                arrow.animation.addByPrefix('confirm', 'right confirm', 24, false);                
            }
            arrow.animation.play('idle');
            arrow.setGraphicSize(Std.int(arrow.width * 0.7));
            arrow.updateHitbox();
            arrow.setPosition(Std.int(FlxG.width / 2) + (i == 0 ? -50 + -290 : 60 + 290), FlxG.height * 0.60);
            arrow.antialiasing = true;
            arrows.add(arrow);
            arrow.animation.finishCallback = function(t) {
                if(arrow.animation.curAnim.name == 'confirm')
                {
                    arrow.animation.play('idle');
                    arrow.centerOffsets();
                }
            }
        }
        changeSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (allowInputs) 
        {
            if(FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
                changeSelection(FlxG.keys.justPressed.RIGHT ? 1 : -1);
            
            if(FlxG.keys.justPressed.ESCAPE) 
                FlxG.switchState(new MainMenuState());

            var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

            if (gamepad != null) {
                trace("controller detected! :D");

                if (gamepad.justPressed.DPAD_RIGHT || gamepad.justPressed.DPAD_LEFT) 
                    changeSelection(gamepad.justPressed.DPAD_RIGHT ? 1 : -1);

                if (gamepad.justPressed.B)
                    FlxG.switchState(new states.MainMenuState());
	    } else {
                trace("oops! no controller detected!");
                trace("probably bc it isnt connected or you dont have one at all.");
	    }
        }
    }

    function changeSelection(change:Int = 0)
    {
        curSelected += change;
        if(curSelected >= images.length)
            curSelected = 0;
        else if(curSelected < 0)
            curSelected = images.length - 1;

        if(change == 1)
        {
            arrows.members[1].animation.play('confirm');
            arrows.members[1].centerOffsets();
            arrows.members[1].offset.x -= 13;
            arrows.members[1].offset.y -= 13;
        }
        else if(change == -1)
        {
            arrows.members[0].animation.play('confirm');
            arrows.members[0].centerOffsets();
            arrows.members[0].offset.x -= 13;
            arrows.members[0].offset.y -= 13;
        }

        allowInputs = false;

        image.loadGraphic(Paths.image(images[curSelected].path));
        image.scale.x = 1;
        image.scale.y = 1;
        
        while(image.width > 450)
        {
            image.scale.x -= 0.05;
            image.scale.y -= 0.05;
            image.updateHitbox();
        }
        image.updateHitbox();
        image.screenCenter();
        image.x += 60;
        image.y -= 60;
        image.alpha = 0;
        FlxTween.tween(image, {y: image.y + 60, alpha: 1}, 0.12, {onComplete:function(twn:FlxTween){
            allowInputs = true;
        }});

        if(curSelected != images.length - 1)
        {
            rightImage.visible = true;
            rightImage.loadGraphic(Paths.image(images[curSelected + 1].path));
            rightImage.scale.x = 1;
            rightImage.scale.y = 1;
            rightImage.updateHitbox();
            while(rightImage.width > 240)
            {
                rightImage.scale.x -= 0.05;
                rightImage.scale.y -= 0.05;
                rightImage.updateHitbox();
            }
            rightImage.updateHitbox();
            rightImage.screenCenter();
            rightImage.x = image.x + image.width + 30;
        } else {
            rightImage.visible = false;
        }

        if(curSelected != 0)
        {
            leftImage.visible = true;
            leftImage.loadGraphic(Paths.image(images[curSelected - 1].path));
            leftImage.scale.x = 1;
            leftImage.scale.y = 1;
            leftImage.updateHitbox();
            while(leftImage.width > 240)
            {
                leftImage.scale.x -= 0.05;
                leftImage.scale.y -= 0.05;
                leftImage.updateHitbox();
            }
            leftImage.updateHitbox();
            leftImage.screenCenter();
            leftImage.x = image.x - leftImage.width - 30;
        } else {
            leftImage.visible = false;
        }
        text.text = images[curSelected].description;
        topText.text = images[curSelected].name;
    }
}

class GalleryImage
{
    public var path:String;
    public var description:String;
    public var name:String;

    public function new(img:String, dsc:String, ?Name:String)
    {
        path = img;
        description = dsc;
        name = Name;
    }
}
