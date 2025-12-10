class_name ControlExpandStylebox
extends Node
## Finds a target node and edits its [StyleBox] height to expand to fill parent container.
## The resize process will re-trigger on [resized] and [visibility_changed] signals.
## NOTE: Modifies the theme override. If not found at node level, will look at the inherited theme.
## [br][br]
## Example use case is a [HSlider] to expand the height, see [MenuSliderUI].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export var target: Control
@export var theme_override_property: String = "theme_override_styles/slider"
@export var theme_inherited_property: String = "HSlider/styles/slider"

@export var expand_factor: float = 0.5:
	set(value):
		expand_factor = value
		_refresh_size()

var _parent_control: Control


func _ready() -> void:
	if target == null:
		target = get_parent()
	if target == null:
		LogWrapper.warn(self, "Target not found for parent: ", get_parent().name)
		return

	_connect_signals()


func _refresh_size() -> void:
	if _parent_control == null:
		return

	var override_stylebox: StyleBox = target.get(theme_override_property) as StyleBox
	if override_stylebox != null:
		return _resize_stylebox(override_stylebox)

	var inherited_theme: Theme = ThemeUtils.get_inherited_theme(target)
	if inherited_theme == null:
		return

	var theme_stylebox: StyleBox = inherited_theme.get(theme_inherited_property) as StyleBox
	if theme_stylebox != null:
		override_stylebox = theme_stylebox.duplicate()
		target.set(theme_override_property, override_stylebox)
		return _resize_stylebox(override_stylebox)


# resize the height of the given [StyleBox]
func _resize_stylebox(stlye_box: StyleBox) -> void:
	stlye_box.content_margin_top = int(float(_parent_control.size.y) * expand_factor / 2)
	stlye_box.content_margin_bottom = int(float(_parent_control.size.y) * expand_factor / 2)


func _connect_signals() -> void:
	if _parent_control != null:
		return

	var parent: Node = target.get_parent()
	if parent != null and is_instance_of(parent, Control):
		_parent_control = parent as Control
		_parent_control.resized.connect(_on_parent_control_resized)
		_parent_control.visibility_changed.connect(_on_parent_control_resized)


func _on_parent_control_resized() -> void:
	_refresh_size()
