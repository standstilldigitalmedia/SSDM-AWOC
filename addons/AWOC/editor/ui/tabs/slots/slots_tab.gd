@tool
class_name AWOCSlotsTab
extends SSDMTabBase


func _ready() -> void:
	new_resource_menu.menu_button.text = "New Slot"
	list_management_menu.menu_button.text = "Manage Slots"
	set_type("slots")
