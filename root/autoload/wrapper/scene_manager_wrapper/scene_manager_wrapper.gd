# TODO: Does not wrap all methods. Wrap other methods from [SceneManager] if and when needed.
extends Node
## Wraps SceneManager plugin:
## - uses [SceneManagerEnum] enum to track available scenes
## - uses [SceneManagerOptions] resource instead of [SceneManager.Options] object from the plugin
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


func _ready() -> void:
	LogWrapper.debug(self, "AUTOLOAD READY.")


func change_scene(scene: SceneManagerEnum.Scene, scene_manager_options_id: String) -> void:
	var scene_id: String = SceneManagerEnum.scene_name(scene)
	LogWrapper.debug(self, "Change scene: ", scene_id)

	var scene_manager_options: SceneManagerOptions = ResourceReference.get_scene_manager_options(
		scene_manager_options_id
	)
	SceneManager.change_scene(
		scene_id,
		scene_manager_options.create_fade_out_options(),
		scene_manager_options.create_fade_in_options(),
		scene_manager_options.create_general_options()
	)


func change_scene_to_loaded_scene(scene_manager_options_id: String) -> void:
	LogWrapper.debug(self, "Change to loaded scene. ")

	var scene_manager_options: SceneManagerOptions = ResourceReference.get_scene_manager_options(
		scene_manager_options_id
	)
	SceneManager.change_scene_to_loaded_scene(
		scene_manager_options.create_fade_out_options(),
		scene_manager_options.create_fade_in_options(),
		scene_manager_options.create_general_options()
	)


func change_scene_to_existing_scene_in_scene_tree(scene_manager_options_id: String) -> void:
	LogWrapper.debug(self, "Change to loaded scene. ")

	var scene_manager_options: SceneManagerOptions = ResourceReference.get_scene_manager_options(
		scene_manager_options_id
	)
	SceneManager.change_scene_to_existing_scene_in_scene_tree(
		scene_manager_options.create_fade_out_options(),
		scene_manager_options.create_fade_in_options(),
		scene_manager_options.create_general_options()
	)
