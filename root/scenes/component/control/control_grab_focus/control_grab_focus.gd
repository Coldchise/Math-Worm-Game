class_name ControlGrabFocus
extends Node
## Provides accessibility to keyboard players and controller players.
## Grabs focus on first focusable child of target control node, if visible in tree.
## [br][br]
## Attach to parent node. Sets target as first control node child if target is not already set.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export var target: Control
## Remembers new focus (if changed anytime) and re-grabs it again when target becomes visible again.
@export var remember_last_focus: bool = true
## If target is not focusable, searches among children of target until a valid ancestor is found.
@export var recursive: bool = false
## If true, will delay [_ready] function to custom [ready] function call.
@export var manual: bool = false

var _ready_called: bool = false


func _ready() -> void:
	if not manual:
		ready()


func ready() -> void:
	if _ready_called:
		LogWrapper.debug(self, "Ready already called.")
		return
	_ready_called = true

	if target == null:
		target = _get_focusable_control_child(self.get_parent())

	if target == null:
		LogWrapper.debug(
			self, "Could not find focusable target for parent: ", self.get_parent().name
		)
		return

	_connect_signals()
	grab_focus.call_deferred()


func grab_focus() -> void:
	if target != null and target.is_visible_in_tree():
		target.grab_focus()


func _get_focusable_control_child(node: Node) -> Control:
	for child: Node in node.get_children(true):
		if is_instance_of(child, Control) and child.visible:
			if (child as Control).focus_mode != Control.FocusMode.FOCUS_NONE:
				return child
		if recursive:
			var focusable: Node = _get_focusable_control_child(child)
			if focusable != null:
				return focusable
	return null


func _connect_signals() -> void:
	get_viewport().connect("gui_focus_changed", _on_gui_focus_changed)
	target.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	grab_focus.call_deferred()


func _on_gui_focus_changed(control: Control) -> void:
	if remember_last_focus and get_parent() == control.get_parent() and target != control:
		target = control
