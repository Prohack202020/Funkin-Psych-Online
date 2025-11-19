package online.replay;

<<<<<<< HEAD
import psychlua.FunkinLua;
=======
>>>>>>> 6d320d34793cbb791cf739c6dc567970cca5c8fc
import objects.Note;
import states.FreeplayState;
import mobile.input.MobileInputID;
import flixel.input.gamepad.FlxGamepad;
import online.network.Leaderboard;
import haxe.crypto.Md5;
import backend.Song;
import backend.Highscore;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.FlxBasic;

class ReplayRecorder extends FlxBasic {
	@:unreflective
	private var REGISTER_BINDS(default, null) = [];
	private static final KEYS_MAP:Map<String, Array<String>> = [
		'4k' => ["note_up", "note_down", "note_left", "note_right"],
		'5k' => ['5k_note_1', '5k_note_2', '5k_note_3', '5k_note_4', '5k_note_5'],
		'6k' => ['6k_note_1', '6k_note_2', '6k_note_3', '6k_note_4', '6k_note_5', '6k_note_6'],
		'7k' => ['7k_note_1', '7k_note_2', '7k_note_3', '7k_note_4', '7k_note_5', '7k_note_6', '7k_note_7'],
		'8k' => ['8k_note_1', '8k_note_2', '8k_note_3', '8k_note_4', '8k_note_5', '8k_note_6', '8k_note_7', '8k_note_8'],
		'9k' => ['9k_note_1', '9k_note_2', '9k_note_3', '9k_note_4', '9k_note_5', '9k_note_6', '9k_note_7', '9k_note_8', '9k_note_9']
	];

	public static function genRegisterBinds() {
		return ['taunt'].concat(KEYS_MAP.get(Note.maniaKeys + 'k'));
	}

	public var data:ReplayData = {
		player: "",
		song: "",
		difficulty: "",
		//mod_url: "",
		opponent_mode: false,
		beat_time: 0,
		chart_hash: "",
		accuracy: 0,
		sicks: 0,
		goods: 0,
		bads: 0,
		shits: 0,
		misses: 0,
		points: 0,
		score: 0,
        inputs: [],
		note_offset: 0,
		gameplay_modifiers: [],
		ghost_tapping: true,
		rating_offset: null,
		safe_frames: null,
		version: 4,
		mod_url: '',
		keys: 4
    };

    var state:PlayState;

	var keyboardIds:Map<FlxKey, Array<String>> = [];
	var controllerIds:Map<FlxGamepadInputID, Array<String>> = [];

	public function new(state:PlayState) {
		super();

		trace("Recording a replay...");

		this.state = state;

		data.player = ClientPrefs.getNickname();
		data.song = PlayState.SONG.song;
		data.difficulty = Difficulty.getString(PlayState.storyDifficulty);
		//data.mod_url = OnlineMods.getModURL(Mods.currentModDirectory); 
		data.opponent_mode = !PlayState.playsAsBF();
		data.note_offset = ClientPrefs.data.noteOffset;
		data.gameplay_modifiers = ClientPrefs.data.gameplaySettings;
		data.ghost_tapping = ClientPrefs.data.ghostTapping;
		data.rating_offset = ClientPrefs.data.ratingOffset;
		data.safe_frames = ClientPrefs.data.safeFrames;
		data.mod_url = OnlineMods.getModURL(Mods.currentModDirectory);
<<<<<<< HEAD

=======
		data.keys = Note.maniaKeys;
>>>>>>> 6d320d34793cbb791cf739c6dc567970cca5c8fc
		data.chart_hash = Md5.encode(PlayState.RAW_SONG);

		REGISTER_BINDS = genRegisterBinds();

		for (id => binds in state.controls.keyboardBinds) {
			if (binds != null)
				for (bind in binds) {
					if (REGISTER_BINDS.contains(id)) {
						if (keyboardIds.exists(bind))
							keyboardIds.get(bind).push(id);
						else
							keyboardIds.set(bind, [id]);
					}
				}
		}

		//exclusive for taunts
		if (keyboardIds.exists(SPACE)) {
			if (keyboardIds.get(SPACE).contains('taunt')) {
				for (key in state.keysArray) {
					if (keyboardIds.get(SPACE).contains(key)) {
						keyboardIds.get(SPACE).remove('taunt');
					}
				}
			}
		}

		for (id => binds in state.controls.gamepadBinds) {
			for (bind in binds) {
				if (REGISTER_BINDS.contains(id)) {
					if (controllerIds.exists(bind))
						controllerIds.get(bind).push(id);
					else
						controllerIds.set(bind, [id]);
				}
			}
		}

		state.add(this);

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		// nvm
		// @:privateAccess FlxG.gamepads.getFirstActiveGamepad()._device.__gamepad.onButtonDown.add(onPadDown);
		// @:privateAccess FlxG.gamepads.getFirstActiveGamepad()._device.__gamepad.onButtonUp.add(onPadUp);
    }

