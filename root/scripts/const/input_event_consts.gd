# TODO: Consider localization of these constants. NOTE: [OS.get_keycode_string()] is not localized.
class_name InputEventConsts
## Constants related to [InputEvent].
## [br][br]
## Modified File MIT License Copyright (c) 2024 TinyTakinTeller
## Original File MIT License Copyright (c) 2022-present Marek Belski

const NONE: String = "None"

const DIRECTION_UP: String = "Up"
const DIRECTION_DOWN: String = "Down"
const DIRECTION_LEFT: String = "Left"
const DIRECTION_RIGHT: String = "Right"

const GAMEPAD_BUTTON: String = "Gamepad Button"
const GAMEPAD_D_PAD: String = "Gamepad D-pad"
const GAMEPAD_JOYSTICK: String = "Gamepad Joystick"

const BUTTON_START: String = "Start"
const BUTTON_GUIDE: String = "Guide"
const BUTTON_BACK: String = "Back"

const SHOULDER_LEFT: String = "Left Shoulder"
const SHOULDER_RIGHT: String = "Right Shoulder"

const STICK_LEFT: String = "Left Stick"
const STICK_RIGHT: String = "Right Stick"

const TRIGGER_LEFT: String = "Left Trigger"
const TRIGGER_RIGHT: String = "Right Trigger"

const JOYSTICK_LEFT_NAME: String = DIRECTION_LEFT + " " + GAMEPAD_JOYSTICK
const JOYSTICK_RIGHT_NAME: String = DIRECTION_RIGHT + " " + GAMEPAD_JOYSTICK

const JOY_BUTTON_NAMES: Dictionary = {
	JOY_BUTTON_A: "A" + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_B: "B" + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_X: "X" + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_Y: "Y" + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_LEFT_SHOULDER: SHOULDER_LEFT + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_RIGHT_SHOULDER: SHOULDER_RIGHT + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_LEFT_STICK: STICK_LEFT + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_RIGHT_STICK: STICK_RIGHT + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_START: BUTTON_START + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_GUIDE: BUTTON_GUIDE + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_BACK: BUTTON_BACK + " " + GAMEPAD_BUTTON,
	JOY_BUTTON_DPAD_UP: GAMEPAD_D_PAD + " " + DIRECTION_UP,
	JOY_BUTTON_DPAD_DOWN: GAMEPAD_D_PAD + " " + DIRECTION_DOWN,
	JOY_BUTTON_DPAD_LEFT: GAMEPAD_D_PAD + " " + DIRECTION_LEFT,
	JOY_BUTTON_DPAD_RIGHT: GAMEPAD_D_PAD + " " + DIRECTION_RIGHT,
}

const JOY_AXIS_NAMES: Dictionary = {
	JOY_AXIS_TRIGGER_LEFT: TRIGGER_LEFT + " " + GAMEPAD_BUTTON,
	JOY_AXIS_TRIGGER_RIGHT: TRIGGER_RIGHT + " " + GAMEPAD_BUTTON,
}


static func get_text(event: InputEvent, suffix: bool = true) -> String:
	var text: String = _get_text(event)
	if not suffix:
		return text

	if "keycode" in event and event.keycode:
		pass
	elif "physical_keycode" in event and event.physical_keycode:
		text = text + " (%s)" % "Physical"
	elif "key_label" in event and event.key_label:
		text = text + " (%s)" % "Unicode"
	return text


static func _get_text(event: InputEvent) -> String:
	if event is InputEventJoypadButton:
		if event.button_index in JOY_BUTTON_NAMES:
			return JOY_BUTTON_NAMES[event.button_index]
	elif event is InputEventJoypadMotion:
		var full_string: String = ""
		var direction_string: String = ""
		var is_right_or_down: bool = event.axis_value > 0.0
		if event.axis in JOY_AXIS_NAMES:
			return JOY_AXIS_NAMES[event.axis]
		match event.axis:
			JOY_AXIS_LEFT_X:
				full_string = JOYSTICK_LEFT_NAME
				direction_string = DIRECTION_RIGHT if is_right_or_down else DIRECTION_LEFT
			JOY_AXIS_LEFT_Y:
				full_string = JOYSTICK_LEFT_NAME
				direction_string = DIRECTION_DOWN if is_right_or_down else DIRECTION_UP
			JOY_AXIS_RIGHT_X:
				full_string = JOYSTICK_RIGHT_NAME
				direction_string = DIRECTION_RIGHT if is_right_or_down else DIRECTION_LEFT
			JOY_AXIS_RIGHT_Y:
				full_string = JOYSTICK_RIGHT_NAME
				direction_string = DIRECTION_DOWN if is_right_or_down else DIRECTION_UP
		full_string += " " + direction_string
		return full_string
	elif event is InputEventKey:
		var keycode: Key = event.get_physical_keycode()
		if keycode:
			keycode = event.get_physical_keycode_with_modifiers()
		else:
			keycode = event.get_keycode_with_modifiers()
		if _display_server_supports_keycode_from_physical():
			keycode = DisplayServer.keyboard_get_keycode_from_physical(keycode)
		if not keycode and "key_label" in event and event.key_label:
			keycode = event.key_label
		return OS.get_keycode_string(keycode)
	var event_text: String = event.as_text()
	return event_text


static func _display_server_supports_keycode_from_physical() -> bool:
	return OS.has_feature("windows") or OS.has_feature("macos") or OS.has_feature("linux")
