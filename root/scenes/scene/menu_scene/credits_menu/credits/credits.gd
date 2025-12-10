# NOTE: Suppported formating rules: title font sizes (h1, h2, h3, h4), URLs and comments.
# TODO: Extend to parse other .md file syntax if needed. (Consider a plugin.)
class_name Credits
extends Control
## Localized credits rendering from .md file, applying some formatting rules.
## [br][br]
## Modified File MIT License Copyright (c) 2024 TinyTakinTeller
## Original File MIT License Copyright (c) 2022-present Marek Belski

signal end_reached

@export_file("*.md") var attribution_file_path: String = PathConsts.RES + "CREDITS.md"

@export_group("Formatting")
@export var h1_font_size: int = 64
@export var h2_font_size: int = 48
@export var h3_font_size: int = 32
@export var h4_font_size: int = 24

@export_group("Scroll")
## Default automatic scroll speed.
@export var current_speed: float = 50.0
## When using ui input events, speed up scrolling (e.g. up and down arrow keys).
@export var boost_speed_factor: float = 10.0
## Delay before resuming auto scroll after player stops it via ui interaction.
@export var scroll_reset_time: float = 1.0
@export var enabled: bool = true
@export var scroll_offset: float = 0.0

@export_group("Text Container")
@export var trim_first_line: bool = false
@export var stretch_minimum_size: bool = true
@export var x_minimum_size: float = 0.0
@export var align: String = "center"
@export var center_padding: bool = false

@export_group("Localization")
## Consider that some keywords might appear in a sentence so we use a suffix to avoid that.
@export var suffix: String = ":"
## Contain suffix in file but not in translation.
@export var keywords: Dictionary = {"Credits": "MENU_LABEL_CREDITS"}
## Contain suffix in file and in translation.
@export var suffix_keywords: Dictionary = {}

var scroll_paused: bool = false:
	set(value):
		if value:
			scroll_paused = true
		else:
			_set_header_and_footer()
			scroll_paused = false

var _current_scroll_position: float = 0.0
var _is_grabbed: bool = false

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var credits_label: RichTextLabel = %CreditsLabel
@onready var header_space: Control = %HeaderSpace
@onready var footer_space: Control = %FooterSpace
@onready var scroll_reset_timer: Timer = %ScrollResetTimer
@onready var padding_margin_container: MarginContainer = %PaddingMarginContainer


func _ready() -> void:
	_connect_signals()
	_init_from_file_path(attribution_file_path)
	scroll_reset_timer.wait_time = scroll_reset_time


func _process(delta: float) -> void:
	var input_axis: float = Input.get_axis("ui_up", "ui_down")
	if input_axis != 0:
		_scroll_container(boost_speed_factor * current_speed * input_axis * delta)
	else:
		_scroll_container(current_speed * delta)


func reset() -> void:
	scroll_paused = false
	scroll_container.scroll_vertical = int(scroll_offset)
	_set_header_and_footer()


func _scroll_container(amount: float) -> void:
	if not is_visible_in_tree() or not enabled or scroll_paused:
		return
	_current_scroll_position += amount
	scroll_container.scroll_vertical = round(_current_scroll_position)
	_check_end_reached()


func _check_end_reached() -> void:
	if not is_end_reached():
		return
	scroll_paused = true
	end_reached.emit()


func is_end_reached() -> bool:
	var end_of_credits_vertical: float = credits_label.size.y + header_space.size.y
	return scroll_container.scroll_vertical > end_of_credits_vertical


func _init_from_file_path(file_path: String) -> void:
	attribution_file_path = file_path
	_update_text_from_file()
	_set_header_and_footer()


func _set_header_and_footer() -> void:
	if (
		scroll_container == null
		or header_space == null
		or footer_space == null
		or credits_label == null
	):
		return

	_current_scroll_position = scroll_container.scroll_vertical
	header_space.custom_minimum_size.y = size.y
	footer_space.custom_minimum_size.y = size.y

	if x_minimum_size != 0.0:
		credits_label.custom_minimum_size.x = x_minimum_size

	if stretch_minimum_size:
		credits_label.custom_minimum_size.x = size.x
	elif center_padding:
		padding_margin_container.custom_minimum_size.x = credits_label.size.x / 4


