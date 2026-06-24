@tool
class_name AWOCNewSlotMenu
extends SSDMNewResourceMenuBase

	
func validate(new_text: String) -> void:
	var name_validate: SSDMResult = SSDMValidator.is_valid_name(name_line_edit.text)
	if !name_validate.is_success():	
		message_display.set_label(name_validate)
		create_button.disabled = true
		return		
	message_display.set_label(SSDMResult.success())
	create_button.disabled = false


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate(name_line_edit.text)
	
	
func _on_create_button_pressed() -> void:
	create_button.disabled = true
	var params: Dictionary = {}
	params.set("name", name_line_edit.text)
	params.set("type", "slot")
	var add_result: SSDMResult = await AWOCPlugin.work_manager.add_resource(resource_type, params)
	if add_result.is_success():
		reset_menu()
	message_display.set_label(add_result)
	
	
func _ready() -> void:
	super()
