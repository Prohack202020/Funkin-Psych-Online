package filemanager;

/**
 * A custom FileDialog functions for easier usability
 * mostly used for mobile devices
 * Author: KralOyuncu 2010x
*/
class FileDialogCustom extends lime.ui.FileDialog
{
	public function openFile(filter:String = null, defaultPath:String = null, title:String = null):Bool
	{
		onSelect.add(path -> {
			onOpen.dispatch(sys.io.File.getBytes(path));
		});
		return browse(OPEN, filter, defaultPath, title); //use retun for getting true & false
	}
}