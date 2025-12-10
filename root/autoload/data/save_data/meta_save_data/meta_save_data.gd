class_name MetaSaveData
extends SaveData
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var save_file_name: String

var playtime_seconds: int
var file_open_count: int

var modified_at_datetime: Dictionary
var modified_at_timezone: Dictionary
var modified_at_version: String

var created_at_datetime: Dictionary
var created_at_timezone: Dictionary
var created_at_version: String


## Metadata updates itself after save file is saved.
func saved(_index: int = -1) -> void:
	var current_datetime: Dictionary = Time.get_datetime_dict_from_system(true)
	var current_timezone: Dictionary = DatetimeUtils.get_time_zone_from_system()
	var current_version: String = ProjectSettings.get_setting("application/config/version")

	if created_at_datetime.is_empty():
		created_at_datetime = current_datetime.duplicate()
	if created_at_timezone.is_empty():
		created_at_timezone = current_timezone.duplicate()
	if created_at_version.is_empty():
		created_at_version = current_version

	if not modified_at_datetime.is_empty():
		playtime_seconds += DatetimeUtils.difference_seconds(modified_at_datetime, current_datetime)
	modified_at_datetime = current_datetime.duplicate()
	modified_at_timezone = current_timezone.duplicate()
	modified_at_version = current_version


## Modified at is updated at load time so that playtime can be properly calculated at save time.
func selected_and_loaded(_index: int = -1) -> void:
	modified_at_datetime = Time.get_datetime_dict_from_system(true)
	file_open_count += 1


## Default save file name is "save {index}".
func clear(index: int = -1) -> void:
	save_file_name = ""

	playtime_seconds = 0
	file_open_count = 0

	modified_at_datetime = {}
	modified_at_timezone = {}
	modified_at_version = ""

	created_at_datetime = {}
	created_at_timezone = {}
	created_at_version = ""

	if index != -1:
		if StringUtils.is_empty(save_file_name):
			save_file_name = "Save %s" % [index]
