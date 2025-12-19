# NOTE: Additional examples: (replace "GameContent" child scene)
# - 2D Incremental Clicker (default): "scenes/scene/game_scene/game_content/game_content.tscn"
# - 3D First Person Controller: "artifacts/example_3d_fp_controller/scenes/.../game_content.tscn"
class_name GameScene
extends Node
## Replace "GameContent" child scene with your own. (Keep unique name.)
## You can modify [_after_unpause], [_after_pause], [_after_leave] functions in this script.

@export_group("Menu Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_play"

@onready var game_content: Node = $GameContent
@onready var pause_menu: PauseMenu = %PauseMenu
@onready var options_menu: OptionsMenu = %OptionsMenu

@onready var ui_builder: UiBuilder = %UiBuilder

# Esc key shortcut toggles pause menu or exits from options via back button
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_pause"):
		if get_tree().paused:
			if pause_menu.visible:
				_action_continue_menu_button()
			else:
				_action_options_back_menu_button()
		else:
			_action_game_pause_menu_button()

func _ready() -> void:
	# Load your custom battle scene instead of the template clicker
	_load_battle_scene()

	ui_builder.build()
	_connect_signals()
	LogWrapper.debug(self, "Ready.")

func _after_pause() -> void:
	if "player" in game_content and game_content.player is Player:
		var player: Player = game_content.player
		player.release_mouse()

func _after_unpause() -> void:
	if "control_grab_focus" in game_content and game_content.control_grab_focus is ControlGrabFocus:
		var control_grab_focus: ControlGrabFocus = game_content.control_grab_focus
		control_grab_focus.grab_focus()

	if "player" in game_content and game_content.player is Player:
		var player: Player = game_content.player
		player.capture_mouse()

func _after_leave() -> void:
	pass

# NEW: load your battle scene here
func _load_battle_scene() -> void:
	game_content.queue_free()
	
	var battle_pck: PackedScene = load("res://assets/Scene/battle_scene.tscn")
	var battle_instance: Node = battle_pck.instantiate()
	
	if battle_instance.has_signal("menu_pressed"):
		battle_instance.menu_pressed.connect(_action_game_pause_menu_button)

	NodeUtils.add_child_front(battle_instance, self)
	
	game_content = battle_instance

func _action_game_pause_menu_button() -> void:
	game_content.visible = true
	pause_menu.visible = true
	options_menu.visible = false
	get_tree().paused = true
	_after_pause()
	LogWrapper.debug(name, "Game paused.")

func _action_continue_menu_button() -> void:
	game_content.visible = true
	pause_menu.visible = false
	options_menu.visible = false
	get_tree().paused = false
	_after_unpause()
	LogWrapper.debug(name, "Game unpaused.")

func _action_options_menu_button() -> void:
	game_content.visible = false
	pause_menu.visible = false
	options_menu.visible = true

func _action_options_back_menu_button() -> void:
	game_content.visible = true
	pause_menu.visible = true
	options_menu.visible = false

func _action_leave_menu_button() -> void:
	game_content.process_mode = Node.PROCESS_MODE_DISABLED
	game_content.visible = true
	pause_menu.visible = false
	options_menu.visible = false
	get_tree().paused = false
	LogWrapper.debug(name, "Game leave.")

	self.process_mode = PROCESS_MODE_DISABLED
	Data.exit_save_file()
	_after_leave()
	SceneManagerWrapper.change_scene(scene, scene_manager_options_id)

func _action_quit_menu_button() -> void:
	Data.save_save_file()
	get_tree().quit()

func _connect_signals() -> void:
	if "pause_menu_button" in game_content:
		game_content.pause_menu_button.confirmed.connect(_action_game_pause_menu_button)

	pause_menu.continue_menu_button.confirmed.connect(_action_continue_menu_button)
	pause_menu.options_menu_button.confirmed.connect(_action_options_menu_button)
	pause_menu.leave_menu_button.confirmed.connect(_action_leave_menu_button)
	pause_menu.quit_menu_button.confirmed.connect(_action_quit_menu_button)

	options_menu.back_menu_button.confirmed.connect(_action_options_back_menu_button)
