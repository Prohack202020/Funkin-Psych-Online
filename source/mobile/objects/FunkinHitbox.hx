package mobile.objects;

import mobile.Hitbox as OGHitbox;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;
import flixel.util.FlxColor;
import objects.Note;

class FunkinHitbox extends OGHitbox {
	public function new(?mode:String, ?globalAlpha:Float = 0.7):Void
	{
		super(mode, globalAlpha, true); //true means basically-mobilecontrols's hitbox creation is disabled
		if ((ClientPrefs.data.hitboxmode == 'V Slice' && mode == null) || mode == 'V Slice')
		{
			var mania = Note.maniaKeys;
			if (mania == 4) {
				addHint('"buttonNote1', ["NOTE_LEFT = 0"], 0, 0, 140, Std.int(FlxG.height), 0xFFC24B99);
				addHint('"buttonNote2', ["NOTE_DOWN = 1"], 0, 0, 140, Std.int(FlxG.height), 0xFF00FFFF);
				addHint('"buttonNote3', ["NOTE_UP = 2"], 0, 0, 140, Std.int(FlxG.height), 0xFF12FA05);
				addHint('"buttonNote4', ["NOTE_RIGHT = 3"], 0, 0, 140, Std.int(FlxG.height), 0xFFF9393F);
			} else {
				if (mania >= 1) addHint('"buttonNote1', ["NOTE_1 = 0", "${mania}K_NOTE_1 = 0"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 2) addHint('"buttonNote2', ["NOTE_2 = 1", "${mania}K_NOTE_2 = 1"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 3) addHint('"buttonNote3', ["NOTE_3 = 2", "${mania}K_NOTE_3 = 2"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 4) addHint('"buttonNote4', ["NOTE_4 = 3", "${mania}K_NOTE_4 = 3"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 5) addHint('"buttonNote5', ["NOTE_5 = 4", "${mania}K_NOTE_5 = 4"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 6) addHint('"buttonNote6', ["NOTE_6 = 5", "${mania}K_NOTE_6 = 5"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 7) addHint('"buttonNote7', ["NOTE_7 = 6", "${mania}K_NOTE_7 = 6"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 8) addHint('"buttonNote8', ["NOTE_8 = 7", "${mania}K_NOTE_8 = 7"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
				if (mania >= 9) addHint('"buttonNote9', ["NOTE_9 = 8", "${mania}K_NOTE_9 = 8"], 0, 0, 110, Std.int(FlxG.height), 0xFFFFFFFF);
			}
		}
		else
		{
			var Custom:String = mode != null ? mode : ClientPrefs.data.hitboxmode;
			if (!MobileConfig.hitboxModes.exists(Custom))
				throw 'The Custom Hitbox File doesn\'t exists.';

			var currentHint = MobileConfig.hitboxModes.get(Custom).hints;
			if (MobileConfig.hitboxModes.get(Custom).none != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).none;
			if (ClientPrefs.data.extraKeys == 1 && MobileConfig.hitboxModes.get(Custom).single != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).single;
			if (ClientPrefs.data.extraKeys == 2 && MobileConfig.hitboxModes.get(Custom).double != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).double;
			if (ClientPrefs.data.extraKeys == 3 && MobileConfig.hitboxModes.get(Custom).triple != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).triple;
			if (ClientPrefs.data.extraKeys == 4 && MobileConfig.hitboxModes.get(Custom).quad != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).quad;
			if (ClientPrefs.data.extraKeys != 0 && MobileConfig.hitboxModes.get(Custom).hints != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).hints;

			//Extra Key Stuff
			if (Note.maniaKeys == 1 && MobileConfig.hitboxModes.get(Custom).mania1 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania1;
			if (Note.maniaKeys == 2 && MobileConfig.hitboxModes.get(Custom).mania2 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania2;
			if (Note.maniaKeys == 3 && MobileConfig.hitboxModes.get(Custom).mania3 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania3;
			if (Note.maniaKeys == 4 && MobileConfig.hitboxModes.get(Custom).mania4 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania4;
			if (Note.maniaKeys == 5 && MobileConfig.hitboxModes.get(Custom).mania5 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania5;
			if (Note.maniaKeys == 6 && MobileConfig.hitboxModes.get(Custom).mania6 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania6;
			if (Note.maniaKeys == 7 && MobileConfig.hitboxModes.get(Custom).mania7 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania7;
			if (Note.maniaKeys == 8 && MobileConfig.hitboxModes.get(Custom).mania8 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania8;
			if (Note.maniaKeys == 9 && MobileConfig.hitboxModes.get(Custom).mania9 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania9;
			if (Note.maniaKeys == 20 && MobileConfig.hitboxModes.get(Custom).mania20 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania20;
			if (Note.maniaKeys == 55 && MobileConfig.hitboxModes.get(Custom).mania55 != null)
				currentHint = MobileConfig.hitboxModes.get(Custom).mania55;

			for (buttonData in currentHint)
			{
				var buttonX:Float = buttonData.x;
				var buttonY:Float = buttonData.y;
				var buttonWidth:Int = buttonData.width;
				var buttonHeight:Int = buttonData.height;
				var buttonColor = buttonData.color;
				var buttonReturn = buttonData.returnKey;
				var location = ClientPrefs.data.hitboxLocation;
				var addButton:Bool = false;

				switch (location) {
					case 'Top':
						if (buttonData.topX != null) buttonX = buttonData.topX;
						if (buttonData.topY != null) buttonY = buttonData.topY;
						if (buttonData.topWidth != null) buttonWidth = buttonData.topWidth;
						if (buttonData.topHeight != null) buttonHeight = buttonData.topHeight;
						if (buttonData.topColor != null) buttonColor = buttonData.topColor;
						if (buttonData.topReturnKey != null) buttonReturn = buttonData.topReturnKey;
					case 'Middle':
						if (buttonData.middleX != null) buttonX = buttonData.middleX;
						if (buttonData.middleY != null) buttonY = buttonData.middleY;
						if (buttonData.middleWidth != null) buttonWidth = buttonData.middleWidth;
						if (buttonData.middleHeight != null) buttonHeight = buttonData.middleHeight;
						if (buttonData.middleColor != null) buttonColor = buttonData.middleColor;
						if (buttonData.middleReturnKey != null) buttonReturn = buttonData.middleReturnKey;
					case 'Bottom':
						if (buttonData.bottomX != null) buttonX = buttonData.bottomX;
						if (buttonData.bottomY != null) buttonY = buttonData.bottomY;
						if (buttonData.bottomWidth != null) buttonWidth = buttonData.bottomWidth;
						if (buttonData.bottomHeight != null) buttonHeight = buttonData.bottomHeight;
						if (buttonData.bottomColor != null) buttonColor = buttonData.bottomColor;
						if (buttonData.bottomReturnKey != null) buttonReturn = buttonData.bottomReturnKey;
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

				for (i in 1...9) {
					var buttonString = 'buttonExtra${i}';
					if (buttonData.button == buttonString && buttonReturn == null)
						buttonReturn = Reflect.getProperty(ClientPrefs.data, 'extraKeyReturn${i}');
				}
				if (addButton)
					addHint(buttonData.button, buttonData.buttonIDs, buttonX, buttonY, buttonWidth, buttonHeight, Util.colorFromString(buttonColor), buttonReturn);
			}
		}

		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	override function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?isLane:Bool = false):BitmapData
	{
		var guh:Float = globalAlpha;
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

	override public function createHint(Name:Array<String>, X:Float, Y:Float, Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?Return:String, ?Map:String):MobileButton
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
		hint.IDs = Name;
		hint.onDown.callback = function()
		{
			onButtonDown.dispatch(hint, Name);
			if (hint.alpha != globalAlpha)
				hint.alpha = globalAlpha;
			if ((hint.hintUp?.alpha != 0.00001 || hint.hintDown?.alpha != 0.00001) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = 0.00001;
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			onButtonUp.dispatch(hint, Name);
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
			if ((hint.hintUp?.alpha != globalAlpha || hint.hintDown?.alpha != globalAlpha) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = globalAlpha;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		if (Return != null) hint.returnedKey = Return;
		return hint;
	}
}