package filemanager;

import openfl.net.FileReference;
import openfl.events.Event;
import lime.utils.Resource;
import openfl.net.FileFilter;

/**
 * A class that converts FileDialog requests to FileReference.
 * for some unknown reason, using FileDialog directly causes a crash.
 * mostly used for mobile devices
 * Author: KralOyuncu 2010x
*/
class FileDialogCustom
{
	public var onOpen = new lime.app.Event<Resource->Void>();

	public function new() {}

	var fileDialog:FileReference;
	public function open(filter:String = null):Void
	{
		var jsonFilter:FileFilter = new FileFilter("Nothing", filter);
		fileDialog = new FileReference();
		fileDialog.addEventListener(Event.SELECT, onLoadComplete);
		fileDialog.browse([jsonFilter]);
	}

	private function onLoadComplete(_):Void
	{
		fileDialog.removeEventListener(Event.SELECT, onLoadComplete);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(fileDialog.__path != null) fullPath = fileDialog.__path;

		if(fullPath != null) onOpen.dispatch(sys.io.File.getBytes(fullPath));
		#end
	}
}