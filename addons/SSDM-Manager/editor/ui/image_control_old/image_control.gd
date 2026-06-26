"""@tool
class_name SSDMImageControl
extends SSDMPathBrowser

@export var texture_rect: TextureRect
@export var no_image: Texture2D


func on_valid_path(path: String) -> void:
	texture_rect.texture = load(path)
	super(path)
	
	
func on_invalid_path(path: String) -> void:
	texture_rect.texture = no_image
	super(path)
	
	
func _ready() -> void:
	super()
	file_dialog.clear_filters()
	file_dialog.filters = PackedStringArray([
		"*.png ; PNG Images",
		"*.jpg, *.jpeg ; JPEG Images",
		"*.webp ; WebP Images",
		"*.svg ; Scalable Vector Graphics"
	])"""
