class_name RandomUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


## Given a dictionary, return random string key weighted by corresponding int values. [br]
## Example: {"gold": 10, "silver": 20, "copper": 70} has 20% chance to return "silver" [br]
## If weight_sum is not provided, it will be calculated.
static func random_weighted_item(item_weight_dict: Dictionary, weight_sum: int = 0) -> String:
	if weight_sum <= 0:
		weight_sum = get_weights_sum(item_weight_dict)
	var roll: int = randi() % weight_sum
	for item: String in item_weight_dict:
		var weight: int = item_weight_dict[item]
		if roll < weight:
			return item
		roll -= weight
	return item_weight_dict[item_weight_dict.size() - 1]


## Use this to (re)calculate weight_sum only after dictionary is modified to optimize performance.
static func get_weights_sum(item_weight_dict: Dictionary) -> int:
	return item_weight_dict.values().reduce(func(x: int, n: int) -> int: return x + n, 0)


## Generate random string of given length and charset. (Default charset is ASCII.)
static func random_string(length: int, charset: String = CharsetConsts.ASCII) -> String:
	var result: String = ""
	for i: int in range(length):
		result += charset[randi() % charset.length()]
	return result


## Generate random string by shuffling characters in the given input.
static func shuffle_string(input: String, rng: RandomNumberGenerator = null) -> String:
	var char_array: Array[String]
	char_array.assign(input.split(""))
	shuffle_array(char_array, rng)
	return StringUtils.join(char_array)


## Modifies given array to rearrange elements randomly.
static func shuffle_array(array: Array, rng: RandomNumberGenerator = null) -> void:
	if rng == null:
		array.shuffle()
		return

	for i: int in range(array.size() - 1, 0, -1):
		var j: int = rng.randi_range(0, i)
		var temp: Variant = array[i]
		array[i] = array[j]
		array[j] = temp


static func create_seeded_rng(seed_secret: String) -> RandomNumberGenerator:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = seed_secret.hash()
	return rng
