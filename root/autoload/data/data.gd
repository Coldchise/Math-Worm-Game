extends Node
## Variables in [GameSaveData] will automatically save and load after [select_save_file] is called.
## Variables in [GameSaveData] will be paused after [exit_save_file] is called.
## Variables in [MetaSaveData] are not meant for game data, but for general save file statistics.
## [br][br]
## This node contains children of type [SaveData].
## Each child of type [SaveData] represents a section of the save file and holds data in variables.
## Default project contains two such nodes: [GameSaveData] and [MetaSaveData].
## - If child is [SaveData.is_metadata()], its data is loaded before selecting a save file.
## - Once save file is selected, each [SaveData] child will autosave the data in its own variables.
## [br][br]
## On filesystem, save files will be saved as a json representing save data.
## Save files filesystem structure example: [br]
##	data [br]
##		save_1 [br]
##			save_1_meta.data [br]
##			save_1_game.data [br]
##		save_2 [br]
##			save_2_meta.data [br]
##			save_2_game.data [br]
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Constants determining where to read metadata vars that are displayed in save file selection UI.
const METADATA_CATEGORY: String = "meta"
const METADATA_SAVE_FILE_NAME: String = "save_file_name"
const METADATA_SAVE_PLAYTIME: String = "playtime_seconds"
const METADATA_SAVE_MODIFIED_AT: String = "modified_at_datetime"
const METADATA_SAVE_TIMEZONE: String = "modified_at_timezone"

## Helps verify the integrity of the file contents. (Exists uniquely at the end of the file.)
const SIGNATURE = "§§§"

@export_category("Configuration")
@export var save_file_count: int = 3
## Save files will be of form "prefix_index_category.data" in directory "data/prefix_index".
@export var save_file_root_folder: String = PathConsts.USER + "data/"
@export var save_file_prefix: String = "save"
@export var save_file_extension: String = "data"
@export var autosave_enabled: bool = true
@export var autosave_seconds: int = 5

@export_category("Security")
## WARNING: After changing security settings, will lose save files with old settings.
@export var use_security: bool = false
## If not empty, will encrypt save file save data files on the filesystem. [br]
## NOTE: Not the best solution, because Cheat Engines can modify memory before saving. [br]
## NOTE: Password encryption will slow down reading and writing of the save files.
@export var filesystem_password: String = ""
## When exporting save file to base64, it will be encrypted with the [export_secret] keyword (UUID).
@export var export_secret: String = ""
## If true, will additionally modify secret based on base64 string that is being encrypted.
@export var export_salt: bool = false
## When exporting save file to base64, it will be encrypted with the [export_encryption] method.
@export var export_encryption: MarshallsUtils.CIPHER = MarshallsUtils.CIPHER.NONE

var selected_index: int = -1

## Save file structure is represented by children of type [SaveData].
var _save_datas: Array[SaveData] = []
## Load only metadata parts of all save files.
## Each element: keys are categories of [SaveData], values are vars dicts of [SaveData].
var _save_files_metadatas: Array[Dictionary] = []

## Children hold data of currently selected save file.
@onready var meta: MetaSaveData = %MetaSaveData
@onready var game: GameSaveData = %GameSaveData

@onready var autosave_timer: Timer = %AutosaveTimer


func _ready() -> void:
	if not use_security:
		filesystem_password = ""
		export_secret = ""
		export_encryption = MarshallsUtils.CIPHER.NONE

	_connect_signals()

	_init_data_types()
	_init_nodes()

	reload_save_files_metadatas()

	LogWrapper.debug(self, "Save files initialized: ", _save_files_metadatas.size())


func get_save_files_metadatas() -> Array[Dictionary]:
	return _save_files_metadatas


func reload_save_files_metadatas() -> void:
	_save_files_metadatas = _load_save_files_datas(false)


func is_save_file_selected() -> bool:
	return selected_index != -1


func exit_save_file(save_on_exit: bool = true) -> void:
	if save_on_exit:
		save_save_file()

	var index: int = selected_index

	selected_index = -1
	for save_data: SaveData in _save_datas:
		save_data.clear()

	_reload_save_file_metadatas(index)


func select_save_file(index: int, load_after_select: bool = true) -> void:
	if index < 0 or index >= save_file_count:
		LogWrapper.debug(self, "Invalid index: ", index)
		return
	selected_index = index
	if load_after_select:
		load_save_file()


func load_save_file() -> void:
	if not is_save_file_selected():
		LogWrapper.debug(self, "Load data failed: save file not selected.")
		return
	for save_data: SaveData in _save_datas:
		_system_read_into_or_create(selected_index, save_data)
		save_data.selected_and_loaded(selected_index)


