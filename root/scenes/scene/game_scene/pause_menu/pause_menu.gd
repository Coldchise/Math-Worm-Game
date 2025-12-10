class_name PauseMenu
extends Control
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var title_label: Label = %TitleLabel

@onready var continue_menu_button: MenuButtonClass = %ContinueMenuButton
@onready var options_menu_button: MenuButtonClass = %OptionsMenuButton
@onready var leave_menu_button: MenuButtonClass = %LeaveMenuButton
@onready var quit_menu_button: MenuButtonClass = %QuitMenuButton


func _ready() -> void:
	_connect_signals()
	_refresh_label()

	if OS.has_feature("web"):
		quit_menu_button.visible = false

	LogWrapper.debug(self, "Ready.")


func _refresh_label() -> void:
	title_label.text = TranslationServerWrapper.translate("MENU_LABEL_PAUSED")


func _connect_signals() -> void:
	SignalBus.language_changed.connect(_on_language_changed)


func _on_language_changed(_locale: String) -> void:
	_refresh_label()
