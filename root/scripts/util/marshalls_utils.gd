class_name MarshallsUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

enum CIPHER { NONE, MONOALPHABETIC_SUBSTITUTION }

const NAME: String = "MarshallsUtils"

const BASE_64_CHARSET: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="


## Either encrypt or decrypt input string, depedning on given [flag] being true or false.
static func run_cipher(
	input: String, cipher: CIPHER, secret: String, flag: bool, charset: String
) -> String:
	if secret == "":
		return input
	match cipher:
		CIPHER.NONE:
			return input
		CIPHER.MONOALPHABETIC_SUBSTITUTION:
			return monoalphabetic_substitution_cipher(input, charset, secret, flag)
		_:
			return input


# ubstitutions are vulnerable to frequency analysis (use for deterrence, not security)
static func monoalphabetic_substitution_cipher(
	input: String, charset: String, secret: String, flag: bool
) -> String:
	var rng: RandomNumberGenerator = RandomUtils.create_seeded_rng(secret)
	var shuffled_charset: String = RandomUtils.shuffle_string(charset, rng)
	var swap_map: Dictionary = (
		StringUtils.charset_map(charset, shuffled_charset)
		if flag
		else StringUtils.charset_map(shuffled_charset, charset)
	)

	var output: String = ""
	for c: String in input:
		output += swap_map.get(c, c)
	return output


static func dict_to_string(
	dict: Dictionary, cipher: CIPHER = CIPHER.NONE, secret: String = "", salt: bool = false
) -> String:
	var json_string: String = JSON.stringify(dict)
	var base64_string: String = Marshalls.utf8_to_base64(json_string)

	if salt:
		secret += str(base64_string.length())
	base64_string = run_cipher(base64_string, cipher, secret, true, BASE_64_CHARSET)

	return base64_string


static func string_to_dict(
	base64_string: String, cipher: CIPHER = CIPHER.NONE, secret: String = "", salt: bool = false
) -> Dictionary:
	if salt:
		secret += str(base64_string.length())
	base64_string = run_cipher(base64_string, cipher, secret, false, BASE_64_CHARSET)

	var json_string: String = Marshalls.base64_to_utf8(base64_string)
	if json_string == null:
		LogWrapper.warn(NAME, "Failed to convert base64 to utf8: ", base64_string)
		return {}

	var json_object: JSON = parse_json(json_string)
	if json_object == null:
		LogWrapper.warn(NAME, "Failed to parse json: ", json_string, "string_to_dict")
		return {}

	return json_object.get_data()


## Reverse method of [JSON.stringify], returns null if it fails.
static func parse_json(json_string: String) -> JSON:
	var json_object: JSON = JSON.new()
	var parse_err: Error = json_object.parse(json_string)
	if parse_err != Error.OK:
		LogWrapper.warn(NAME, "Failed parse json (error code: %s): " % [parse_err], json_string)
		return null
	return json_object
