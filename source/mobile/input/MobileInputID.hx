package mobile.input;

import flixel.system.macros.FlxMacroUtil;
import objects.Note;

/**
 * A high-level list of unique values for mobile input buttons.
 * Maps enum values and strings to unique integer codes
 * @author Karim Akra
 */
@:runtimeValue
@:build(mobile.macros.ButtonMacro.createExtraButtonIDs(60, 53))
enum abstract MobileInputID(Int) from Int to Int {
	public static var fromStringMap(default, null):Map<String, MobileInputID> = FlxMacroUtil.buildMap("mobile.input.MobileInputID");
	public static var toStringMap(default, null):Map<MobileInputID, String> = FlxMacroUtil.buildMap("mobile.input.MobileInputID", true);
	// Nothing & Anything
	var ANY = -2;
	var NONE = -1;
	// Notes
	var NOTE_1 = 0;
	var NOTE_2 = 1;
	var NOTE_3 = 2;
	var NOTE_4 = 3;
	var NOTE_5 = 4;
	var NOTE_6 = 5;
	var NOTE_7 = 6;
	var NOTE_8 = 7;
	var NOTE_9 = 8;
	// Mobile Pad Buttons
	var A = 9;
	var B = 10;
	var C = 11;
	var D = 12;
	var E = 13;
	var F = 14;
	var G = 15;
	var H = 16;
	var I = 17;
	var J = 18;
	var K = 19;
	var L = 20;
	var M = 21;
	var N = 22;
	var O = 23;
	var P = 24;
	var Q = 25;
	var R = 26;
	var S = 27;
	var T = 28;
	var U = 29;
	var V = 30;
	var W = 31;
	var X = 32;
	var Y = 33;
	var Z = 34;
	// Mobile Pad Directional Buttons
	var UP = 35;
	var UP2 = 36;
	var DOWN = 37;
	var DOWN2 = 38;
	var LEFT = 39;
	var LEFT2 = 40;
	var RIGHT = 41;
	var RIGHT2 = 42;
	// Hitbox Hints (Not Needed, removing them doesn't change anything on my port)
	var HITBOX_NOTE_1 = 43;
	var HITBOX_NOTE_2 = 44;
	var HITBOX_NOTE_3 = 45;
	var HITBOX_NOTE_4 = 46;
	var HITBOX_NOTE_5 = 47;
	var HITBOX_NOTE_6 = 48;
	var HITBOX_NOTE_7 = 49;
	var HITBOX_NOTE_8 = 50;
	var HITBOX_NOTE_9 = 51;
	var TAUNT = 52;

	@:from
	public static inline function fromString(s:String) {
		s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
	}

	@:to
	public inline function toString():String {
		var stringShit:String = toStringMap.get(this);
		var keys = Note.maniaKeys;
		if (keys == 4) {
			switch (stringShit) {
				case 'NOTE_1': stringShit = 'NOTE_LEFT';
				case 'NOTE_2': stringShit = 'NOTE_DOWN';
				case 'NOTE_3': stringShit = 'NOTE_UP';
				case 'NOTE_4': stringShit = 'NOTE_RIGHT';
			}
		}
		else {
			if (stringShit.startsWith("EXTRA_")) {
				var fixedStringShit:String = stringShit;
				var countFix:Int = Std.parseInt(fixedStringShit.split("EXTRA_")[1]);
				fixedStringShit = fixedStringShit.replace('EXTRA_', 'NOTE_');

				if (countFix > 9 && countFix <= keys)
					stringShit = '${keys}K_' + fixedStringShit;
			} else if (stringShit.startsWith("NOTE_")) {
				var countFix:Int = Std.parseInt(stringShit.split("NOTE_")[1]);
				if (countFix <= keys)
					stringShit = '${keys}K_' + stringShit;
			}
		}

		return stringShit;
	}
}