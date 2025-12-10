class_name EnumUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const NAME: String = "ConfigurationEnum"


## Tries to convert string name to enum value. (If it fails, returns 0.)
## Ignores string case (upper = lower) in comparisons.
## Tries direct comparison first, then tries comparison without underscore if [robust] is true.
static func from_name(string_name: String, enum_class: Variant, robust: bool = true) -> int:
	for key: int in range(enum_class.keys().size()):
		var name: String = enum_class.keys()[key]
		if StringUtils.equals_ignore_case(name, string_name):
			return key
		if robust and StringUtils.equals_ignore_case(name.replace("_", ""), string_name):
			return key

	LogWrapper.error(NAME, "Could not match name '%s' to any of: " % string_name, enum_class.keys())
	return 0


## Convert enum value to string name.
static func to_name(int_value: int, enum_class: Variant) -> String:
	return enum_class.keys()[int_value] as String
