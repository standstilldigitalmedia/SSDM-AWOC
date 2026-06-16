@tool
class_name SSDMEditRowManagementMenu
extends SSDMRowManagementMenuBase

signal edit_resource(res_ref: SSDMResourceReference)


func _on_edit_button_pressed() -> void:
	edit_resource.emit(resource_reference)
