@tool
class_name AWOCEditRowManagementBase
extends AWOCRowManagementBase


func _on_edit_button_pressed() -> void:
	AWOCPlugin.work_manager.edit_resource.emit(resource_type, resource_reference)
