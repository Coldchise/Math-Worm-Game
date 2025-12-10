# Encapsulates [MenuDropdownUI] instead of extending it, prefers Component Driven Design over OOP.
class_name MenuDropdownNode
extends Control
## Persistent (save & load) version of the [MenuDropdownUI] node, links to a [Configuration] child.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# expose [ConfigurationController] related properties
@export_group("ConfigurationController")
## Select the configuration controller (list cfg node) that will be updated by [MenuDropdownUI].
@export var list_cfg: ConfigurationEnum.ListCfg = ConfigurationEnum.ListCfg.NULL

# expose [MenuDropdownUI] child node properties
@export_group("MenuDropdownUI")
@export var title: String = "":
	set(value):
		title = value
		if not is_inside_tree():
			return
		menu_dropdown_ui.title = value
@export var option_titles_padding: int = 3:
	set(value):
		option_titles_padding = value
		if not is_inside_tree():
			return
		menu_dropdown_ui.option_titles_padding = value

# children node exports
@export_group("Nodes")
@export var menu_dropdown_ui: MenuDropdownUI


func _ready() -> void:
	if list_cfg == ConfigurationEnum.ListCfg.NULL:
		LogWrapper.warn(self, "Configuration controller not set.")
		return

	_set_children_node_exports()
	_connect_signals()
	_initialize()
	_update_displayed_value()


# workaround for when exported setters (of children) fail if the scene is loaded outside scene tree
func _set_children_node_exports() -> void:
	title = title
	option_titles_padding = option_titles_padding


func _get_list_configuration_controller() -> ListConfigurationController:
	return Configuration.loader.get_list_configuration_controller(list_cfg)


func _initialize() -> void:
	var cfg_options: ListConfigurationController.CfgOptions = (
		_get_list_configuration_controller().get_cfg_options()
	)
	menu_dropdown_ui.set_option_titles(
		cfg_options.options.get_keys(), cfg_options.disabled_options, cfg_options.hide_disabled
	)


func _update_displayed_value() -> void:
	var cfg_value_index: int = _get_list_configuration_controller().get_config_value_index()
	menu_dropdown_ui.set_option_index(cfg_value_index)

	var is_disabled: bool = _get_list_configuration_controller().is_disabled()
	menu_dropdown_ui.toggle(is_disabled)

	# sometimes cfg is disabled because it is always overriden by external platform
	# for example: window resolution (size) in web browser
	if cfg_value_index == -1 and is_disabled:
		var cfg_default_index: int = _get_list_configuration_controller().get_default_value_index()
		menu_dropdown_ui.set_option_index(cfg_default_index)


func _connect_signals() -> void:
	menu_dropdown_ui.value_updated.connect(_on_value_updated)
	_get_list_configuration_controller().configuration_applied.connect(_on_configuration_applied)
	_get_list_configuration_controller().option_disabled.connect(_on_option_disabled)


# update configuration controller value after player interacts with [MenuDropdownUI] child node
func _on_value_updated(value_index: int) -> void:
	_get_list_configuration_controller().update_config_value_index(value_index)

	var list_cfg_name: String = EnumUtils.to_name(list_cfg, ConfigurationEnum.ListCfg)
	LogWrapper.debug(self, "ListCfg '%s' value changed to '%s'." % [list_cfg_name, value_index])


# update [MenuDropdownUI] child node after some other node interacts with configuration controller
func _on_configuration_applied() -> void:
	_update_displayed_value()


func _on_option_disabled(option_label: String) -> void:
	menu_dropdown_ui.disable_option_title(option_label)
