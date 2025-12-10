class_name ActionHandler
extends Object
## Encapsulates a map of callable functions (actions).
## Register actions by type and id, then call them by type and id (with or without arguments).
## [br][br]
## This is the (light) command pattern: (use map instead if-else/switch/match statements) [br]
## - https://refactoring.guru/design-patterns/command
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const NAME: String = "ActionHandler"

const KEY_SEPARATOR: String = "-"

var _action_register_type: String = ""
var _action_map: Dictionary = {}


func set_register_type(type: String) -> void:
	_action_register_type = type


func register_action(id: int, action: Callable) -> void:
	_action_map[_get_key(_action_register_type, id)] = action


func register_actions(id_action: Dictionary) -> void:
	for id: int in id_action:
		var action: Callable = id_action[id]
		register_action(id, action)


func register_same_action(ids: Array[int], action: Callable) -> void:
	for id: int in ids:
		register_action(id, action)


func handle_action(type: String, id: int, source: Node) -> void:
	handle_action_args(type, id, source, [])


func handle_action_args(type: String, id: int, source: Node, args: Array) -> void:
	var action: Callable = _action_map.get(_get_key(type, id), _no_action)
	if action != _no_action:
		LogWrapper.debug(NAME, "%s: %s action called '%s'." % [source.name, type, action])
		action.callv(args)


func _get_key(type: String, id: int) -> String:
	return type + KEY_SEPARATOR + str(id)


static func _no_action() -> void:
	pass
