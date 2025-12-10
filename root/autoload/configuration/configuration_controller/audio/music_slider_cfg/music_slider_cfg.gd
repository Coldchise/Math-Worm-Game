class_name MusicSliderCfg
extends SliderConfigurationController
## Extension of [SliderConfigurationController] for managing music volume slider percent (0-100).
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const BUS_NAME := "Music"

var _bus_index: int = AudioServer.get_bus_index(BUS_NAME)


func get_default_value() -> float:
	return 100.0


func get_config_value() -> Variant:
	return db_to_linear(AudioServer.get_bus_volume_db(_bus_index)) * 100


func apply_config_value(value: Variant) -> void:
	var volume: float = clamp(value as float, 0.0, 100.0)

	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(volume / 100))

	configuration_applied.emit()
