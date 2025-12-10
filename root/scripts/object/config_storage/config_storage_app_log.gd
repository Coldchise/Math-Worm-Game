class_name ConfigStorageAppLog
## Uses [ConfigStorage] to track information related to the usage of the app. [br]
## Example: Called at the start of [Configuration].
## [br][br]
## Modified File MIT License Copyright (c) 2024 TinyTakinTeller
## Original File MIT License Copyright (c) 2022-present Marek Belski

const APP_LOG_SECTION: String = "AppLog"

const APP_OPENED_COUNT_KEY: String = "AppOpenedCount"
const APP_FIRST_VERSION_OPENED_KEY: String = "AppFirstVersionOpened"
const APP_LAST_VERSION_OPENED_KEY: String = "AppLastVersionOpened"


static func app_opened() -> void:
	_update_app_opened_count()

	var app_version: String = ProjectSettings.get_setting("application/config/version", "0")
	_update_app_first_version_opened(app_version)
	_update_app_last_version_opened(app_version)


static func _update_app_opened_count() -> void:
	ConfigStorage.increment_config(APP_LOG_SECTION, APP_OPENED_COUNT_KEY)


static func _update_app_first_version_opened(new_value: String) -> void:
	var value: String = ConfigStorage.get_config(APP_LOG_SECTION, APP_FIRST_VERSION_OPENED_KEY, "")
	if value == "":
		ConfigStorage.set_config(APP_LOG_SECTION, APP_FIRST_VERSION_OPENED_KEY, new_value)


static func _update_app_last_version_opened(new_value: String) -> void:
	ConfigStorage.set_config(APP_LOG_SECTION, APP_LAST_VERSION_OPENED_KEY, new_value)
