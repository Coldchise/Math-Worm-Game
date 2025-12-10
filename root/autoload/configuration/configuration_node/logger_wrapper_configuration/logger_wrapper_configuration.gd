class_name LoggerWrapperConfiguration
extends Node
## When calling [LogWrapper] methods, use [debug_log_groups] and [prod_log_groups] dictionaries
## keys as first argument. This will override the default log groups (log levels) for that log call.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@export_group("Debug")
@export var default_debug_log_group: Log.LogLevel = Log.LogLevel.DEBUG
@export var debug_log_groups: Dictionary[String, int] = {
	"ParticleQueue": Log.LogLevel.WARN,
	"Data": Log.LogLevel.DEBUG,
	#"Reference": LogWrapper.LOG_LEVEL_DISABLED,
	"TweenSpawnerBuffer": LogWrapper.LOG_LEVEL_DISABLED,
	"ActionHandler": LogWrapper.LOG_LEVEL_DISABLED,
	"ButtonAudio": LogWrapper.LOG_LEVEL_DISABLED,
	"OkButtonAudio": LogWrapper.LOG_LEVEL_DISABLED,
	"CancelButtonAudio": LogWrapper.LOG_LEVEL_DISABLED,
	"SliderAudio": LogWrapper.LOG_LEVEL_DISABLED,
	"TreeAudio": LogWrapper.LOG_LEVEL_DISABLED,
	"MenuKeybinds": LogWrapper.LOG_LEVEL_DISABLED,
	"ConfirmationDialogJsLoader.eval_snippet": LogWrapper.LOG_LEVEL_DISABLED,
	"MarshallsUtils.string_to_dict": LogWrapper.LOG_LEVEL_DISABLED,
	"Data._system_write_from": LogWrapper.LOG_LEVEL_DISABLED
}

@export_group("Prod")
@export var default_prod_log_group: Log.LogLevel = Log.LogLevel.INFO
@export var prod_log_groups: Dictionary = {}
## If true, always skips execution of debug log lines in prod environment, removes logging overhead.
@export var disable_debug_in_prod: bool = true


func _ready() -> void:
	if OS.is_debug_build():
		_init_debug_configuration()
	else:
		_init_release_configuration()


func _init_debug_configuration() -> void:
	Log.current_log_level = default_debug_log_group
	LogWrapper.default_log_group = default_debug_log_group
	LogWrapper.log_groups = debug_log_groups
	LogWrapper.disable_debug_logs = false


func _init_release_configuration() -> void:
	Log.current_log_level = default_prod_log_group
	LogWrapper.default_log_group = default_prod_log_group
	LogWrapper.log_groups = prod_log_groups
	LogWrapper.disable_debug_logs = disable_debug_in_prod
