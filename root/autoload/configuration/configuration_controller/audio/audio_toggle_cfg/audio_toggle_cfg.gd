class_name AudioToggleCfg
extends ToggleConfigurationController
## Extension of [ToggleConfigurationController] for managing master audio enable/disable toggle.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const BUS_NAME := "Master"

var _bus_index: int = AudioServer.get_bus_index(BUS_NAME)


func get_default_value() -> bool:
	return true


func get_config_value() -> Variant:
	return not AudioServer.is_bus_mute(_bus_index)


func apply_config_value(value: Variant) -> void:
	var enabled: bool = value as bool

	AudioServer.set_bus_mute(_bus_index, not enabled)

	configuration_applied.emit()
