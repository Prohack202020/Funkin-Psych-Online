package mobile.backend;

import haxe.ds.Map;
import haxe.Json;
import haxe.io.Path;
import openfl.utils.Assets;
import flixel.util.FlxSave;

class MobileData
{
	public static var actionModes:Map<String, MobileButtonsData> = new Map();
	public static var dpadModes:Map<String, MobileButtonsData> = new Map();
	public static var hitboxModes:Map<String, CustomHitboxData> = new Map();

	public static var save:FlxSave;

	public static function init()
	{
		save = new FlxSave();
		save.bind('MobileControls', CoolUtil.getSavePath());

		readDirectory(Paths.getPreloadPath('mobile/MobilePad/DPadModes'), dpadModes);
		readDirectory(Paths.getPreloadPath('mobile/Hitbox/HitboxModes'), hitboxModes);
		readDirectory(Paths.getPreloadPath('mobile/MobilePad/ActionModes'), actionModes);
		#if MODS_ALLOWED
		for (folder in Mods.directoriesWithFile(Paths.getPreloadPath(), 'mobile/MobilePad/'))
		{
			readDirectory(Path.join([folder, 'DPadModes']), dpadModes);
			readDirectory(Path.join([folder, 'ActionModes']), actionModes);
		}
		for (folder in Mods.directoriesWithFile(Paths.getPreloadPath(), 'mobile/Hitbox/'))
		{
			readDirectory(Path.join([folder, 'HitboxModes']), hitboxModes);
		}
		#end
	}

	static function readDirectory(folder:String, map:Dynamic)
	{
		folder = folder.contains(':') ? folder.split(':')[1] : folder;

		#if MODS_ALLOWED if (FileSystem.exists(folder)) #end
		for (file in readDirectoryPlus(folder))
		{
			var fileWithNoLib:String = file.contains(':') ? file.split(':')[1] : file;
			if (Path.extension(fileWithNoLib) == 'json')
			{
				file = Path.join([folder, Path.withoutDirectory(file)]);
				var str = #if MODS_ALLOWED File.getContent(file) #else Assets.getText(file) #end;
				var json:MobileButtonsData = cast Json.parse(str);
				var mapKey:String = Path.withoutDirectory(Path.withoutExtension(fileWithNoLib));
				map.set(mapKey, json);
			}
		}
	}

	static function readDirectoryPlus(directory:String):Array<String>
	{
		#if MODS_ALLOWED
		return FileSystem.readDirectory(directory);
		#else
		var dirs:Array<String> = [];
		for(dir in Assets.list().filter(folder -> folder.startsWith(directory)))
		{
			@:privateAccess
			for(library in lime.utils.Assets.libraries.keys())
			{
				if(library != 'default' && Assets.exists('$library:$dir') && (!dirs.contains('$library:$dir') || !dirs.contains(dir)))
					dirs.push('$library:$dir');
				else if(Assets.exists(dir) && !dirs.contains(dir))
					dirs.push(dir);
			}
		}
		return dirs;
		#end
	}
}

typedef MobileButtonsData =
{
	buttons:Array<ButtonsData>
}

typedef CustomHitboxData =
{
	hints:Array<HitboxData>, //support old jsons
	//Shitty but works (as said, if it works don't touch)
	none:Array<HitboxData>,
	single:Array<HitboxData>,
	double:Array<HitboxData>,
	triple:Array<HitboxData>,
	quad:Array<HitboxData>,
	mania1:Array<HitboxData>,
	mania2:Array<HitboxData>,
	mania3:Array<HitboxData>,
	mania4:Array<HitboxData>,
	mania5:Array<HitboxData>,
	mania6:Array<HitboxData>,
	mania7:Array<HitboxData>,
	mania8:Array<HitboxData>,
	mania9:Array<HitboxData>,
	mania20:Array<HitboxData>,
	mania55:Array<HitboxData>,
	test:Array<HitboxData>
}

typedef HitboxData =
{
	button:String, // what Hitbox Button should be used, must be a valid Hitbox Button var from Hitbox as a string.
	//if custom ones isn't setted these will be used
	x:Dynamic, // the button's X position on screen.
	y:Dynamic, // the button's Y position on screen.
	width:Dynamic, // the button's Width on screen.
	height:Dynamic, // the button's Height on screen.
	color:String, // the button color, default color is white.
	returnKey:String, // the button return, default return is nothing (please don't add custom return if you don't need).
	extraKeyMode:Null<Int>,
	//Top
	topX:Dynamic,
	topY:Dynamic,
	topWidth:Dynamic,
	topHeight:Dynamic,
	topColor:String,
	topReturnKey:String,
	topExtraKeyMode:Null<Int>,
	//Middle
	middleX:Dynamic,
	middleY:Dynamic,
	middleWidth:Dynamic,
	middleHeight:Dynamic,
	middleColor:String,
	middleReturnKey:String,
	middleExtraKeyMode:Null<Int>,
	//Bottom
	bottomX:Dynamic,
	bottomY:Dynamic,
	bottomWidth:Dynamic,
	bottomHeight:Dynamic,
	bottomColor:String,
	bottomReturnKey:String,
	bottomExtraKeyMode:Null<Int>
}

typedef ButtonsData =
{
	button:String, // what MobileButton should be used, must be a valid MobileButton var from MobilePad as a string.
	graphic:String, // the graphic of the button, usually can be located in the MobilePad xml.
	x:Float, // the button's X position on screen.
	y:Float, // the button's Y position on screen.
	color:String, // the button color, default color is white.
	bg:String // the button background for MobilePad, default background is `bg`.
}