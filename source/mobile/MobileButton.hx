package mobile;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.FlxInput;
import flixel.input.FlxPointer;
import flixel.input.IFlxInput;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.FlxG;
#if mobile_controls_allow_mouse_clicks
import flixel.input.mouse.FlxMouseButton;
#end
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

/**
 * A simple button class that calls a function when clicked by the touch.
 * @author: KralOyuncu2010x (ArkoseLabs)
 */
class MobileButton extends TypedMobileButton<FlxSprite>
{
	/**
	 * Used with public variable status, means not highlighted or pressed.
	 */
	public static inline var NORMAL:Int = 0;

	/**
	 * Used with public variable status, means highlighted (usually from touch over).
	 */
	public static inline var HIGHLIGHT:Int = 1;

	/**
	 * Used with public variable status, means pressed (usually from touch click).
	 */
	public static inline var PRESSED:Int = 2;

	/**
	 * A simple tag that returns the button's graphic name in upper case.
	 */
	public var tag:String;

	/**
	 * A simple tag that you can check which one is what in for function.
	 */
	public var name:String;

	/**
	 * A returned key from Psych Extended.
	 */
	public var returnedKey:String;

	/**
	 * A String IDs from Psych Extended.
	 */
	public var IDs:Array<String> = [];

	/**
	 * A Unique ID for PsychEngine Notes.
	 */
	public var uniqueID:Int;

	/**
	 * A Small invisible bounds used for colision
	**/
	public var bounds:FlxSprite = new FlxSprite();

	/**
	 * Creates a new `MobileButton` object
	 * and a callback function on the UI thread.
	 *
	 * @param   X		 The x position of the button.
	 * @param   Y		 The y position of the button.
	 * @param   Return	 The return of the button.
	 */
	public function new(X:Float = 0, Y:Float = 0, ?returned:String):Void
	{
		super(X, Y);
		if (returned != null || returned != '') returnedKey = returned;
	}

	public inline function centerInBounds()
	{
		setPosition(bounds.x + ((bounds.width - frameWidth) / 2), bounds.y + ((bounds.height - frameHeight) / 2));
	}

	public inline function centerBounds()
	{
		bounds.setPosition(x + ((frameWidth - bounds.width) / 2), y + ((frameHeight - bounds.height) / 2));
	}
}

/**
 * A simple button class that calls a function when clicked by the touch.
 */
#if !display
@:generic
#end
class TypedMobileButton<T:FlxSprite> extends FlxSprite implements IFlxInput
{
	/**
	 * The label that appears on the button. Can be any `FlxSprite`.
	 */
	public var label(default, set):T;

	/**
	 * Whether you can press the button simply by releasing the touch button over it (default).
	 * If false, the input has to be pressed while hovering over the button.
	 */
	public var allowSwiping:Bool = true;

	/**
	 * Whether the button can use multiple fingers on it.
	 */
	public var multiTouch:Bool = false;

	/**
	 * Maximum distance a pointer can move to still trigger event handlers.
	 * If it moves beyond this limit, onOut is triggered.
	 * Defaults to `Math.POSITIVE_INFINITY` (i.e. no limit).
	 */
	public var maxInputMovement:Float = Math.POSITIVE_INFINITY;

	/**
	 * The properties of this button's `onUp` event (callback function, sound).
	 */
	public var onUp(default, null):MobileButtonEvent;

	/**
	 * The properties of this button's `onDown` event (callback function, sound).
	 */
	public var onDown(default, null):MobileButtonEvent;

	/**
	 * The properties of this button's `onOver` event (callback function, sound).
	 */
	public var onOver(default, null):MobileButtonEvent;

	/**
	 * The properties of this button's `onOut` event (callback function, sound).
	 */
	public var onOut(default, null):MobileButtonEvent;

	/**
	 * Shows the current state of the button, either `MobileButton.NORMAL`,
	 * `MobileButton.HIGHLIGHT` or `MobileButton.PRESSED`.
	 */
	public var status(default, set):Int;

	/**
	 * The alpha's the button should use depednging on the status.
	**/
	public var statusAlphas:Array<Float> = [1.0, 1.0, 0.6];

	/**
	 * What animation should be played for each status.
	 * Default is ['normal', 'highlight', 'pressed'].
	 */
	public var statusAnimations:Array<String> = ['normal', 'highlight', 'pressed'];

	/**
	 * How much to add/substract from the current indicator value for the label.
	**/
	public var labelStatusDiff:Float = 0.05;

