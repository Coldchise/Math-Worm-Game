class_name MenuSaveFile
extends MarginContainer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal save_file_pressed(index: int)
signal save_file_button_pressed(button_type: ButtonType)

enum ButtonType { PLAY, EXPORT, IMPORT, DELETE, RENAME }

const NAME_TITLE: String = "MENU_NAME"
const TIME_TITLE: String = "GAME_OBJECTIVE_TIME"

var index: int = -1

@onready var name_title_label: Label = %NameTitleLabel
@onready var name_value_label: Label = %NameValueLabel
@onready var name_value_line_edit: LineEdit = %NameValueLineEdit

@onready var playtime_title_label: Label = %PlaytimeTitleLabel
@onready var playtime_time_label: Label = %PlaytimeTimeLabel
@onready var playtime_datetime_label: Label = %PlaytimeDatetimeLabel

@onready var save_file_button: Button = %SaveFileButton

@onready var buttons_margin_container: MarginContainer = %ButtonsMarginContainer
@onready var play_save_menu_button: MenuButtonClass = %PlaySaveMenuButton
@onready var export_save_menu_button: MenuButtonClass = %ExportSaveMenuButton
@onready var import_save_menu_button: MenuButtonClass = %ImportSaveMenuButton
@onready var delete_save_menu_button: MenuButtonClass = %DeleteSaveMenuButton
@onready var rename_save_menu_button: MenuButtonClass = %RenameSaveMenuButton


func _ready() -> void:
	_connect_signals()
	_refresh_title_labels()


func toggle_name_edit(enabled: bool) -> void:
	if enabled:
		name_value_line_edit.text = name_value_label.text
		name_value_label.visible = false
		name_value_line_edit.visible = true
		name_value_line_edit.grab_focus()
	else:
		if name_value_label.text != name_value_line_edit.text and name_value_line_edit.text != "":
			Data.rename_save_file_index(index, name_value_line_edit.text)
		name_value_label.text = name_value_line_edit.text
		name_value_label.visible = true
		name_value_line_edit.visible = false


func set_index(new_index: int) -> void:
	index = new_index


func set_value_labels(
	save_file_name: String, playtime_seconds: int, modified_at_datetime: Dictionary
) -> void:
	name_value_label.text = save_file_name
	name_value_line_edit.text = save_file_name
	playtime_time_label.text = DatetimeUtils.format_seconds(playtime_seconds)
	playtime_datetime_label.text = DatetimeUtils.format_datetime(
		modified_at_datetime, "{z}.{x}.{y} {h}:{m}"
	)

	var never_played: bool = playtime_seconds == 0 or modified_at_datetime.is_empty()
	if never_played:
		playtime_time_label.text = "---------------"
		playtime_datetime_label.text = "-------------------------"


func _refresh_title_labels() -> void:
	name_title_label.text = TranslationServerWrapper.translate(NAME_TITLE)
	playtime_title_label.text = TranslationServerWrapper.translate(TIME_TITLE)

	buttons_margin_container.visible = false
	toggle_name_edit(false)


func _connect_signals() -> void:
	save_file_button.pressed.connect(_on_save_file_pressed)
	save_file_button.toggled.connect(_on_save_file_button_toggled)

	name_value_line_edit.focus_exited.connect(_on_name_value_line_edit_focus_exited)
	name_value_line_edit.text_submitted.connect(_on_name_value_line_edit_text_submitted)

	SignalBus.language_changed.connect(_on_language_changed)

	play_save_menu_button.confirmed.connect(_on_button_confirmed.bind(ButtonType.PLAY))
	export_save_menu_button.confirmed.connect(_on_button_confirmed.bind(ButtonType.EXPORT))
	import_save_menu_button.confirmed.connect(_on_button_confirmed.bind(ButtonType.IMPORT))
	delete_save_menu_button.confirmed.connect(_on_button_confirmed.bind(ButtonType.DELETE))
	rename_save_menu_button.confirmed.connect(_on_button_confirmed.bind(ButtonType.RENAME))


func _on_save_file_pressed() -> void:
	save_file_pressed.emit(index)


func _on_save_file_button_toggled(toggled_on: bool) -> void:
	buttons_margin_container.visible = toggled_on
	if toggled_on:
		play_save_menu_button.grab_focus()


func _on_name_value_line_edit_focus_exited() -> void:
	toggle_name_edit(false)


func _on_name_value_line_edit_text_submitted(_new_text: String) -> void:
	rename_save_menu_button.grab_focus()


func _on_language_changed(_locale: String) -> void:
	_refresh_title_labels()


func _on_button_confirmed(button_type: ButtonType) -> void:
	save_file_button_pressed.emit(button_type)
