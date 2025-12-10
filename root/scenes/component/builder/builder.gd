# example: [UiBuilder]
class_name Builder
extends Node
## Instantiate and attach given component nodes [attach_components] to found targets.
## Recursive search over all nodes below its parent to find targets satisfying some conditions.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export_group("Setup")
## If false, must call [build] function manually.
@export var build_on_ready: bool = true
## If true, will search for targets among internal children.
@export var include_internal: bool = true

@export_group("Conditions")
## Keys are existing node properties to look for.
## Values are needed target values (leave null for any value).
@export var condition_properties: Dictionary
## Keys are existing node properties to look for.
## Values are forbidden target values (leave null for any value).
@export var not_condition_properties: Dictionary

@export_group("Exceptions")
@export var no_condition_classes: Array[Variant]
@export var no_condition_names: Array[String]

@export_group("Components")
@export var attach_components: Array[PackedScene]
## If key matches the node name, value should be a dictionary of form:
## {TYPE: PROPERTIES} where PROPERTIES is a dictionary of custom values to apply to the component.
@export var customize: Dictionary
## If key matches the node name, will skip value as a list of attach_components.
@export var skip: Dictionary

# Will target only [_condition_class] type of nodes.
var _condition_class: Variant

var _attach_count: int = 0


func _ready() -> void:
	if build_on_ready:
		build()


func build() -> void:
	search_children(self.get_parent())

	LogWrapper.debug(
		name,
		"Attached %d instances of %d components each." % [_attach_count, attach_components.size()]
	)


func search_children(node: Node) -> void:
	for child: Node in node.get_children(include_internal):
		search_children(child)
		if is_matching_conditions(child):
			do_attach_components(child)


func is_matching_conditions(node: Node) -> bool:
	var matching_condition_classes: bool = is_matching_condition_classes(node)
	if not matching_condition_classes:
		return false

	var matching_condition_properties: bool = is_matching_condition_properties(node)
	if not matching_condition_properties:
		return false

	return true


func is_matching_condition_classes(node: Node) -> bool:
	if not is_instance_of(node, _condition_class):
		return false

	for no_condition_class: Variant in no_condition_classes:
		if is_instance_of(node, no_condition_class):
			return false

	for no_condition_name: Variant in no_condition_names:
		if node.name == no_condition_name:
			return false

	return true


func is_matching_condition_properties(node: Node) -> bool:
	for condition_property: String in condition_properties:
		if condition_property not in node:
			return false
		var value: Variant = condition_properties[condition_property]
		if value != null and value != node.get(condition_property):
			return false

	for not_condition_property: String in not_condition_properties:
		if not_condition_property in node:
			var value: Variant = not_condition_properties[not_condition_property]
			if value == null or value == node.get(not_condition_property):
				return false

	return true


func do_attach_components(parent: Node) -> void:
	_attach_count += 1

	for component: PackedScene in attach_components:
		var instance: Node = component.instantiate()
		if is_skip(instance, parent):
			continue

		customize_component(instance, parent)
		NodeUtils.add_child_back(instance, parent)


func is_skip(node: Node, parent: Node) -> bool:
	for skip_name: String in skip:
		if parent.name != skip_name:
			continue

		var skip_type: Variant = skip[skip_name]
		if is_instance_of(node, skip_type):
			return true

	return false


func customize_component(node: Node, parent: Node) -> void:
	for custom_name: String in customize:
		if parent.name != custom_name:
			continue

		var custom: Dictionary = customize[custom_name]
		for type: Variant in custom:
			if is_instance_of(node, type):
				var properties: Dictionary = custom[type]
				for property: String in properties:
					if property in node:
						node.set(property, properties[property])
