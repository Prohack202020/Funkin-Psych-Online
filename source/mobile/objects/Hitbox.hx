package mobile.objects;

#if hscript
import hscript.Parser;
import hscript.Interp;
#end
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;

/**
 * A zone with 34 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw)
 * @modifier KralOyuncu 2010x (ArkoseLabs)
 */

/**
 * Interface can't see MobileInputManager variables, so use this instead (I hope this works)
 */
class GlobalHitbox extends MobileInputManager
{
	public var onButtonDown:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void> = new FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>();
	public var onButtonUp:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void> = new FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>();
}

@:build(mobile.macros.ButtonMacro.createExtraButtons(30)) //I think 30 is enough
class Hitbox extends GlobalHitbox
{
	public var buttonLeft:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_LEFT, MobileInputID.NOTE_LEFT]);
	public var buttonDown:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_DOWN, MobileInputID.NOTE_DOWN]);
	public var buttonUp:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_UP, MobileInputID.NOTE_UP]);
	public var buttonRight:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_RIGHT, MobileInputID.NOTE_RIGHT]);
	public var extraKey1 = ClientPrefs.data.extraKeyReturn1.toUpperCase();
	public var extraKey2 = ClientPrefs.data.extraKeyReturn2.toUpperCase();
	public var extraKey3 = ClientPrefs.data.extraKeyReturn3.toUpperCase();
	public var extraKey4 = ClientPrefs.data.extraKeyReturn4.toUpperCase();

	public var instance:MobileInputManager;

	var storedButtonsIDs:Map<String, Array<MobileInputID>> = new Map<String, Array<MobileInputID>>();

	/**
	 * Create the zone.
	 */
	public function new(?CustomMode:String):Void
	{
		instance = this;
		super();
		for (button in Reflect.fields(this))
		{
			var field = Reflect.field(this, button);
			if (Std.isOfType(field, MobileButton))
				storedButtonsIDs.set(button, Reflect.getProperty(field, 'IDs'));
		}

		if ((ClientPrefs.data.hitboxmode != 'Classic' && CustomMode == null) || CustomMode != null){
			var Custom:String = CustomMode != null ? CustomMode : ClientPrefs.data.hitboxmode;
			if (!MobileData.hitboxModes.exists(Custom))
				throw 'The Custom Hitbox File doesn\'t exists.';

			var currentHint = MobileData.hitboxModes.get(Custom).hints;
			if (MobileData.hitboxModes.get(Custom).none != null)
				currentHint = MobileData.hitboxModes.get(Custom).none;
			if (ClientPrefs.data.extraKeys == 1 && MobileData.hitboxModes.get(Custom).single != null)
				currentHint = MobileData.hitboxModes.get(Custom).single;
			if (ClientPrefs.data.extraKeys == 2 && MobileData.hitboxModes.get(Custom).double != null)
				currentHint = MobileData.hitboxModes.get(Custom).double;
			if (ClientPrefs.data.extraKeys == 3 && MobileData.hitboxModes.get(Custom).triple != null)
				currentHint = MobileData.hitboxModes.get(Custom).triple;
			if (ClientPrefs.data.extraKeys == 4 && MobileData.hitboxModes.get(Custom).quad != null)
				currentHint = MobileData.hitboxModes.get(Custom).quad;
			if (ClientPrefs.data.extraKeys != 0 && MobileData.hitboxModes.get(Custom).test != null)
				currentHint = MobileData.hitboxModes.get(Custom).test;

			for (buttonData in currentHint)
			{
				var buttonX:Float = 0;
				var buttonY:Float = 0;
				var buttonXString:String = null;
				var buttonYString:String = null;
				if (buttonData.x is String) buttonXString = buttonData.x;
				else buttonX = buttonData.x;
				if (buttonData.y is String) buttonYString = buttonData.y;
				else buttonY = buttonData.y;

				var buttonWidth:Int = 0;
				var buttonHeight:Int = 0;
				var buttonWidthString:String = null;
				var buttonHeightString:String = null;
				if (buttonData.width is String) buttonWidthString = buttonData.width;
				else buttonWidth = buttonData.width;
				if (buttonData.height is String) buttonHeightString = buttonData.height;
				else buttonHeight = buttonData.height;

				var buttonColor = buttonData.color;
				var customReturn = buttonData.returnKey;
				var location = ClientPrefs.data.hitboxLocation;
				var addButton:Bool = false;

				switch (location) {
					case 'Top':
						//Position
						if (buttonData.topX != null && buttonData.topX is String) buttonXString = buttonData.topX;
						else if (buttonData.topX != null) buttonX = buttonData.topX;
						if (buttonData.topY != null && buttonData.topY is String) buttonYString = buttonData.topY;
						else if (buttonData.topY != null) buttonY = buttonData.topY;

						//Size
						if (buttonData.topWidth != null && buttonData.topWidth is String) buttonWidthString = buttonData.topWidth;
						else if (buttonData.topWidth != null) buttonWidth = buttonData.topWidth;
						if (buttonData.topHeight != null && buttonData.topHeight is String) buttonHeightString = buttonData.topHeight;
						else if (buttonData.topWidth != null) buttonHeight = buttonData.topHeight;

						if (buttonData.topColor != null) buttonColor = buttonData.topColor;
						if (buttonData.topReturnKey != null) customReturn = buttonData.topReturnKey;
					case 'Middle':
						if (buttonData.middleX != null && buttonData.middleX is String) buttonXString = buttonData.middleX;
						else if (buttonData.middleX != null) buttonX = buttonData.middleX;
						if (buttonData.middleY != null && buttonData.middleY is String) buttonYString = buttonData.middleY;
						else if (buttonData.middleY != null) buttonY = buttonData.middleY;

						//Size
						if (buttonData.middleWidth != null && buttonData.middleWidth is String) buttonWidthString = buttonData.middleWidth;
						else if (buttonData.middleWidth != null) buttonWidth = buttonData.middleWidth;
						if (buttonData.middleHeight != null && buttonData.middleHeight is String) buttonHeightString = buttonData.middleHeight;
						else if (buttonData.middleHeight != null) buttonHeight = buttonData.middleHeight;

						if (buttonData.middleColor != null) buttonColor = buttonData.middleColor;
						if (buttonData.middleReturnKey != null) customReturn = buttonData.middleReturnKey;
					case 'Bottom':
						if (buttonData.bottomX != null && buttonData.bottomX is String) buttonXString = buttonData.bottomX;
						else if (buttonData.bottomX != null) buttonX = buttonData.bottomX;
						if (buttonData.bottomY != null && buttonData.bottomY is String) buttonYString = buttonData.bottomY;
						else if (buttonData.bottomY != null) buttonY = buttonData.bottomY;

						//Size
						if (buttonData.bottomWidth != null && buttonData.bottomWidth is String) buttonWidthString = buttonData.bottomWidth;
						else if (buttonData.bottomWidth != null) buttonWidth = buttonData.bottomWidth;
						if (buttonData.bottomHeight != null && buttonData.bottomHeight is String) buttonHeightString = buttonData.bottomHeight;
						else if (buttonData.bottomWidth != null) buttonHeight = buttonData.bottomHeight;

						if (buttonData.bottomColor != null) buttonColor = buttonData.bottomColor;
						if (buttonData.bottomReturnKey != null) customReturn = buttonData.bottomReturnKey;
				}
				//A little optimization for customReturns, also better than old messy code
				for (i in 1...9) {
					var button = Reflect.getProperty(ClientPrefs.data, 'extraKeyReturn${i}');
					if (customReturn == null && buttonData.button == 'buttonExtra${i}') customReturn = button.toUpperCase();
				}

				if (ClientPrefs.data.extraKeys == 0 && buttonData.extraKeyMode == 0 ||
				   ClientPrefs.data.extraKeys == 1 && buttonData.extraKeyMode == 1 ||
				   ClientPrefs.data.extraKeys == 2 && buttonData.extraKeyMode == 2 ||
				   ClientPrefs.data.extraKeys == 3 && buttonData.extraKeyMode == 3 ||
				   ClientPrefs.data.extraKeys == 4 && buttonData.extraKeyMode == 4)
				{
					addButton = true;
				}
				else if(buttonData.extraKeyMode == null)
					addButton = true;

				if (addButton) {
					Reflect.setField(this, buttonData.button,
						createHint(buttonX, buttonY, buttonWidth, buttonHeight, CoolUtil.colorFromString(buttonColor), customReturn, buttonData.button));
					add(Reflect.field(this, buttonData.button));
				}
			}
		}
		for (button in Reflect.fields(this))
		{
			if (Std.isOfType(Reflect.field(this, button), MobileButton))
				Reflect.setProperty(Reflect.getProperty(this, button), 'IDs', storedButtonsIDs.get(button));
		}

		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	/**
	 * Clean up memory.
	 */
	override function destroy():Void
	{
		super.destroy();
		onButtonUp.destroy();
		onButtonDown.destroy();

		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), MobileButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}

	private function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF):BitmapData
	{
		var guh:Float = ClientPrefs.data.hitboxalpha;
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		switch (ClientPrefs.data.hitboxtype) {
			case "No Gradient":
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(Width, Height, 0, 0, 0);
				shape.graphics.beginGradientFill(RADIAL, [Color, Color], [0, guh], [60, 255], matrix, PAD, RGB, 0);
				shape.graphics.drawRect(0, 0, Width, Height);
				shape.graphics.endFill();
			case "No Gradient (Old)":
				shape.graphics.lineStyle(10, Color, 1);
				shape.graphics.drawRect(0, 0, Width, Height);
				shape.graphics.endFill();
			case "Gradient":
				shape.graphics.lineStyle(3, Color, 1);
				shape.graphics.drawRect(0, 0, Width, Height);
				shape.graphics.lineStyle(0, 0, 0);
				shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
				shape.graphics.endFill();
				shape.graphics.beginGradientFill(RADIAL, [Color, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
				shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
				shape.graphics.endFill();
		}

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?customReturn:String, ?mapKey:String):MobileButton
	{
		var hint:MobileButton = new MobileButton(X, Y);
		hint.loadGraphic(createHintGraphic(Width, Height, Color));

		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.onDown.callback = function()
		{
			onButtonDown.dispatch(hint, storedButtonsIDs.get(mapKey));
			if (hint.alpha != ClientPrefs.data.hitboxalpha)
				hint.alpha = ClientPrefs.data.hitboxalpha;
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			onButtonUp.dispatch(hint, storedButtonsIDs.get(mapKey));
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		if (customReturn != null) hint.returnedButton = customReturn;
		return hint;
	}
}

class HitboxOld extends GlobalHitbox {
	public var buttonLeft:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_LEFT, MobileInputID.NOTE_LEFT]);
	public var buttonDown:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_DOWN, MobileInputID.NOTE_DOWN]);
	public var buttonUp:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_UP, MobileInputID.NOTE_UP]);
	public var buttonRight:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_RIGHT, MobileInputID.NOTE_RIGHT]);
	public var buttonExtra1:MobileButton = new MobileButton(0, 0);
	public var buttonExtra2:MobileButton = new MobileButton(0, 0);

	public var instance:MobileInputManager;

	var storedButtonsIDs:Map<String, Array<MobileInputID>> = new Map<String, Array<MobileInputID>>();

	public function new() {
		instance = this;
		super();

		if (ClientPrefs.data.extraKeys == 0){
			add(buttonLeft = createhitbox(0, 0, "left", "mobile/Hitbox/hitbox", null, "buttonLeft"));
			add(buttonDown = createhitbox(320, 0, "down", "mobile/Hitbox/hitbox", null, "buttonDown"));
			add(buttonUp = createhitbox(640, 0, "up", "mobile/Hitbox/hitbox", null, "buttonUp"));
			add(buttonRight = createhitbox(960, 0, "right", "mobile/Hitbox/hitbox", null, "buttonRight"));
		}else{
			if (ClientPrefs.data.hitboxLocation == 'Bottom') {
				switch (ClientPrefs.data.extraKeys) {
					case 2:
						add(buttonLeft = createhitbox(0, 0, "left", "mobile/Hitbox/hitboxBottom-2", null, "buttonLeft"));
						add(buttonDown = createhitbox(320, 0, "down", "mobile/Hitbox/hitboxBottom-2", null, "buttonDown"));
						add(buttonUp = createhitbox(640, 0, "up", "mobile/Hitbox/hitboxBottom-2", null, "buttonUp"));
						add(buttonRight = createhitbox(960, 0, "right", "mobile/Hitbox/hitboxBottom-2", null, "buttonRight"));
						add(buttonExtra1 = createhitbox(0, 580, "extra1", "mobile/Hitbox/hitboxBottom-2", ClientPrefs.data.extraKeyReturn1.toUpperCase()));
						add(buttonExtra2 = createhitbox(640, 580, "extra2", "mobile/Hitbox/hitboxBottom-2", ClientPrefs.data.extraKeyReturn2.toUpperCase()));
				}
			}
			else if (ClientPrefs.data.hitboxLocation == 'Top') {
				switch (ClientPrefs.data.extraKeys) {
					case 2:
						add(buttonLeft = createhitbox(0, 144, "left", "mobile/Hitbox/hitboxBottom-2", null, "buttonLeft"));
						add(buttonDown = createhitbox(320, 144, "down", "mobile/Hitbox/hitboxBottom-2", null, "buttonDown"));
						add(buttonUp = createhitbox(640, 144, "up", "mobile/Hitbox/hitboxBottom-2", null, "buttonUp"));
						add(buttonRight = createhitbox(960, 144, "right", "mobile/Hitbox/hitboxBottom-2", null, "buttonRight"));
						add(buttonExtra1 = createhitbox(0, 0, "extra1", "mobile/Hitbox/hitboxBottom-2", ClientPrefs.data.extraKeyReturn1.toUpperCase(), "buttonExtra1"));
						add(buttonExtra2 = createhitbox(640, 0, "extra2", "mobile/Hitbox/hitboxBottom-2", ClientPrefs.data.extraKeyReturn2.toUpperCase(), "buttonExtra2"));
				}
			}
		}

		/*
		var hitbox_hint:FlxSprite = new FlxSprite(0, (ClientPrefs.data.hitboxLocation == 'Bottom' && ClientPrefs.data.extraKeys != 0) ? -150 : 0).loadGraphic(Paths.image('mobile/Hitbox/hitbox_hint'));
		hitbox_hint.antialiasing = ClientPrefs.data.antialiasing;
		hitbox_hint.alpha = 0.75;
		add(hitbox_hint);
		*/
	}

	public function createhitbox(x:Float = 0, y:Float = 0, frames:String, ?texture:String, ?customReturn:String, ?mapKey:String) {
		var button = new MobileButton(x, y);
		button.loadGraphic(FlxGraphic.fromFrame(getFrames(texture).getByName(frames)));
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.alpha = 0.00001;
		button.onDown.callback = function()
		{
			onButtonDown.dispatch(button, storedButtonsIDs.get(mapKey));
			if (button.alpha != 0.75)
				button.alpha = 0.75;
		}
		button.onOut.callback = button.onUp.callback = function()
		{
			onButtonUp.dispatch(button, storedButtonsIDs.get(mapKey));
			if (button.alpha != 0.00001)
				button.alpha = 0.00001;
		}
		if (customReturn != null) button.returnedButton = customReturn;
		return button;
	}

	public function getFrames(?texture:String = 'mobile/Hitbox/hitbox'):FlxAtlasFrames {
		return getSparrowAtlas(texture);
	}

	inline static public function getSparrowAtlas(key:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
	{
		#if MODS_ALLOWED
		var imageLoaded:FlxGraphic = Paths.image(key, allowGPU, true);
		var xmlExists:Bool = false;

		var xml:String = Paths.modFolders(key + '.xml');
		if(FileSystem.exists(xml)) {
			xmlExists = true;
		}

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : Paths.image(key, library, allowGPU, true)), (xmlExists ? File.getContent(xml) : Paths.getPath('$key.xml', library)));
		#else
		return FlxAtlasFrames.fromSparrow(Paths.image(key, library, allowGPU, true), Paths.getPath('$key.xml', library));
		#end
	}

	override public function destroy():Void {
		super.destroy();
		onButtonUp.destroy();
		onButtonDown.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
	}
}
