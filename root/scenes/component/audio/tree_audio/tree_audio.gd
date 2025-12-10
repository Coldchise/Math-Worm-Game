# unlike [ButtonAudio], does not continue to search for [target] in descendant nodes
# (there are no built-in nodes with internal [Slider] nodes, so this is not necessary)
class_name TreeAudio
extends Node
## Emits audio events on target [Tree] signals (cell selected, button clicked).
## [br][br]
## Attach to parent node of type [Tree].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Sets target as parent if target is not already set.
@export var target: Tree

@export_category("Sounds")
@export var cell_selected: AudioEnum.Sfx = AudioEnum.Sfx.SELECT
@export var button_clicked: AudioEnum.Sfx = AudioEnum.Sfx.CLICK


func _ready() -> void:
	if target == null:
		target = get_parent()
	if target == null:
		LogWrapper.warn(self, "Target not found for parent: ", get_parent().name)
		return

	_connect_signals()


func _connect_signals() -> void:
	target.cell_selected.connect(_on_cell_selected)
	target.button_clicked.connect(_on_button_clicked)


func _on_cell_selected() -> void:
	if _is_set(cell_selected):
		AudioManagerWrapper.play_sfx(cell_selected)

	LogWrapper.debug(
		self, "Tree sfx drag started: ", EnumUtils.to_name(cell_selected, AudioEnum.Sfx)
	)


func _on_button_clicked(_item: TreeItem, _column: int, _id: int, _mouse_button_index: int) -> void:
	if _is_set(button_clicked):
		AudioManagerWrapper.play_sfx(button_clicked)

	LogWrapper.debug(
		self, "Tree sfx drag ended: ", EnumUtils.to_name(button_clicked, AudioEnum.Sfx)
	)


func _is_set(event: AudioEnum.Sfx) -> bool:
	return target != null and event != AudioEnum.Sfx.NULL
