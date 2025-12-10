class_name TwistMotion
extends Motion
## Extension of [Motion] that animates [scale] and [rotation] properties of target(s).
## Set export variables to get a desired effect intensity and variation.
## [br][br]
## Use [add_motion] func to apply motion or set the trigger signals in export variables.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export var max_rotation_degrees: float = 2.5

var _sign: int = 0


func _ready() -> void:
	super.initialize(Control)


func _motion_transform(target: Node) -> void:
	target.scale = _original_target_values[target]["scale"] * motion_factor

	# normalized_factor goes from 0 to 1 regardless of min and max motion factor
	var normalized_factor: float = (
		(motion_factor - min_motion_factor) / (max_motion_factor - min_motion_factor)
	)
	var rotation_offset: float = _sign * deg_to_rad(normalized_factor * max_rotation_degrees)
	target.rotation = _original_target_values[target]["rotation"] - rotation_offset


func _set_target_original_values(target: Node) -> void:
	_original_target_values[target] = {"scale": target.scale, "rotation": target.rotation}


func reset_motion_tween() -> void:
	_sign = 1 - (randi_range(0, 1) * 2)
	super.reset_motion_tween()
