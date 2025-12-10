class_name ScaleMotion
extends Motion
## Extension of [Motion] that animates [scale] property of target(s).
## Set export variables to get a desired effect intensity and variation.
## [br][br]
## Use [add_motion] func to apply motion or set the trigger signals in export variables.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func _ready() -> void:
	super.initialize(Control)


# do not modify font size during project runtime
# - https://github.com/godotengine/godot/issues/35836#issuecomment-581083643
func _motion_transform(target: Node) -> void:
	target.scale = _original_target_values[target] * motion_factor


func _set_target_original_values(target: Node) -> void:
	_original_target_values[target] = target.scale
