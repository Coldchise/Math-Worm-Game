@tool
extends Node
## Extends [TranslationServer] with extra functionality and to fix some issues: [br]
## - Supports [LOCALE_LIST_SEPARATOR] for handling localization concatenations. [br]
## - Supports [translate] working in @tool scripts in the editor (return key if not found). [br]
## - Fixes: https://github.com/godotengine/godot/issues/46271
## [br][br]
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const LOCALE_LIST_SEPARATOR: String = "|"

const DEFAULT_EDITOR_LOCALE: String = "en"


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	LogWrapper.debug(self, "AUTOLOAD READY.")


func translate(text: String) -> String:
	if text == null:
		return ""

	if not text.contains(LOCALE_LIST_SEPARATOR):
		return _translate(text)

	var texts: String = ""
	for subtext: String in text.split(LOCALE_LIST_SEPARATOR):
		texts += _translate(subtext)
	return texts


func _translate(text: String) -> String:
	if text == null:
		return ""

	var localized_text: String
	if Engine.is_editor_hint():
		var translation: Translation = TranslationServer.get_translation_object(
			DEFAULT_EDITOR_LOCALE
		)
		localized_text = translation.get_message(text)
	else:
		localized_text = tr(text)

	if localized_text == "":
		return text
	return localized_text
