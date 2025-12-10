class_name TreeConfigurationController
extends ConfigurationController
## Handles dictionary-based (tree-like) configurations with nested keys.
## [br][br]
## Original Concept MIT License Copyright (c) 2024 TinyTakinTeller

var tree: Dictionary = get_default_value()


func get_default_value() -> Dictionary:
	return {}


func get_config_value() -> Dictionary:
	return tree


func get_config_resource() -> Dictionary:
	push_error("Not Implemented")
	return {}


func get_config_title_mappers() -> Dictionary:
	push_error("Not Implemented")
	return {}


# override current config value with given (set new dictionary)
func update_config_value(value: Variant) -> void:
	apply_config_value(value)
	save_config_value()


# patch current config value with given (merge with new dictionary)
func update_partial_config_value(value: Variant) -> void:
	apply_merge_config_value(value)
	save_config_value()


# patch current config value with a specific key path and nested value
func update_nested_value(key_path: Array, nested_value: Variant) -> void:
	apply_nested_value(key_path, nested_value)
	save_config_value()


# patch current config value by removing a specific key path
func update_remove_nested_key(key_path: Array) -> void:
	apply_remove_nested_key(key_path)
	save_config_value()


# save internal [tree] var as a a new configuration value
func save_config_value(value: Variant = tree) -> void:
	ConfigStorage.set_config(get_config_group_id(), get_config_id(), value)


func apply_merge_config_value(value: Variant) -> void:
	var dictionary: Dictionary = value
	tree.merge(dictionary, true)
	apply_internal_config_value()


func apply_config_value(value: Variant) -> void:
	var dictionary: Dictionary = value
	tree = dictionary.duplicate(true)
	apply_internal_config_value()


func apply_nested_value(key_path: Array, value: Variant) -> void:
	set_nested_value(key_path, value)
	apply_internal_config_value()


func apply_remove_nested_key(key_path: Array) -> void:
	remove_nested_key(key_path)
	apply_internal_config_value()


func set_nested_value(key_path: Array, value: Variant) -> void:
	DictionaryUtils.set_nested_value(tree, key_path, value)


func remove_nested_key(key_path: Array) -> void:
	DictionaryUtils.delete_nested_key(tree, key_path)


# apply the internal [tree] var to the dictionary-based configuration
func apply_internal_config_value() -> void:
	push_error("Not Implemented")
