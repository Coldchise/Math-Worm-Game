# Encapsulates [MenuSliderUI] instead of extending it, prefers Component Driven Design over OOP.
class_name MenuSliderNode
extends Control
## Persistent (save & load) version of the [MenuSliderUI] node, links to a [Configuration] child.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# expose [ConfigurationController] related properties
@export_group("ConfigurationController")
## Select the configuration controller (cfg node) that will be updated by [MenuSliderUI].
@export var slider_cfg: ConfigurationEnum.SliderCfg = ConfigurationEnum.SliderCfg.NULL

# expose [MenuSliderUI] child node properties
@export_group("MenuSliderUI")
@export var title: String = "":
	set(value):
		title = value
		if not is_inside_tree():
			return
		menu_slider_ui.title = value
@export var value_suffix: String = "":
	set(value):
		value_suffix = value
		if not is_inside_tree():
			return
		menu_slider_ui.value_suffix = value
@export var min_value: float = 0:
	set(value):
		min_value = value
		if not is_inside_tree():
			return
		menu_slider_ui.min_value = value
@export var max_value: float = 100:
	set(value):
		max_value = value
		if not is_inside_tree():
			return
		menu_slider_ui.max_value = value
@export var step: float = 1:
	set(value):
		step = value
		if not is_inside_tree():
			return
		menu_slider_ui.step = value
@export var slider_stretch_ratio: float = 1.0:
	set(value):
		slider_stretch_ratio = value
		if not is_inside_tree():
			return
		menu_slider_ui.slider_stretch_ratio = value
## Emits signal [value_updated] depending on the mode.
## [br] Use ON_SLIDE for live updates to preview changes right away.
## [br] Use ON_RELEASE when the update signal triggers an expensive function.
@export var slider_update_mode: MenuSliderUI.UpdateMode = MenuSliderUI.UpdateMode.ON_SLIDE:
	set(value):
		slider_update_mode = value
		menu_slider_ui.slider_update_mode = value

# children node exports
@export_group("Nodes")
@export var menu_slider_ui: MenuSliderUI


func _ready() -> void:
	if slider_cfg == ConfigurationEnum.SliderCfg.NULL:
		LogWrapper.warn(self, "Configuration controller not set.")
		return

	_set_children_node_exports()
	_connect_signals()
	_update_displayed_value()


# workaround for when exported setters (of children) fail if the scene is loaded outside scene tree
func _set_children_node_exports() -> void:
	title = title
	value_suffix = value_suffix
	min_value = min_value
	max_value = max_value
	step = step
	slider_stretch_ratio = slider_stretch_ratio
	slider_update_mode = slider_update_mode


func _get_slider_configuration_controller() -> ConfigurationController:
	return Configuration.loader.get_slider_configuration_controller(slider_cfg)


func _update_displayed_value() -> void:
	var cfg_value: float = _get_slider_configuration_controller().get_config_value()
	menu_slider_ui.set_value(cfg_value)

	var is_disabled: bool = _get_slider_configuration_controller().is_disabled()
	menu_slider_ui.toggle(is_disabled)


func _connect_signals() -> void:
	menu_slider_ui.value_updated.connect(_on_value_updated)
	_get_slider_configuration_controller().configuration_applied.connect(_on_configuration_applied)


# update configuration controller value after player interacts with [MenuSliderUI] child node
func _on_value_updated(value: float) -> void:
	_get_slider_configuration_controller().update_config_value(value)

	var slider_cfg_name: String = EnumUtils.to_name(slider_cfg, ConfigurationEnum.SliderCfg)
	LogWrapper.debug(self, "SliderCfg '%s' value changed to '%s'." % [slider_cfg_name, value])


# update [MenuSliderUI] child node after some other node interacts with configuration controller
func _on_configuration_applied() -> void:
	_update_displayed_value()
