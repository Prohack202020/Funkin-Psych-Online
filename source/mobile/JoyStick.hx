package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;
import openfl.display.BitmapData;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class JoyStick extends FlxTypedSpriteGroup<MobileButton>
{
	public var deadZone = {x: 0.3, y: 0.3}; 
	public var inputAngle:Float = 0;
	public var intensity:Float = 0;
	var easeSpeed:Float;
	var radius:Float = 0;

	public var onPressed:Void->Void; 

	public var status(get, set):Int; 
	public var instance:MobileButton;
	static inline var NORMAL:Int = MobileButton.NORMAL;
	static inline var HIGHLIGHT:Int = MobileButton.HIGHLIGHT;
	static inline var PRESSED:Int = MobileButton.PRESSED;

	static var analogs:Array<JoyStick> = [];
	var currentTouch:FlxTouch;
	var tempTouches:Array<FlxTouch> = [];
	var zone:FlxRect = FlxRect.get();

	public var size(default, set):Float = 1;
	function set_size(Value:Float) {
		size = Value;
		instance.scale.set(Value, Value);
		if (instance.label != null)
			instance.label.scale.set(Value, Value);

		if (instance != null && radius == 0)
			radius = (instance.width * 0.5) * Value;

		zone.set(x - radius, y - radius, 2 * radius, 2 * radius);
		return Value;
	}

	public function new(?stickPath:String, X:Float = 0, Y:Float = 0, Radius:Float = 0, Ease:Float = 0.25, Size:Float = 1)
	{
		super(X, Y);
		radius = Radius;
		easeSpeed = FlxMath.bound(Ease, 0, 60 / FlxG.updateFramerate);
		analogs.push(this);
		_point = FlxPoint.get();
		createInstance(); 
		createZone();
		size = Size;
		scrollFactor.set();
		moves = false;
	}

	function createInstance(?stickPath:String):Void
	{
		if (stickPath == null) stickPath = MobileConfig.mobileFolderPath + 'JoyStick/joystick';
		var xmlFile:String = '${stickPath}.xml';
		var pngFile:String = '${stickPath}.png';

		instance = new MobileButton(0, 0);
		instance.isJoyStick = true;
		instance.statusIndicatorType = NONE;

		#if mobile_controls_file_support
		var xmlAndPngExists:Bool = false;
		if(FileSystem.exists(xmlFile) && FileSystem.exists(pngFile)) xmlAndPngExists = true;

		if (xmlAndPngExists)
			instance.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(BitmapData.fromFile(pngFile), File.getContent(xmlFile)).getByName('base')));
		else #end
			instance.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(Assets.getBitmapData(pngFile), Assets.getText(xmlFile)).getByName('base')));

		instance.resetSizeFromFrame();
		instance.x += -instance.width * 0.5;
		instance.y += -instance.height * 0.5;
		instance.scrollFactor.set();
		instance.solid = false;

		instance.label = new FlxSprite(0, 0);

		#if mobile_controls_file_support
		if (xmlAndPngExists)
			instance.label.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(BitmapData.fromFile(pngFile), File.getContent(xmlFile)).getByName('thumb')));
		else #end
			instance.label.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow(Assets.getBitmapData(pngFile), Assets.getText(xmlFile)).getByName('thumb')));

		instance.label.resetSizeFromFrame();
		instance.label.x += -instance.label.width * 0.5; 
		instance.label.y += -instance.label.height * 0.5;
		instance.label.scrollFactor.set();
		instance.label.solid = false;

		add(instance);

		if (radius == 0)
			radius = instance.width * 0.5;
	}

	public function createZone():Void
	{
		if (instance != null && radius == 0)
			radius = instance.width * 0.5;

		zone.set(x - radius, y - radius, 2 * radius, 2 * radius);
	}

	override public function destroy():Void
	{
		super.destroy();
		zone = FlxDestroyUtil.put(zone);
		analogs.remove(this);
		instance = FlxDestroyUtil.destroy(instance);
		currentTouch = null;
		tempTouches = null;
		onPressed = null; 
	}

	override public function update(elapsed:Float):Void
	{
		var offAll:Bool = true;

		// There is no reason to get into the loop if their is already a pointer on the analog
		if (currentTouch != null)
		{
			tempTouches.push(currentTouch);
		}
		else
		{
			for (touch in FlxG.touches.list)
			{
				var touchInserted:Bool = false;

				for (analog in analogs)
				{
					if (analog == this && analog.currentTouch != touch && !touchInserted)
					{
						tempTouches.push(touch);
						touchInserted = true;
					}
				}
			}
		}

		for (touch in tempTouches)
		{
			_point.set(touch.screenX, touch.screenY);
			final worldPos:FlxPoint = touch.getWorldPosition(camera, _point);

			if (!updateAnalog(worldPos, touch.pressed, touch.justPressed, touch.justReleased, touch))
			{
				offAll = false;
				break;
			}
		}

		if ((status == HIGHLIGHT || status == NORMAL) && intensity != 0)
		{
			intensity -= intensity * easeSpeed * FlxG.updateFramerate / 60;

			if (Math.abs(intensity) < 0.1)
			{
				intensity = 0;
				inputAngle = 0;
			}
		}

		instance.label.x = (x + Math.cos(inputAngle) * intensity * radius - (instance.label.width * 0.5));
		instance.label.y = (y + Math.sin(inputAngle) * intensity * radius - (instance.label.height * 0.5));

		if (offAll)
			status = NORMAL;

		tempTouches.splice(0, tempTouches.length);

		super.update(elapsed);
	}

	function updateAnalog(TouchPoint:FlxPoint, Pressed:Bool, JustPressed:Bool, JustReleased:Bool, Touch:FlxTouch):Bool
	{
		var offAll:Bool = true;

		if (zone.containsPoint(TouchPoint) || status == PRESSED)
		{
			offAll = false;

			if (status == PRESSED) instance.onDownHandler();

			if (Pressed)
			{
				if (Touch != null)
					currentTouch = Touch;

				status = PRESSED;

				if (JustPressed) instance.onDown.fire(); 

				if (status == PRESSED)
				{
					if (onPressed != null)
						onPressed(); 

					var dx:Float = TouchPoint.x - x;
					var dy:Float = TouchPoint.y - y;

					var dist:Float = Math.sqrt(dx * dx + dy * dy);

					if (dist < 1)
						dist = 0;

					inputAngle = Math.atan2(dy, dx);
					intensity = Math.min(radius, dist) / radius;

					acceleration.x = Math.cos(inputAngle) * intensity;
					acceleration.y = Math.sin(inputAngle) * intensity;
				}
			}
			else if (JustReleased && status == PRESSED)
			{
				currentTouch = null;
				status = HIGHLIGHT;

				instance.onUp.fire();
				acceleration.set();
			}

			if (status == NORMAL)
			{
				status = HIGHLIGHT;
			}
		}

		return offAll;
	}

	inline function get_pressed():Bool
	{ 
		return status == PRESSED;
	}
	inline function get_justPressed():Bool 
	{
		if (currentTouch != null)
			return currentTouch.justPressed && status == PRESSED;
		return false;
	}
	inline function get_justReleased():Bool
	{
		if (currentTouch != null)
			return currentTouch.justReleased && status == HIGHLIGHT;
		return false;
	}

	public var pressed(get, never):Bool;
	public var justPressed(get, never):Bool;
	public var justReleased(get, never):Bool;

	function get_status():Int { return instance.status; }
	function set_status(Value:Int):Int { return instance.status = Value; }

	override public function set_x(X:Float):Float
	{
		super.set_x(X);
		createZone();
		return X;
	}

	override public function set_y(Y:Float):Float
	{
		super.set_y(Y);
		createZone();
		return Y;
	}

	public var up(get, never):Bool;
	function get_up():Bool
	{
		if (!pressed) return false;
		return intensity > deadZone.y && (Math.sin(inputAngle) < -deadZone.y); 
	}

	public var down(get, never):Bool;
	function get_down():Bool
	{
		if (!pressed) return false;
		return Math.sin(inputAngle) > deadZone.y;
	}

	public var left(get, never):Bool;
	function get_left():Bool
	{
		if (!pressed) return false;
		return Math.cos(inputAngle) < -deadZone.x;
	}

	public var right(get, never):Bool;
	function get_right():Bool
	{
		if (!pressed) return false;
		return Math.cos(inputAngle) > deadZone.x;
	}

	public function joyStickJustPressed(Direction:String, Threshold:Float = 0.5):Bool
	{
		if (!justPressed) return false;
		switch (Direction.toLowerCase())
		{
			case 'up': return up;
			case 'down': return down;
			case 'left': return left;
			case 'right': return right;
			default: return false;
		}
	}

	public function joyStickPressed(Direction:String, Threshold:Float = 0.5):Bool
	{
		if (!pressed) return false;
		switch (Direction.toLowerCase())
		{
			case 'up': return up;
			case 'down': return down;
			case 'left': return left;
			case 'right': return right;
			default: return false;
		}
	}

	public function joyStickJustReleased(Direction:String, Threshold:Float = 0.5):Bool
	{
		if (!justReleased) return false;
		switch (Direction.toLowerCase())
		{
			case 'up': return up;
			case 'down': return down;
			case 'left': return left;
			case 'right': return right;
			default: return false;
		}
	}
}
