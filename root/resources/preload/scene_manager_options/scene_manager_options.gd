class_name SceneManagerOptions
extends Resource
## Resource script that defines reusable options for [SceneManagerWrapper] autoload.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export_group("Fade Out Options")
@export var fade_out_speed: float = 1.0
@export var fade_out_pattern: SceneManagerEnum.ShaderPattern = SceneManagerEnum.ShaderPattern.FADE
@export_range(0.0, 1.0) var fade_out_smoothness: float = 0.1
@export var fade_out_inverted: bool = false

@export_group("Fade In Options")
@export var fade_in_speed: float = 1.0
@export var fade_in_pattern: SceneManagerEnum.ShaderPattern = SceneManagerEnum.ShaderPattern.FADE
@export_range(0.0, 1.0) var fade_in_smoothness: float = 0.1
@export var fade_in_inverted: bool = false

@export_group("General Options")
@export var color: Color = Color(0, 0, 0)
@export var timeout: float = 0.0
@export var clickable: bool = false
@export var add_to_back: bool = true


func create_fade_out_options() -> SceneManager.Options:
	var fade_out_pattern_name: String = SceneManagerEnum.shader_pattern_name(fade_out_pattern)
	return SceneManager.create_options(
		fade_out_speed, fade_out_pattern_name, fade_out_smoothness, fade_out_inverted
	)


func create_fade_in_options() -> SceneManager.Options:
	var fade_in_pattern_name: String = SceneManagerEnum.shader_pattern_name(fade_in_pattern)
	return SceneManager.create_options(
		fade_in_speed, fade_in_pattern_name, fade_in_smoothness, fade_in_inverted
	)


func create_general_options() -> SceneManager.GeneralOptions:
	return SceneManager.create_general_options(color, timeout, clickable, add_to_back)
