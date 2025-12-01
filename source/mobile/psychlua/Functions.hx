package mobile.psychlua;

import lime.ui.Haptic;
import flixel.util.FlxSave;
import mobile.TouchUtil;
import psychlua.CustomSubstate;
import psychlua.FunkinLua;

class MobileFunctions
{
	public static function implement(funk:FunkinLua)
	{
		#if LUA_ALLOWED
		var lua:State = funk.lua;

		//Use them for 8k charts or something
		Lua_helper.add_callback(lua, 'hitboxPressed', function(button:String):Bool
		{
			return PlayState.checkHBoxPress(button, 'pressed');
		});

		Lua_helper.add_callback(lua, 'hitboxJustPressed', function(button:String):Bool
		{
			return PlayState.checkHBoxPress(button, 'justPressed');
		});

		Lua_helper.add_callback(lua, 'hitboxReleased', function(button:String):Bool
		{
			return PlayState.checkHBoxPress(button, 'released');
		});

		Lua_helper.add_callback(lua, 'hitboxJustReleased', function(button:String):Bool
		{
			return PlayState.checkHBoxPress(button, 'justReleased');
		});

		//OMG
		Lua_helper.add_callback(lua, 'mobilePadPressed', function(button:String):Bool
		{
			return PlayState.checkMPadPress(button, 'pressed');
		});

		Lua_helper.add_callback(lua, 'mobilePadJustPressed', function(button:String):Bool
		{
			return PlayState.checkMPadPress(button, 'justPressed');
		});

		Lua_helper.add_callback(lua, 'mobilePadReleased', function(button:String):Bool
		{
			return PlayState.checkMPadPress(button, 'released');
		});

		Lua_helper.add_callback(lua, 'mobilePadJustReleased', function(button:String):Bool
		{
			return PlayState.checkMPadPress(button, 'justReleased');
		});

		Lua_helper.add_callback(lua, 'addMobilePad', function(DPad:String, Action:String, ?addToCustomSubstate:Bool = false, ?posAtCustomSubstate:Int = -1):Void
		{
			PlayState.instance.makeLuaMobilePad(DPad, Action);
			if (addToCustomSubstate)
			{
				if (PlayState.instance.luaMobilePad != null || !PlayState.instance.members.contains(PlayState.instance.luaMobilePad))
					CustomSubstate.insertLuaMpad(posAtCustomSubstate);
			}
			else
				PlayState.instance.addLuaMobilePad();
		});

		Lua_helper.add_callback(lua, 'addMobilePadCamera', function():Void
		{
			PlayState.instance.addLuaMobilePadCamera();
		});

		Lua_helper.add_callback(lua, 'removeMobilePad', function():Void
		{
			PlayState.instance.removeLuaMobilePad();
		});

		Lua_helper.add_callback(lua, "MobileC", function(enabled:Bool = false):Void
		{
			MusicBeatState.getState().hitbox.visible = enabled;
		});

		//better support
		Lua_helper.add_callback(lua, "changeMobileControls", function(?mode:String):Void
		{
			if (mode == null && mode == '') mode = "NONE";
			PlayState.instance.reloadControls(mode);
		});

		Lua_helper.add_callback(lua, "setMobileControlPosition", function(?x:Float, ?y:Float):Void
		{
			if (MusicBeatState.getState().hitbox != null) {
				if (x != null) MusicBeatState.getState().hitbox.x = x;
				if (y != null) MusicBeatState.getState().hitbox.y = y;
			}
		});

		Lua_helper.add_callback(lua, "reloadMobileControls", function():Void
		{
			PlayState.instance.reloadControls();
		});

		Lua_helper.add_callback(lua, "addMobileControls", function(?mode:String):Void
		{
			PlayState.instance.addControls(mode);
		});

		Lua_helper.add_callback(lua, "removeMobileControls", function():Void
		{
			PlayState.instance.removeControls();
		});
		#end

		#if mobile
		Lua_helper.add_callback(lua, "vibrate", function(duration:Null<Int>, ?period:Null<Int>)
		{
			if (period == null)
				period = 0;
			if (duration == null)
				return funk.luaTrace('vibrate: No duration specified.');
			return Haptic.vibrate(period, duration);
		});

		Lua_helper.add_callback(lua, "touchJustPressed", TouchUtil.justPressed);
		Lua_helper.add_callback(lua, "touchPressed", TouchUtil.pressed);
		Lua_helper.add_callback(lua, "touchJustReleased", TouchUtil.justReleased);
		Lua_helper.add_callback(lua, "touchPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				funk.luaTrace('touchPressedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj) && TouchUtil.pressed;
		});

