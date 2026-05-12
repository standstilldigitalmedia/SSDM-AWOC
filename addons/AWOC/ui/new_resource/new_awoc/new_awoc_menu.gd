@tool
class_name AWOCNewAWOCMenu
extends SSDMNewResourceMenuBase

@export var path_line_edit: LineEdit
@export var file_dialog: FileDialog


func reset_menu() -> void:
	path_line_edit.text = ""
	file_dialog.hide()
	super()
	
	
func validate(new_text: String) -> void:
	var name_validate: SSDMResult = validate_name()
	if name_validate.is_success():		
		var path_validate: SSDMResult = SSDMValidator.is_valid_new_path(path_line_edit.text)
		if !path_validate.is_success():
			message_display.set_label(path_validate)
			create_button.disabled = true
			return
			
		message_display.set_label(SSDMResult.success())
		create_button.disabled = false


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate(name_line_edit.text)
	
	
func _on_create_button_pressed() -> void:
	var resource_reference: SSDMResourceReference = SSDMResourceReference.new()
	var create_resource: SSDMResult = AWOCPlugin.work_manager.get_new_resource("welcome")
	if !create_resource.is_success():
		message_display.set_label(create_resource)
		return
	resource_reference.resource = create_resource.data
	resource_reference.res_path = path_line_edit.text
	var add_resource: SSDMResult = await AWOCPlugin.work_manager.add_resource("welcome", name_line_edit.text, resource_reference)
	message_display.set_label(add_resource)
	if add_resource.is_success():
		reset_menu()


func _on_browse_button_pressed() -> void:
	file_dialog.show()
	

func _on_file_dialog_dir_selected(dir: String) -> void:
	path_line_edit.text = dir
	validate(dir)
