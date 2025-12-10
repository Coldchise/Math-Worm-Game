# Easy to customize with [ParticleProcessMaterial].
# Note that a [GPUParticles2D] using a [SubViewport] can be performance expensive.
# To avoid performance cost, use one emitter for multiple particles instead of spawning emitters.
class_name ParticleEmitter
extends GPUParticles2D
## Base scene for particle emitter scenes.
## When extending the script, make sure to set override exports: [sub_viewport], [particle].
## [br][br]
## Allows to convert any scene into a particle by using a sub-viewport.
## Emits child node [sub_viewport] containing [particle] node, given [particle_process_material_id].
## [br][br]
## Use [start] and [stop] functions.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal particle_started
signal particle_stopped

@export_group("Options")
@export var particle_process_material_id: String = "":
	set(value):
		particle_process_material_id = value
		_set_particle()
@export var particle_modulate: Color = Color.WHITE:
	set(value):
		particle_modulate = value
		_set_modulate()
@export var stop_on_not_visible: bool = true

@export_group("On Ready")
@export var ready_one_shot: bool = true
@export var ready_emitting: bool = false
@export var ready_amount: int = 1

@export_group("Override")
@export var sub_viewport: SubViewport
@export var particle: Node

var is_finished: bool = true


# workaround for flickering particles
# - https://github.com/godotengine/godot/issues/65390
func _notification(what: int) -> void:
	if NOTIFICATION_PAUSED == what:
		self.interpolate = false
	elif NOTIFICATION_UNPAUSED == what:
		self.interpolate = true


func _process(_delta: float) -> void:
	if stop_on_not_visible and !is_visible_in_tree():
		stop()


func _ready() -> void:
	particle.theme = Configuration.get_theme()

	initialize()


func initialize() -> void:
	if sub_viewport == null or particle == null:
		LogWrapper.error(self, "SubViewport and Particle are mandatory, but are not set.")
		return

	self.one_shot = ready_one_shot
	self.emitting = ready_emitting
	self.amount = ready_amount

	self.finished.connect(_on_finished)


func start() -> void:
	_on_started()
	is_finished = false
	particle.visible = true
	self.emitting = true
	self.restart()


func stop() -> void:
	self.emitting = false
	particle.visible = false


func _set_particle() -> void:
	var particle_process_material: ParticleProcessMaterial = (
		ResourceReference.get_particle_process_material(particle_process_material_id)
	)
	if particle_process_material != null:
		self.process_material = particle_process_material


func _set_modulate() -> void:
	particle.modulate = particle_modulate


func _on_started() -> void:
	particle_started.emit()


func _on_finished() -> void:
	is_finished = true
	particle_stopped.emit()
