## Modified File MIT License Copyright (c) 2024 TinyTakinTeller
class_name MenuTextboxDialog
extends ConfirmationDialog

signal confirmed_action(textbox_mode: TextboxMode, text: String, index: int)

enum TextboxMode { NONE, EXPORT, IMPORT }

const CONFIRM_LABEL: String = "MENU_LABEL_CONFIRM_BUTTON_YOU"
const CANCEL_LABEL: String = "MENU_LABEL_CANCEL_YOU"
const MENU_LABEL_EXPORT: String = "MENU_LABEL_EXPORT"
const MENU_LABEL_IMPORT: String = "MENU_LABEL_IMPORT"
const MENU_LABEL_EXPORT_TEXT: String = "MENU_LABEL_EXPORT_TEXT"
const MENU_LABEL_IMPORT_TEXT: String = "MENU_LABEL_IMPORT_TEXT"
const MENU_LABEL_IMPORT_FAILED: String = "MENU_LABEL_IMPORT_FAILED"

var textbox_mode: TextboxMode = TextboxMode.NONE
var index: int = -1

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var text_edit: TextEdit = %CodeTextEdit


func _ready() -> void:
	hide_popup.call_deferred()

	_connect_signals()

	var node_theme: Theme = ThemeUtils.get_inherited_theme(self)
	ConfirmationDialogJsLoader.set_snippet_theme_from_resource(node_theme)


func hide_popup() -> void:
	self.visible = false


func custom_popup(
	textbox: String,
	center_target: Control,
	editable: bool,
	save_file_index: int,
	retry_flag: bool = false
) -> void:
	if OS.has_feature("web"):
		_web_custom_popup(textbox, center_target, editable, save_file_index, retry_flag)
		return

	text_edit.modulate = Color.WHITE

	var relative_size: Vector2i = MathUtils.scale_v2i(center_target.size, 0.75, 0.75)
	self.popup_centered(relative_size)
	self.position.x = int(center_target.position.x + ((center_target.size.x - self.size.x) / 2.0))
	self.position.y = int(center_target.position.y + ((center_target.size.y - self.size.y) / 2.0))

	self.title = ""
	self.ok_button_text = TranslationServerWrapper.translate(CONFIRM_LABEL)
	self.cancel_button_text = TranslationServerWrapper.translate(CANCEL_LABEL)

	text_edit.text = textbox
	text_edit.editable = editable
	if not editable:
		title_label.text = TranslationServerWrapper.translate(MENU_LABEL_EXPORT)
		subtitle_label.text = TranslationServerWrapper.translate(MENU_LABEL_EXPORT_TEXT)
		text_edit.placeholder_text = ""
		self.get_ok_button().grab_focus()
		textbox_mode = TextboxMode.EXPORT
	else:
		title_label.text = TranslationServerWrapper.translate(MENU_LABEL_IMPORT)
		subtitle_label.text = TranslationServerWrapper.translate(MENU_LABEL_IMPORT_TEXT)
		text_edit.placeholder_text = subtitle_label.text
		text_edit.grab_focus()
		textbox_mode = TextboxMode.IMPORT
		if retry_flag:
			text_edit.placeholder_text = TranslationServerWrapper.translate(
				MENU_LABEL_IMPORT_FAILED
			)
			text_edit.modulate = Color.RED
	index = save_file_index


func _web_custom_popup(
	textbox: String,
	_center_target: Control,
	editable: bool,
	save_file_index: int,
	retry_flag: bool = false
) -> void:
	var accept_button_text: String = TranslationServerWrapper.translate(CONFIRM_LABEL)
	var cancle_button_text: String = TranslationServerWrapper.translate(CANCEL_LABEL)

	var title_text: String
	var subtitle_text: String
	var textarea_text: String = textbox
	var textarea_placeholder: String
	var textarea_readonly: bool = not editable
	if not editable:
		title_text = TranslationServerWrapper.translate(MENU_LABEL_EXPORT)
		subtitle_text = TranslationServerWrapper.translate(MENU_LABEL_EXPORT_TEXT)
		textarea_placeholder = ""
		textbox_mode = TextboxMode.EXPORT
	else:
		title_text = TranslationServerWrapper.translate(MENU_LABEL_IMPORT)
		subtitle_text = TranslationServerWrapper.translate(MENU_LABEL_IMPORT_TEXT)
		textarea_placeholder = subtitle_text
		textbox_mode = TextboxMode.IMPORT
		if retry_flag:
			textarea_placeholder = TranslationServerWrapper.translate(MENU_LABEL_IMPORT_FAILED)
	index = save_file_index

	var font_base_size: float = 16.0
	var font_min_size: float = 16.0
	var canvas_scale: Vector2 = get_window().get_screen_transform().get_scale()
	var scale: float = min(canvas_scale.x, canvas_scale.y)
	var font_scaled: int = max(font_min_size, int(font_base_size * scale))
	ConfirmationDialogJsLoader.set_snippet_property("font_size", str(font_scaled) + "px")

	ConfirmationDialogJsLoader.set_snippet_content(
		textarea_readonly,
		textarea_text,
		textarea_placeholder,
		title_text,
		subtitle_text,
		accept_button_text,
		cancle_button_text
	)
	var result: String = await ConfirmationDialogJsLoader.eval_snippet(self)
	if result != "":
		text_edit.text = result
		_on_confirmed()


func _connect_signals() -> void:
	text_edit.gui_input.connect(_on_textbox_gui_submitted)

	self.confirmed.connect(_on_confirmed)
	self.canceled.connect(_on_canceled)


func _on_textbox_gui_submitted(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return

	text_edit.modulate = Color.WHITE

	if Input.get_axis("ui_accept", "ui_select") != 0 or Input.get_action_strength("ui_paste") != 0:
		self.get_ok_button().grab_focus()


func _on_confirmed() -> void:
	var text: String = StringUtils.sanitize_newline(text_edit.text)
	confirmed_action.emit(textbox_mode, text, index)


func _on_canceled() -> void:
	pass
