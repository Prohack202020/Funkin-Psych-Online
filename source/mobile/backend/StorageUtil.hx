package mobile.backend;

import lime.system.System as LimeSystem;
import haxe.io.Path;
import haxe.Exception;

import lime.system.System;
import lime.app.Application;
import openfl.Assets;
import haxe.io.Bytes;

/**
 * A storage class for mobile.
 * @author Mihai Alexandru (M.A. Jigsaw)
 * @modifier KralOyuncu2010x (ArkoseLabs)
 */
class StorageUtil
{
	#if sys
	// root directory, used for handling the saved storage type and path
	public static final rootDir:String = LimeSystem.applicationStorageDirectory;

	// package name, I know I can app's package name but I really don't want to do it for now
	public static var packageName:String = 'com.snirozu.psychonlinebasic';

	public static function getStorageDirectory():String
		return #if android haxe.io.Path.addTrailingSlash(AndroidContext.getExternalFilesDir()) #elseif ios lime.system.System.documentsDirectory #else Sys.getCwd() #end;

	public static function getCustomStorageDirectories(?doNotSeperate:Bool):Array<String>
	{
		var curTextFile:String = '/storage/emulated/0/Android/data/${packageName}/files/' + Paths.getPreloadPath() + 'mobile/storageModes.txt';
		var ArrayReturn:Array<String> = [];
		for (mode in CoolUtil.coolTextFile(curTextFile))
		{
			if(mode.trim().length < 1) continue;

			//turning the readle to original one (also, much easier to rewrite the code) -KralOyuncu2010x
			if (mode.contains('Name: ')) mode = mode.replace('Name: ', '');
			if (mode.contains(' Folder: ')) mode = mode.replace(' Folder: ', '|');
			//trace(mode);

			var dat = mode.split("|");
			if (doNotSeperate)
				ArrayReturn.push(mode); //get both as array
			else
				ArrayReturn.push(dat[0]); //get storage name as array
		}
		return ArrayReturn;
	}

	#if android
	// always force path due to haxe (This shit is dead for now)
	public static function getExternalStorageDirectory():String
	{
		var daPath:String = '';
		#if android
		if (!FileSystem.exists(rootDir + 'storagetype.txt'))
			File.saveContent(rootDir + 'storagetype.txt', ClientPrefs.data.storageType);

		var curStorageType:String = File.getContent(rootDir + 'storagetype.txt');

		/* Put this there because I don't want to override original paths, also brokes the normal storage system */
		for (line in getCustomStorageDirectories(true))
		{
			if (line.startsWith(curStorageType) && (line != '' || line != null)) {
				var dat = line.split("|");
				daPath = dat[1];
			}
		}

		/* Hardcoded Storage Types, these types cannot be changed by Custom Type */
		switch(curStorageType) {
			case 'EXTERNAL':
				daPath = AndroidEnvironment.getExternalStorageDirectory() + '/.' + lime.app.Application.current.meta.get('file');
			case 'EXTERNAL_OBB':
				daPath = AndroidContext.getObbDir();
			case 'EXTERNAL_MEDIA':
				daPath = AndroidEnvironment.getExternalStorageDirectory() + '/Android/media/' + lime.app.Application.current.meta.get('packageName');
			case 'EXTERNAL_DATA':
				daPath = AndroidContext.getExternalFilesDir();
			default:
				daPath = getExternalDirectory(curStorageType) + '/.' + lime.app.Application.current.meta.get('file');
		}

		daPath = Path.addTrailingSlash(daPath);
		#elseif ios
		return LimeSystem.documentsDirectory;
		#else
		return Sys.getCwd();
		#end

		return daPath;
	}

	public static function requestPermissions():Void
	{
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			AndroidPermissions.requestPermissions([
				'READ_MEDIA_IMAGES',
				'READ_MEDIA_VIDEO',
				'READ_MEDIA_AUDIO',
				'READ_MEDIA_VISUAL_USER_SELECTED'
			]);
		else
			AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);

		if (!AndroidEnvironment.isExternalStorageManager())
			AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');

		/* I have no idea why this thing causes the crash,
			also I can make a custom lime for other Psych Online Port, Otherwise Their Port won't work on my phone (I'm android 15) */

