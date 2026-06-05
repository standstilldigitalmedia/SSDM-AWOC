@tool
class_name SSDMNewResourceMenuBase
extends SSDMVerticalMenuBase

@export var name_line_edit: LineEdit
@export var create_button: Button


func reset_menu() -> void:
	name_line_edit.text = ""
	create_button.disabled = true
	
	
func validate_name() -> SSDMResult:
	var name_validate: SSDMResult = SSDMValidator.is_valid_name(name_line_edit.text)
	if !name_validate.is_success():
		return name_validate
	return SSDMResult.success()


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate_name()


func _on_create_button_pressed() -> void:
	message_display.set_label(SSDMResult.failure("_on_create_button_pressed must be overridden"))
	
	
func _ready() -> void:
	message_display.hide()
	create_button.disabled = true
	super()