		Lua_helper.add_callback(lua, "touchJustPressedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				funk.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj) && TouchUtil.justPressed;
		});

		Lua_helper.add_callback(lua, "touchJustReleasedObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				funk.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj) && TouchUtil.justReleased;
		});

		Lua_helper.add_callback(lua, "touchOverlapsObject", function(object:String):Bool
		{
			var obj = PlayState.instance.getLuaObject(object);
			if (obj == null)
			{
				funk.luaTrace('touchOverlapsObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj);
		});
		#end
	}
}

#if android
class AndroidFunctions
{
	public static function implement(funk:FunkinLua)
	{
		#if LUA_ALLOWED
		var lua:State = funk.lua;

		Lua_helper.add_callback(lua, "isDolbyAtmos", AndroidTools.isDolbyAtmos());
		Lua_helper.add_callback(lua, "isAndroidTV", AndroidTools.isAndroidTV());
		Lua_helper.add_callback(lua, "isTablet", AndroidTools.isTablet());
		Lua_helper.add_callback(lua, "isChromebook", AndroidTools.isChromebook());
		Lua_helper.add_callback(lua, "isDeXMode", AndroidTools.isDeXMode());
		Lua_helper.add_callback(lua, "backJustPressed", FlxG.android.justPressed.BACK);
		Lua_helper.add_callback(lua, "backPressed", FlxG.android.pressed.BACK);
		Lua_helper.add_callback(lua, "backJustReleased", FlxG.android.justReleased.BACK);
		Lua_helper.add_callback(lua, "menuJustPressed", FlxG.android.justPressed.MENU);
		Lua_helper.add_callback(lua, "menuPressed", FlxG.android.pressed.MENU);
		Lua_helper.add_callback(lua, "menuJustReleased", FlxG.android.justReleased.MENU);
		Lua_helper.add_callback(lua, "getCurrentOrientation", () -> PsychJNI.getCurrentOrientationAsString());
		Lua_helper.add_callback(lua, "setOrientation", function(hint:Null<String>):Void
		{
			switch (hint.toLowerCase())
			{
				case 'portrait':
					hint = 'Portrait';
				case 'portraitupsidedown' | 'upsidedownportrait' | 'upsidedown':
					hint = 'PortraitUpsideDown';
				case 'landscapeleft' | 'leftlandscape':
					hint = 'LandscapeLeft';
				case 'landscaperight' | 'rightlandscape' | 'landscape':
					hint = 'LandscapeRight';
				default:
					hint = null;
			}
			if (hint == null)
				return funk.luaTrace('setOrientation: No orientation specified.');
			PsychJNI.setOrientation(FlxG.stage.stageWidth, FlxG.stage.stageHeight, false, hint);
		});
		Lua_helper.add_callback(lua, "minimizeWindow", () -> AndroidTools.minimizeWindow());
		Lua_helper.add_callback(lua, "showToast", function(text:String, duration:Null<Int>, ?xOffset:Null<Int>, ?yOffset:Null<Int>)
		{
			if (text == null)
				return funk.luaTrace('showToast: No text specified.');
			else if (duration == null)
				return funk.luaTrace('showToast: No duration specified.');

			if (xOffset == null)
				xOffset = 0;
			if (yOffset == null)
				yOffset = 0;

			AndroidToast.makeText(text, duration, -1, xOffset, yOffset);
		});
		Lua_helper.add_callback(lua, "isScreenKeyboardShown", () -> PsychJNI.isScreenKeyboardShown());

		Lua_helper.add_callback(lua, "clipboardHasText", () -> PsychJNI.clipboardHasText());
		Lua_helper.add_callback(lua, "clipboardGetText", () -> PsychJNI.clipboardGetText());
		Lua_helper.add_callback(lua, "clipboardSetText", function(text:Null<String>):Void
		{
			if (text != null) return funk.luaTrace('clipboardSetText: No text specified.');
			PsychJNI.clipboardSetText(text);
		});

		Lua_helper.add_callback(lua, "manualBackButton", () -> PsychJNI.manualBackButton());

		Lua_helper.add_callback(lua, "setActivityTitle", function(text:Null<String>):Void
		{
			if (text != null) return funk.luaTrace('setActivityTitle: No text specified.');
			PsychJNI.setActivityTitle(text);
		});
		#end
	}
}
#end