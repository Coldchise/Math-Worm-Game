class_name ConfigurationEnum
## Tracks [ConfigurationController] children in [Configuration].
## [br][br]

enum Group { OTHER, AUDIO, VIDEO, CONTROLS, GAME }

enum ListCfg {
	NULL,
	ANTI_ALIAS,
	DISPLAY_MODE,
	FPS_LIMIT,
	RESOLUTION,
	VSYNC_MODE,
	GAME_MODE,
	NUMBER_FORMAT,
	LOCALE,
	THEME
}

enum SliderCfg { NULL, AUDIO, MUSIC, SFX, WINDOW_ZOOM }

enum ToggleCfg { NULL, AUDIO, FPS_COUNT, AUTOSAVE }

enum TreeCfg { NULL, KEYBINDS }
