@tool
class_name MenuDropdownUI
extends MarginContainer
## Localized option button (list of option titles) with title label. [br]
## Emits a [value_updated] signal.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal value_updated(value_index: int)

# expose main properties
@export_group("MenuDropdownUI")
@export var title: String = "":
	set(value):
		title = value
		_set_title()
@export var option_titles_padding: int = 3
@export var hide_disabled_option_titles: bool = false
@export var option_titles: Array[String] = []
@export var disabled_option_titles: Dictionary = {}

# children node exports
# (@export vars are set at all times, @onready vars are set after _ready)
# (@tool script runs inside editor and needs access to some vars at all times)
@export_group("Nodes")
@export var option_button: OptionButton
@export var title_label: Label

# track overriden properties in [disable] function so [enable] function can revert them:
var _overriden_focus_mode: FocusMode


func _ready() -> void:
	_connect_signals()


func set_option_titles(
	new_option_titles: Array[String],
	new_disabled_option_titles: Dictionary = {},
	new_hide_disabled_option_titles: bool = hide_disabled_option_titles
) -> void:
	option_titles = new_option_titles
	disabled_option_titles = new_disabled_option_titles
	hide_disabled_option_titles = new_hide_disabled_option_titles
	_set_option_titles()


func disable_option_title(option_title: String) -> void:
	disabled_option_titles[option_title] = true
	var item_index: int = option_titles.find(option_title)
	if item_index != -1:
		option_button.set_item_disabled(item_index, true)


func get_option_index() -> int:
	return option_button.selected


func set_option_index(index: int = -1) -> void:
	if index >= option_button.item_count:
		LogWrapper.warn(self, "Index out of bounds: ", index)
		return
	option_button.select(index)


func toggle(is_disabled: bool) -> void:
	if is_disabled:
		disable()
	else:
		enable()


func disable() -> void:
	if not option_button.disabled:
		_overriden_focus_mode = option_button.focus_mode
		option_button.disabled = true
		option_button.focus_mode = FocusMode.FOCUS_NONE


func enable() -> void:
	if option_button.disabled:
		option_button.disabled = false
		option_button.focus_mode = _overriden_focus_mode


func _set_option_titles() -> void:
	var selected_index: int = get_option_index()

	option_button.clear()
	for option_title: String in option_titles:
		var is_disabled: bool = disabled_option_titles.get(option_title, false)
		if is_disabled and hide_disabled_option_titles:
			continue
		var localized_text: String = TranslationServerWrapper.translate(option_title)
		option_button.add_item(StringUtils.add_padding(localized_text, option_titles_padding))
		var item_index: int = option_button.item_count - 1
		option_button.set_item_disabled(item_index, is_disabled)

	set_option_index(selected_index)


func _set_title() -> void:
	title_label.text = TranslationServerWrapper.translate(title)


func _hide_option_button_popup() -> void:
	option_button.get_popup().visible = false


func _connect_signals() -> void:
	if Engine.is_editor_hint():
		return

	SignalBus.language_changed.connect(_on_language_changed)

	option_button.item_selected.connect(_on_option_button_item_selected)

	get_tree().get_root().size_changed.connect(_on_root_size_changed)


func _on_language_changed(_locale: String) -> void:
	_set_title()
	_set_option_titles()


func _on_option_button_item_selected(index: int) -> void:
	value_updated.emit(index)


func _on_root_size_changed() -> void:
	_hide_option_button_popup.call_deferred()
