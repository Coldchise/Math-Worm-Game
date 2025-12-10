class_name FPSLimitListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages FPS limit settings.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func is_disabled() -> bool:
	return OS.has_feature("web")  # web browsers limit FPS themselves already


func init_cfg_options() -> void:
	init_cfg_option("LABEL_UNLIMITED", 0)
	for fps: int in [240, 200, 180, 165, 160, 144, 120, 100, 60, 30]:
		init_cfg_option("%d FPS" % fps, fps)


func get_default_value() -> int:
	return 0


func get_config_value() -> int:
	return Engine.max_fps


func apply_config_value(value: Variant) -> void:
	var fps_limit: int = value

	Engine.max_fps = fps_limit

	configuration_applied.emit()
