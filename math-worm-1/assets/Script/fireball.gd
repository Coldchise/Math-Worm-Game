extends Area2D

@export var fireball_speed = 1000
@export var fireball_damage = 15

signal collision(body: Node2D)  # Pass the collided body

func _process(delta: float) -> void:
	position.x -= fireball_speed * delta

func _on_body_entered(body: Node2D) -> void:
	collision.emit(body)  # Pass the collided body
	queue_free()  # Remove fireball after collision
