package mobile.objects;

//I'm keeping this because Idk

import flixel.util.FlxSave;

#if TOUCH_CONTROLS
class MobileControls extends FlxSpriteGroup {
	public var hbox:HitboxOld;
	public var newhbox:Hitbox;
	public var current:CurrentManager;

	public function new(?customControllerValue:Int, ?CustomMode:String) {
		super();

		//Put this here bc control system is changed
		if (ClientPrefs.data.hitboxhint){
			var hitbox_hint:FlxSprite = new FlxSprite(0, (ClientPrefs.data.hitboxLocation == 'Bottom' && ClientPrefs.data.extraKeys != 0) ? -150 : 0).loadGraphic(Paths.image('mobile/Hitbox/hitbox_hint'));
			add(hitbox_hint);
		}

		if(ClientPrefs.data.hitboxmode == 'Classic') {
			hbox = new HitboxOld(0.75, ClientPrefs.data.antialiasing);
			add(hbox);
		} else {
			if (CustomMode != null || CustomMode != "NONE") newhbox = new Hitbox(CustomMode);
			else newhbox = new Hitbox();
			add(newhbox);
		}
		current = new CurrentManager(this);
	}
}

class CurrentManager {
	public var buttonLeft:MobileButton;
	public var buttonDown:MobileButton;
	public var buttonUp:MobileButton;
	public var buttonRight:MobileButton;
	public var buttonExtra1:MobileButton;
	public var buttonExtra2:MobileButton;
	public var buttonExtra3:MobileButton;
	public var buttonExtra4:MobileButton;

	public function new(control:MobileControls){
		if(ClientPrefs.data.hitboxmode != 'Classic') {
			buttonLeft = control.newhbox.buttonLeft;
			buttonDown = control.newhbox.buttonDown;
			buttonUp = control.newhbox.buttonUp;
			buttonRight = control.newhbox.buttonRight;
			buttonExtra1 = control.newhbox.buttonExtra1;
			buttonExtra2 = control.newhbox.buttonExtra2;
			buttonExtra3 = control.newhbox.buttonExtra3;
			buttonExtra4 = control.newhbox.buttonExtra4;
		} else if(ClientPrefs.data.hitboxmode == 'Classic') { //Classic Hitbox Now Support Shift & Space Buttons
			buttonLeft = control.hbox.buttonLeft;
			buttonDown = control.hbox.buttonDown;
			buttonUp = control.hbox.buttonUp;
			buttonRight = control.hbox.buttonRight;
			buttonExtra1 = control.hbox.buttonExtra1;
			buttonExtra2 = control.hbox.buttonExtra2;
		}
	}
}
#end