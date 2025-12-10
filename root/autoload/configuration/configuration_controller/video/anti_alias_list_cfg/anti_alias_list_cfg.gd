class_name AntiAliasListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages anti alias settings.
## Tracks both MSAA and FXAA anti alias types as combined setting. (Disallows both at same time.)
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

enum AntiAlias { AA_DISABLED, FXAA, MSAA_2X, MSAA_4X, MSAA_8X }


func init_cfg_options() -> void:
	var gl_disabled: bool = (
		ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility"
	)

	init_cfg_option("MENU_OPTIONS_DISABLED", AntiAlias.AA_DISABLED)
	init_cfg_option("FXAA", AntiAlias.FXAA)
	init_cfg_option("MSAA 2X", AntiAlias.MSAA_2X, gl_disabled)
	init_cfg_option("MSAA 4X", AntiAlias.MSAA_4X, gl_disabled)
	init_cfg_option("MSAA 8X", AntiAlias.MSAA_8X, gl_disabled)


func get_default_value() -> AntiAlias:
	return AntiAlias.AA_DISABLED


func get_config_value() -> AntiAlias:
	if get_viewport().screen_space_aa == Viewport.ScreenSpaceAA.SCREEN_SPACE_AA_FXAA:
		return AntiAlias.FXAA
	if Viewport.MSAA.MSAA_2X in [get_viewport().msaa_2d, get_viewport().msaa_3d]:
		return AntiAlias.MSAA_2X
	if Viewport.MSAA.MSAA_4X in [get_viewport().msaa_2d, get_viewport().msaa_3d]:
		return AntiAlias.MSAA_4X
	if Viewport.MSAA.MSAA_8X in [get_viewport().msaa_2d, get_viewport().msaa_3d]:
		return AntiAlias.MSAA_8X
	return AntiAlias.AA_DISABLED


func apply_config_value(value: Variant) -> void:
	var anti_alias: AntiAlias = value

	if is_disabled():
		return  # skip apply if configuration is disabled (not supported)

	if anti_alias == AntiAlias.AA_DISABLED:
		_disable_fxaa()
		_disable_msaa()
	elif anti_alias == AntiAlias.FXAA:
		get_viewport().screen_space_aa = Viewport.ScreenSpaceAA.SCREEN_SPACE_AA_FXAA
		_disable_msaa()
	else:
		_disable_fxaa()
		if anti_alias == AntiAlias.MSAA_2X:
			_set_msaa_2d_and_3d(Viewport.MSAA.MSAA_2X)
		elif anti_alias == AntiAlias.MSAA_4X:
			_set_msaa_2d_and_3d(Viewport.MSAA.MSAA_4X)
		elif anti_alias == AntiAlias.MSAA_8X:
			_set_msaa_2d_and_3d(Viewport.MSAA.MSAA_8X)

	configuration_applied.emit()


func _disable_fxaa() -> void:
	get_viewport().screen_space_aa = Viewport.ScreenSpaceAA.SCREEN_SPACE_AA_DISABLED


func _disable_msaa() -> void:
	get_viewport().msaa_2d = Viewport.MSAA.MSAA_DISABLED
	get_viewport().msaa_3d = Viewport.MSAA.MSAA_DISABLED


func _set_msaa_2d_and_3d(msaa: Viewport.MSAA) -> void:
	get_viewport().msaa_2d = msaa
	get_viewport().msaa_3d = msaa
