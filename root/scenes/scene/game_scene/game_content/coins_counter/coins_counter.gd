extends VBoxContainer
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

@onready var coins_counter_title_label: Label = %CoinsCounterTitleLabel
@onready var coins_counter_value_label: Label = %CoinsCounterValueLabel
@onready var scale_motion: ScaleMotion = %ScaleMotion


func _ready() -> void:
	_connect_signals()
	_refresh_label()
	_load_data()


func _load_data() -> void:
	_on_data_game_coins_set(Data.game.coins)


func _refresh_label() -> void:
	coins_counter_title_label.text = TranslationServerWrapper.translate("CONTEXT_ITEM_LOVE")


func _refresh_coins_counter() -> void:
	var number_format: NumberUtils.NumberFormat = Configuration.get_number_format()
	coins_counter_value_label.text = NumberUtils.format(Data.game.coins, number_format)


func _connect_signals() -> void:
	Data.game.coins_set.connect(_on_data_game_coins_set)
	SignalBus.language_changed.connect(_on_language_changed)
	SignalBus.number_format_changed.connect(_on_number_format_changed)


func _on_data_game_coins_set(_value: int) -> void:
	if not Data.is_save_file_selected():
		return
	_refresh_coins_counter()
	scale_motion.add_motion()


func _on_language_changed(_locale: String) -> void:
	_refresh_label()


func _on_number_format_changed(_number_format: NumberUtils.NumberFormat) -> void:
	_refresh_coins_counter()
