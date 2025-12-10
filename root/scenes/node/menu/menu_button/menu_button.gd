@tool
class_name MenuButtonClass
extends Button
## Localized button that refreshes text on language selected signal, emits [confirmed] signal.
## If [confirm_label] label is not set, the [confirmed] signal acts as regular [pressed] signal.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal confirmed

@export var label: String = "":
	set(value):
		label = value
		_refresh_label()

## If set, button need to be clicked twice to emit signal. (First will switch to confirm label.)
@export var confirm_label: String = "":
	set(value):
		confirm_label = value
		_refresh_label()

@export var padding_spaces: int = 7:
	set(value):
		padding_spaces = value
		_refresh_label()

# tracks confirm state if confirm_label is set
var confirm: bool = false


func _ready() -> void:
	_connect_signals()
	_refresh_label()


func _refresh_label() -> void:
	self.text = _get_button_text()


func _get_button_text() -> String:
	var label_text: String = label if not confirm else confirm_label
	var localized_text: String = TranslationServerWrapper.translate(label_text)
	return StringUtils.add_padding(localized_text, padding_spaces)


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	SignalBus.language_changed.connect(_on_language_changed)

	self.pressed.connect(_on_button_pressed)
	self.focus_exited.connect(_on_button_focus_exited)


func _on_language_changed(_locale: String) -> void:
	_refresh_label()


func _on_button_pressed() -> void:
	if confirm_label != "":
		if not confirm:
			confirm = true
			_refresh_label()
			return
		if confirm:
			confirm = false
			_refresh_label()

	LogWrapper.debug(self, "Menu button pressed.")

	confirmed.emit()


func _on_button_focus_exited() -> void:
	if confirm_label != "":
		if confirm:
			confirm = false
			_refresh_label()
