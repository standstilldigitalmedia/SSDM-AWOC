@tool
class_name AWOCListManagementBase
extends SSDMListManagementMenuBase

func get_resources() -> SSDMResult:
	return AWOCPlugin.work_manager.get_refs(resource_type)
	
	
func has_resources() -> SSDMResult:
	return AWOCPlugin.work_manager.has_refs(resource_type)
		
		
func _ready() -> void:
	AWOCPlugin.work_manager.resource_modified.connect(_on_resource_modified)
	super()
