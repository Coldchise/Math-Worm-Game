class_name MenuScene
extends Control
## Holds menu scenes and manages their transitions (listens to menu button pressed signal).
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var _current_menu: Control = null

@onready var main_menu: MainMenu = %MainMenu
@onready var options_menu: OptionsMenu = %OptionsMenu
@onready var credits_menu: CreditsMenu = %CreditsMenu
@onready var save_files_menu: SaveFilesMenu = %SaveFilesMenu

@onready var ui_builder: UiBuilder = %UiBuilder


# Esc key shortcut returns to main menu if inside any of the sub-menus
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_pause"):
		if not main_menu.visible:
			_toggle(main_menu)


func _ready() -> void:
	ui_builder.build()

	_connect_signals()
	_toggle(main_menu)

	AudioManagerWrapper.play_music(AudioEnum.Music.MENU_DOODLE, 1.0)

	LogWrapper.debug(self, "Scene ready.")


func _toggle(menu: Control) -> void:
	menu.visible = true
	if _current_menu != null:
		_current_menu.visible = false
	_current_menu = menu

	if _current_menu == credits_menu:
		credits_menu.credits.reset()


func _connect_signals() -> void:
	options_menu.back_menu_button.confirmed.connect(_toggle.bind(main_menu))
	credits_menu.back_menu_button.confirmed.connect(_toggle.bind(main_menu))
	save_files_menu.back_menu_button.confirmed.connect(_toggle.bind(main_menu))

	main_menu.play_menu_button.confirmed.connect(_toggle.bind(save_files_menu))
	main_menu.options_menu_button.confirmed.connect(_toggle.bind(options_menu))
	main_menu.credits_menu_button.confirmed.connect(_toggle.bind(credits_menu))
