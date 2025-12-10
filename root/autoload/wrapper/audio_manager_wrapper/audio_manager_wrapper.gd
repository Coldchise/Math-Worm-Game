# TODO: Does not wrap all methods. Wrap other methods from [MusicManager] [SoundManager] if needed.
extends Node
## Wraps Resonance (Audio Manager) plugin autoloads [MusicManager] [SoundManager] methods. [br]
## - initializes audio tracks in [AudioBanks] [br]
## - uses [AudioEnum] enum instead of string names [br]
## - extends [play_music] with [unique] flag that tracks [_already_playing] music
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

# tracks already playing music (useful to avoid replaying looped music)
var _already_playing: Dictionary[String, bool] = {}

@onready var audio_banks: AudioBanks = %AudioBanks


func _ready() -> void:
	LogWrapper.debug(self, "AUTOLOAD READY.")


func play_music(music: AudioEnum.Music, crossfade: float = 0.0, unique: float = true) -> void:
	var music_name: String = EnumUtils.to_name(music, AudioEnum.Music)

	# skip playing music if [unqiue] flag is true
	if unique:
		if _already_playing.get(music_name, false):
			return
		_already_playing[music_name] = true

	MusicManager.play(audio_banks.MUSIC_BANK, music_name, crossfade)


func play_sfx(sfx: AudioEnum.Sfx) -> void:
	SoundManager.play(audio_banks.SOUND_BANK, EnumUtils.to_name(sfx, AudioEnum.Sfx))
