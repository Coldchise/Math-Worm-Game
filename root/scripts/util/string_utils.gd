class_name StringUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


static func is_set(string: String) -> bool:
	return string != null and not string.is_empty()


static func is_empty(string: String) -> bool:
	return string == null or string.is_empty()


static func equals_ignore_case(a: String, b: String) -> bool:
	return a.to_lower() == b.to_lower()


static func join(char_array: Array[String]) -> String:
	var output: String = ""
	for c: String in char_array:
		output += c
	return output


## Adds suffix and prefix as padding to given text.
static func add_padding(text: String, n: int, padding: String = " ") -> String:
	for i: int in range(n):
		text = padding + text + padding
	return text


## Shorten text from end to fit given max_length.
static func trim_end(text: String, max_length: int) -> String:
	return text.substr(0, min(text.length(), max_length))


## Remove chars from text that are not in allowed charset.
static func trim_unallowed(text: String, allowed_charset: String) -> String:
	var output: String = ""
	for c in text:
		if allowed_charset.contains(c):
			output += c
	return output


## Remove chars from text that are not in allowed and then shorten it down to max_length. [br]
## Default allowed charset is ASCII, while default max_length is unlimited.
static func sanitize_text(
	text: String,
	allowed_charset: String = CharsetConsts.ASCII,
	max_length: int = -1,
	default_empty: String = ""
) -> String:
	text = StringUtils.trim_unallowed(text, allowed_charset)
	if max_length > -1:
		text = StringUtils.trim_end(text, max_length)
	if text.length() == 0:
		text = default_empty
	return text


static func sanitize_newline(text: String) -> String:
	text = text.replace("\n", "")
	text = text.replace("\r\n", "")
	text = text.replace("\n\r", "")
	return text


static func charset_map(charset_keys: String, charset_values: String) -> Dictionary:
	var map: Dictionary = {}
	for i: int in range(charset_keys.length()):
		map[charset_keys[i]] = charset_values[i]
	return map
