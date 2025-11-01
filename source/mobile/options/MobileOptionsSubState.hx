package mobile.options;

import mobile.backend.MobileScaleMode;
import flixel.input.keyboard.FlxKey;
import options.BaseOptionsMenu;
import options.Option;

class MobileOptionsSubState extends BaseOptionsMenu {
	#if android
	var storageTypes:Array<String> = ["EXTERNAL_DATA", "EXTERNAL_OBB", "EXTERNAL_MEDIA", "EXTERNAL"];
	var externalPaths:Array<String> = StorageUtil.checkExternalPaths(true);
	var customPaths:Array<String> = StorageUtil.getCustomStorageDirectories(false);
	final lastStorageType:String = ClientPrefs.data.storageType;
	#end

	var option:Option;
	var HitboxTypes:Array<String>;
	public function new() {
		title = 'Mobile Options';
		rpcTitle = 'Mobile Options Menu'; // for Discord Rich Presence, fuck it
		#if android
		storageTypes = storageTypes.concat(customPaths); //Get Custom Paths From File
		storageTypes = storageTypes.concat(externalPaths); //Get SD Card Path
		#end

		HitboxTypes = Mods.mergeAllTextsNamed('mobile/Hitbox/HitboxModes/hitboxModeList.txt');

		option = new Option('MobilePad Opacity',
			'Selects the opacity for the mobile buttons (careful not to put it at 0 and lose track of your buttons).', 'mobilePadAlpha', 'percent');
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = () -> {
			mobilePad.alpha = curOption.getValue();
			ClientPrefs.toggleVolumeKeys();
		};
		addOption(option);

		var option:Option = new Option('Extra Controls',
			'Allow Extra Controls',
			'extraKeys',
			'int');
		option.scrollSpeed = 1;
		option.minValue = 0;
		option.maxValue = 4;
		option.changeValue = 1;
		option.decimals = 0;
		addOption(option);

		option = new Option('Extra Control Location',
			'Choose Extra Control Location',
			'hitboxLocation',
			'string',
			['Bottom', 'Top', 'Middle']
		);
		addOption(option);
		
		HitboxTypes.insert(0, "Classic");
		option = new Option('Hitbox Mode',
			'Choose your Hitbox Style!',
			'hitboxmode',
			'string',
			HitboxTypes
		);
		addOption(option);
		
		option = new Option('Hitbox Design',
			'Choose how your hitbox should look like.',
			'hitboxtype',
			'string',
			['Gradient', 'No Gradient' , 'No Gradient (Old)']
		);
		addOption(option);

		option = new Option('Hitbox Hint',
			'Hitbox Hint',
			'hitboxhint', 'bool');
		addOption(option);

		option = new Option('Hitbox Opacity',
			'Selects the opacity for the hitbox buttons.',
			'hitboxalpha',
			'percent'
		);
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if mobile
		option = new Option('Wide Screen Mode',
			'If checked, The game will stetch to fill your whole screen. (WARNING: Can result in bad visuals & break some mods that resizes the game/cameras)',
			'wideScreen', 'bool');
		option.onChange = () -> FlxG.scaleMode = new MobileScaleMode();
		addOption(option);
		#end

		#if android
		option = new Option('Storage Type',
			'Which folder Psych Online should use?',
			'storageType',
			'string',
			storageTypes
		);
		addOption(option);
		#end
		super();
	}

	override public function destroy() {
		super.destroy();

		#if android
		if (ClientPrefs.data.storageType != lastStorageType) {
			onStorageChange();
			ClientPrefs.saveSettings();
			CoolUtil.showPopUp('Storage Type has been changed and you needed restart the game!!\nPress OK to close the game.', 'Notice!');
			lime.system.System.exit(0);
		}
		#end
	}
}