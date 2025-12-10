class_name MenuUnbindDialog
extends ConfirmationDialog
## Original File MIT License Copyright (c) 2024 TinyTakinTeller

const CONFIRM_LABEL: String = "MENU_LABEL_CONFIRM_BUTTON_YOU"
const CANCEL_LABEL: String = "MENU_LABEL_CANCEL_YOU"
const DELETE_DIALOG_LABEL: String = "MENU_OPTIONS_KEYBINDS_DELETE_DIALOG_LABEL"


func custom_popup(parent_item_text: String, item_text: String) -> void:
	self.dialog_text = (
		TranslationServerWrapper.translate(DELETE_DIALOG_LABEL) % [parent_item_text, item_text]
	)
	self.ok_button_text = TranslationServerWrapper.translate(CONFIRM_LABEL)
	self.cancel_button_text = TranslationServerWrapper.translate(CANCEL_LABEL)
	self.popup_centered(Vector2i(1, 1))
