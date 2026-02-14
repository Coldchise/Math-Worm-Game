extends Control

signal menu_pressed


var fireball_scene: PackedScene = load("res://assets/Scene/fireball.tscn")
var antattack_scene: PackedScene = load("res://assets/Scene/ant_slash.tscn")
var current_player_health = 0
var current_enemy_health = 0
var current_question_index = 0
var last_player_action_correct = false
var calculator_scene = preload("res://general.tscn")
var calculator_instance = null

enum BattleState { PLAYER_TURN, ENEMY_TURN }
var battle_state = BattleState.PLAYER_TURN


@onready var key_pad = $KeyPad
@onready var dialog_manager = $DialogManager
@export var enemy: Resource = null
# @onready var game_message = $GameMessage Future use dont touch
@onready var paint_root = $PaintRoot # <--- Reference to the Paint Node
@onready var fade_overlay = get_node_or_null("ColorRect2") # <--- Reference to your Fade Overlay

func _ready() -> void:
	# --- FADE IN EFFECT START ---
	# Make sure the black overlay is visible and fully opaque (solid black)
	if fade_overlay:
		fade_overlay.visible = true
		fade_overlay.color.a = 1.0
		var tween = create_tween()
		tween.tween_property(fade_overlay, "color:a", 0.0, 1.0)
	else:
		print("Warning: ColorRect2 (fade_overlay) not found in battle_scene.gd")
	
	# Create a tween to fade the alpha to 0 (transparent) over 1 second
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 0.0, 1.0)
	# --- FADE IN EFFECT END ---

	paint_root.visible = false # <--- Ensure it starts hidden
	
	if enemy == null:
		# Note: Ensure "Enemy1" is NOT in Project Settings > Autoload, or this line will conflict.
		enemy = load("res://assets/Script/Enemy1.tres")
		
	set_health($EnemyHealthBar, enemy.health, enemy.health)
	set_health($PlayerHealthBar, State.current_health, State.max_health)

	current_player_health = State.current_health
	current_enemy_health = enemy.health

	$explosion.emitting = false
	$explosion.one_shot = true

	# Connect dialog signal to the central state handler
	dialog_manager.connect("dialogue_finished", Callable(self, "_on_dialogue_finished"))
	dialog_manager.show_dialogue()

func _on_attack_pressed() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	var user_answer = key_pad.label.text.strip_edges()
	key_pad.clear_answer()
	
	# Fetch the correct answer using the current index
	var correct_answer = dialog_manager.get_answer(current_question_index)
	
	# IMPORTANT: Start fade out of the question panel before transition
	dialog_manager.fade_out_question()
	
	# Lock the state
	battle_state = BattleState.ENEMY_TURN
	
	if user_answer == correct_answer:
		last_player_action_correct = true
		print("Correct! Launching fireball...")
		launch_fireball()
	else:
		last_player_action_correct = false
		print("Wrong answer: ", user_answer, "! Enemy turn.")
		# Wrong answer: Enemy immediately speaks "WRONNGGG!!"
		dialog_manager.enemy_speak("WRONNGGG!!")

func launch_fireball():
	var fireball = fireball_scene.instantiate()
	$Fireball.add_child(fireball)
	fireball.position = Vector2(1060.0, 240.0)
	fireball.scale = Vector2(0.2, 0.2)
	# Connect collision to handle enemy damage and transition
	fireball.collision.connect(on_fireball_collision)

func on_fireball_collision(_body: Node2D):
	# 1. Damage Enemy
	$explosion.emitting = true
	$explosion.position = Vector2(285.0, 213.0)

	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyHealthBar, current_enemy_health, enemy.health)

	if current_enemy_health <= 0:
		handle_win()
		return

	# 2. Correct hit: Enemy speaks "Ouch!"
	dialog_manager.enemy_speak("Ouch!")

# CENTRAL STATE TRANSITION HANDLER
func _on_dialogue_finished():
	if battle_state == BattleState.ENEMY_TURN:
		
		# 1. Player is always damaged on a completed turn
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerHealthBar, current_player_health, State.max_health)
		
		if current_player_health <= 0:
			handle_game_over()
			return
		
		# 2. Play enemy attack animation (ant_slash)
		var antattack = antattack_scene.instantiate()
		$AntSlash.call_deferred("add_child", antattack)
		antattack.position = Vector2(1137.0, 190.0)
		antattack.scale = Vector2(3.0, 3.0)
		
		# 3. Update question index and state
		if last_player_action_correct:
			current_question_index += 1 # Advance question on correct answer
			
		# Check for end of questions/win condition
		if current_question_index >= dialog_manager.get_total_questions():
			handle_win()
			return

		# Get question text (either the next one or the same one if wrong)
		var next_question_text = dialog_manager.get_question(current_question_index)
		dialog_manager.update_question(next_question_text)

		battle_state = BattleState.PLAYER_TURN
		print("Player's turn! Current Q Index: ", current_question_index)
	
	else: # Handles the end of the *initial* scene dialogue
		# Set up the first question
		var initial_question_text = dialog_manager.get_question(current_question_index)
		dialog_manager.update_question(initial_question_text)
		battle_state = BattleState.PLAYER_TURN
		print("Battle start!")


func _on_defend_pressed() -> void:
	if battle_state == BattleState.PLAYER_TURN:
		# Defend logic: skips fireball but still triggers enemy turn with damage
		print("Defend action: Skip attack, immediately take damage.")
		battle_state = BattleState.ENEMY_TURN
		last_player_action_correct = false
		dialog_manager.fade_out_question()
		dialog_manager.enemy_speak("You try to hide!")

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func handle_win():
	battle_state = BattleState.ENEMY_TURN
	dialog_manager.update_question("VICTORY!")
	print("Game Over: Player Wins!")

func handle_game_over():
	battle_state = BattleState.ENEMY_TURN
	dialog_manager.update_question("GAME OVER")
	print("Game Over: Player Lost!")

func _on_menu_pressed() -> void:
	menu_pressed.emit()

func _on_canvas_pressed() -> void:
	paint_root.visible = true # <--- Shows the canvas
	
func _on_calculator_pressed():
	if calculator_instance == null:
		calculator_instance = calculator_scene.instantiate()
		add_child(calculator_instance)
	else:
		# Optional: if toggle from battle button itself
		calculator_instance.queue_free()
		calculator_instance = null
