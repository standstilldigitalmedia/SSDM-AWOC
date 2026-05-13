@tool
class_name AWOCNewAWOCMenu
extends AWOCNewResourceMenuBase

@export var path_line_edit: LineEdit
@export var file_dialog: FileDialog


func reset_menu() -> void:
	path_line_edit.text = ""
	file_dialog.hide()
	super()
	
	
func validate(new_text: String) -> void:
	var name_validate: AWOCResult = validate_name()
	if name_validate.is_success():		
		var path_validate: AWOCResult = AWOCValidator.is_valid_new_path(path_line_edit.text)
		if !path_validate.is_success():
			set_label(path_validate)
			create_button.disabled = true
			return
			
		set_label(AWOCResult.success())
		create_button.disabled = false


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate(name_line_edit.text)
	
	
func _on_create_button_pressed() -> void:
	var resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	var create_resource: AWOCResult = AWOCPlugin.work_manager.get_new_resource("welcome")
	if !create_resource.is_success():
		set_label(create_resource)
		return
	resource_reference.resource = create_resource.data
	resource_reference.res_path = path_line_edit.text
	var add_resource: AWOCResult = await AWOCPlugin.work_manager.add_resource("welcome", name_line_edit.text, resource_reference)
	set_label(add_resource)
	if add_resource.is_success():
		reset_menu()
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y


func _on_browse_button_pressed() -> void:
	file_dialog.show()
	

func _on_file_dialog_dir_selected(dir: String) -> void:
	path_line_edit.text = dir
	validate(dir)
