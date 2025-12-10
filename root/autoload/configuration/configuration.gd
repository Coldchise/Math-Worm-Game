extends Node
## Manages configurations defined in [ConfigurationEnum]. [br]
## - ConfigurationControllers are configurations that can be changed during project runtime. [br]
## - ConfigurationNodes are configurations that are set before the project starts.
## [br][br]
## The [ConfigurationControllerLoader] maps [ConfigurationEnum] to [ConfigurationController].
## [br][br]

const GAME_TITLE: String = "GAME_TITLE"
const GAME_AUTHOR: String = ""

@export var loader: ConfigurationControllerLoader


func _ready() -> void:
	ConfigStorageAppLog.app_opened()

	LogWrapper.debug(self, "AUTOLOAD READY.")


func reset_options(config_group: ConfigurationEnum.Group) -> void:
	var cfgs: Array[ConfigurationController] = loader.get_configuration_controllers(config_group)
	for cfg: ConfigurationController in cfgs:
		cfg.reset_config_value()


func get_theme() -> Theme:
	return %ThemeListCfg.get_config_value()


func get_number_format() -> NumberUtils.NumberFormat:
	return %NumberFormatListCfg.get_config_value()


func get_game_mode_content_scene() -> PackedScene:
	return %GameModeListCfg.get_config_resource()