func _update_text_from_file() -> void:
	var text: String = FileSystemUtils.load_file_as_string(attribution_file_path)
	if text == "":
		return

	if trim_first_line:
		var end_of_first_line: int = text.find("\n") + 1
		text = text.right(-end_of_first_line)

	text = text.replace("\r\n", "\n")
	text = text.replace("\n\r", "\n")
	text = text.replace("\\" + "\n", "\n")
	text = _regex_replace_comments(text)
	text = _regex_replace_urls(text)
	text = _regex_replace_titles(text)

	text = _localize_keywords(text)

	credits_label.text = ("[" + align + "]%s[/" + align + "]") % [text]


func _localize_keyword(
	credits: String, keyword: String, tr_key: String, oc_suffix: String = "", tr_suffix: String = ""
) -> String:
	var translation: String = TranslationServerWrapper.translate(tr_key)
	credits = credits.replace(keyword + oc_suffix, translation + tr_suffix)
	return credits


func _localize_keywords(credits: String) -> String:
	for keyword: String in keywords:
		credits = _localize_keyword(credits, keyword, keywords[keyword], suffix)
	for keyword: String in suffix_keywords:
		credits = _localize_keyword(credits, keyword, suffix_keywords[keyword], suffix, suffix)
	return credits


func _regex_replace_urls(credits: String) -> String:
	var regex: RegEx = RegEx.new()
	var match_string: String = "\\[([^\\]]*)\\]\\(([^\\)]*)\\)"
	var replace_string: String = "[url=$2]$1[/url]"
	regex.compile(match_string)
	return regex.sub(credits, replace_string, true)


func _regex_replace_titles(credits: String) -> String:
	var iter: int = 0
	var heading_font_sizes: Array[int] = [h1_font_size, h2_font_size, h3_font_size, h4_font_size]
	for heading_font_size in heading_font_sizes:
		iter += 1
		var regex: RegEx = RegEx.new()
		var match_string: String = "([^#]|^)#{%d}\\s([^\\n]*)" % iter
		var replace_string: String = "$1[font_size=%d]$2[/font_size]" % [heading_font_size]
		regex.compile(match_string)
		credits = regex.sub(credits, replace_string, true)
	return credits


## Match and remove lines starting with "[]:" (with any content inside the brackets)
func _regex_replace_comments(credits: String) -> String:
	var regex: RegEx = RegEx.new()
	var match_string: String = "(?:.*\\n)?\\[.*?\\]:.*(?:\\n|$)"
	regex.compile(match_string)
	return regex.sub(credits, "", true)


func _start_scroll_timer() -> void:
	scroll_reset_timer.start()


func _connect_signals() -> void:
	scroll_container.gui_input.connect(_on_scroll_container_gui_input)
	scroll_container.scroll_started.connect(_on_scroll_container_scroll_started)
	scroll_container.resized.connect(_on_scroll_container_resized)

	scroll_container.get_v_scroll_bar().gui_input.connect(_on_scroll_bar_gui_input)
	scroll_container.get_v_scroll_bar().mouse_entered.connect(_on_scroll_bar_mouse_entered)

	credits_label.meta_clicked.connect(_on_credits_label_meta_clicked)

	scroll_reset_timer.timeout.connect(_on_scroll_reset_timer_timeout)

	SignalBus.language_changed.connect(_on_language_changed)


## Capture the mouse scroll wheel input event
func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		scroll_paused = true
		_start_scroll_timer()
	_check_end_reached()


## Capture the touch input event
func _on_scroll_container_scroll_started() -> void:
	scroll_paused = true
	_start_scroll_timer()


func _on_scroll_container_resized() -> void:
	_set_header_and_footer()


func _on_scroll_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			_is_grabbed = event.pressed


func _on_scroll_bar_mouse_entered() -> void:
	scroll_paused = true
	_start_scroll_timer()


func _on_credits_label_meta_clicked(meta: String) -> void:
	if meta.begins_with("https://"):
		var err: Error = OS.shell_open(meta)
		if err != Error.OK:
			LogWrapper.debug(self, "Failed to open URL %s due to error code: " % [meta], err)


func _on_scroll_reset_timer_timeout() -> void:
	if _is_grabbed:
		_start_scroll_timer()
	else:
		scroll_paused = false


func _on_language_changed(_locale: String) -> void:
	_update_text_from_file()
