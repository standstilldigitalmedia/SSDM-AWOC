@tool
class_name AWOCMaterialTab
extends SSDMTabBase

func _ready() -> void:
	new_resource_menu.menu_button.text = "New Material"
	list_management_menu.menu_button.text = "Manage Materials"
	set_type("materials")
