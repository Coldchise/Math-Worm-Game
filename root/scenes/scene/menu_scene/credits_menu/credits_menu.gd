class_name CreditsMenu
extends Control
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var credits: Credits = %Credits
@onready var back_menu_button: MenuButtonClass = %BackMenuButton


func _ready() -> void:
	LogWrapper.debug(self, "Scene ready.")
