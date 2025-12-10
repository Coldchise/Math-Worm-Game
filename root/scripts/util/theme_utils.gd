# TODO: Does not contain functions for all properties. Expose other properties if and when needed.
class_name ThemeUtils
## Improved getters and setters for theme properties.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const DEFAULT_FONT_SIZE: int = 16
const DEFAULT_SEPARATION: int = 0
const DEFAULT_MINIMUM_SIZE: Vector2 = Vector2(0, 0)
const DEFAULT_MARGIN: int = 0


## returns active theme of control node (control nodes inheirt parent theme if theirs is null)
static func get_inherited_theme(control: Node) -> Theme:
	var theme: Theme = null

	while (control != null) and ("theme" in control):
		theme = control.theme
		if theme != null:
			break
		control = control.get_parent()

	if theme == null:
		theme = ThemeDB.get_project_theme()

	return theme


static func get_font_size(node: Node, default: int = DEFAULT_FONT_SIZE) -> int:
	return _get_property(node, "theme_override_font_sizes/font_size", default)


static func get_separation(node: Node, default: int = DEFAULT_SEPARATION) -> int:
	return _get_property(node, "theme_override_constants/separation", default)


static func get_minimum_size(node: Node, default: Vector2 = DEFAULT_MINIMUM_SIZE) -> Vector2:
	return _get_property(node, "custom_minimum_size", default)


static func get_margin_left(node: Node, default: int = DEFAULT_MARGIN) -> int:
	return _get_property(node, "theme_override_constants/margin_left", default)


static func get_margin_right(node: Node, default: int = DEFAULT_MARGIN) -> int:
	return _get_property(node, "theme_override_constants/margin_right", default)


static func get_margin_top(node: Node, default: int = DEFAULT_MARGIN) -> int:
	return _get_property(node, "theme_override_constants/margin_top", default)


static func get_margin_bottom(node: Node, default: int = DEFAULT_MARGIN) -> int:
	return _get_property(node, "theme_override_constants/margin_bottom", default)


static func set_font_size(node: Node, value: int) -> void:
	_set_property(node, "theme_override_font_sizes/font_size", value)


static func set_separation(node: Node, value: int) -> void:
	_set_property(node, "theme_override_constants/separation", value)


static func set_minimum_size(node: Node, value: Vector2) -> void:
	_set_property(node, "custom_minimum_size", value)


static func set_margin_left(node: Node, value: int) -> void:
	_set_property(node, "theme_override_constants/margin_left", value)


static func set_margin_right(node: Node, value: int) -> void:
	_set_property(node, "theme_override_constants/margin_right", value)


static func set_margin_top(node: Node, value: int) -> void:
	_set_property(node, "theme_override_constants/margin_top", value)


static func set_margin_bottom(node: Node, value: int) -> void:
	_set_property(node, "theme_override_constants/margin_bottom", value)


static func _get_property(node: Node, path: String, default: Variant) -> Variant:
	return node.get(path) if node.get(path) != null else default


static func _set_property(node: Node, path: String, value: Variant) -> void:
	node.set(path, value)
