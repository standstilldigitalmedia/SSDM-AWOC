@tool
class_name AWOCColorTab
extends SSDMTabBase


func _ready() -> void:
	new_resource_menu.menu_button.text = "New Color"
	list_management_menu.menu_button.text = "Manage Colors"
	set_type("colors")
