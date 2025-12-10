class_name GameModeListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages game mode selection.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export var game_content_scenes: Array[PackedScene]

var game_mode: int = get_default_value()


func init_cfg_options() -> void:
	init_cfg_option(_get_option_name(0), 0)
	init_cfg_option(_get_option_name(1), 1)
	init_cfg_option(_get_option_name(2), 2)


func get_default_value() -> int:
	return 1


func get_config_value() -> int:
	return game_mode


func get_config_resource() -> PackedScene:
	return game_content_scenes[game_mode]


func apply_config_value(value: Variant) -> void:
	game_mode = value

	configuration_applied.emit()


func _get_option_name(new_game_mode: int) -> String:
	return TranslationServerWrapper.translate("MENU_LABEL_GAME_MODE| " + str(new_game_mode))
