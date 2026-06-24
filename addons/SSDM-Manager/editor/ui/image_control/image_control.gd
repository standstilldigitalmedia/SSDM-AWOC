@tool
class_name SSDMImageControl
extends HBoxContainer

@export var image_label: Label
@export var path_line_edit: LineEdit
@export var browse_button: Button
@export var texture_rect: TextureRect
@export var file_dialog: FileDialog
@export var no_image: Texture2D


func _on_path_line_edit_text_changed(new_text: String) -> void:
	pass # Replace with function body.


func _on_browse_button_pressed() -> void:
	file_dialog.title = "Open Image"
	file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	path_line_edit.text = path
	texture_rect.texture = load(path)
