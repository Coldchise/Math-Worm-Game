extends Node
## Preload explicitly assets here for quick access.
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# Music
const MENU_DOODLE_2_LOOP: AudioStream = preload(
	PathConsts.ASSETS + "audio/music/menu_doodle_2_loop/ogg/menu_doodle_2_loop.ogg"
)

# SFX
const CLICK_4: AudioStream = preload(PathConsts.SFX + "kenny_ui/ogg/click4.ogg")
const CLICK_5: AudioStream = preload(PathConsts.SFX + "kenny_ui/ogg/click5.ogg")
const MOUSECLICK_1: AudioStream = preload(PathConsts.SFX + "kenny_ui/ogg/mouseclick1.ogg")
const MOUSERELEASE_1: AudioStream = preload(PathConsts.SFX + "kenny_ui/ogg/mouserelease1.ogg")
