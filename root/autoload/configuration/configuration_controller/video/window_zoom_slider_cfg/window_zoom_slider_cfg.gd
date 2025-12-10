class_name WindowZoomSliderCfg
extends SliderConfigurationController
## Extension of [ConfigurationController] that manages root window zoom factor (default is 100%).
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func get_default_value() -> float:
	return 100


func get_config_value() -> float:
	return get_tree().get_root().content_scale_factor * 100.0


func apply_config_value(value: Variant) -> void:
	var scale_percent: float = value

	get_tree().get_root().content_scale_factor = scale_percent / 100.0

	configuration_applied.emit()