func save_save_file() -> void:
	if not is_save_file_selected():
		LogWrapper.debug(self, "Save data failed: save file not selected.")
		return
	for save_data: SaveData in _save_datas:
		_system_write_from(selected_index, save_data)
		save_data.saved(selected_index)


func rename_save_file_index(index: int, value: String) -> void:
	if index < 0 or index >= save_file_count:
		LogWrapper.debug(self, "Invalid index: ", index)
		return
	if is_save_file_selected():
		LogWrapper.debug(
			self, "Rename failed: save file must not be selected for index operations."
		)
		return

	_system_set_metadata_value(index, value, Data.METADATA_SAVE_FILE_NAME, Data.METADATA_CATEGORY)


func delete_save_file_index(index: int) -> void:
	if index < 0 or index >= save_file_count:
		LogWrapper.debug(self, "Invalid index: ", index)
		return
	if is_save_file_selected():
		LogWrapper.debug(
			self, "Delete failed: save file must not be selected for index operations."
		)
		return

	var path: String = _system_get_save_file_path(index)
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
		LogWrapper.debug(
			name, "Delete path not found (error code %s): " % [DirAccess.get_open_error()], path
		)
		return

	for file in dir.get_files():
		dir.remove(file)
	DirAccess.remove_absolute(path)
	_reload_save_file_metadatas(index)


## Return false if failed.
func import_save_file_index(index: int, import: String) -> bool:
	if index < 0 or index >= save_file_count:
		LogWrapper.debug(self, "Invalid index: ", index)
		return false
	if is_save_file_selected():
		LogWrapper.debug(
			self, "Import failed: save file must not be selected for index operations."
		)
		return false

	var datas: Dictionary = MarshallsUtils.string_to_dict(
		import, export_encryption, export_secret, export_salt
	)
	if datas.is_empty():
		LogWrapper.debug(self, "Import failed: could not convert string to data dict: ", import)
		return false

	_save_save_file_datas(index, datas)
	_reload_save_file_metadatas(index)
	return true


## Return "" if failed.
func export_save_file_index(index: int) -> String:
	if index < 0 or index >= save_file_count:
		LogWrapper.debug(self, "Invalid index: ", index)
		return ""
	if is_save_file_selected():
		LogWrapper.debug(
			self, "Export failed: save file must not be selected for index operations."
		)
		return ""

	var datas: Dictionary = _load_save_file_datas(index, true)
	var export: String = MarshallsUtils.dict_to_string(
		datas, export_encryption, export_secret, export_salt
	)
	return export


func _reload_save_file_metadatas(index: int) -> void:
	var save_file_datas: Dictionary = _load_save_file_datas(index, false)
	_save_files_metadatas[index] = save_file_datas


func _load_save_files_datas(full_load: bool) -> Array[Dictionary]:
	var save_files_datas: Array[Dictionary] = []
	for index: int in range(save_file_count):
		var save_file_datas: Dictionary = _load_save_file_datas(index, full_load)
		save_files_datas.append(save_file_datas)
	return save_files_datas


## Returns category data map for given save file index. If not full load, includes only metadata.
func _load_save_file_datas(index: int, full_load: bool) -> Dictionary:
	var save_file_datas: Dictionary = {}
	for save_data: SaveData in _save_datas:
		var should_load: bool = full_load or save_data.is_metadata()
		if should_load:
			_system_read_into_or_create(index, save_data)
			save_file_datas[save_data.get_category()] = save_data.get_as_dict()
		save_data.clear()
	return save_file_datas


func _save_save_file_datas(index: int, datas: Dictionary) -> void:
	for category: String in datas:
		var data: Dictionary = datas[category]
		var save_data: SaveData = _find_by_category(category)
		if save_data == null:
			LogWrapper.debug(self, "Could not read category '%s'." % [category])
			continue
		save_data.set_from_dict(data)
		_system_write_from(index, save_data)
		save_data.clear()


func _init_nodes() -> void:
	autosave_timer.wait_time = autosave_seconds
	autosave_timer.start()


func _init_data_types() -> void:
	for child: Node in self.get_children():
		if not is_instance_of(child, SaveData):
			continue
		var save_data: SaveData = child as SaveData
		_save_datas.append(save_data)


func _find_by_category(category: String) -> SaveData:
	for save_data: SaveData in _save_datas:
		if save_data.get_category() == category:
			return save_data
	return null


