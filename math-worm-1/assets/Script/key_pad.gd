extends Control

@onready var label: Label = $ColorRect/MarginContainer/Label
@onready var numbers_grid := $Numbers
@onready var letters_grid := $Letters

func _ready() -> void:
	_show_numbers()

func clear_answer():
	label.text = ""

func key_press(digit):
	label.text += str(digit)


# =========================
# Number buttons (Unchanged)
# =========================

func _on_button_0_pressed() -> void:
	key_press("0")

func _on_button_1_pressed() -> void:
	key_press("1")

func _on_button_2_pressed() -> void:
	key_press("2")

func _on_button_3_pressed() -> void:
	key_press("3")

func _on_button_4_pressed() -> void:
	key_press("4")

func _on_button_5_pressed() -> void:
	key_press("5")

func _on_button_6_pressed() -> void:
	key_press("6")

func _on_button_7_pressed() -> void:
	key_press("7")

func _on_button_8_pressed() -> void:
	key_press("8")

func _on_button_9_pressed() -> void:
	key_press("9")


# =========================
# Operators (Unchanged)
# =========================

func _on_buttonplus_pressed() -> void:
	key_press("+")

func _on_buttonminus_pressed() -> void:
	key_press("-")

func _on_buttonmultiply_pressed() -> void:
	key_press("×")   # or "*"

func _on_buttondivide_pressed() -> void:
	key_press("÷")   # or "/"

func _on_button_square_root_pressed() -> void:
	key_press("√")

func _on_dot_pressed() -> void:
	key_press(".")


# =========================
# Edit actions - Both physical buttons MUST be connected to this single function
# =========================

func _on_backspace_pressed() -> void:
	if label.text.length() > 0:
		label.text = label.text.substr(0, label.text.length() - 1)

func _on_c_pressed() -> void:
	label.text = ""


# =========================
# Show / hide grids (Unchanged)
# =========================

func _show_numbers() -> void:
	numbers_grid.visible = true
	letters_grid.visible = false

func _show_letters() -> void:
	letters_grid.visible = true
	numbers_grid.visible = false


# Buttons that switch between grids (Unchanged)

func _on_numberselection_pressed() -> void:
	_show_numbers()

func _on_letterselection_pressed() -> void:
	_show_letters()


# =========================
# Letter buttons (Unchanged)
# =========================

func _on_openparenthesis_pressed() -> void:
	key_press("(")

func _on_closeparenthesis_pressed() -> void:
	key_press(")")

func _on_x_pressed() -> void:
	key_press("x")   # or "X"

func _on_y_pressed() -> void:
	key_press("y")   # or "Y"

func _on_z_pressed() -> void:
	key_press("z")   # or "Z")
