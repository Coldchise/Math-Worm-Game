@tool
class_name MenuToggleUI
extends MarginContainer
## Localized toggle button with title label. [br]
## Emits a [value_updated] signal.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal value_updated(enabled: bool)

# Expose main properties
@export_group("MenuToggleUI")
@export var title: String = "":
	set(value):
		title = value
		_set_title()
@export var label_on: String = "":
	set(value):
		label_on = value
		_update_toggle_button_text()
@export var label_off: String = "":
	set(value):
		label_off = value
		_update_toggle_button_text()
@export var padding_spaces: int = 7:
	set(value):
		padding_spaces = value
		_update_toggle_button_text()

# children node exports
@export_group("Nodes")
@export var toggle_button: Button
@export var title_label: Label


func _ready() -> void:
	_connect_signals()
	set_value()


func set_value(enabled: bool = false) -> void:
	toggle_button.button_pressed = enabled
	_update_toggle_button_text()


func get_value() -> bool:
	return toggle_button.button_pressed


func toggle(is_disabled: bool) -> void:
	toggle_button.disabled = is_disabled


func _set_title() -> void:
	title_label.text = TranslationServerWrapper.translate(title)


func _update_toggle_button_text() -> void:
	if toggle_button.button_pressed:
		toggle_button.text = TranslationServerWrapper.translate(label_on)
	else:
		toggle_button.text = TranslationServerWrapper.translate(label_off)
	toggle_button.text = StringUtils.add_padding(toggle_button.text, padding_spaces)


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	SignalBus.language_changed.connect(_on_language_changed)
	toggle_button.pressed.connect(_on_toggle_button_pressed)


func _on_language_changed(_locale: String) -> void:
	_set_title()
	_update_toggle_button_text()


func _on_toggle_button_pressed() -> void:
	value_updated.emit(toggle_button.button_pressed)
