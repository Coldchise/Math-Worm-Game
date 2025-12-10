@tool
extends Control

@export_group("Next Scene")
@export var scene: SceneManagerEnum.Scene = SceneManagerEnum.Scene.MENU_SCENE
@export var scene_manager_options_id: String = "fade_boot"

var _boot_splash_color: Color = ProjectSettings.get("application/boot_splash/bg_color")
var _boot_splash_image_path: String = ProjectSettings.get("application/boot_splash/image")
var _boot_splash_texture: Texture = load(_boot_splash_image_path)

@onready var boot_splash_color_rect: ColorRect = %BootSplashColorRect
@onready var boot_splash_texture_rect: TextureRect = %BootSplashTextureRect

func _ready() -> void:
	_set_boot_splash()

	if Engine.is_editor_hint():
		return

	# This wants an enum value, not a String
	SceneManagerWrapper.change_scene(scene, scene_manager_options_id)

func _set_boot_splash() -> void:
	boot_splash_color_rect.color = _boot_splash_color
	boot_splash_texture_rect.texture = _boot_splash_texture
