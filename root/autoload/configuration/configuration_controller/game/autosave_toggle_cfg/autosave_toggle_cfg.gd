class_name AutosaveToggleCfg
extends ToggleConfigurationController
## Extension of [ToggleConfigurationController] that manages autosave.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func get_default_value() -> bool:
	return true


func get_config_value() -> bool:
	return Data.autosave_enabled


func apply_config_value(value: Variant) -> void:
	var is_autosave_enabled: bool = value

	Data.autosave_enabled = is_autosave_enabled

	configuration_applied.emit()
