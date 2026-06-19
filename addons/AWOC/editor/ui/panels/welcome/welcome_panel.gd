@tool
class_name AWOCWelcomePanel
extends SSDMHorizontalMenuBase


func _ready() -> void:
	menu_button.text = turn_string_sideways("Welcome")
	menu_label.text = "Welcome"
