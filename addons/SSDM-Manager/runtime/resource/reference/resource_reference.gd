@tool
class_name SSDMResourceReference
extends Resource

@export var res_name: String = ""
@export var res_uid: String = ""
@export var stored_resource: Resource = null
@export var stored_value: Variant


func generate_dictionary_key() -> String:
	var valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*<>?:;,.~+=-_"
	var return_string = ""
	for i in range(16):
		return_string += valid_chars[randi() % valid_chars.length()]
	return return_string
	
	
func get_resource() -> SSDMResult:
	if !stored_resource:
		return SSDMResult.print_failure("No resource found in Resource Reference")
	return SSDMResult.success("", stored_resource)
