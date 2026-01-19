extends Control

@onready var pre_area:Label = $Screen/ColorRect/full/displaycontainer/MarginContainer/VBoxContainer/PreArea
@onready var display:Label = $Screen/ColorRect/full/displaycontainer/MarginContainer/VBoxContainer/Area

var total = 0
var last_symbol = ""
var expression := ""
var current_input := ""

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
		"×":
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
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"Pi":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"EE":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"Rand":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"2nd":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
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
		"c":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"del":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		"a/b":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
		".":
			if expression == "":
				expression = current_input
			do_math()
			last_symbol = symbol
			expression += symbol
			current_input = ""
			update_display()
	print(symbol)

func do_math():
	var n: float

	# Determine which value to operate on
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

		# Binary
		"+":
			total += n
		"-":
			total -= n
		"×":
			total *= n
		"/":
			if n != 0:
				total /= n
			else:
				display.text = "Error"
				total = 0
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
			total = sin(n)
		"cos(":
			total = cos(n)
		"tan(":
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
			total = PI
		"Rand":
			total = randi() % 100  # random int from 0 to 99

		
		_:
			print("Unknown operation: ", last_symbol)

	# Reset current_input for next entry
	current_input = ""
	update_display()
	print("total: ", total)

# Factorial helper
func factorial(n: int) -> int:
	if n <= 1:
		return 1
	return n * factorial(n - 1)
