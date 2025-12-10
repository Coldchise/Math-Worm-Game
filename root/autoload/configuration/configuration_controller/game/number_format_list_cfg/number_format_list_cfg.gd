class_name NumberFormatListCfg
extends ListConfigurationController
## Extension of [ListConfigurationController] that manages number formatting settings.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var number_format: NumberUtils.NumberFormat = get_default_value()


func init_cfg_options() -> void:
	init_cfg_option(
		_get_option_name("NUMBER_FORMAT_STRING", NumberUtils.NumberFormat.STRING),
		NumberUtils.NumberFormat.STRING
	)
	init_cfg_option(
		_get_option_name("NUMBER_FORMAT_DIGITS", NumberUtils.NumberFormat.DIGITS),
		NumberUtils.NumberFormat.DIGITS
	)
	init_cfg_option(
		_get_option_name("NUMBER_FORMAT_METRIC", NumberUtils.NumberFormat.METRIC),
		NumberUtils.NumberFormat.METRIC
	)
	init_cfg_option(
		_get_option_name("NUMBER_FORMAT_SCIENTIFIC", NumberUtils.NumberFormat.SCIENTIFIC),
		NumberUtils.NumberFormat.SCIENTIFIC
	)


func get_default_value() -> NumberUtils.NumberFormat:
	return NumberUtils.NumberFormat.DIGITS


func get_config_value() -> NumberUtils.NumberFormat:
	return number_format


func apply_config_value(value: Variant) -> void:
	number_format = value

	SignalBus.number_format_changed.emit(number_format)
	configuration_applied.emit()


func _get_option_name(label: String, new_number_format: NumberUtils.NumberFormat) -> String:
	var separator: String = "{0}: {0}".format({"0": TranslationServerWrapper.LOCALE_LIST_SEPARATOR})
	return label + separator + NumberUtils.format(98765, new_number_format)
