package mobile.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * A simple macro for mobile controls.
 *
 * @author KralOyuncu 2010x (ArkoseLabs)
 */
class ButtonMacro {
	public static macro function createExtraButtons(extraButtons:Int):Array<Field> {
		var fields = Context.getBuildFields();

		for (i in 1...extraButtons + 1) {
			var buttonName = 'buttonExtra$i';
			var buttonID = 'EXTRA_$i';
			var buttonType = macro :MobileButton;
			var buttonExpr = macro new MobileButton(0, 0, [MobileInputID.$buttonID]);

			fields.push({
				name: buttonName,
				access: [APublic],
				kind: FVar(buttonType, buttonExpr),
				pos: Context.currentPos()
			});
		}

		return fields;
	}

	public static macro function createManiaButtons(startButton:Int, maniaButtons:Int):Array<Field> {
		var fields = Context.getBuildFields();

		for (i in startButton...maniaButtons + 1) {
			var buttonName = 'buttonExtra$i';
			var buttonID = 'NOTE_$i';
			var buttonHitboxID = 'HITBOX_NOTE_$i';
			var buttonType = macro :MobileButton;
			var buttonExpr = macro new MobileButton(0, 0, [MobileInputID.$buttonHitboxID, MobileInputID.$buttonID]);

			fields.push({
				name: buttonName,
				access: [APublic],
				kind: FVar(buttonType, buttonExpr),
				pos: Context.currentPos()
			});
		}

		return fields;
	}

	public static macro function createButtons(letters:Array<String>):Array<Field> {
		var fields = Context.getBuildFields();
		var typePath:ComplexType = TPath({ pack: [], name: "MobileButton" });

		for (letter in letters) {
			var varName = "button" + letter.toUpperCase();
			var upperLatter = letter.toUpperCase();
			fields.push({
				name: varName,
				access: [APublic],
				kind: FVar(
					typePath,
					macro new MobileButton(0, 0, [MobileInputID.$upperLatter])
				),
				pos: Context.currentPos()
			});
		}
		
		return fields;
	}

	public static macro function createExtraButtonIDs(extraButtons:Int, startFromValue:Int):Array<Field> {
		var fields = Context.getBuildFields();
		var currentValue = startFromValue;

		for (i in 1...extraButtons + 1) {
			var buttonName = 'EXTRA_$i';
			var buttonExpr = macro $v{currentValue};

			fields.push({
				name: buttonName,
				access: [APublic],
				kind: FVar(null, buttonExpr),
				pos: Context.currentPos()
			});
			currentValue++;
		}

		return fields;
	}
}
#end