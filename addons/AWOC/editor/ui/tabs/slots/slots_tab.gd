@tool
class_name AWOCSlotsTab
extends AWOCTabBase


func _ready() -> void:
	new_resource_menu.resource_type = "slots"
	list_management_menu.resource_type = "slots"
