class_name FPSCountToggleCfg
extends ToggleConfigurationController
## Extension of [ToggleConfigurationController] that manages FPS counter visibility.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func get_default_value() -> bool:
	return false


func get_config_value() -> bool:
	return Overlay.is_enabled()


func apply_config_value(value: Variant) -> void:
	var enabled: bool = value

	Overlay.fps_counter_toggle(enabled)

	configuration_applied.emit()
