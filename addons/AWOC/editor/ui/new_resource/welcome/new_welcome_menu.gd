@tool
class_name AWOCNewWelcomeMenu
extends SSDMNewResourceMenuBase

@export var path_browser: SSDMPathBrowser


func reset_menu() -> void:
	path_browser.reset_menu()
	super()
	
	
func validate(new_text: String) -> void:
	var name_validate: SSDMResult = SSDMValidator.is_valid_name(name_line_edit.text)
	if !name_validate.is_success():	
		message_display.set_label(name_validate)
		create_button.disabled = true
		return	
	var path_validate: SSDMResult = SSDMValidator.is_valid_new_path(path_browser.path_line_edit.text)
	if !path_validate.is_success():
		message_display.set_label(path_validate)
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
	params.set("path", path_browser.path_line_edit.text)
	var add_result: SSDMResult = await SSDMPlugin.work_manager.add_resource(resource_type, params)
	if add_result.is_success():
		reset_menu()
	message_display.set_label(add_result)
	
	
func _on_valid_path(path: String) -> void:
	var name_validate: SSDMResult = SSDMValidator.is_valid_name(name_line_edit.text)
	message_display.set_label(name_validate)
	create_button.disabled = !name_validate.is_success()
	
	
func _on_invalid_path(path: String) -> void:
	message_display.set_label(SSDMResult.failure("Invalid Path"))
	create_button.disabled = true
	
	
func _ready() -> void:
	path_browser.valid_path.connect(_on_valid_path)
	path_browser.invalid_path.connect(_on_invalid_path)
	super()
