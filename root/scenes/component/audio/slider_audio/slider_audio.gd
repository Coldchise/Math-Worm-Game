# unlike [ButtonAudio], does not continue to search for [target] in descendant nodes
# (there are no built-in nodes with internal [Slider] nodes, so this is not necessary)
class_name SliderAudio
extends Node
## Emits audio events on target [Slider] signals (drag started, drag ended).
## [br][br]
## Attach to parent node of type [Slider].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Sets target as parent if target is not already set.
@export var target: Slider

@export_category("Sounds")
@export var drag_started: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var drag_ended: AudioEnum.Sfx = AudioEnum.Sfx.CLICK


func _ready() -> void:
	if target == null:
		target = get_parent()
	if target == null:
		LogWrapper.warn(self, "Target not found for parent: ", get_parent().name)
		return

	_connect_signals()


func _connect_signals() -> void:
	target.drag_started.connect(_on_target_drag_started)
	target.drag_ended.connect(_on_target_drag_ended)


func _on_target_drag_started() -> void:
	if _is_set(drag_started):
		AudioManagerWrapper.play_sfx(drag_started)

	LogWrapper.debug(
		self, "Slider sfx drag started: ", EnumUtils.to_name(drag_started, AudioEnum.Sfx)
	)


func _on_target_drag_ended(_value_changed: bool) -> void:
	if _is_set(drag_ended):
		AudioManagerWrapper.play_sfx(drag_ended)

	LogWrapper.debug(self, "Slider sfx drag ended: ", EnumUtils.to_name(drag_ended, AudioEnum.Sfx))


func _is_set(event: AudioEnum.Sfx) -> bool:
	return target != null and event != AudioEnum.Sfx.NULL
