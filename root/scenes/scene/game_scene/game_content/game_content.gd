class_name GameContent
extends Control
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var control_grab_focus: ControlGrabFocus = %ControlGrabFocus
@onready var pause_menu_button: MenuButtonClass = %PauseMenuButton


func _ready() -> void:
	LogWrapper.debug(self, "Scene ready.")
