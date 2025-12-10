class_name ResolutionListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages resolution settings.
## Tracks window resolutions relevant to windowed display mode.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func is_disabled() -> bool:
	return OS.has_feature("web")  # on web the window size is determined by the web browser


func init_cfg_options() -> void:
	init_cfg_option("854 x 480", Vector2i(854, 480))
	init_cfg_option("1280 x 720", Vector2i(1280, 720))
	init_cfg_option("1920 x 1080", Vector2i(1920, 1080))
	init_cfg_option("2560 x 1440", Vector2i(2560, 1440))
	init_cfg_option("3840 x 2160", Vector2i(3840, 2160))


func get_default_value() -> Vector2i:
	return Vector2i(1280, 720)


func get_config_value() -> Vector2i:
	return get_tree().get_root().size


func apply_config_value(value: Variant) -> void:
	var resolution: Vector2i = value

	if DisplayServer.window_get_mode() != DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
		return  # skip apply if not applicable

	if is_disabled():
		return  # skip apply if configuration is disabled (not supported)
	if resolution == get_config_value():
		return  # skip apply if same value is already applied

	get_tree().get_root().size = resolution
