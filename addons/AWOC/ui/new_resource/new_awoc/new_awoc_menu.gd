@tool
class_name AWOCNewAWOCMenu
extends SSDMVerticalMenu

@export var name_line_edit: LineEdit
@export var path_line_edit: LineEdit
@export var file_dialog: FileDialog


func validate(new_text: String) -> void:
	var name_validate: SSDMResult = SSDMValidator.is_valid_name(name_line_edit.text)
	if !name_validate.is_success():
		message_display.set_label(name_validate)
		create_button.disabled = true
		return
		
	var path_validate: SSDMResult = SSDMValidator.is_valid_new_path(path_line_edit.text)
	if !path_validate.is_success():
		message_display.set_label(path_validate)
		create_button.disabled = true
		return
		
	message_display.set_label(SSDMResult.success())
	create_button.disabled = false
