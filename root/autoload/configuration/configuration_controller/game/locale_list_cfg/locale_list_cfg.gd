class_name LocaleListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages locale (language) settings.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# localization.csv key that represents the locale (language) name
const LOCALIZED_OPTION_NAME_KEY := "STRING_ID"


func init_cfg_options() -> void:
	var current_locale := TranslationServer.get_locale()
	for locale in TranslationServer.get_loaded_locales():
		TranslationServer.set_locale(locale)
		var locale_name: String = TranslationServer.translate(LOCALIZED_OPTION_NAME_KEY)
		init_cfg_option(locale_name, locale)
	TranslationServer.set_locale(current_locale)

	cfg_options.options.sort_by_values()


func get_default_value() -> String:
	return "en"


func get_config_value() -> Variant:
	return TranslationServer.get_locale()


func apply_config_value(value: Variant) -> void:
	var locale: String = value

	if locale == get_config_value():
		return  # skip apply if same value is already applied

	TranslationServer.set_locale(locale)

	SignalBus.language_changed.emit(locale)
	configuration_applied.emit()
