class_name ControlFocusOnHover
extends Node
## Connects [mouse_entered] signal of parent control node to action of taking focus if focusable.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var target: Node


func _ready() -> void:
	target = get_parent()
	if is_instance_of(target, Control) and "focus_mode" in target:
		target.mouse_entered.connect(_on_mouse_entered)


func _on_mouse_entered() -> void:
	if target.focus_mode != Control.FocusMode.FOCUS_NONE:
		target.grab_focus()