		/*
		if ((AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU && !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_MEDIA_IMAGES'))
			|| (AndroidVersion.SDK_INT < AndroidVersionCode.TIRAMISU && !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_EXTERNAL_STORAGE')))
			{
				CoolUtil.showPopUp('If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress OK to see what happens', 'Notice!');
			}
		*/

		try
		{
			if (!FileSystem.exists(StorageUtil.getStorageDirectory()))
				FileSystem.createDirectory(StorageUtil.getStorageDirectory());
		}
		catch (e:Dynamic)
		{
			CoolUtil.showPopUp('Please create directory to\n${StorageUtil.getStorageDirectory()}\nPress OK to close the game', "Error!");
			lime.system.System.exit(1);
		}

		try
		{
			if (!FileSystem.exists(StorageUtil.getExternalStorageDirectory() + 'mods'))
				FileSystem.createDirectory(StorageUtil.getExternalStorageDirectory() + 'mods');
		}
		catch (e:Dynamic)
		{
			CoolUtil.showPopUp('Please create directory to\n${StorageUtil.getExternalStorageDirectory()}\nPress OK to close the game', "Error!");
			lime.system.System.exit(1);
		}
	}


	public static function createDirectories(directory:String):Void
	{
		try
		{
			if (FileSystem.exists(directory) && FileSystem.isDirectory(directory))
				return;
		}
		catch (e:haxe.Exception)
		{
			trace('Something went wrong while looking at directory. (${e.message})');
		}

		var total:String = '';
		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');
		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				try
				{
					if (!FileSystem.exists(total))
						FileSystem.createDirectory(total);
				}
				catch (e:Exception)
					trace('Error while creating directory. (${e.message}');
			}
		}
	}

	public static function checkExternalPaths(?splitStorage = false):Array<String>
	{
		var process = new Process('grep -o "/storage/....-...." /proc/mounts | paste -sd \',\'');
		var paths:String = process.stdout.readAll().toString();
		trace(paths);
		if (splitStorage)
			paths = paths.replace('/storage/', '');
		trace(paths);
		return paths.split(',');
	}

	public static function getExternalDirectory(externalDir:String):String
	{
		var daPath:String = '';
		for (path in checkExternalPaths())
			if (path.contains(externalDir))
				daPath = path;

		daPath = haxe.io.Path.addTrailingSlash(daPath.endsWith("\n") ? daPath.substr(0, daPath.length - 1) : daPath);
		return daPath;
	}
	#end

	public static function saveContent(fileName:String, fileData:String, ?alert:Bool = true):Void
	{
		final folder:String = #if android StorageUtil.getExternalStorageDirectory() + #else Sys.getCwd() + #end 'saves/';
		try
		{
			if (!FileSystem.exists(folder))
				FileSystem.createDirectory(folder);

			File.saveContent('$folder/$fileName', fileData);
			if (alert)
				CoolUtil.showPopUp('${fileName} has been saved.', "Success!");
		}
		catch (e:Dynamic)
			if (alert)
				CoolUtil.showPopUp('${fileName} couldn\'t be saved.\n${e.message}', "Error!");
			else
				trace('$fileName couldn\'t be saved. (${e.message})');
	}
	#end

	/**
	 * Copies recursively the assets folder from the APK to external directory
	 * @param sourcePath Path to the assets folder inside APK (usually "assets/")
	 * @param targetPath Destination path (optional, uses Sys.getCwd() + "assets/" if not specified)
	 */
	inline public static function copyAssetsFromAPK(sourcePath:String = "assets/", targetPath:String = null):Void {
		#if mobile
		if (targetPath == null)
			targetPath = Sys.getCwd() + "assets/";

		try {
			if (!FileSystem.exists(targetPath))
				FileSystem.createDirectory(targetPath);

			copyAssetsRecursively(sourcePath, targetPath);

			trace('Assets successfully copied to: $targetPath');
		} catch (e:Dynamic) {
			trace('Error copying assets: $e');
			CoolUtil.showPopUp('Error copying game files. Check storage permissions or re-open the game to see what happens.', 'Error');
		}
		#end
	}

	/**
	 * Helper function to copy assets recursively
	 */
	inline private static function copyAssetsRecursively(sourcePath:String, targetPath:String):Void {
		#if mobile
		try {
			var cleanSourcePath = sourcePath;
			if (StringTools.endsWith(cleanSourcePath, "/"))
				cleanSourcePath = cleanSourcePath.substring(0, cleanSourcePath.length - 1);

			var assetList:Array<String> = Assets.list();

			for (assetPath in assetList) {
				if (StringTools.startsWith(assetPath, cleanSourcePath)) {
					var relativePath = assetPath;

					if (StringTools.startsWith(relativePath, "assets/"))
						relativePath = relativePath.substring(7);

					if (relativePath == "") continue;

					var fullTargetPath = targetPath + relativePath;

					var targetDir = haxe.io.Path.directory(fullTargetPath);
					if (targetDir != "" && !FileSystem.exists(targetDir))
						createDirectoryRecursive(targetDir);

					try {
						if (Assets.exists(assetPath)) {
							var fileData:Bytes = Assets.getBytes(assetPath);
							if (fileData != null) {
								File.saveBytes(fullTargetPath, fileData);
								trace('Copied: $assetPath -> $fullTargetPath');
							} else {
								var textData = Assets.getText(assetPath);
								if (textData != null) {
									File.saveContent(fullTargetPath, textData);
									trace('Copied (text): $assetPath -> $fullTargetPath');
								}
							}
						}
					} catch (e:Dynamic) {
						trace('Error copying file $assetPath: $e');
					}
				}
			}
		} catch (e:Dynamic) {
			trace('Error in recursive copy: $e');
			throw e;
		}
		#end
	}

	/**
	 * Creates directories recursively
	 */
	inline private static function createDirectoryRecursive(path:String):Void {
		#if mobile
		if (FileSystem.exists(path)) return;

		var pathParts = path.split("/");
		var currentPath = "";

		for (part in pathParts) {
			if (part == "") continue;
			currentPath += "/" + part;

			if (!FileSystem.exists(currentPath)) {
				try {
					FileSystem.createDirectory(currentPath);
				} catch (e:Dynamic) {
					trace('Error creating directory $currentPath: $e');
				}
			}
		}
		#end
	}

	/**
	 * Counts total number of asset files for progress
	 */
	inline private static function countAssetsFiles(sourcePath:String):Int {
		#if mobile
		var count = 0;
		var cleanSourcePath = sourcePath;
		if (StringTools.endsWith(cleanSourcePath, "/"))
			cleanSourcePath = cleanSourcePath.substring(0, cleanSourcePath.length - 1);
		var assetList:Array<String> = Assets.list();

		for (assetPath in assetList) {
			if (StringTools.startsWith(assetPath, cleanSourcePath)) {
				var relativePath = assetPath;

				if (StringTools.startsWith(relativePath, "assets/"))
					relativePath = relativePath.substring(7);

				if (relativePath != "")
					count++;
			}
		}

		return count;
		#else
		return 0;
		#end
	}

	/**
	 * Checks if assets have already been copied
	 */
	inline public static function areAssetsCopied(sourcePath:String = "assets/", targetPath:String = null):Bool {
		#if mobile
		if (targetPath == null)
			targetPath = Sys.getCwd() + "assets/";

		if (!FileSystem.exists(targetPath))
			return false;

		var sourceCount = countAssetsFiles(sourcePath);
		var targetCount = countFilesInDirectory(targetPath);

		return sourceCount > 0 && sourceCount == targetCount;
		#else
		return false;
		#end
	}

	/**
	 * Counts files in a directory recursively
	 */
	inline private static function countFilesInDirectory(path:String):Int {
		#if mobile
		if (!FileSystem.exists(path)) return 0;

		var count = 0;
		var items = FileSystem.readDirectory(path);

		for (item in items) {
			var fullPath = path + "/" + item;
			if (FileSystem.isDirectory(fullPath))
				count += countFilesInDirectory(fullPath);
			else
				count++;
		}

		return count;
		#else
		return 0;
		#end
	}
}