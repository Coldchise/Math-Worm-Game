class_name ClickCounter
extends Node
## Calculates average clicks in interval.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

## Interval to claculate average clicks.
@export var interval: float = 1.0
## How often to emit the [update] signal.
@export var process_window: float = 0.1

var _timestamps: Array = []
var _timestamps_time: float = 0.0
var _process_time: float = 0.0


func _process(delta: float) -> void:
	_process_time += delta
	if _process_time >= process_window:
		_timestamps_time += _process_time
		_process_time = 0.0
		while _timestamps.size() > 0 and _timestamps[0] < _timestamps_time - interval:
			_timestamps.pop_front()
		SignalBus.clicks_per_second_updated.emit(int(float(_timestamps.size()) / interval))


func click() -> void:
	_timestamps.append(_timestamps_time)
