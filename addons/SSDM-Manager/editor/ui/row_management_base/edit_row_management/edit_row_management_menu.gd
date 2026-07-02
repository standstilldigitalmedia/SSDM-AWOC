@tool
class_name SSDMEditRowManagementMenu
extends SSDMRowManagementMenuBase

signal edit_resource(res_ref: SSDMResourceReference)


func _on_edit_button_pressed() -> void:
	SSDMPlugin.work_manager.edit_resource.emit(resource_type, resource_reference)
