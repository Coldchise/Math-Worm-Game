class_name MenuTreeUI
extends Tree
## Tree UI container with addition and deletion buttons on tree items.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## The [button_id] will be positive or negative (for add or del button), or 0 if keyboard was used
signal tree_item_button_clicked(tree_item: TreeItem, button_id: int)

const COLUMN: int = 0

# expose main properties
@export_group("MenuTreeUI")
## Will not set add button to last level or beyond.
@export var max_levels: int = 2
## If false, will not set del button to first level.
@export var is_first_level_removable: bool = false
@export var add_button_texture: Texture2D
@export var del_button_texture: Texture2D

var _total_button_count: int = 0


func _ready() -> void:
	_connect_signals()


# allows keyboard / joystick users to interact with item button(s)
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		click_item_button()


func click_item_button() -> void:
	var selected_tree_item: TreeItem = self.get_selected()
	if selected_tree_item != null:
		tree_item_button_clicked.emit(selected_tree_item, 0)


func default_title_mapper_callable(metadata: Variant) -> String:
	return str(metadata)


## Create items with [nested_dictionary] keys as metadata and title text mapped by [title_mappers].
func set_items(
	nested_dictionary: Dictionary,
	title_mappers: Dictionary,
	default_title_mapper: Callable = default_title_mapper_callable
) -> void:
	self.clear()
	var root_tree_item: TreeItem = self.create_item()
	add_items(nested_dictionary, root_tree_item, title_mappers, default_title_mapper, 0)


func add_items(
	current_dict: Dictionary,
	parent_item: TreeItem,
	title_mappers: Dictionary,
	default_title_mapper: Callable,
	level: int,
) -> void:
	for key: Variant in current_dict:
		var title: String = title_mappers.get(level, default_title_mapper).call(key)
		var tree_item: TreeItem = add_tree_item(key, title, parent_item, level)
		var next_dict: Variant = current_dict[key]
		if next_dict is Dictionary:
			add_items(next_dict, tree_item, title_mappers, default_title_mapper, level + 1)


func add_tree_item(
	metadata: Variant, title: String, parent_tree_item: TreeItem, level: int
) -> TreeItem:
	var tree_item: TreeItem = self.create_item(parent_tree_item)
	tree_item.set_text(COLUMN, title)
	tree_item.set_metadata(COLUMN, metadata)
	_add_tree_item_buttons(tree_item, level)
	return tree_item


# will set positive id to add button and negative id to del button
func _add_tree_item_buttons(tree_item: TreeItem, level: int) -> void:
	if add_button_texture != null:
		if level < max_levels - 1:
			_total_button_count += 1
			tree_item.add_button(COLUMN, add_button_texture, _total_button_count)
	if del_button_texture != null:
		if (level == 0 and is_first_level_removable) or level > 0:
			_total_button_count += 1
			tree_item.add_button(COLUMN, del_button_texture, -_total_button_count)


func _connect_signals() -> void:
	self.focus_exited.connect(_on_tree_item_focus_exited)
	self.cell_selected.connect(_on_tree_item_cell_selected)
	self.button_clicked.connect(_on_tree_item_button_clicked)


func _on_tree_item_focus_exited() -> void:
	self.deselect_all()
	LogWrapper.debug(self, "Menu tree item: deselected.")


func _on_tree_item_cell_selected() -> void:
	pass


func _on_tree_item_button_clicked(
	item: TreeItem, _column: int, id: int, _mouse_button_index: int
) -> void:
	tree_item_button_clicked.emit(item, id)
