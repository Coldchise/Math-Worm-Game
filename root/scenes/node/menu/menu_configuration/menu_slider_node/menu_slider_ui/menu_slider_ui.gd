@tool
class_name MenuSliderUI
extends MarginContainer
## Localized slider with accessibility button, title and value labels. [br]
## Buttons and slider emit a [value_updated] signal.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal value_updated(value: float)

enum UpdateMode { ON_RELEASE, ON_SLIDE }

# expose main properties
@export_group("MenuSliderUI")
@export var title: String = "":
	set(value):
		title = value
		_set_title()
@export var value_suffix: String = "":
	set(value):
		value_suffix = value
		_set_value()
@export var min_value: float = 0:
	set(value):
		min_value = value
		_set_min_value()
@export var max_value: float = 100:
	set(value):
		max_value = value
		_set_max_value()
@export var step: float = 1:
	set(value):
		step = value
		_set_step()
@export var slider_stretch_ratio: float = 1.0:
	set(value):
		slider_stretch_ratio = value
		_set_slider_stretch_ratio()
## Emits signal [value_updated] depending on the mode.
## [br] Use ON_SLIDE for live updates to preview changes right away.
## [br] Use ON_RELEASE when the update signal triggers an expensive function.
@export var slider_update_mode: UpdateMode = UpdateMode.ON_SLIDE
@export var big_increment: float = 10
@export var small_increment: float = 1
@export var small_decrement: float = -1
@export var big_decrement: float = -10

# children node exports
# (@export vars are set at all times, @onready vars are set after _ready)
# (@tool script runs inside editor and needs access to some vars at all times)
@export_group("Nodes")
@export var h_slider: HSlider
@export var title_label: Label
@export var value_label: Label

# keeps track so [value_updated] signal does not trigger when value is not really updated
var _last_value: float

@onready var decrement_slider_button: Button = %DecrementSliderButton
@onready var decrement_step_slider_button: Button = %DecrementStepSliderButton
@onready var increment_slider_button: Button = %IncrementSliderButton
@onready var increment_step_slider_button: Button = %IncrementStepSliderButton
@onready var slider_margin_container: MarginContainer = %SliderMarginContainer


func _ready() -> void:
	_connect_signals()
	set_value()


func set_value(value: float = 0) -> void:
	_last_value = value
	h_slider.value = value
	_set_value()


func get_value() -> float:
	return h_slider.value


func toggle(is_disabled: bool) -> void:
	h_slider.editable = not is_disabled
	decrement_slider_button.disabled = is_disabled
	decrement_step_slider_button.disabled = is_disabled
	increment_slider_button.disabled = is_disabled
	increment_step_slider_button.disabled = is_disabled


func _set_title() -> void:
	title_label.text = TranslationServerWrapper.translate(title)


func _set_value() -> void:
	value_label.text = str(int(h_slider.value)) + value_suffix


func _set_min_value() -> void:
	h_slider.min_value = min_value


func _set_max_value() -> void:
	h_slider.max_value = max_value


func _set_step() -> void:
	h_slider.step = step


func _set_slider_stretch_ratio() -> void:
	slider_margin_container.size_flags_stretch_ratio = slider_stretch_ratio


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	SignalBus.language_changed.connect(_on_language_changed)

	h_slider.value_changed.connect(_on_slider_value_changed)
	h_slider.drag_ended.connect(_on_slider_drag_ended)
	decrement_slider_button.pressed.connect(_on_slider_updated.bind(big_decrement))
	decrement_step_slider_button.pressed.connect(_on_slider_updated.bind(small_decrement))
	increment_slider_button.pressed.connect(_on_slider_updated.bind(big_increment))
	increment_step_slider_button.pressed.connect(_on_slider_updated.bind(small_increment))


func _on_language_changed(_locale: String) -> void:
	_set_title()


func _on_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	if not (slider_update_mode == UpdateMode.ON_RELEASE):
		return

	var value: float = h_slider.value

	_set_value()

	value_updated.emit(value)


func _on_slider_value_changed(value: float) -> void:
	if not (slider_update_mode == UpdateMode.ON_SLIDE):
		return
	_on_slider_updated(h_slider.value - value)


func _on_slider_updated(increment: float) -> void:
	var value: float = min(h_slider.max_value, max(h_slider.min_value, h_slider.value + increment))
	if value == _last_value:
		return

	_last_value = value
	if h_slider.value != value:
		h_slider.value = value
	_set_value()

	value_updated.emit(value)
