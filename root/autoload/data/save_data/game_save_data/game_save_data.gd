class_name GameSaveData
extends SaveData
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

signal coins_set(value: int)
signal max_clicks_per_second_set(value: int)

var coins: int:
	set(value):
		coins = value
		coins_set.emit(value)

var max_clicks_per_second: int:
	set(value):
		max_clicks_per_second = value
		max_clicks_per_second_set.emit(value)


func clear(_index: int = -1) -> void:
	coins = 0
	max_clicks_per_second = 0
