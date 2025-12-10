# attaches [TwistMotion], [ControlFocusOnHover] to all [Control] nodes with [focus_mode] property
class_name UiBuilder
extends Builder
## This is a [Builder] script that builds ui scenes: [MenuScene], [GameScene].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export_group("UiBuilder")
@export var twist_component: PackedScene
@export var control_focus_on_hover: PackedScene


# Setting export variables in code instead of in the editor for clarity.
func _ready() -> void:
	# Will wait for [build] function call.
	build_on_ready = false

	condition_properties = {}

	# Will search for target nodes that have [focus_mode] property that is not [FOCUS_NONE].
	not_condition_properties = {"focus_mode": Control.FocusMode.FOCUS_NONE}

	# Will add [TwistMotion], [ControlFocusOnHover] components to target nodes.
	attach_components = [twist_component, control_focus_on_hover]

	# Will ignore target nodes of types [Tree], [GameButton].
	no_condition_classes = [Tree, GameButton]

	# Scale down the [TwistMotion] animation for larger targets: [SaveFileButton], [CodeTextEdit].
	customize = {}
	customize["SaveFileButton"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.975, "max_rotation_degrees": 1.25}
	}
	customize["CodeTextEdit"] = {
		TwistMotion:
		{"offset_target_level": 2, "max_motion_factor": 0.988, "max_rotation_degrees": 0.625}
	}

	# Will target only [Control] type nodes.
	_condition_class = Control

	if build_on_ready:
		build()
