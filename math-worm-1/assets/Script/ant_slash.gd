extends Area2D

signal collide(body: Node2D)
signal animation_complete  # New signal for when animation finishes

func _ready():
	var sprite = $AnimatedSprite2D
	if sprite:
		var anim_name = sprite.sprite_frames.get_animation_names()[0] if sprite.sprite_frames.get_animation_names().size() > 0 else ""
		if anim_name != "":
			sprite.sprite_frames.set_animation_loop(anim_name, false)  # Make sure loop is disabled on animation resource
			sprite.play(anim_name)
			sprite.animation_finished.connect(_on_animation_finished)


func _on_animation_finished():
	animation_complete.emit()
	queue_free()  # Auto-disappear after animation

func _on_body_entered(body: Node2D) -> void:
	collide.emit(body)