	/**
	 * IF YOU'RE USING SPRITE GROUPS YOU MUST SET THIS TO THE GROUP'S ALPHA LIKE IN TouchPad.
	**/
	public var parentAlpha(default, set):Float = 1;

	public var statusIndicatorType(default, set):StatusIndicators = ALPHA;

	public var justReleased(get, never):Bool;
	public var released(get, never):Bool;
	public var pressed(get, never):Bool;
	public var justPressed(get, never):Bool;

	/**
	 * Basically disables the buttok updates.
	 */
	public var isJoyStick:Bool;

	/**
	 * An array of objects that blocks your input.
	 */
	public var deadZones:Array<FlxSprite> = [];

	/**
	 * We cast label to a `FlxSprite` for internal operations to avoid Dynamic casts in C++
	 */
	var _spriteLabel:FlxSprite;

	/**
	 * A hint shits, did you expect something?
	 */
	public var hintUp:FlxSprite;
	public var hintDown:FlxSprite;

	/** 
	 * We don't need an ID here, so let's just use `Int` as the type.
	 */
	var input:FlxInput<Int>;

	/**
	 * The input currently pressing this button, if none, it's `null`. Needed to check for its release.
	 */
	var currentInput:IFlxInput;

	#if mobile_controls_allow_mouse_clicks
	/**
	* Which mouse buttons can trigger the button - by default only the left mouse button.
	*/
	public var mouseButtons:Array<FlxMouseButtonID> = [FlxMouseButtonID.LEFT];
	#end

	var lastStatus = -1;
	public var canChangeLabelAlpha:Bool = true;

	/**
	 * Creates a new `TypedMobileButton` object with a gray background.
	 *
	 * @param   X         The x position of the button.
	 * @param   Y         The y position of the button.
	 */
	public function new(X:Float = 0, Y:Float = 0, ?OnClick:Void->Void):Void
	{
		super(X, Y);

		loadDefaultGraphic();

		onUp = new MobileButtonEvent();
		onDown = new MobileButtonEvent();
		onOver = new MobileButtonEvent();
		onOut = new MobileButtonEvent();

		status = multiTouch ? MobileButton.NORMAL : MobileButton.HIGHLIGHT;

		// Since this is a UI element, the default scrollFactor is (0, 0)
		scrollFactor.set();

		statusAnimations[MobileButton.HIGHLIGHT] = 'normal';

		input = new FlxInput(0);
	}

	override public function graphicLoaded():Void
	{
		super.graphicLoaded();

		setupAnimation('normal', MobileButton.NORMAL);
		setupAnimation('pressed', MobileButton.PRESSED);
	}

	function loadDefaultGraphic():Void
		loadGraphic('flixel/images/ui/button.png', true, 80, 20);

