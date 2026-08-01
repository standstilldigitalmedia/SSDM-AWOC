@tool
class_name SSDMResourceReference
extends Resource

@export var res_name: String = ""
@export var res_uid: String = ""
@export var stored_resource: Resource = null
@export var stored_value: Variant

	
func get_resource() -> SSDMResult:
	if !stored_resource:
		return SSDMResult.print_failure("No resource stored")
	return SSDMResult.success("", stored_resource)
