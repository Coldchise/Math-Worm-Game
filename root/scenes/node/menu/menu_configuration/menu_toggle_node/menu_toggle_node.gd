# Encapsulates [MenuToggleUI] instead of extending it, prefers Component Driven Design over OOP.
class_name MenuToggleNode
extends Control
## Persistent (save & load) version of the [MenuToggleUI] node, links to a [Configuration] child.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# Expose [ConfigurationController] related properties
@export_group("ConfigurationController")
## Select the configuration controller (cfg node) that will be updated by [MenuToggleUI].
@export var toggle_cfg: ConfigurationEnum.ToggleCfg = ConfigurationEnum.ToggleCfg.NULL

# Expose [MenuToggleUI] child node properties
@export_group("MenuToggleUI")
@export var title: String = "":
	set(value):
		title = value
		if not is_inside_tree():
			return
		menu_toggle_ui.title = value
@export var label_on: String = "MENU_LABEL_ON":
	set(value):
		label_on = value
		if not is_inside_tree():
			return
		menu_toggle_ui.label_on = value
@export var label_off: String = "MENU_LABEL_OFF":
	set(value):
		label_off = value
		if not is_inside_tree():
			return
		menu_toggle_ui.label_off = value
@export var padding_spaces: int = 7:
	set(value):
		padding_spaces = value
		if not is_inside_tree():
			return
		menu_toggle_ui.padding_spaces = value

# children node exports
@export_group("Nodes")
@export var menu_toggle_ui: MenuToggleUI


func _ready() -> void:
	if toggle_cfg == ConfigurationEnum.ToggleCfg.NULL:
		LogWrapper.warn(self, "Configuration controller not set.")
		return

	_set_children_node_exports()
	_connect_signals()
	_update_displayed_value()


# workaround for when exported setters (of children) fail if the scene is loaded outside scene tree
func _set_children_node_exports() -> void:
	title = title
	label_on = label_on
	label_off = label_off
	padding_spaces = padding_spaces


func _get_toggle_configuration_controller() -> ToggleConfigurationController:
	return Configuration.loader.get_toggle_configuration_controller(toggle_cfg)


func _update_displayed_value() -> void:
	var cfg_value: bool = _get_toggle_configuration_controller().get_config_value()
	menu_toggle_ui.set_value(cfg_value)

	var is_disabled: bool = _get_toggle_configuration_controller().is_disabled()
	menu_toggle_ui.toggle(is_disabled)


func _connect_signals() -> void:
	menu_toggle_ui.value_updated.connect(_on_value_updated)
	_get_toggle_configuration_controller().configuration_applied.connect(_on_configuration_applied)


# update configuration controller value after player interacts with [MenuToggleUI] child node
func _on_value_updated(enabled: bool) -> void:
	_get_toggle_configuration_controller().update_config_value(enabled)

	var toggle_cfg_name: String = EnumUtils.to_name(toggle_cfg, ConfigurationEnum.ToggleCfg)
	LogWrapper.debug(self, "ToggleCfg '%s' toggled to '%s'." % [toggle_cfg_name, enabled])


# update [MenuToggleUI] child node after some other node interacts with configuration controller
func _on_configuration_applied() -> void:
	_update_displayed_value()
