class_name OptionsMenu
extends Control
## Holds options scenes and manages their transitions (listens to menu button signal).
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var _current_menu: OptionsContainer = null

@onready var tab_h_box_container: HBoxContainer = %TabHBoxContainer

@onready var audio_options: OptionsContainer = %AudioOptions
@onready var video_options: OptionsContainer = %VideoOptions
@onready var controls_options: OptionsContainer = %ControlsOptions
@onready var game_options: GameOptionsContainer = %GameOptions

@onready var audio_menu_button: MenuButtonClass = %AudioMenuButton
@onready var video_menu_button: MenuButtonClass = %VideoMenuButton
@onready var controls_menu_button: MenuButtonClass = %ControlsMenuButton
@onready var game_menu_button: MenuButtonClass = %GameMenuButton

@onready var back_menu_button: MenuButtonClass = %BackMenuButton
@onready var reset_menu_button: MenuButtonClass = %ResetMenuButton


func _ready() -> void:
	_connect_signals()
	_toggle(audio_options, tab_h_box_container.get_child(0))

	# cannot change game mode while playing the game
	if get_parent().name == "GameScene":
		game_options.game_mode_menu_dropdown_node.menu_dropdown_ui.disable()

	LogWrapper.debug(self, "Scene ready.")


func _toggle(menu: Control, source: MenuButtonClass) -> void:
	if menu == _current_menu:
		if source != null:
			source.button_pressed = true
		return

	menu.visible = true
	if _current_menu != null:
		_current_menu.visible = false
	_current_menu = menu

	if source != null:
		_unpress_tabs_except(source)


func _unpress_tabs_except(menu_button: MenuButtonClass) -> void:
	for child: Node in tab_h_box_container.get_children():
		if is_instance_of(child, MenuButtonClass) and child != menu_button:
			(child as MenuButtonClass).button_pressed = false
	menu_button.button_pressed = true


func _connect_signals() -> void:
	self.visibility_changed.connect(_on_visibility_changed)

	audio_menu_button.confirmed.connect(_toggle.bind(audio_options, audio_menu_button))
	video_menu_button.confirmed.connect(_toggle.bind(video_options, video_menu_button))
	controls_menu_button.confirmed.connect(_toggle.bind(controls_options, controls_menu_button))
	game_menu_button.confirmed.connect(_toggle.bind(game_options, game_menu_button))

	reset_menu_button.confirmed.connect(_on_reset_button)


# toggle first tab (audio_options) if options menu is re-opened
func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		_toggle(audio_options, tab_h_box_container.get_child(0))


func _on_reset_button() -> void:
	var config_group: ConfigurationEnum.Group = _current_menu.get_config_group()
	Configuration.reset_options(config_group)