	function setupAnimation(animationName:String, frameIndex:Int):Void
	{
		// make sure the animation doesn't contain an invalid frame
		frameIndex = Std.int(Math.min(frameIndex, #if (flixel < "5.3.0") animation.frames #else animation.numFrames #end - 1));
		animation.add(animationName, [frameIndex]);
	}

	/**
	 * Called by the game state when state is changed (if this object belongs to the state)
	 */
	override public function destroy():Void
	{
		label = FlxDestroyUtil.destroy(label);
		_spriteLabel = null;
		hintUp = null;
		hintDown = null;

		onUp = FlxDestroyUtil.destroy(onUp);
		onDown = FlxDestroyUtil.destroy(onDown);
		onOver = FlxDestroyUtil.destroy(onOver);
		onOut = FlxDestroyUtil.destroy(onOut);

		deadZones = FlxDestroyUtil.destroyArray(deadZones);
		currentInput = null;
		input = null;

		super.destroy();
	}

	/**
	 * Called by the game loop automatically, handles touch over and click detection.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (visible)
		{
			// Update the button, but only if at least either touches are enabled
			#if FLX_POINTER_INPUT
			updateButton();
			#end

			// Trigger the animation only if the button's input status changes.
			if (lastStatus != status)
			{
				updateStatusAnimation();
				lastStatus = status;
			}
		}

		input.update();
	}

	function updateStatusAnimation():Void
		animation.play(statusAnimations[status]);

	/**
	 * Just draws the button graphic and text label to the screen.
	 */
	override public function draw():Void
	{
		super.draw();

		if (_spriteLabel != null && _spriteLabel.visible)
		{
			_spriteLabel.cameras = cameras;
			_spriteLabel.draw();
		}

		if (hintUp != null && hintUp.visible)
		{
			hintUp.cameras = cameras;
			hintUp.draw();
		}

		if (hintDown != null && hintDown.visible)
		{
			hintDown.cameras = cameras;
			hintDown.draw();
		}
	}

	#if FLX_DEBUG
	/**
	 * Helper function to draw the debug graphic for the label as well.
	 */
	override public function drawDebug():Void
	{
		super.drawDebug();

		if (_spriteLabel != null)
			_spriteLabel.drawDebug();
		if (hintUp != null)
			hintUp.drawDebug();
		if (hintDown != null)
			hintDown.drawDebug();
	}
	#end

	/**
	 * Basic button update logic - searches for overlaps with touches and
	 * the touch and calls `updateStatus()`.
	 */
	function updateButton():Void
	{
		#if mobile_controls_allow_mouse_clicks
		var overlapFound = checkMouseOverlap();
		if (!overlapFound)
			overlapFound = checkTouchOverlap();
		#else
		var overlapFound = checkTouchOverlap();
		#end

		if (!isJoyStick) {
			if (currentInput != null && currentInput.justReleased && overlapFound)
				onUpHandler();

			if (status != MobileButton.NORMAL && (!overlapFound || (currentInput != null && currentInput.justReleased)))
				onOutHandler();
		}
	}

	#if mobile_controls_allow_mouse_clicks
	function checkMouseOverlap():Bool
	{
		var overlap = false;
		for (camera in cameras)
		{
			for (buttonID in mouseButtons)
			{
				var button = FlxMouseButton.getByID(buttonID);

				final worldPos:FlxPoint = FlxG.mouse.getWorldPosition(camera, _point);

				for (zone in deadZones) {
					if (zone != null) {
						if (zone.overlapsPoint(worldPos, true, camera))
							return false;
					}
				}

				if (checkInput(FlxG.mouse, button, button.justPressedPosition, camera))
					overlap = true;
			}
		}
		return overlap;
	}
	#end

	function checkTouchOverlap():Bool
	{
		var overlap = false;

		for (camera in cameras) {
			for (touch in FlxG.touches.list) {
				final worldPos:FlxPoint = touch.getWorldPosition(camera, _point);

				for (zone in deadZones) {
					if (zone != null) {
						if (zone.overlapsPoint(worldPos, true, camera))
							return false;
					}
				}

				if (checkInput(touch, touch, touch.justPressedPosition, camera))
					overlap = true;
			}
		}

		return overlap;
	}

	function checkInput(pointer:FlxPointer, input:IFlxInput, justPressedPosition:FlxPoint, camera:FlxCamera):Bool
	{
		if (maxInputMovement != Math.POSITIVE_INFINITY
			&& justPressedPosition.distanceTo(pointer.getScreenPosition(FlxPoint.weak())) > maxInputMovement
			&& input == currentInput)
		{
			currentInput = null;
		}
		else if (overlapsPoint(pointer.getWorldPosition(camera, _point), true, camera))
		{
			updateStatus(input);
			return true;
		}

		return false;
	}

	/**
	 * Updates the button status by calling the respective event handler function.
	 */
	function updateStatus(input:IFlxInput):Void
	{
		if (input.justPressed)
		{
			currentInput = input;
			onDownHandler();
		}
		else if (status == MobileButton.NORMAL)
		{
			// Allow 'swiping' to press a button (dragging it over the button while pressed)
			if (allowSwiping && input.pressed)
				onDownHandler();
			else
				onOverHandler();
		}
	}

	public function updateLabelPosition()
	{
		if (_spriteLabel != null)
		{
			_spriteLabel.x = ((width - _spriteLabel.width) / 2) + (pixelPerfectPosition ? Math.floor(x) : x);
			_spriteLabel.y = ((height - _spriteLabel.height) / 2) + (pixelPerfectPosition ? Math.floor(y) : y);
		}
	}
	
	public function updateLabelScale()
	{
		if (_spriteLabel != null)
			_spriteLabel.scale.set(scale.x, scale.y);
	}

	function indicateStatus()
	{
		switch (statusIndicatorType)
		{
			case ALPHA:
				if (_spriteLabel != null && statusAlphas.length > status)
					_spriteLabel.alpha = alpha * statusAlphas[status];
			case NONE: // no balls
		}
	}

	/**
	 * Internal function that handles the onUp event.
	 */
	public function onUpHandler():Void
	{
		status = MobileButton.NORMAL;
		input.release();
		currentInput = null;
		onUp.fire(); // Order matters here, because onUp.fire() could cause a state change and destroy this object.
	}

	/**
	 * Internal function that handles the onDown event.
	 */
	public function onDownHandler():Void
	{
		status = MobileButton.PRESSED;
		input.press();
		onDown.fire(); // Order matters here, because onDown.fire() could cause a state change and destroy this object.
	}

	/**
	 * Internal function that handles the onOver event.
	 */
	public function onOverHandler():Void
	{
		status = MobileButton.HIGHLIGHT;
		onOver.fire(); // Order matters here, because onOver.fire() could cause a state change and destroy this object.
	}

	/**
	 * Internal function that handles the onOut event.
	 */
	public function onOutHandler():Void
	{
		status = MobileButton.NORMAL;
		input.release();
		onOut.fire(); // Order matters here, because onOut.fire() could cause a state change and destroy this object.
	}

	function set_label(Value:T):T
	{
		if (Value != null)
		{
			// use the same FlxPoint object for both
			Value.scrollFactor.put();
			Value.scrollFactor = scrollFactor;
		}

		label = Value;
		_spriteLabel = label;

		updateLabelPosition();

		return Value;
	}

	function set_status(Value:Int):Int
	{
		status = Value;
		indicateStatus();
		return status;
	}

	override function set_alpha(Value:Float):Float
	{
		super.set_alpha(Value);
		indicateStatus();
		return alpha;
	}
	
	override function set_visible(Value:Bool):Bool
	{
		super.set_visible(Value);
		if (_spriteLabel != null)
			_spriteLabel.visible = Value;
		return Value;
	}

	override function set_x(Value:Float):Float
	{
		super.set_x(Value);
		updateLabelPosition();
		return x;
	}

	override function set_y(Value:Float):Float
	{
		super.set_y(Value);
		updateLabelPosition();
		return y;
	}
	
	override function set_color(Value:FlxColor):Int
	{
		if (_spriteLabel != null)
			_spriteLabel.color = Value;
		
		super.set_color(Value);
		return Value;
	}

	override private function set_width(Value:Float)
	{
		super.set_width(Value);
		updateLabelScale();
		return Value;
	}

	override private function set_height(Value:Float)
	{
		super.set_height(Value);
		updateLabelScale();
		return Value;
	}

	override public function updateHitbox()
	{
		super.updateHitbox();
		if (_spriteLabel != null)
			_spriteLabel.updateHitbox();
		if (hintUp != null)
			hintUp.updateHitbox();
		if (hintDown != null)
			hintDown.updateHitbox();
	}

	function set_parentAlpha(Value:Float):Float
	{
		statusAlphas = [
			Value,
			Value - 0.05,
			(parentAlpha - 0.45 == 0 && parentAlpha > 0)
			? 0.25 : parentAlpha - 0.45
		];
		indicateStatus();
		return parentAlpha = Value;
	}

	function set_statusIndicatorType(Value:StatusIndicators)
	{
		statusIndicatorType = Value;
		return Value;
	}

	inline function get_justReleased():Bool
		return input.justReleased;

	inline function get_released():Bool
		return input.released;

	inline function get_pressed():Bool
		return input.pressed;

	inline function get_justPressed():Bool
		return input.justPressed;
}

/** 
 * Helper function for `MobileButton` which handles its events.
 */
private class MobileButtonEvent implements IFlxDestroyable
{
	/**
	 * The callback function to call when this even fires.
	 */
	public var callback:Void->Void;

	#if FLX_SOUND_SYSTEM
	/**
	 * The sound to play when this event fires.
	 */
	public var sound:FlxSound;
	#end

	/**
	 * @param   Callback   The callback function to call when this even fires.
	 * @param   sound	  The sound to play when this event fires.
	 */
	public function new(?Callback:Void->Void, ?sound:FlxSound):Void
	{
		callback = Callback;

		#if FLX_SOUND_SYSTEM
		this.sound = sound;
		#end
	}

	/**
	 * Cleans up memory.
	 */
	public inline function destroy():Void
	{
		callback = null;

		#if FLX_SOUND_SYSTEM
		sound = FlxDestroyUtil.destroy(sound);
		#end
	}

	/**
	 * Fires this event (calls the callback and plays the sound)
	 */
	public inline function fire():Void
	{
		if (callback != null)
			callback();

		#if FLX_SOUND_SYSTEM
		if (sound != null)
			sound.play(true);
		#end
	}
}

enum StatusIndicators
{
	// best one in my opinion
	ALPHA;
	// used when u make ur own status indicator like in joystick
	NONE;
}