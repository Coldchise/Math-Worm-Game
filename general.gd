extends Control

@onready var pre_area:Label = $Screen/ColorRect/full/displaycontainer/MarginContainer/VBoxContainer/PreArea
@onready var display:Label = $Screen/ColorRect/full/displaycontainer/MarginContainer/VBoxContainer/Area

var total = 0
var last_symbol = ""
var expression := ""
var current_input := ""
var just_cleared = true
var just_evaluated = false
var radians_mode := true
var just_second = false

func _ready():
	randomize()
	display.text = "0"
	update_display()


func update_display():
	if expression == "" and current_input == "":
		display.text = "0"
	else:
		display.text = expression + current_input
		
func _on_number_pressed(number:int) -> void:
	if just_cleared or display.text == "0" or just_evaluated:
		current_input = str(number)
		just_cleared = false
		just_evaluated = false
	else:
		current_input += str(number)
	update_display()
func _on_symbol_pressed(symbol:String) -> void:
	print(symbol)
	match(symbol):
		"+":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"-":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"*":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"/":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"=":
			do_math()
			display.text = str(total)
			current_input = str(total)
			expression = ""
			last_symbol = ""
			just_evaluated = true
		"+/-":
			if current_input != "":
				# flip the sign of the current input
				if current_input.begins_with("-"):
					current_input = current_input.substr(1)  # remove the minus
				else:
					current_input = "-" + current_input     # add the minus
			else:
				# if no input, flip the total
				total = -total
				current_input = str(total)
			update_display()

		"^(-1)":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"^2":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"^3":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"^":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"!":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"sqrt(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"cbrt(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"log(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"sin(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"cos(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
			last_symbol = symbol
		"tan(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"ln(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"sinh(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"cosh(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"tanh(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"e^":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"Rad":
			radians_mode = !radians_mode  # toggle the mode
			pre_area.text = "RAD" if radians_mode else "DEG"
			current_input = ""
			expression = ""
			last_symbol = ""
			just_cleared = true

		"Pi":
			current_input = str(PI)
			update_display()
		"EE":
			if current_input != "":
				total = float(current_input)
				last_symbol = "EE"
				current_input = ""
				expression += "e"
		"Rand":
			total = randi() % 100
			display.text = str(total)
			current_input = str(total)
			expression = ""
			last_symbol = ""
		"(":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		")":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"%":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"mc":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"m+":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"m-":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"mr":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"ac":
			display.text = "0"
			total = 0
			last_symbol = ""
			current_input = ""
			expression = ""
			just_cleared = true
		"del":
			if display.text.length() > 1:
				display.text = display.text.left(display.text.length() - 1)
			else:
				display.text = "0"
		"a/b":
			if current_input != "":
				# Check if input is fraction (has "/")
				if "/" in current_input:
					var parts = current_input.split("/")
					if parts.size() == 2:
						var numerator = int(parts[0])
						var denominator = int(parts[1])
						var dec = float(numerator) / float(denominator)
						display.text = str(dec)
						current_input = str(dec)
				# Otherwise assume decimal
				else:
					var dec = float(current_input)
					var frac = decimal_to_fraction(dec)
					display.text = str(frac[0]) + "/" + str(frac[1])
					current_input = display.text
			update_display()
		".":
			if "." not in current_input:
				if current_input == "":
					current_input = "0."
				else:
					current_input += "."
			update_display()
	print(symbol)

func do_math():
	var n: float = 0.0

	if current_input != "":
		n = float(current_input)
	elif last_symbol in ["^2","^3","^(-1)","!","sqrt()","cbrt()","sin(","cos(","tan(","ln(","log(","sinh(","cosh(","tanh(","e^"]:
		# If current_input is empty, apply unary to total
		n = total
	else:
		# Nothing to calculate
		print("Error: no input")
		return
	
	# Perform operation
	match last_symbol:
		"":  # first input
			total = n
		"+":
			total += n
		"-":
			total -= n
		"*":
			total *= n
		"/":
			if n != 0:
				total = float(total)
				total /= n
			else:
				display.text = "Error"
				total = str(total)
				total = "Error"
		"^":
			total = pow(total, n)

		# Unary
		"^2":
			total = n * n
		"^3":
			total = n * n * n
		"^(-1)":
			if n != 0:
				total = 1 / n
			else:
				display.text = "Error"
				total = 0
		"!":
			if n < 0 or n != int(n):
				display.text = "Error"
				total = 0
			else:
				total = factorial(int(n))
		"sqrt()":
			if n >= 0:
				total = sqrt(n)
			else:
				display.text = "Error"
				total = 0
		"cbrt(":
			if n == 0:
				total = 0
			elif n > 0:
				total = pow(n, 1.0/3.0)
			else:
				total = -pow(-n, 1.0/3.0)
		"sin(":
			if not radians_mode:
				n = deg_to_rad(n)  # convert degrees to radians
			total = sin(n)
		"cos(":
			if not radians_mode:
				n = deg_to_rad(n)
			total = cos(n)
		"tan(":
			if not radians_mode:
				n = deg_to_rad(n)
			total = tan(n)
		
		"ln(":
			if n > 0:
				total = log(n)
			else:
				display.text = "Error"
				total = 0
		"log(":
			if n > 0:
				total = log(n) / log(10)
			else:
				display.text = "Error"
				total = 0
		"sinh(":
			total = sinh(n)
		"cosh(":
			total = cosh(n)
		"tanh(":
			total = tanh(n)
		"e^":
			total = exp(n)
		"Pi":
			current_input = str(PI)
			expression = ""
			update_display()
		"Rand":
			total = randi() % 100  # random int from 0 to 99
		"EE":
			if current_input != "":
		# total × 10^current_input
				total = total * pow(10, float(current_input))
		"a/b":
			if current_input != "":
				n = float(current_input)
				if n != 0:
					total = 1.0 / n
				else:
					display.text = "Error"
					total = 0
			else:
				# kung walang input, apply sa total
				if total != 0:
					total = 1.0 / total
				else:
					display.text = "Error"
					total = 0

		_:
			print("Unknown operation: ", last_symbol)
		


	current_input = ""
	update_display()
	print("total: ", total)

# Factorial helper
func factorial(n: int) -> int:
	if n <= 1:
		return 1
	return n * factorial(n - 1)
	
func decimal_to_fraction(x: float, max_denominator: int = 1000) -> Array:
	var closest_numerator = 0
	var closest_denominator = 1
	var min_error = abs(x - float(closest_numerator)/closest_denominator)

	for d in range(1, max_denominator+1):
		var n = round(x * d)
		var error = abs(x - float(n)/d)
		if error < min_error:
			min_error = error
			closest_numerator = n
			closest_denominator = d
	return [closest_numerator, closest_denominator]
