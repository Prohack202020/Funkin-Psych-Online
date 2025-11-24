package mobile.objects;

import objects.Note;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;

/**
 * A zone with 19 hint's (A hitbox).
 * It's really easy to customize the layout.
 *
 * @author Mihai Alexandru (M.A. Jigsaw), KralOyuncu 2010x (ArkoseLabs)
 */

@:build(mobile.macros.ButtonMacro.createExtraButtons(60)) //I think 10 is enough
class Hitbox extends MobileInputManager
{
	public var buttonLeft:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_1, MobileInputID.NOTE_1]);
	public var buttonDown:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_2, MobileInputID.NOTE_2]);
	public var buttonUp:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_3, MobileInputID.NOTE_3]);
	public var buttonRight:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_4, MobileInputID.NOTE_4]);
	public var buttonNote5:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_5, MobileInputID.NOTE_5]);
	public var buttonNote6:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_6, MobileInputID.NOTE_6]);
	public var buttonNote7:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_7, MobileInputID.NOTE_7]);
	public var buttonNote8:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_8, MobileInputID.NOTE_8]);
	public var buttonNote9:MobileButton = new MobileButton(0, 0, [MobileInputID.HITBOX_NOTE_9, MobileInputID.NOTE_9]);
	public var extraKey1 = ClientPrefs.data.extraKeyReturn1.toUpperCase();
	public var extraKey2 = ClientPrefs.data.extraKeyReturn2.toUpperCase();
	public var extraKey3 = ClientPrefs.data.extraKeyReturn3.toUpperCase();
	public var extraKey4 = ClientPrefs.data.extraKeyReturn4.toUpperCase();

	public var onButtonDown:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void> = new FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>();
	public var onButtonUp:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void> = new FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>();
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

		if ((ClientPrefs.data.hitboxmode == 'V Slice' && CustomMode == null) || CustomMode == 'V Slice'){
			if (Note.maniaKeys == 4) {
				add(buttonLeft = createHint(0, 0, 140, Std.int(FlxG.height * 1), 0xFFC24B99, null, 'buttonLeft'));
				add(buttonDown = createHint(0, 0, 140, Std.int(FlxG.height * 1), 0xFF00FFFF, null, 'buttonDown'));
				add(buttonUp = createHint(0, 0, 140, Std.int(FlxG.height * 1), 0xFF12FA05, null, 'buttonUp'));
				add(buttonRight = createHint(0, 0, 140, Std.int(FlxG.height * 1), 0xFFF9393F, null, 'buttonRight'));
			} else {
				if (Note.maniaKeys >= 1) add(buttonLeft = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonLeft'));
				if (Note.maniaKeys >= 2) add(buttonDown = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonDown'));
				if (Note.maniaKeys >= 3) add(buttonUp = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonUp'));
				if (Note.maniaKeys >= 4) add(buttonRight = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonRight'));
				if (Note.maniaKeys >= 5) add(buttonNote5 = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonNote5'));
				if (Note.maniaKeys >= 6) add(buttonNote6 = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonNote6'));
				if (Note.maniaKeys >= 7) add(buttonNote7 = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonNote7'));
				if (Note.maniaKeys >= 8) add(buttonNote8 = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonNote8'));
				if (Note.maniaKeys >= 9) add(buttonNote9 = createHint(0, 0, 110, Std.int(FlxG.height * 1), 0xFFFFFFFF, null, 'buttonNote9'));
			}
		}
		else if ((ClientPrefs.data.hitboxmode != 'Classic' && CustomMode == null) || CustomMode != null){
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

			//Extra Key Stuff
			if (Note.maniaKeys == 1 && MobileData.hitboxModes.get(Custom).mania1 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania1;
			if (Note.maniaKeys == 2 && MobileData.hitboxModes.get(Custom).mania2 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania2;
			if (Note.maniaKeys == 3 && MobileData.hitboxModes.get(Custom).mania3 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania3;
			if (Note.maniaKeys == 4 && MobileData.hitboxModes.get(Custom).mania4 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania4;
			if (Note.maniaKeys == 5 && MobileData.hitboxModes.get(Custom).mania5 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania5;
			if (Note.maniaKeys == 6 && MobileData.hitboxModes.get(Custom).mania6 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania6;
			if (Note.maniaKeys == 7 && MobileData.hitboxModes.get(Custom).mania7 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania7;
			if (Note.maniaKeys == 8 && MobileData.hitboxModes.get(Custom).mania8 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania8;
			if (Note.maniaKeys == 9 && MobileData.hitboxModes.get(Custom).mania9 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania9;
			if (Note.maniaKeys == 20 && MobileData.hitboxModes.get(Custom).mania20 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania20;
			if (Note.maniaKeys == 55 && MobileData.hitboxModes.get(Custom).mania55 != null)
				currentHint = MobileData.hitboxModes.get(Custom).mania55;

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

				//If buttons doesn't have a customReturn, set it from ClientPrefs
				for (i in 1...10) {
					var buttonString = 'buttonExtra${i}';
					if (buttonData.button == buttonString && customReturn == null)
						customReturn = Reflect.getProperty(ClientPrefs.data, 'extraKeyReturn${i}');
				}

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

	private function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?isLane:Bool = false):BitmapData
	{
		var guh:Float = ClientPrefs.data.hitboxalpha;
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		switch (ClientPrefs.data.hitboxtype) {
			case "No Gradient":
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(Width, Height, 0, 0, 0);
				if (isLane)
					shape.graphics.beginFill(Color);
				else
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
				if (isLane)
					shape.graphics.beginFill(Color);
				else
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

		if (ClientPrefs.data.hitboxhint && !ClientPrefs.data.VSliceControl) {
			var doHeightFix:Bool = false;
			if (Height == 144) doHeightFix = true;

			//Up Hint
			hint.hintUp = new FlxSprite();
			hint.hintUp.loadGraphic(createHintGraphic(Width, Math.floor(Height * (doHeightFix ? 0.060 : 0.020)), Color, true));
			hint.hintUp.x = X;
			hint.hintUp.y = hint.y;

			//Down Hint
			hint.hintDown = new FlxSprite();
			hint.hintDown.loadGraphic(createHintGraphic(Width, Math.floor(Height * (doHeightFix ? 0.060 : 0.020)), Color, true));
			hint.hintDown.x = X;
			hint.hintDown.y = hint.y + hint.height / (doHeightFix ? 1.060 : 1.020);
		}

		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.onDown.callback = function()
		{
			onButtonDown.dispatch(hint, storedButtonsIDs.get(mapKey));
			if (hint.alpha != ClientPrefs.data.hitboxalpha)
				hint.alpha = ClientPrefs.data.hitboxalpha;
			if ((hint.hintUp?.alpha != 0.00001 || hint.hintDown?.alpha != 0.00001) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = 0.00001;
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			onButtonUp.dispatch(hint, storedButtonsIDs.get(mapKey));
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
			if ((hint.hintUp?.alpha != ClientPrefs.data.hitboxalpha || hint.hintDown?.alpha != ClientPrefs.data.hitboxalpha) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = ClientPrefs.data.hitboxalpha;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		if (customReturn != null) hint.returnedButton = customReturn;
		return hint;
	}
}