class_name ControlsOptionsContainer
extends OptionsContainer
## Manager Controls Keybinds options.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var _keybinds_action: StringName = &""
var _keybinds_input: InputEvent = null

@onready var keybinds_map_margin_container: MarginContainer = %KeybindsMapMarginContainer
@onready var menu_tree_node: MenuTreeNode = %MenuTreeNode

@onready var menu_unbind_dialog: MenuUnbindDialog = %MenuUnbindDialog
@onready var menu_bind_dialog: MenuBindDialog = %MenuBindDialog


func _ready() -> void:
	_connect_signals()


func get_config_group() -> ConfigurationEnum.Group:
	return ConfigurationEnum.Group.CONTROLS


func get_keybinds_tree_cfg() -> KeybindsTreeCfg:
	var tree_cfg: ConfigurationEnum.TreeCfg = ConfigurationEnum.TreeCfg.KEYBINDS
	return Configuration.loader.get_tree_configuration_controller(tree_cfg)


func add_keybind(action: StringName, input_event: InputEvent) -> void:
	if action == &"" or input_event == null:
		return
	get_keybinds_tree_cfg().update_nested_value([action, input_event], true)


func remove_keybind(action: StringName, input_event: InputEvent) -> void:
	if action == &"" or input_event == null:
		return
	get_keybinds_tree_cfg().update_nested_value([action, input_event], false)


func _connect_signals() -> void:
	menu_tree_node.menu_tree_ui.tree_item_button_clicked.connect(_on_tree_item_button_clicked)

	menu_unbind_dialog.confirmed.connect(_on_delete_dialog_confirmed)

	menu_bind_dialog.confirmed.connect(_on_record_dialog_confirmed)
	menu_bind_dialog.keybinds_input_recorded.connect(_on_keybinds_input_recorded)


func _on_tree_item_button_clicked(tree_item: TreeItem, _button_id: int) -> void:
	var metadata: Variant = tree_item.get_metadata(0)
	if metadata is StringName or metadata is String:
		_on_keybind_item_add_button_event(metadata, tree_item.get_text(0))
	elif metadata is InputEvent:
		var parent_tree_item: TreeItem = tree_item.get_parent()
		_on_keybind_item_del_button_event(
			parent_tree_item.get_metadata(0),
			metadata,
			tree_item.get_text(0),
			parent_tree_item.get_text(0)
		)


func _on_keybind_item_add_button_event(action: StringName, item_text: String) -> void:
	_keybinds_action = action
	menu_bind_dialog.custom_popup(item_text, keybinds_map_margin_container)


func _on_keybind_item_del_button_event(
	action: StringName, input: InputEvent, item_text: String, parent_item_text: String
) -> void:
	_keybinds_action = action
	_keybinds_input = input
	menu_unbind_dialog.custom_popup(parent_item_text, item_text)


func _on_delete_dialog_confirmed() -> void:
	remove_keybind(_keybinds_action, _keybinds_input)
	_keybinds_action = &""
	_keybinds_input = null


func _on_record_dialog_confirmed() -> void:
	add_keybind(_keybinds_action, _keybinds_input)
	_keybinds_action = &""
	_keybinds_input = null


func _on_keybinds_input_recorded(input: InputEvent) -> void:
	_keybinds_input = input
