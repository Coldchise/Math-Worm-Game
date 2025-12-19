extends Control
#Signal
signal dialogue_finished
#Used variables
@onready var char_visuals = $Main
@onready var enemy_visuals = $Enemy
@onready var question_visuals = $Question
@onready var enemy_label = $Enemy/MarginContainer/Label
@onready var char_label = $Main/MarginContainer/Label
@onready var question_label = $Question/MarginContainer/Label
@onready var timer = $Timer
var index := 0

# Array form for questions ans answers
const QUESTIONS_DATA = [
	{ "question": "f(x)=2x+1, find f(3)", "answer": "7" },
	{ "question": "g(x)=3x^2 - 4, find g(-2)", "answer": "8" },
	{ "question": "f(x)=x-3 and h(x)=x-2, find (f+h)(x)", "answer": "2x-5" },
	{ "question": "f(x)=x-3 and h(x)=x-2, find (h-f)(x)", "answer": "1"}
]
# Array form for dialog for enemy and character
var dialogue_sequence = [
	{ "speaker": "enemy", "text": "The group of ants appeared!" },
	{ "speaker": "enemy", "text": "Hey, Worm. This is our territory." },
	{ "speaker": "char", "text": "Who are you guys?" },
	{ "speaker": "enemy", "text": "Get ready! We're not letting you pass." },
	{ "speaker": "char", "text": "I won't back down!" }
]

const FADE_DURATION = 0.3

# Getting the amount of index in a array
func get_question(index: int) -> String:
	if index >= 0 and index < QUESTIONS_DATA.size():
		return QUESTIONS_DATA[index]["question"]
	return "No More Questions!"

func get_answer(index: int) -> String:
	if index >= 0 and index < QUESTIONS_DATA.size():
		return QUESTIONS_DATA[index]["answer"]
	return "" 

func get_total_questions() -> int:
	return QUESTIONS_DATA.size()

func _ready() -> void:
	_reset_all_visibilities()
#Making sure the index is 0 hehe
func show_dialogue():
	index = 0
	_show_next_line()

func _show_next_line() -> void:
	if index >= dialogue_sequence.size():
		timer.stop()
		# The dailog is finished
		emit_signal("dialogue_finished") 
		return

	var line = dialogue_sequence[index]
	
	# reset visibility of the signals
	_reset_all_visibilities()

	match line["speaker"]:
		"enemy":
			enemy_label.text = line["text"]
			enemy_visuals.visible = true
			enemy_label.visible = true

		"char":
			char_label.text = line["text"]
			char_visuals.visible = true
			char_label.visible = true

	# Start the timer to transition to the next line
	if index < dialogue_sequence.size():
		timer.wait_time = 3.0
		timer.start()

# Now instantly moves to the next line without fading
func _fade_out_and_continue() -> void:
	# Dialog Functions
	var line = dialogue_sequence[index]

	match line["speaker"]:
		"enemy":
			enemy_visuals.visible = false
			enemy_label.visible = false
		"char":
			char_visuals.visible = false
			char_label.visible = false
	
	index += 1
	_show_next_line()

func _on_timer_timeout() -> void:
	# Stop the timer immediately to prevent re-triggering while fading
	timer.stop()
	_fade_out_and_continue()

# Resets visibility and ensures alpha is 1.0 (opaque)
func _reset_all_visibilities() -> void:
	# Reset alpha for all elements
	enemy_visuals.modulate.a = 1.0
	char_visuals.modulate.a = 1.0
	question_visuals.modulate.a = 1.0
	
	enemy_label.visible = false
	enemy_visuals.visible = false
	char_label.visible = false
	char_visuals.visible = false
	question_label.visible = false
	question_visuals.visible = false

# Public function to fade out the persistent question panel (Kept for questions)
func fade_out_question() -> void:
	if question_visuals.visible:
		var tween := create_tween()
		tween.tween_property(question_label, "modulate:a", 0.0, FADE_DURATION)
		tween.tween_property(question_visuals, "modulate:a", 0.0, FADE_DURATION)
		tween.tween_callback(func():
			question_visuals.visible = false
			question_label.visible = false
		)

func _start_question_fade_in() -> void:
	question_label.modulate.a = 0.0
	question_visuals.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(question_label, "modulate:a", 1.0, 0.5)
	tween.tween_property(question_visuals, "modulate:a", 1.0, 0.5)

# NEW: Update question for next turn (persists)
func update_question(new_text: String) -> void:
	# Instantly hide any previous char/enemy dialogue
	_reset_all_visibilities()
	
	question_label.text = new_text
	question_visuals.visible = true
	question_label.visible = true
	_start_question_fade_in()

# Enemy speaks during turn (disappears after 2 seconds) - Now instant appearance
func enemy_speak(text: String) -> void:
	# Instantly hide character/enemy dialogue (if visible from intro) and reset alpha
	_reset_all_visibilities()
	
	enemy_label.text = text
	enemy_label.visible = true
	enemy_visuals.visible = true
	
	# 2 seconds each dialog then remove
	var tween := create_tween()
	tween.tween_interval(2.0) 
	
	tween.tween_callback(func():
		enemy_visuals.visible = false
		enemy_label.visible = false
		emit_signal("dialogue_finished")
	)
