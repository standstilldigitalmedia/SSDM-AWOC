@tool
class_name AWOCWelcomeListManagement
extends SSDMListManagementBase


func get_resources() -> SSDMResult:
	return AWOCPlugin.work_manager.get_refs(resource_type)
	
	
func has_resources() -> SSDMResult:
	return AWOCPlugin.work_manager.has_refs(resource_type)
	
	
func _on_resource_modified(type: String) -> void:
	if type == resource_type:
		populate()
		set_menu_button()
		
		
func _ready() -> void:
	AWOCPlugin.work_manager.resource_created.connect(_on_resource_modified)
	AWOCPlugin.work_manager.resource_deleted.connect(_on_resource_modified)
	super()
