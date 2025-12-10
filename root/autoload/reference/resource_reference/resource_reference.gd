extends Node
## Preload automatically assets here for quick access.
## [br][br]
## Example usage: [ResourceReference.get_resource(resource_id, SceneManagerOptions)].
## [br][br]
## Preloads all resources (.tres files) in PRELOAD_PATH (res://resources/preload).
## Holds references to resources in dictionary by name as key (see getter methods).
## The key also holds a prefix to avoid conflicts of equal names across different resources types.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const NAME: String = "Reference"

const PRELOAD_PATH = PathConsts.RESOURCES + "preload/"
const RESOURCE_EXTENSION = ".tres"

var _resource_references_map: Dictionary[String, Resource] = {}


func _ready() -> void:
	var paths: Array[String] = FileSystemUtils.get_paths(PRELOAD_PATH, RESOURCE_EXTENSION)
	_resource_references_map = _load_resources(paths)

	LogWrapper.debug(self, "AUTOLOAD READY.")


func get_particle_process_material(particle_id: String) -> ParticleProcessMaterial:
	return get_resource(particle_id, "ParticleProcessMaterial")


func get_scene_manager_options(resource_id: String) -> SceneManagerOptions:
	return get_resource(resource_id, SceneManagerOptions)


func get_resource(resource_id: String, type: Variant) -> Resource:
	var key: String = _get_key(resource_id, type)
	if _resource_references_map.has(key):
		return _resource_references_map[key]
	return null


static func _load_resources(paths: Array[String]) -> Dictionary[String, Resource]:
	var resource_references: Dictionary[String, Resource] = {}
	for path: String in paths:
		var resource: Resource = load(path) as Resource
		if resource != null:
			var resource_id: String = FileSystemUtils.get_file_name(path)
			var key: String = _get_key(resource_id, _get_type(resource))
			if resource_references.has(key):
				LogWrapper.warn(NAME, "Duplicate resource reference key: ", key)
				continue
			resource_references[key] = resource
			LogWrapper.debug(NAME, "Success to load resource reference key: ", key)
		else:
			LogWrapper.warn(NAME, "Failed to load resource reference at: ", path)
	return resource_references


static func _get_type(resource: Resource) -> Variant:
	return resource.get_script() if resource.get_script() != null else resource


static func _get_key(resource_id: String, type: Variant) -> String:
	if type == null:
		return resource_id
	if type is String or type is StringName:
		return type + "-" + resource_id
	if "get_global_name" in type:
		return type.get_global_name() + "-" + resource_id
	return type.get_class() + "-" + resource_id
