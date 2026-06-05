@tool
class_name AWOCWelcomeRowManagement
extends SSDMRowManagementMenuBase


func _on_rename_confirmation_dialog_confirmed() -> void:
	message_display.set_label(await AWOCPlugin.work_manager.rename_resource(resource_type, name_line_edit.text, resource_reference))
	
	
func _on_delete_confirmation_dialog_confirmed() -> void:
	message_display.set_label(await AWOCPlugin.work_manager.delete_resource(resource_type, resource_reference))
