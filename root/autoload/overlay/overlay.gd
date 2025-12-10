extends Control
## Container for global overlays. Currently, contains the FPS counter.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var fps_counter_margin_container: MarginContainer = %FPSCounterMarginContainer
@onready var fps_counter_label: Label = %FPSCounterLabel


func _ready() -> void:
	fps_counter_toggle(false)


func _process(_delta: float) -> void:
	if fps_counter_margin_container.visible:
		var fps: int = int(Engine.get_frames_per_second())
		fps_counter_label.text = "%d FPS" % [fps]


func is_enabled() -> bool:
	return fps_counter_margin_container.visible


func fps_counter_toggle(enabled: bool) -> void:
	fps_counter_margin_container.visible = enabled
