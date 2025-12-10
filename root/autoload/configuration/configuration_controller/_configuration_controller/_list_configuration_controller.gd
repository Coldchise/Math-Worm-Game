class_name ListConfigurationController
extends ConfigurationController
## This is an extended [ConfigurationController] base class for a configuration controller.
## In addition, this class also provides [CfgOptions] representing a list of possible options.
## Example usage in dropdown options.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# sometimes we want to disable an option if it fails to apply (if detected that it is not supported)
# example: [VsyncModeListCfg] uses [_process] override to check if the apply failed
signal option_disabled(option_label: String)


## Each option has a title and a value and the order of options matters, hence we use [LinkedMap].
## Some platforms do not support all option values so we track that in "disabled_options"
class CfgOptions:
	var options: LinkedMap = LinkedMap.new()
	var disabled_options: Dictionary[String, bool] = {}
	var hide_disabled: bool = false


var cfg_options: CfgOptions = CfgOptions.new()

var disabled: bool


func _ready() -> void:
	init_cfg_options()
	load_config_value()


# apply and save a new configuration value by index
func update_config_value_index(index: int) -> void:
	var value: Variant = cfg_options.options.get_value_at(index)
	update_config_value(value)


# save a new configuration value by index
func save_config_value_index(index: int) -> void:
	var value: Variant = cfg_options.options.get_value_at(index)
	save_config_value(value)


# get default configuration value index
func get_default_value_index() -> int:
	var value: Variant = get_default_value()
	return cfg_options.options.find_key_index_by_value(value)


# get applied (current) configuration value index
func get_config_value_index() -> int:
	var value: Variant = get_config_value()
	return cfg_options.options.find_key_index_by_value(value)


# get saved configuration value index
func get_saved_config_value_index() -> int:
	var value: Variant = get_saved_config_value()
	return cfg_options.options.find_key_index_by_value(value)


func get_cfg_options() -> CfgOptions:
	return cfg_options


func init_cfg_options() -> void:
	push_error("Not Implemented")


func init_cfg_option(label: String, value: Variant, is_option_disabled: bool = false) -> void:
	cfg_options.options.add(label, value)
	cfg_options.disabled_options[label] = is_option_disabled


func disable_cfg_option(option_value: Variant) -> void:
	var option_label: String = cfg_options.options.get_key_by_value(option_value)
	cfg_options.disabled_options[option_label] = true

	option_disabled.emit(option_label)
