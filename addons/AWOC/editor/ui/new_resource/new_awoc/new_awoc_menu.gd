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
			set_label(path_validate)
			create_button.disabled = true
			return			
		set_label(SSDMResult.success())
		create_button.disabled = false


func _on_name_line_edit_text_changed(new_text: String) -> void:
	validate(name_line_edit.text)
	
	
func _on_create_button_pressed() -> void:
	create_button.disabled = true
	var params: Dictionary = {}
	params.set("name", name_line_edit.text)
	params.set("path", path_line_edit.text)
	var add_result: SSDMResult = await AWOCPlugin.work_manager.add_resource("welcome", params)
	animate_container.custom_minimum_size.y = outer_panel_container.get_combined_minimum_size().y


func _on_browse_button_pressed() -> void:
	file_dialog.show()
	

func _on_file_dialog_dir_selected(dir: String) -> void:
	path_line_edit.text = dir
	validate(dir)
	
	
func _on_resource_created() -> void:
	name_line_edit.text = ""
	path_line_edit.text = ""
	create_button.disabled = true
	
func _ready() -> void:
	super()
	AWOCPlugin.work_manager.resource_created.connect(_on_resource_created)
