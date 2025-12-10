@tool
extends Control

@export_group("Next Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_boot"

var _boot_splash_color: Color = ProjectSettings.get("application/boot_splash/bg_color")

@onready var boot_splash_color_rect: ColorRect = %BootSplashColorRect

func _ready() -> void:
	_set_boot_splash()

	if Engine.is_editor_hint():
		return

	SceneManagerWrapper.change_scene(scene, scene_manager_options_id)

func _set_boot_splash() -> void:
	boot_splash_color_rect.color = _boot_splash_color