	override function destroy() {
		super.destroy();

		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	function onKeyDown(e:KeyboardEvent) {
		recordKey(Conductor.songPosition, keyboardIds.get(e.keyCode), e.keyCode, 0, true);
    }

	function onKeyUp(e:KeyboardEvent) {
		recordKey(Conductor.songPosition, keyboardIds.get(e.keyCode), e.keyCode, 1, true);
	}

	var _gamepad:FlxGamepad;
	var isHitboxNull:Bool = true;
	var isMobilePadNull:Bool = true;
	override function update(elapsed:Float) {
		super.update(elapsed);

		//get Variables on update bc I wanna check them
		var hitbox:Hitbox = state.hitbox;
		var mobilePad:MobilePad = state.mobilePad;

		//Null Check
		if (hitbox == null)
			isHitboxNull = true;
		if (mobilePad == null)
			isMobilePadNull = true;

		if(hitbox != null && isHitboxNull)
		{
			isHitboxNull = false;
			hitbox.onButtonDown.add((button:MobileButton, ids:Array<MobileInputID>) -> recordKeyMobileC(Conductor.songPosition, ids, 0));
			hitbox.onButtonUp.add((button:MobileButton, ids:Array<MobileInputID>) -> recordKeyMobileC(Conductor.songPosition, ids, 1));
		}
		else
		{
			trace("Tried to init replay recorder for mobile controls but failed.");
		}

		if (FlxG.gamepads.numActiveGamepads > 0) {
			if (_gamepad == null || !_gamepad.connected)
				_gamepad = FlxG.gamepads.getFirstActiveGamepad();

			if (_gamepad != null)
				for (id => ids in controllerIds) {
					switch (@:privateAccess _gamepad.buttons[_gamepad.mapping.getRawID(id)]?.current) {
						case JUST_PRESSED:
							recordKey(Conductor.songPosition, ids, id, 0, false);
						case JUST_RELEASED:
							recordKey(Conductor.songPosition, ids, id, 1, false);
						default:
							// nothing
					}
				}
		}
	}

	function recordKey(time:Float, ids:Array<String>, keyCode:Int, move:Int, isKeyboard:Bool) {
		if (isKeyboard) {
			switch (keyCode) {
				case 16: // shift
					data.inputs.push([time, 'KEY:SHIFT', move]);
				case 17: // ctrl
					data.inputs.push([time, 'KEY:CONTROL', move]);
				case 18: // alt
					data.inputs.push([time, 'KEY:ALT', move]);
				case 32: // spaceeee
					data.inputs.push([time, 'KEY:SPACE', move]);
			}
		}
		
		if (ids == null)
			return;

		for (id in ids) {
			if (id == null || state.paused || !REGISTER_BINDS.contains(id))
				continue;
			data.inputs.push([time, id, move]);
		}
	}

	function recordKeyMobileC(time:Float, IDs:Array<MobileInputID>, move:Int) {
		if (IDs == null || IDs.length < 0)
			return;

		if(IDs.length == 1 && !REGISTER_BINDS.contains(IDs[0].toString().toLowerCase()))
		{
			switch(IDs[0])
			{
				case EXTRA_1:
					if (state.hitbox.buttonExtra1 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra1.returnedButton.toUpperCase(), move]);
				case EXTRA_2:
					if (state.hitbox.buttonExtra2 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra2.returnedButton.toUpperCase(), move]);
				case EXTRA_3:
					if (state.hitbox.buttonExtra3 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra3.returnedButton.toUpperCase(), move]);
				case EXTRA_4:
					if (state.hitbox.buttonExtra4 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra4.returnedButton.toUpperCase(), move]);
				case EXTRA_5:
					if (state.hitbox.buttonExtra5 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra5.returnedButton.toUpperCase(), move]);
				case EXTRA_6:
					if (state.hitbox.buttonExtra6 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra6.returnedButton.toUpperCase(), move]);
				case EXTRA_7:
					if (state.hitbox.buttonExtra7 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra7.returnedButton.toUpperCase(), move]);
				case EXTRA_8:
					if (state.hitbox.buttonExtra8 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra8.returnedButton.toUpperCase(), move]);
				case EXTRA_9:
					if (state.hitbox.buttonExtra9 != null)
						data.inputs.push([time, 'KEY:' + state.hitbox.buttonExtra9.returnedButton.toUpperCase(), move]);
				default:
					// nothing
			}
			return;
		}

		for (id in IDs)
		{
			var idName:String = id.toString().toLowerCase();

			if (idName == null || state.paused || !REGISTER_BINDS.contains(idName))
				continue;

			data.inputs.push([time, idName, move]);
		}
	}

	public function save():Float {
		if (!FileSystem.exists("replays/"))
			FileSystem.createDirectory("replays/");

		data.score = state.songScore;
		data.misses = state.songMisses;
		data.accuracy = CoolUtil.floorDecimal(state.ratingPercent * 100, 2);
		data.sicks = state.songSicks;
		data.goods = state.songGoods;
		data.bads = state.songBads;
		data.shits = state.songShits;
		data.points = FunkinPoints.calcFP(state.ratingPercent, state.songMisses, state.songDensity, state.totalNotesHit, state.maxCombo);
		data.beat_time = Date.now().getTime();
		data.note_offset = ClientPrefs.data.noteOffset;
		data.keys = Note.maniaKeys;

		if (data.accuracy < 5) {
			Alert.alert("git gud", 'your performance was SHIT');
			return 0;
		}

		trace("Saving replay...");
		var replayData = Json.stringify(data);
		File.saveContent(FileUtils.joinFiles([
			"replays", 
			"MyReplay-" + PlayState.SONG.song + "-" + Difficulty.getString().toUpperCase() + "-" + DateTools.format(Date.now(), "%Y-%m-%d_%H'%M'%S") + ".funkinreplay"
		]), replayData);
		trace("Saved a replay!");
		
		if (!ClientPrefs.data.disableSubmiting) {
			var response = Leaderboard.submitScore(replayData);
			final MAX_TRIES = 3;
			var tries = MAX_TRIES;
			while (response == null && tries > 0) {
				tries--;
				Sys.sleep(1);
				response = Leaderboard.submitScore(replayData);
			}
			if (response != null) {
				var res = Json.parse(response.getString() ?? "{}");
				states.FreeplayState.gainedRanks += res.climbed_ranks ?? 0;
				if (tries < MAX_TRIES) {
					Alert.alert('Replay Uploaded!', 'After try #' + (MAX_TRIES - tries));
				}
				if (res.gained_points != null) {
					return res.gained_points;
				}
			}
		}
		return 0;
    }
}

typedef ReplayData = {
	var player:String;

	var song:String;
	var difficulty:String;
	var accuracy:Float;
	var sicks:Float;
	var goods:Float;
	var bads:Float;
	var shits:Float;
	var misses:Float;
	var score:Float;
	var points:Float;

	//var mod_url:String;
	var opponent_mode:Bool;
	var beat_time:Float;
	var chart_hash:String;
	var keys:Int;

	var note_offset:Float;
	var gameplay_modifiers:Map<String, Dynamic>;
	var ghost_tapping:Null<Bool>;
	var rating_offset:Null<Int>;
	var safe_frames:Null<Float>;

	/**
	 * [ SONG_POSITION, BIND_ID, DOWN_OR_UP_INT ]
	 */
	var inputs:Array<Array<Dynamic>>;

	var version:Int;
	var mod_url:String;
}