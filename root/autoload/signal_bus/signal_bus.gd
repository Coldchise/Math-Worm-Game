extends Node
## The [SignalBus] can be used to provide global signals.
## Use normal signals for child to parent communication, use global signals otherwise.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# Configuration
signal language_changed(locale: String)
signal number_format_changed(number_format: NumberUtils.NumberFormat)

# Game
signal clicks_per_second_updated(cps: int)
