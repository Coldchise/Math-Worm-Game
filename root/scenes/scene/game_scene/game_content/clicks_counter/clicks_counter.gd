extends VBoxContainer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var clicks_counter_title_label: Label = %ClicksCounterTitleLabel
@onready var clicks_counter_value_label: Label = %ClicksCounterValueLabel
@onready var scale_motion: ScaleMotion = %ScaleMotion


func _ready() -> void:
	_connect_signals()
	_refresh_label()
	_load_data()


func _load_data() -> void:
	_on_clicks_per_second_updated(Data.game.max_clicks_per_second)


func _refresh_label() -> void:
	clicks_counter_title_label.text = TranslationServerWrapper.translate(
		"GAME_LABEL_CLICKS_PER_SECONDS"
	)


func _connect_signals() -> void:
	Data.game.coins_set.connect(_on_data_game_coins_set)
	SignalBus.clicks_per_second_updated.connect(_on_clicks_per_second_updated)
	SignalBus.language_changed.connect(_on_language_changed)


func _on_data_game_coins_set(_value: int) -> void:
	if not Data.is_save_file_selected():
		return
	scale_motion.add_motion()


func _on_clicks_per_second_updated(clicks_per_second: int) -> void:
	clicks_counter_value_label.text = (
		"%d / %d" % [clicks_per_second, Data.game.max_clicks_per_second]
	)


func _on_language_changed(_locale: String) -> void:
	_refresh_label()
