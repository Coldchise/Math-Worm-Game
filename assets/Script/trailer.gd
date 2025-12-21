extends Control

# 1. Define a signal to tell the parent (GameScene) we are done
signal video_finished 

@onready var video_player = $VideoStreamPlayer
@onready var fade_overlay = $ColorRect # (Or ColorRect2 depending on your scene)

func _ready():
	fade_overlay.color.a = 0.0
	fade_overlay.visible = true
	video_player.finished.connect(_on_video_finished)
	video_player.play()

func _on_video_finished():
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 1.0)
	await tween.finished
	
	# 2. DO NOT change scene here. Emit the signal instead.
	video_finished.emit()
