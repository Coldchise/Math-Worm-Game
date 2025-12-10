class_name MathUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


static func logarithm(value: int, base: int) -> float:
	return log(value) / log(base)


## Integer power. (Edge cases in order: 0^x = 0, 1^x = 1, x^0 = 1)
static func pow_int(base: int, exponent: int) -> int:
	if base == 0 or exponent < 0:
		return 0
	if base == 1 or exponent == 0:
		return 1

	var result: int = 1
	for i: int in range(exponent):
		result *= base
	return result


## Example: 5678 in base 10 is converted to {3: 5, 2: 6, 1: 7, 0: 8}.
func int_to_base_dict(n: int, base: int) -> Dictionary:
	var result: Dictionary = {}
	var position: int = 0
	while n > 0:
		result[position] = n % base
		n = n / base
		position += 1
	return result


## Uses [factor_x] for both dimensions if [factor_y] is not provided.
static func scale_v2i(vector: Vector2i, factor_x: float, factor_y: float = 0.0) -> Vector2i:
	if is_equal_approx(factor_y, 0.0):
		factor_y = factor_x
	var x: int = int(float(vector.x) * factor_x)
	var y: int = int(float(vector.y) * factor_y)
	return Vector2i(x, y)
