class_name DisplayModeListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages display mode settings.
## Tracks window modes including borderless and maximized states.
## [br][br]
## Coupled with [ResolutionListCfg], see usage in [_reload_resolution].
## Coupled with external changes, see [_connect_signals].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## This enum extends [DisplayServer.WindowMode] enum with borderless flag in some cases.
## UNDEFINED value is to cover cases that can be externally set on some platforms.
## Example: [DisplayServer.WindowMode.WINDOW_MODE_MINIMIZED] on desktop platforms.
enum DisplayMode {
	UNDEFINED,
	WINDOWED,
	MAXIMIZED,
	FULLSCREEN,
	BORDERLESS_WINDOWED,
	BORDERLESS_MAXIMIZED,
	EXCLUSIVE_FULLSCREEN
}

var _window_mode_map: Dictionary[DisplayServer.WindowMode, DisplayMode] = {
	DisplayServer.WindowMode.WINDOW_MODE_WINDOWED: DisplayMode.WINDOWED,
	DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED: DisplayMode.MAXIMIZED,
	DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN: DisplayMode.FULLSCREEN,
	DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN: DisplayMode.EXCLUSIVE_FULLSCREEN
}

# used to detect if the configuration was updated by this script (internally) or not (externally)
var _internal_update: bool = false


func init_cfg_options() -> void:
	_connect_signals()

	var disabled_on_web: bool = OS.has_feature("web")

	init_cfg_option("MENU_OPTIONS_FULLSCREEN", DisplayMode.FULLSCREEN)
	init_cfg_option("MENU_OPTIONS_WINDOWED", DisplayMode.WINDOWED)
	init_cfg_option("MENU_OPTIONS_MAXIMIZED", DisplayMode.MAXIMIZED, disabled_on_web)
	init_cfg_option(
		"MENU_OPTIONS_EXCLUSIVE_FULLSCREEN", DisplayMode.EXCLUSIVE_FULLSCREEN, disabled_on_web
	)
	init_cfg_option(
		"MENU_OPTIONS_BORDERLESS_WINDOWED", DisplayMode.BORDERLESS_WINDOWED, disabled_on_web
	)
	init_cfg_option(
		"MENU_OPTIONS_BORDERLESS_MAXIMIZED", DisplayMode.BORDERLESS_MAXIMIZED, disabled_on_web
	)


func get_default_value() -> DisplayMode:
	return DisplayMode.WINDOWED


func get_config_value() -> DisplayMode:
	if _is_borderless_windowed():
		return DisplayMode.BORDERLESS_WINDOWED
	if _is_borderless_maximized():
		return DisplayMode.BORDERLESS_MAXIMIZED
	return _window_mode_map.get(DisplayServer.window_get_mode(), DisplayMode.UNDEFINED)


func apply_config_value(value: Variant) -> void:
	var display_mode: DisplayMode = value

	if display_mode == get_config_value():
		return  # skip apply if same value is already applied

	_internal_update = true
	if display_mode == DisplayMode.WINDOWED:
		_set_windowed()
	elif display_mode == DisplayMode.MAXIMIZED:
		_set_maximized()
	elif display_mode == DisplayMode.FULLSCREEN:
		_set_fullscreen()
	elif display_mode == DisplayMode.BORDERLESS_WINDOWED:
		_set_borderless_windowed()
	elif display_mode == DisplayMode.BORDERLESS_MAXIMIZED:
		_set_borderless_maximized()
	elif display_mode == DisplayMode.EXCLUSIVE_FULLSCREEN:
		_set_exclusive_fullscreen()
	else:
		pass
	_internal_update = false

	# seems [DisplayServer] needs 2 frames to propagate changes
	await get_tree().process_frame
	await get_tree().process_frame

	# seems some web browsers need time to return new window mode
	if OS.has_feature("web"):
		await get_tree().create_timer(0.1).timeout

	configuration_applied.emit()


func _is_borderless_windowed() -> bool:
	return (
		DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
		and DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	)


func _is_borderless_maximized() -> bool:
	return (
		DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED
		and DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	)


func _set_windowed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	_reload_resolution()


func _set_maximized() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _set_fullscreen() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)


func _set_borderless_windowed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	_reload_resolution()
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _set_borderless_maximized() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	_reload_resolution()
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _set_exclusive_fullscreen() -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


## Need to re-apply [ResolutionListCfg] when changing to a windowed display mode.
## (Otherwise, some [Control] nodes do not display properly.)
func _reload_resolution() -> void:
	var list_cfg: ConfigurationEnum.ListCfg = ConfigurationEnum.ListCfg.RESOLUTION
	var resolution_list_cfg: ResolutionListCfg = (
		Configuration.loader.get_list_configuration_controller(list_cfg)
	)
	resolution_list_cfg.load_config_value()


## OS can externally modify the display mode, so we detect that here.
## Examples: window buttons on desktop, fullscreen shortcut key on web browser.
func _connect_signals() -> void:
	get_tree().get_root().size_changed.connect(_on_viewport_size_changed)


func _on_viewport_size_changed() -> void:
	if _internal_update:
		return  # skip notification if [apply_config_value] function was the cause of the signal

	_configuration_applied_externally.call_deferred()


## Similarly to [update_config_value], we proceed to save the new value and emit the signal.
func _configuration_applied_externally() -> void:
	var value_index: int = get_config_value_index()
	if value_index == -1:
		return  # skip notification if applied value is not among supported configuration values
	if get_config_value_index() == get_saved_config_value_index():
		return  # skip notification if applied value is already equal to saved configuration value

	save_config_value_index(value_index)

	configuration_applied.emit()
