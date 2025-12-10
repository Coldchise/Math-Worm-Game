class_name KeybindsTreeCfg
extends TreeConfigurationController
## Tracks differences between the [InputMap] and the [get_config_value] dictionary. [br]
## - the dictionary key structure is: [StringName, InputEvent, bool]. [br]
## - the dictionary key structure represents: action, input event, bind/unbind difference.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# tracks all external (project configured) actions and only a subset of internal (built-in) actions
# Project > Project Settings > Input Map > Show Built-In Actions
@export var internal_action_prefix: StringName = &"ui_"
@export var exposed_internal_actions: Array[StringName] = [
	&"ui_right",
	&"ui_left",
	&"ui_up",
	&"ui_down",
	&"ui_accept",
	&"ui_select",
	&"ui_cancel",
	&"ui_focus_next",
	&"ui_focus_prev"
]


func is_external_action(action: StringName) -> bool:
	return not action.begins_with(internal_action_prefix)


func is_exposed_action(action: StringName) -> bool:
	return is_external_action(action) or (action in exposed_internal_actions)


func get_keybind_actions() -> Array[StringName]:
	var actions: Array[StringName] = InputMap.get_actions().filter(
		func(action: StringName) -> bool: return is_exposed_action(action)
	)
	return actions


func get_keybind_input_events(action: StringName) -> Array[InputEvent]:
	return InputMap.action_get_events(action)


# return full dictionary, not just tracked differences as in [get_config_value]
func get_config_resource() -> Dictionary:
	var resource_dictionary: Dictionary = {}
	for action: StringName in get_keybind_actions():
		resource_dictionary[action] = {}
		var inputs: Array[InputEvent] = get_keybind_input_events(action)
		for input: InputEvent in inputs:
			resource_dictionary[action][input] = true
	return resource_dictionary


func get_config_title_mappers() -> Dictionary:
	return {
		0: func(action: StringName) -> String: return action.capitalize(),
		1: func(input_event: InputEvent) -> String: return InputEventConsts.get_text(input_event),
	}


func apply_internal_config_value() -> void:
	InputMap.load_from_project_settings()
	var keybinds: Dictionary = get_config_value()
	for action: StringName in keybinds:
		var action_inputs: Dictionary = keybinds[action]
		for input_event: InputEvent in action_inputs:
			var bind: bool = action_inputs[input_event]
			_apply_keybind(action, input_event, bind)

	configuration_applied.emit()


func _apply_keybind(action: StringName, input_event: InputEvent, bind: bool) -> void:
	if bind and not InputMap.action_has_event(action, input_event):
		InputMap.action_add_event(action, input_event)
	if not bind and InputMap.action_has_event(action, input_event):
		InputMap.action_erase_event(action, input_event)
