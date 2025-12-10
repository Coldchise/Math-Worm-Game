# alternative to [LabelParticleTween]
class_name LabelParticleEmitter
extends ParticleEmitter
## Exteds [ParticleEmitter] and sets a particle scene containing a [Label].
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

var label_amount: int = 0
var label_title: String = ""

@onready var label: Label = %Label


func buffer(new_label_amount: int, new_label_title: String) -> void:
	label_amount += new_label_amount
	label_title = new_label_title


func flush() -> void:
	label.text = "+%s %s" % [label_amount, label_title]
	start()
