class_name NumberUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

enum NumberFormat { STRING, DIGITS, METRIC, SCIENTIFIC }


static func format(number: int, number_format: NumberFormat) -> String:
	match number_format:
		NumberFormat.STRING:
			return format_string(number)
		NumberFormat.DIGITS:
			return format_digits(number)
		NumberFormat.METRIC:
			return format_metric(number)
		NumberFormat.SCIENTIFIC:
			return format_scientific(number)
		_:
			return format_string(number)


## Wrapper for built-in function [str].
static func format_string(number: int) -> String:
	return str(number)


## Example: convers number 123456789 to "123,456,789" if group_size is 3.
static func format_digits(number: int, separator: String = ",", group_size: int = 3) -> String:
	var is_negative: bool = number < 0
	var absolute: int = abs(number)

	var input: String = str(absolute)
	var out: Array[String] = []
	var length: int = input.length()
	for i: int in length:
		out.append(input[length - i - 1])
		if i < length - 1 and (i + 1) % group_size == 0:
			out.append(separator)
	out.reverse()

	var output: String = "".join(out)
	return ("-" + output) if is_negative else output


## Converts number to maginute suffix: K = 10^3, M = 10^6, B = 10^9, t = 10^12, q = 10^15.
## Example: converts number 123456 to: "123.4K" if length is 4 or "123.456K" if length is 6 or more.
## 1234 * 10^4
static func format_metric(number: int, length: int = 4) -> String:
	var is_negative: bool = number < 0
	var absolute: int = abs(number)

	var input: String = str(absolute)
	var digits: int = input.length()
	var order: int = min(digits, IntConsts.MAX_INT_LENGTH - 1)
	var suffix: String = _metric_suffix(order)
	if suffix.length() == 0:
		return str(number)

	var magnitude: int = _metric_magnitude(order)
	var part: int = absolute / magnitude
	var remainder: int = absolute % magnitude
	var output: String = str(part)
	var part_digits: int = output.length()
	var leftover_digits: int = digits - part_digits
	var digits_room: int = length - part_digits
	if digits_room > 0:
		var decimal: String = format_zeroes_prefix(remainder, leftover_digits)
		var digits_decimal: int = len(decimal)
		decimal = decimal.substr(0, min(digits_room, digits_decimal))
		output = output + "." + decimal

	output = output + suffix
	return ("-" + output) if is_negative else output


## Example: 567890123 is formatted as "5.679e8" for 4 digits and base 10.
static func format_scientific(number: int, significant_digits: int = 4, base: int = 10) -> String:
	var is_negative: bool = number < 0
	var absolute: int = abs(number)

	if float(absolute) < pow(base, significant_digits - 1):
		return str(absolute)

	var magnitude: int = int(floor(MathUtils.logarithm(abs(absolute), base)))
	var scaled: float = float(absolute) / pow(base, magnitude)
	var mantissa: String = str(scaled).pad_decimals(significant_digits - 1)
	var output: String = "%se%d" % [mantissa, magnitude]

	return ("-" + output) if is_negative else output


## Append leading zeroes to given number such that total length is reached.
## Example: (123, 5) -> "00123".
static func format_zeroes_prefix(number: int, total_length: int) -> String:
	return "%0*d" % [total_length, number]


static func format_digits_list(
	values: Array[int], separator: String = ",", group_size: int = 3
) -> Array:
	return values.map(
		func(v: int) -> String: return NumberUtils.format_digits(v, separator, group_size)
	)


static func format_metric_list(values: Array[int], length: int = 4) -> Array:
	return values.map(func(v: int) -> String: return NumberUtils.format_metric(v, length))


static func format_scientific_list(
	values: Array[int], significant_digits: int = 4, base: int = 10
) -> Array:
	return values.map(
		func(v: int) -> String: return NumberUtils.format_scientific(v, significant_digits, base)
	)


## The built-in function only checks for digits, not if the value will overflow the int value. [br]
## - https://github.com/godotengine/godot/issues/75072
## [br][br]
## Original Function MIT License Copyright (c) 2024 alexmunoz502
static func is_valid_int(input_string: String) -> bool:
	if not input_string.is_valid_int():
		return false

	var number_string: String = input_string.lstrip("0")
	if number_string == "":
		return true

	if number_string.length() > IntConsts.MAX_INT_LENGTH:
		return false
	if number_string.length() < IntConsts.MAX_INT_LENGTH:
		return true
	if number_string.begins_with("-"):
		return number_string >= str(IntConsts.MIN_INT)
	return number_string <= str(IntConsts.MAX_INT)


static func _metric_suffix(index: int) -> String:
	return [
		"", "", "", "", "K", "K", "K", "M", "M", "M", "B", "B", "B", "t", "t", "t", "q", "q", "q"
	][index]


static func _metric_magnitude(index: int) -> int:
	return [
		0,
		0,
		0,
		0,
		1000,
		1000,
		1000,
		1000000,
		1000000,
		1000000,
		1000000000,
		1000000000,
		1000000000,
		1000000000000,
		1000000000000,
		1000000000000,
		1000000000000000,
		1000000000000000,
		1000000000000000,
	][index]
