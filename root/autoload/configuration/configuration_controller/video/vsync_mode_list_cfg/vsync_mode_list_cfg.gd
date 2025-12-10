class_name VsyncModeListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages VSync mode settings.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# we do not want to execute [_process] every frame, but instead every [_process_delay] seconds
var _process_delay: float = 0.1
var _delay: float = 0
var _last_mode: DisplayServer.VSyncMode = DisplayServer.VSyncMode.VSYNC_ENABLED


# some hardware does not support some vsync modes, so we try to detect that here
func _process(delta: float) -> void:
	_delay += delta
	if _delay > _process_delay:
		_delay = 0
		check_if_last_applied_mode_failed()


func check_if_last_applied_mode_failed() -> void:
	var actual_mode: DisplayServer.VSyncMode = DisplayServer.window_get_vsync_mode()
	if actual_mode != _last_mode:
		disable_cfg_option(_last_mode)
		_last_mode = actual_mode
		configuration_applied.emit()


func is_disabled() -> bool:
	return OS.has_feature("web")  # web browsers limit FPS themselves already


# if project uses compatibility renderer, it does not support VSYNC_ADAPTIVE, VSYNC_MAILBOX options
func init_cfg_options() -> void:
	var gl_disabled: bool = (
		ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility"
	)

	init_cfg_option("MENU_OPTIONS_DISABLED", DisplayServer.VSyncMode.VSYNC_DISABLED)
	init_cfg_option("MENU_OPTIONS_ENABLED", DisplayServer.VSyncMode.VSYNC_ENABLED)
	init_cfg_option("MENU_OPTIONS_ADAPTIVE", DisplayServer.VSyncMode.VSYNC_ADAPTIVE, gl_disabled)
	init_cfg_option("MENU_OPTIONS_FAST", DisplayServer.VSyncMode.VSYNC_MAILBOX, gl_disabled)


func get_default_value() -> DisplayServer.VSyncMode:
	return DisplayServer.VSyncMode.VSYNC_ENABLED


func get_config_value() -> DisplayServer.VSyncMode:
	return DisplayServer.window_get_vsync_mode()


func apply_config_value(value: Variant) -> void:
	var vsync_mode: DisplayServer.VSyncMode = value

	if vsync_mode == get_config_value():
		return  # skip apply if same value is already applied

	DisplayServer.window_set_vsync_mode(vsync_mode)

	_last_mode = vsync_mode
	configuration_applied.emit()
