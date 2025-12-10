class_name GameButton
extends TextureButton
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

enum ParticleType { EMITTER, TWEEN }

const BRIGHTNESS_EFFECT: float = 0.25

## Tween particle type is better for performance (higher FPS).
@export var particle_type: ParticleType = ParticleType.TWEEN

var hovering: bool = false
var pressing: bool = false

var _love_label: String

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var click_counter: ClickCounter = %ClickCounter

@onready var emitter_spawner_buffer: SpawnerBuffer = %EmitterSpawnerBuffer
@onready var emitter_spawner_entity_parent: Node2D = %EmitterSpawnerEntityParent
@onready var tween_spawner_buffer: SpawnerBuffer = %TweenSpawnerBuffer
@onready var tween_spawner_entity_parent: Node2D = %TweenSpawnerEntityParent


func _process(_delta: float) -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	emitter_spawner_entity_parent.position = viewport_size / 2
	tween_spawner_entity_parent.position = viewport_size / 2


func _ready() -> void:
	_connect_signals()
	_init_nodes()
	_refresh_label()


func click(coins_per_click: int = 1) -> void:
	Data.game.coins += coins_per_click
	click_counter.click()

	if particle_type == ParticleType.EMITTER:
		emitter_spawner_buffer.process([coins_per_click, _love_label])
	else:
		tween_spawner_buffer.process([coins_per_click, _love_label])


func max_click(clicks_per_second: int) -> void:
	Data.game.max_clicks_per_second = max(clicks_per_second, Data.game.max_clicks_per_second)
	animation_player.speed_scale = 1.0 + 1.0 * clicks_per_second


func _init_nodes() -> void:
	animation_player.play("float")


func _refresh_label() -> void:
	_love_label = TranslationServerWrapper.translate("CONTEXT_ITEM_LOVE")


func _display_effect() -> void:
	if pressing:
		self.modulate.v = 1.0 - BRIGHTNESS_EFFECT
	elif hovering:
		self.modulate.v = 1.0  #+ BRIGHTNESS_EFFECT
	else:
		self.modulate.v = 1.0


func _connect_signals() -> void:
	self.visibility_changed.connect(_on_visibility_changed)

	self.mouse_entered.connect(_on_hover.bind(true))
	self.mouse_exited.connect(_on_hover.bind(false))
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)

	SignalBus.clicks_per_second_updated.connect(_on_clicks_per_second_updated)
	SignalBus.language_changed.connect(_on_language_changed)


# visibility property propagation gets broken if parent is a [Node] instead of [Node2D] or [Control]
func _on_visibility_changed() -> void:
	emitter_spawner_entity_parent.visible = is_visible_in_tree()
	tween_spawner_entity_parent.visible = is_visible_in_tree()


func _on_hover(hovered: bool) -> void:
	hovering = hovered
	_display_effect()


func _on_button_down() -> void:
	pressing = true
	_display_effect()
	click()


func _on_button_up() -> void:
	pressing = false
	_display_effect()


func _on_clicks_per_second_updated(clicks_per_second: int) -> void:
	max_click(clicks_per_second)


func _on_language_changed(_locale: String) -> void:
	_refresh_label()
