class_name ConfigurationController
extends Node
## This is a base class for a configuration controller.
## Responsible for saving, loading and applying a configuration.
## Uses [ConfigStorage] object for saving and loading via INI file.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Can emit this if nodes need to react to configuration changes
signal configuration_applied

@export_group("ConfigStorage")
@export var config_group: ConfigurationEnum.Group
@export var config_id: String


# load and apply the saved configuration value at startup
func _ready() -> void:
	load_config_value()


func get_config_group_id() -> String:
	return EnumUtils.to_name(config_group, ConfigurationEnum.Group)


func get_config_id() -> String:
	return config_id


# some platforms do not support some configurations
func is_disabled() -> bool:
	return false


# get default value (used first time, if configuration was never saved and there is nothing to load)
func get_default_value() -> Variant:
	push_error("Not Implemented")
	return null


# get applied (current) configuration value
func get_config_value() -> Variant:
	push_error("Not Implemented")
	return null


# use when [get_config_value] is an ID for some other resource (to avoid saving entire resource)
func get_config_resource() -> Variant:
	push_error("Not Implemented")
	return null


# get saved configuration value
func get_saved_config_value() -> Variant:
	return ConfigStorage.get_config(get_config_group_id(), get_config_id(), get_default_value())


# load and apply the saved configuration value
func load_config_value() -> void:
	var value: Variant = get_saved_config_value()
	apply_config_value(value)


# apply and save a new configuration value
func update_config_value(value: Variant) -> void:
	apply_config_value(value)
	save_config_value(value)


# save a new configuration value
func save_config_value(value: Variant) -> void:
	ConfigStorage.set_config(get_config_group_id(), get_config_id(), value)


# apply the given configuration value
func apply_config_value(_value: Variant) -> void:
	push_error("Not Implemented")


# apply and save the default configuration value
func reset_config_value() -> void:
	update_config_value(get_default_value())
