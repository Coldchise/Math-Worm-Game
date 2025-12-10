class_name DictionaryUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


## Helper for a dictionary of dictionaries.
static func set_nested_value(dictionary: Dictionary, key_path: Array, value: Variant) -> void:
	for i: int in range(key_path.size() - 1):
		var key: Variant = key_path[i]
		if not dictionary.has(key) or typeof(dictionary[key]) != TYPE_DICTIONARY:
			dictionary[key] = {}
		dictionary = dictionary[key]
	dictionary[key_path[-1]] = value


## Helper for a dictionary of dictionaries.
static func delete_nested_key(dictionary: Dictionary, key_path: Array) -> void:
	for i: int in range(key_path.size() - 1):
		var key: Variant = key_path[i]
		if not dictionary.has(key):
			return
		dictionary = dictionary[key]
	dictionary.erase(key_path[-1])
