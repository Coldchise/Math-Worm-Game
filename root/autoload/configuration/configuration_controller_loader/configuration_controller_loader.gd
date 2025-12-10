class_name ConfigurationControllerLoader
extends Node
## Contains getter methods that map enum values to configuration controllers.
## [br][br]
## Loads children of [configuration_controllers_root].
## The child name suffix must match one of: "ListCfg", "SliderCfg", "ToggleCfg", "TreeCfg".
## The child name prefix must match some [ConfigurationEnum] enum (with or without underscore).
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export var configuration_controllers_root: Node

var _config_group_map: Dictionary = {}

var _list_cfg_map: Dictionary[int, ConfigurationController] = {}
var _slider_cfg_map: Dictionary[int, ConfigurationController] = {}
var _toggle_cfg_map: Dictionary[int, ConfigurationController] = {}
var _tree_cfg_map: Dictionary[int, ConfigurationController] = {}


func _ready() -> void:
	_init_cfg_maps()


func get_configuration_controllers(
	config_group: ConfigurationEnum.Group
) -> Array[ConfigurationController]:
	return _config_group_map[config_group]


func get_list_configuration_controller(
	list_cfg: ConfigurationEnum.ListCfg
) -> ListConfigurationController:
	return _list_cfg_map[list_cfg]


func get_slider_configuration_controller(
	cfg: ConfigurationEnum.SliderCfg
) -> SliderConfigurationController:
	return _slider_cfg_map[cfg]


func get_toggle_configuration_controller(
	toggle_cfg: ConfigurationEnum.ToggleCfg
) -> ToggleConfigurationController:
	return _toggle_cfg_map[toggle_cfg]


func get_tree_configuration_controller(
	tree_cfg: ConfigurationEnum.TreeCfg
) -> TreeConfigurationController:
	return _tree_cfg_map[tree_cfg]


func _init_cfg_maps() -> void:
	NodeUtils.apply_function_to_all_children(configuration_controllers_root, _init_cfg_map_on_child)


func _init_cfg_map_on_child(node: Node) -> void:
	if is_instance_of(node, TreeConfigurationController):
		_init_cfg_map_entry(node, ConfigurationEnum.TreeCfg, "TreeCfg", _tree_cfg_map)
	elif is_instance_of(node, ToggleConfigurationController):
		_init_cfg_map_entry(node, ConfigurationEnum.ToggleCfg, "ToggleCfg", _toggle_cfg_map)
	elif is_instance_of(node, SliderConfigurationController):
		_init_cfg_map_entry(node, ConfigurationEnum.SliderCfg, "SliderCfg", _slider_cfg_map)
	elif is_instance_of(node, ListConfigurationController):
		_init_cfg_map_entry(node, ConfigurationEnum.ListCfg, "ListCfg", _list_cfg_map)
	else:
		LogWrapper.debug(self, "Skipped loading configuration controller '%s'." % node.name)


func _init_cfg_map_entry(
	node: ConfigurationController, enum_class: Variant, suffix: String, map: Dictionary
) -> void:
	var node_name: String = node.name.split(suffix)[0]
	var enum_value: int = EnumUtils.from_name(node_name, enum_class)
	map[enum_value] = node

	var config_group: ConfigurationEnum.Group = node.config_group
	if _config_group_map.has(config_group):
		_config_group_map[config_group].append(node)
	else:
		var array: Array[ConfigurationController] = []
		array.append(node)
		_config_group_map[config_group] = array