func _system_set_metadata_value(index: int, value: String, key: String, category: String) -> void:
	var save_files_metadatas: Array[Dictionary] = Data.get_save_files_metadatas()
	var save_file_metadatas: Dictionary = save_files_metadatas[index]
	var save_file_meta: Dictionary = save_file_metadatas.get(Data.METADATA_CATEGORY, {})
	if save_file_meta.is_empty():
		LogWrapper.debug(self, "Could not read metadata '%s': " % [category], save_files_metadatas)
		return
	save_file_meta[key] = value

	var save_data: SaveData = _find_by_category(category)
	if save_data == null:
		LogWrapper.debug(self, "Could not read category '%s'." % [category])
		return
	save_data.set_from_dict(save_file_meta)
	_system_write_from(index, save_data)
	save_data.clear()


## Returns file path to save file with given index (or just folder path if category not given).
func _system_get_save_file_path(index: int, category: String = "") -> String:
	var save_file_folder: String = "%s_%s/" % [save_file_prefix, index]
	var folder_path: String = save_file_root_folder + save_file_folder
	if category != "":
		var filename: String = (
			"%s_%s_%s.%s" % [save_file_prefix, index, category, save_file_extension]
		)
		return folder_path + filename
	return folder_path


func _system_write_from(index: int, save_data: SaveData) -> void:
	var category: String = save_data.get_category()
	var data: Dictionary = save_data.get_as_dict()

	var content: String = JSON.stringify(data)
	content += SIGNATURE

	var path: String = _system_get_save_file_path(index, category)
	var save_file: FileAccess = _system_file_access_open(path, FileAccess.WRITE)
	if save_file == null:
		# if cannot open path, create necessary directories then reopen
		var folder_path: String = _system_get_save_file_path(index)
		DirAccess.make_dir_recursive_absolute(folder_path)
		save_file = _system_file_access_open(path, FileAccess.WRITE)
	save_file.store_line(content)
	save_file.close()

	LogWrapper.debug(self, "System write: ", path, "_system_write_from")


## If cannot read save file or its data, create a new save file for given index.
func _system_read_into_or_create(index: int, save_data: SaveData) -> void:
	var success: bool = _system_read_into(index, save_data)
	if not success:
		_system_write_from(index, save_data)
		save_data.saved(index)


## Return false if no data was read (defaults were created), i.e. error or no file found.
func _system_read_into(index: int, save_data: SaveData) -> bool:
	var category: String = save_data.get_category()

	var path: String = _system_get_save_file_path(index, category)
	var save_file: FileAccess = _system_file_access_open(path, FileAccess.READ)
	if save_file == null:
		# if loading index for the first time (save file does not exist), it will be created
		save_data.clear(index)
		LogWrapper.debug(
			name, "Cannot open (error code: %s) at: " % [FileAccess.get_open_error()], path
		)
		return false
	var content: String = save_file.get_as_text()
	save_file.close()

	content = StringUtils.sanitize_newline(content)
	content = _system_verify_signature(content)
	var json_object: JSON = MarshallsUtils.parse_json(content)
	if json_object == null:
		# unreadable save file contents (this should never happen)
		save_data.clear(index)
		LogWrapper.warn(
			name, "Cannot parse (error code: %s) at: " % [FileAccess.get_open_error()], path
		)
		return false

	var data: Dictionary = json_object.get_data()
	save_data.set_from_dict(data, index)

	LogWrapper.debug(self, "System read: ", path)
	return true


## removes corrupt excess data from end of save file (underlying OS can fumble FileAccess operation)
func _system_verify_signature(content: String) -> String:
	var signature_index: int = content.find(SIGNATURE)
	if signature_index == -1:
		LogWrapper.debug(self, "No signature found.")
		return content
	var new_content: String = content.substr(0, signature_index + SIGNATURE.length())
	if content.length() != new_content.length():
		var corrupt_content: String = content.substr(signature_index, content.length())
		LogWrapper.debug(self, "Save file corruption detected and corrected: ", corrupt_content)
	new_content = content.replace(SIGNATURE, "")
	return new_content


func _system_file_access_open(path: String, mode_flags: FileAccess.ModeFlags) -> FileAccess:
	if filesystem_password != "":
		return FileAccess.open_encrypted_with_pass(path, mode_flags, filesystem_password)
	return FileAccess.open(path, mode_flags)


func _connect_signals() -> void:
	autosave_timer.timeout.connect(_on_autosave_timer_timeout)


func _on_autosave_timer_timeout() -> void:
	if is_save_file_selected() and autosave_enabled:
		save_save_file()
