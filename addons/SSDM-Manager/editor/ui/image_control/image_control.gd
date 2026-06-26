@tool
class_name SSDMImageControl
extends HBoxContainer

signal image_selected(path: String)

@export var label_text: String
@export_group("nodes")
@export var label: Label
@export var texture_button: TextureButton
@export var file_dialog: FileDialog


func _on_texture_button_pressed() -> void:
	file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	var validation_result: SSDMResult = SSDMValidator.is_valid_new_path(path)
	if validation_result.is_success():
		texture_button.texture_normal = load(path)
		image_selected.emit(path)
		
		
func _ready() -> void:
	label.text = label_text
	file_dialog.clear_filters()
	file_dialog.filters = PackedStringArray([
		"*.png ; PNG Images",
		"*.jpg, *.jpeg ; JPEG Images",
		"*.webp ; WebP Images",
		"*.svg ; Scalable Vector Graphics"
	])
