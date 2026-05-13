@tool
class_name AWOCNewResourceMenuBase
extends AWOCVerticalMenu

@export var name_line_edit: LineEdit
@export var create_button: Button


func reset_menu() -> void:
	name_line_edit.text = ""
	create_button.disabled = true
	
	
func validate_name() -> AWOCResult:
	var name_validate: AWOCResult = AWOCValidator.is_valid_name(name_line_edit.text)
	if !name_validate.is_success():
		set_label(name_validate)
		create_button.disabled = true
		return name_validate
	return AWOCResult.success()


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate_name()


func _on_create_button_pressed() -> void:
	pass # Replace with function body.
