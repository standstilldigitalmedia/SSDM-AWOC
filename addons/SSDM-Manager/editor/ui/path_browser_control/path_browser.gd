@tool
class_name SSDMPathBrowser
extends VBoxContainer

signal valid_path(path: String)
signal invalid_path(path: String)

@export var is_dir: bool = false
@export var label_text: String = ""
@export_group("Nodes")
@export var control_label: Label
@export var path_line_edit: LineEdit
@export var browse_button: Button
@export var file_dialog: FileDialog


func validate(new_text: String) -> void:
	var validate_result: SSDMResult = SSDMValidator.is_valid_new_path(new_text)
	if validate_result.is_success():
		valid_path.emit(new_text)
	else:
		invalid_path.emit(new_text)
		
		
func reset_menu() -> void:
	path_line_edit.text = ""
	browse_button.disabled = false
	file_dialog.hide()


func _on_file_dialog_dir_selected(dir: String) -> void:
	path_line_edit.text = dir
	browse_button.disabled = false
	validate(dir)


func _on_file_dialog_file_selected(path: String) -> void:
	path_line_edit.text = path
	browse_button.disabled = false
	validate(path)
	
	
func _on_path_line_edit_text_changed(new_text: String) -> void:
	validate(new_text)


func _on_browse_button_pressed() -> void:
	print("browse")
	browse_button.disabled = true
	file_dialog.show()
	
	
func _ready() -> void:
	control_label.text = label_text
	if is_dir:
		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	else:
		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
