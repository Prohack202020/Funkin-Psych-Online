package mobile.objects;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;

//More button support (Some buttons doesn't have a texture)
@:build(mobile.macros.ButtonMacro.createButtons(["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","SELECTOR"]))
@:build(mobile.macros.ButtonMacro.createExtraButtons(30)) //Psych Extended Allows to Create 30 Extra Button with Json for now

@:access(mobile.objects.MobileButton)
class MobilePad extends MobileInputManager implements IMobileControls {
	//DPad
	public var buttonLeft:MobileButton = new MobileButton(0, 0, [MobileInputID.LEFT, MobileInputID.NOTE_LEFT]);
	public var buttonUp:MobileButton = new MobileButton(0, 0, [MobileInputID.UP, MobileInputID.NOTE_UP]);
	public var buttonRight:MobileButton = new MobileButton(0, 0, [MobileInputID.RIGHT, MobileInputID.NOTE_RIGHT]);
	public var buttonDown:MobileButton = new MobileButton(0, 0, [MobileInputID.DOWN, MobileInputID.NOTE_DOWN]);

	//PAD DUO MODE
	public var buttonLeft2:MobileButton = new MobileButton(0, 0, [MobileInputID.LEFT2, MobileInputID.NOTE_LEFT]);
	public var buttonUp2:MobileButton = new MobileButton(0, 0, [MobileInputID.UP2, MobileInputID.NOTE_UP]);
	public var buttonRight2:MobileButton = new MobileButton(0, 0, [MobileInputID.RIGHT2, MobileInputID.NOTE_RIGHT]);
	public var buttonDown2:MobileButton = new MobileButton(0, 0, [MobileInputID.DOWN2, MobileInputID.NOTE_DOWN]);

	public var dPad:FlxTypedSpriteGroup<MobileButton>;
	public var actions:FlxTypedSpriteGroup<MobileButton>;
	public var createdButtons:Array<String> = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","SELECTOR","Left","Up","Right","Down","Left2","Up2","Right2","Down2"];

	public var instance:MobileInputManager;
	public var onButtonDown:FlxTypedSignal<MobileButton->Void> = new FlxTypedSignal<MobileButton->Void>();
	public var onButtonUp:FlxTypedSignal<MobileButton->Void> = new FlxTypedSignal<MobileButton->Void>();
	
	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode   The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */

	public function new(DPad:String, Action:String) {
		super();

		if (DPad != "NONE")
		{
			if (!MobileData.dpadModes.exists(DPad))
				throw 'The mobilePad dpadMode "$DPad" doesn\'t exists.';

			for (buttonData in MobileData.dpadModes.get(DPad).buttons)
			{
				var buttonID:Array<MobileInputID> = Reflect.getProperty(this, buttonData.button).IDs; //Get ID With variable because otherwise it returns the null
				var buttonStr:String = '${buttonData.button}';
				Reflect.setField(this, buttonData.button,
					createVirtualButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color),
						buttonID, buttonStr));
				add(Reflect.field(this, buttonData.button));
			}
		}

		if (Action != "NONE" && Action != "controlExtend")
		{
			if (!MobileData.actionModes.exists(Action))
				throw 'The mobilePad actionMode "$Action" doesn\'t exists.';

			for (buttonData in MobileData.actionModes.get(Action).buttons)
			{
				var buttonID:Array<MobileInputID> = Reflect.getProperty(this, buttonData.button).IDs; //Get ID With variable because otherwise it returns the null
				trace(buttonID);
				var buttonStr:String = '${buttonData.button}';
				Reflect.setField(this, buttonData.button,
					createVirtualButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color),
						buttonID, buttonStr));
				add(Reflect.field(this, buttonData.button));
			}
		}

		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	public function createVirtualButton(x:Float, y:Float, Frames:String, ?ColorS:Int = 0xFFFFFF, ?IDs:Array<MobileInputID>, ?strName:String):MobileButton {
		var frames:FlxGraphic;

		final path:String = Paths.getPreloadPath() + 'mobile/MobileButton/VirtualPad/original/$Frames.png';
		#if MODS_ALLOWED
		final modsPath:String = Paths.modFolders('mobile/MobileButton/VirtualPad/original/$Frames.png');
		if(sys.FileSystem.exists(modsPath))
			frames = FlxGraphic.fromBitmapData(BitmapData.fromFile(modsPath));
		else #end if(Assets.exists(path))
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(path));
		else
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(Paths.getPreloadPath() + 'mobile/MobileButton/VirtualPad/original/default.png'));

		trace("=== DETAILED DEBUG/DETAYLI DEBUG ===");
		trace("strName: " + strName);
		trace("IDs: " + IDs);
		trace("IDs.length: " + IDs.length);
		trace("IDs != null: " + (IDs != null));
		trace("IDs.length > 0: " + (IDs.length > 0));

		var conditionResult = (IDs != null && IDs.length > 0);
		trace("Condition result: " + conditionResult);

		if (conditionResult) {
			trace("IF BLOCK EXECUTED/IF BLOĞU ÇALIŞTI - Setting strName to null/strName null yapılıyor");
			strName = null;
		} else {
			trace("ELSE BLOCK EXECUTED/ELSE BLOĞU ÇALIŞTI - strName remains unchanged/strName değişmeyecek");
		}

		trace("Final/SON strName: " + strName);
		trace("=== DEBUG END/DEBUG SONU ===");

		var button = new MobileButton(x, y, IDs, strName);
		button.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(Std.int(frames.width / 2), frames.height));

		button.updateHitbox();
		button.updateLabelPosition();

		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();

		button.immovable = true;
		button.solid = button.moves = false;
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.tag = Frames.toUpperCase();

		if (ColorS != -1) button.color = ColorS;

		button.onDown.callback = () -> onButtonDown.dispatch(button);
		button.onOut.callback = button.onUp.callback = () -> onButtonUp.dispatch(button);
		return button;
	}

	override public function destroy():Void
	{
		super.destroy();
		onButtonUp.destroy();
		onButtonDown.destroy();

		for (fieldName in Reflect.fields(this))
		{
			var field = Reflect.field(this, fieldName);
			if (Std.isOfType(field, MobileButton))
				Reflect.setField(this, fieldName, FlxDestroyUtil.destroy(field));
		}
	}
}