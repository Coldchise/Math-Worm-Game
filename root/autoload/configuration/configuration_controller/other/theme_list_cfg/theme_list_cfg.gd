class_name ThemeListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages theme settings.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# alternative to the inconsistent custom theme: Project > Project Settings > GUI > Theme > Custom
# - https://github.com/godotengine/godot/issues/96023
const CUSTOM_THEME = preload(PathConsts.RES + "resources/global/theme/tres/theme.tres")


func is_disabled() -> bool:
	return true  # disabled by default since it has only 1 option to select from right now


func init_cfg_options() -> void:
	init_cfg_option("MENU_OPTIONS_THEME| 1", CUSTOM_THEME)


func get_default_value() -> Theme:
	return CUSTOM_THEME


func get_config_value() -> Theme:
	return get_tree().root.theme


func apply_config_value(value: Variant) -> void:
	var theme: Theme = value

	get_tree().root.theme = theme

	configuration_applied.emit()
