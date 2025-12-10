class_name GameOptionsContainer
extends OptionsContainer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var game_mode_menu_dropdown_node: MenuDropdownNode = %GameModeMenuDropdownNode


func get_config_group() -> ConfigurationEnum.Group:
	return ConfigurationEnum.Group.GAME
