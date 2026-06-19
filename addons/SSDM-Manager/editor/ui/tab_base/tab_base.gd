@tool
class_name SSDMTabBase
extends MarginContainer

@export var new_resource_menu: SSDMNewResourceMenuBase
@export var list_management_menu: SSDMListManagementMenuBase


func set_type(type: String) -> void:
	new_resource_menu.resource_type = type
	list_management_menu.resource_type = type
	list_management_menu.set_menu_button()
	list_management_menu.populate()
