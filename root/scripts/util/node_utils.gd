class_name NodeUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


## Same as [Node.get_parent(node)] if [levels] is set to 1. Else, repeated [levels] amount of times.
static func get_grandparent(node: Node, levels: int) -> Node:
	var target: Node = node
	for i in range(levels):
		target = target.get_parent()
	return target


## remove child from node
static func remove_child(node: Node, child: Node) -> void:
	node.remove_child(child)
	child.queue_free()


## remove all children of given node
static func remove_children(node: Node) -> void:
	for child: Node in node.get_children():
		remove_child(node, child)


## remove all children of given node with given type
static func remove_children_of(node: Node, type: Variant) -> void:
	for child: Node in node.get_children():
		if is_instance_of(child, type):
			remove_child(node, child)


## remove child of given node at given index (allows large and negative index, looping around)
static func remove_child_at(parent: Node, index: int) -> void:
	index = index % parent.get_child_count()
	var child: Node = parent.get_child(index)
	parent.remove_child(child)
	child.queue_free()


## remove last child of given node
static func remove_child_back(parent: Node) -> void:
	remove_child_at(parent, -1)


## remove first child of given node
static func remove_child_front(parent: Node) -> void:
	remove_child_at(parent, 0)


## add child to given node to last spot
static func add_child_back(child: Node, parent: Node) -> void:
	parent.add_child(child)


## add child to given node to first spot
static func add_child_front(child: Node, parent: Node) -> void:
	parent.add_child(child)
	parent.move_child(child, 0)


## add child to given node to first spot
static func add_child_at(child: Node, parent: Node, index: int) -> void:
	parent.add_child(child)
	parent.move_child(child, index)


## add child to given node such that children remain sorted (assumes children are sorted before add)
static func add_child_sorted(child: Node, parent: Node, compare_func: Callable) -> void:
	var children: Array[Node] = parent.get_children()
	if children.size() == 0:
		parent.add_child(child)
	var position: int = children.bsearch_custom(child, compare_func)
	add_child_at(child, parent, position)


## Iterates all children and their children ... and applies the given function.
## If [max_depth] is set to 0, iterates recursively all the way down.
static func apply_function_to_all_children(
	node: Node, function: Callable, internal: bool = false, max_depth: int = 0, depth: int = 0
) -> void:
	if max_depth > 0 and depth >= max_depth:
		return
	for child: Node in node.get_children(internal):
		function.call(child)
		apply_function_to_all_children(child, function, internal, max_depth, depth + 1)


## Checks given node then checks all children and their children ... until valid target is found.
## If [max_depth] is set to 0, iterates recursively all the way down.
static func find_descendant(
	node: Node, is_valid: Callable, internal: bool = false, max_depth: int = 0, depth: int = 0
) -> Node:
	if max_depth > 0 and depth >= max_depth:
		return null
	if is_valid.call(node):
		return node
	for child: Node in node.get_children(internal):
		var target: Node = find_descendant(child, is_valid, internal, max_depth, depth)
		if target != null:
			return target
	return null
