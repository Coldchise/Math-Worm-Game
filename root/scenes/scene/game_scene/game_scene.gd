class_name GameScene
extends Node

@export_group("Menu Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_play"

@onready var game_content: Node = $GameContent
@onready var pause_menu: PauseMenu = %PauseMenu
@onready var options_menu: OptionsMenu = %OptionsMenu
@onready var ui_builder: UiBuilder = %UiBuilder

# --- LOAD YOUR SCENES HERE ---
var trailer_scene_path = "res://assets/Scene/Trailer.tscn" 
var battle_scene_path = "res://assets/Scene/battle_scene.tscn" 

func _ready() -> void:
	_load_intro_sequence()

	ui_builder.build()
	_connect_signals()
	LogWrapper.debug(self, "Ready.")

# 1. Function to load the Trailer
func _load_intro_sequence() -> void:
	# Remove placeholder content if it exists
	if is_instance_valid(game_content):
		game_content.queue_free()
	
	var trailer_pck = load(trailer_scene_path)
	var trailer_instance = trailer_pck.instantiate()
	
	# Connect the signal we created in Step 1
	if trailer_instance.has_signal("video_finished"):
		trailer_instance.video_finished.connect(_on_intro_finished)
	
	# Add to scene
	NodeUtils.add_child_front(trailer_instance, self)
	game_content = trailer_instance

# 2. Function called when Trailer says it's done
func _on_intro_finished():
	# Remove the Trailer
	game_content.queue_free()
	
	# Load the Battle
	_load_battle_scene()

# 3. Function to load the Battle
func _load_battle_scene() -> void:
	var battle_pck = load(battle_scene_path)
	var battle_instance = battle_pck.instantiate()
	
	# Connect your menu signal
	if battle_instance.has_signal("menu_pressed"):
		battle_instance.menu_pressed.connect(_action_game_pause_menu_button)

	NodeUtils.add_child_front(battle_instance, self)
	game_content = battle_instance
	
	# Optional: If you have a fade-in on the battle scene, it will play now automatically.

# ... [Keep the rest of your pause/input logic exactly as it was] ...

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_pause"):
		if get_tree().paused:
			if pause_menu.visible:
				_action_continue_menu_button()
			else:
				_action_options_back_menu_button()
		else:
			_action_game_pause_menu_button()

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
