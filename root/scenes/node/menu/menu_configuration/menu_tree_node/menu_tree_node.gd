# Encapsulates [MenuTreeUI] instead of extending it, prefers Component Driven Design over OOP.
class_name MenuTreeNode
extends Control
## Persistent (save & load) version of the [MenuTreeUI] node, links to a [Configuration] child.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# expose [ConfigurationController] related properties
@export_group("ConfigurationController")
## Select the configuration controller (list cfg node) that will be updated by [MenuTreeUI].
@export var tree_cfg: ConfigurationEnum.TreeCfg = ConfigurationEnum.TreeCfg.NULL

# expose [MenuTreeUI] child node properties
@export_group("MenuTreeUI")
## Will not set add button to last level.
@export var max_levels: int = 2:
	set(value):
		max_levels = value
		if not is_inside_tree():
			return
		menu_tree_ui.max_levels = value
## If false, will not set del button to first level.
@export var is_first_level_removable: bool = false:
	set(value):
		is_first_level_removable = value
		if not is_inside_tree():
			return
		menu_tree_ui.is_first_level_removable = value
@export var add_button_texture: Texture2D:
	set(value):
		add_button_texture = value
		if not is_inside_tree():
			return
		menu_tree_ui.add_button_texture = value
@export var del_button_texture: Texture2D:
	set(value):
		del_button_texture = value
		if not is_inside_tree():
			return
		menu_tree_ui.del_button_texture = value

# children node exports
@export_group("Nodes")
@export var menu_tree_ui: MenuTreeUI


func _ready() -> void:
	if tree_cfg == ConfigurationEnum.TreeCfg.NULL:
		LogWrapper.warn(self, "Configuration controller not set.")
		return

	_set_children_node_exports()
	_connect_signals()
	_set_displayed_values()


# workaround for when exported setters (of children) fail if the scene is loaded outside scene tree
func _set_children_node_exports() -> void:
	max_levels = max_levels
	is_first_level_removable = is_first_level_removable
	add_button_texture = add_button_texture
	del_button_texture = del_button_texture


func _get_tree_configuration_controller() -> TreeConfigurationController:
	return Configuration.loader.get_tree_configuration_controller(tree_cfg)


func _set_displayed_values() -> void:
	var resource_dictionary: Dictionary = _get_tree_configuration_controller().get_config_resource()
	var title_mappers: Dictionary = _get_tree_configuration_controller().get_config_title_mappers()
	menu_tree_ui.set_items(resource_dictionary, title_mappers)


func _connect_signals() -> void:
	menu_tree_ui.tree_item_button_clicked.connect(_on_tree_item_button_clicked)
	_get_tree_configuration_controller().configuration_applied.connect(_on_configuration_applied)


# NOTE: connect and handle this signal in parent node
func _on_tree_item_button_clicked(_tree_item: TreeItem, _is_add_button: bool) -> void:
	pass


# update [MenuTreeUI] child node after some other node interacts with configuration controller
func _on_configuration_applied() -> void:
	_set_displayed_values()
