package filemanager;

import openfl.net.FileReference;
import openfl.events.Event;
import lime.utils.Resource;
import openfl.net.FileFilter;

/**
 * A custom FileDialog functions for easier usability
 * mostly used for mobile devices
 * Author: KralOyuncu 2010x
*/
class FileDialogCustom
{
	public var onOpen = new Event<Resource->Void>();

	function new() {}

	public function open(filter:String = null):Bool
		var fileDialog:FileReference;

		var jsonFilter:FileFilter = new FileFilter(filter, filter);
		fileDialog = new FileReference();
		fileDialog.addEventListener(Event.SELECT, onLoadComplete);
		fileDialog.browse([jsonFilter]);
	}

	private static function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null) onOpen.dispatch(sys.io.File.getBytes(fullPath));
		#end
	}
}