package mobile.objects;

import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * ...
 * @author: Karim Akra
 */
interface IMobileControls
{
	public var buttonLeft:MobileButton;
	public var buttonUp:MobileButton;
	public var buttonRight:MobileButton;
	public var buttonDown:MobileButton;
	public var buttonExtra1:MobileButton; //same as the buttonExtra
	public var buttonExtra2:MobileButton;
	public var instance:MobileInputManager;
	public var onButtonDown:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>;
	public var onButtonUp:FlxTypedSignal<(MobileButton, Array<MobileInputID>) -> Void>;
}