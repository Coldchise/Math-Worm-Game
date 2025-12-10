class_name ConfirmationDialogJsLoader
extends Object
## Web export alternative to [ConfirmationDialog] because Godot cannot access web clipboard. [br]
## - https://github.com/godotengine/godot/issues/81252
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const NAME: String = "ConfirmationDialogJsLoader"

const ROOT_PATH: String = PathConsts.RES + "/snippets/js/"
const FILE_PATH: String = ROOT_PATH + "confirmation_dialog/confirmation_dialog.js"

const OUTPUT_CONTAINER: String = "window.textAreaResult"
const OUTPUT_CONTAINER_RESET_COMMAND: String = "window.textAreaResult = null;"

static var _snippet_template: String

static var _snippet_properties: Dictionary = {
	# General style
	"font_size": "16px",
	# Modal dimensions
	"modal_width": "25%",
	"modal_height": "50%",
	# Modal appearance
	"modal_bg_color": "#404040",
	"modal_text_color": "#ffffff",
	# Title
	"title_text": "Title",
	"title_text_color": "#ffffff",
	# Subtitle
	"subtitle_text": "Subtitle",
	"subtitle_text_color": "#ffffff",
	# Textarea styles
	"textarea_readonly": false,
	"textarea_text": "Default text",
	"textarea_placeholder": "",
	"textarea_bg_color": "#1a1a1a99",
	"textarea_text_color": "#ffffff",
	# Accept button
	"accept_button_text": "Accept",
	"accept_button_bg_color": "#1a1a1a99",
	"accept_button_bg_hover_color": "#39393999",
	"accept_button_text_color": "#ffffff",
	# Cancel button
	"cancel_button_text": "Cancel",
	"cancel_button_bg_color": "#1a1a1a99",
	"cancel_button_bg_hover_color": "#39393999",
	"cancel_button_text_color": "#ffffff"
}


static func _init() -> void:
	push_error("ConfirmationDialogJsLoader is a static object class and cannot be instantiated.")


## Blocks code execution until snippet is closed (either accepted or canceled).
## If canceled, return will be empty string (""). Otherwise, return will be text from textarea.
## The [node] argument must be inside scene tree.
static func eval_snippet(node: Node) -> String:
	node.get_tree().paused = true
	var snippet: String = get_snippet()
	LogWrapper.debug(NAME, "JavaScriptBridge eval: %s " % [snippet], "eval_snippet")
	var eval_return: Variant = JavaScriptBridge.eval(snippet)
	while true:
		eval_return = JavaScriptBridge.eval(OUTPUT_CONTAINER)
		if eval_return != null:
			break
		await node.get_tree().create_timer(0.1).timeout
	JavaScriptBridge.eval(OUTPUT_CONTAINER_RESET_COMMAND)
	node.get_tree().paused = false
	return eval_return


static func get_snippet() -> String:
	var snippet: String = get_snippet_template()
	snippet = snippet.format(_snippet_properties)
	return snippet


static func set_snippet_content(
	textarea_readonly: bool,
	textarea_text: String,
	textarea_placeholder: String,
	title_text: String,
	subtitle_text: String,
	accept_button_text: String,
	cancel_button_text: String,
) -> void:
	_snippet_properties["textarea_readonly"] = textarea_readonly
	_snippet_properties["textarea_text"] = textarea_text
	_snippet_properties["textarea_placeholder"] = textarea_placeholder
	_snippet_properties["title_text"] = title_text
	_snippet_properties["subtitle_text"] = subtitle_text
	_snippet_properties["accept_button_text"] = accept_button_text
	_snippet_properties["cancel_button_text"] = cancel_button_text


## NOTE: Non-nullable properties use fallback values (e.g. Color to Black) if not set in the theme.
static func set_snippet_theme_from_resource(theme: Theme) -> void:
	if theme == null:
		LogWrapper.debug(NAME, "Theme not set.")
		return

	var button_normal_stylebox: StyleBox = theme.get("Button/styles/normal") as StyleBox
	if button_normal_stylebox != null:
		var button_bg_color: Color = button_normal_stylebox.get("bg_color") as Color
		_snippet_properties["accept_button_bg_color"] = "#" + button_bg_color.to_html()
		_snippet_properties["cancel_button_bg_color"] = "#" + button_bg_color.to_html()

	var button_hover_stylebox: StyleBox = theme.get("Button/styles/hover") as StyleBox
	if button_hover_stylebox != null:
		var button_bg_color: Color = button_hover_stylebox.get("bg_color") as Color
		_snippet_properties["accept_button_bg_hover_color"] = "#" + button_bg_color.to_html()
		_snippet_properties["cancel_button_bg_hover_color"] = "#" + button_bg_color.to_html()

	var button_font_color: Color = theme.get("Button/colors/font_color") as Color
	if button_font_color != null:
		_snippet_properties["accept_button_text_color"] = "#" + button_font_color.to_html()
		_snippet_properties["cancel_button_text_color"] = "#" + button_font_color.to_html()

	var textedit_normal_stylebox: StyleBox = theme.get("TextEdit/styles/normal") as StyleBox
	if textedit_normal_stylebox != null:
		var textedit_bg_color: Color = textedit_normal_stylebox.get("bg_color") as Color
		_snippet_properties["textarea_bg_color"] = "#" + textedit_bg_color.to_html()

	var textedit_font_color: Color = theme.get("TextEdit/colors/font_color") as Color
	if textedit_font_color != null:
		_snippet_properties["textarea_text_color"] = "#" + textedit_font_color.to_html()

	var modal_normal_stylebox: StyleBox = theme.get("AcceptDialog/styles/panel") as StyleBox
	if modal_normal_stylebox != null:
		var modal_bg_color: Color = modal_normal_stylebox.get("bg_color") as Color
		_snippet_properties["modal_bg_color"] = "#" + modal_bg_color.to_html()

	var label_font_color: Color = theme.get("Label/colors/font_color") as Color
	if label_font_color != null:
		_snippet_properties["title_text_color"] = "#" + label_font_color.to_html()
		_snippet_properties["subtitle_text_color"] = "#" + label_font_color.to_html()
		_snippet_properties["modal_text_color"] = "#" + label_font_color.to_html()


static func set_snippet_property(key: String, value: Variant) -> void:
	_snippet_properties[key] = value


static func get_snippet_template() -> String:
	_load_snippet_template()
	return _snippet_template


static func _load_snippet_template() -> void:
	if StringUtils.is_empty(_snippet_template):
		_snippet_template = FileSystemUtils.load_file_as_string(FILE_PATH)
