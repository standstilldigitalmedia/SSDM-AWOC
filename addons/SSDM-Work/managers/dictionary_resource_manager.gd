@tool
class_name SSDMDictionaryResourceManager
extends RefCounted

var _resource_dictionary: Dictionary[String, SSDMResourceReference]

func has_resources() -> SSDMResult:
	if _resource_dictionary.size() > 0:
		return SSDMResult.success()
	return SSDMResult.failure("No resources found")


func has_named_resource(resource_name: String) -> SSDMResult:
	if _resource_dictionary.has(resource_name):
		return SSDMResult.success()
	return SSDMResult.failure("A resource named " + resource_name + " could not be found")


func get_sorted_name_array() -> SSDMResult:
	var names: Array[String] = []
	for key in _resource_dictionary.keys():
		names.append(key)
	names.sort()
	return SSDMResult.success("", names)


func validate_dictionary_resource_reference(resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference.dictionary_resource == null:
		return SSDMResult.failure("Resource reference must have a resource")
	return SSDMResult.success()
	
	
func validate_new_dictionary_resource(res_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if _resource_dictionary.has(res_name):
		return SSDMResult.failure("Can not add a resource that already exists: " + res_name)
	if !SSDMValidator.is_valid_name(res_name):
		return SSDMResult.failure("Invalid name: " + res_name)
	if !resource_reference:
		return SSDMResult.failure("Can not add a resource reference that is null")
	return SSDMResult.success()
	
	
func validate_delete_dictionary_resource(res_name:String) -> SSDMResult:	
	if !_resource_dictionary.has(res_name):
		return SSDMResult.failure("Can not delete a resource that does not exist: " + res_name)
	return SSDMResult.success()
	
	
func validate_rename_dictionary_resource(old_name: String, new_name: String) -> SSDMResult:
	if !_resource_dictionary.has(old_name):
		return SSDMResult.failure("Can not rename a resource that does not exist: " + old_name)
	if !SSDMValidator.is_valid_name(new_name):
		return SSDMResult.failure("Can not rename a resource to an invalid name: " + new_name)
	return SSDMResult.success()
		
		
func _add_resource_reference_to_dictionary(res_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	_resource_dictionary.set(res_name, resource_reference)
	return SSDMResult.success()
	
	
func _delete_resource_reference_from_dictionary(res_name: String) -> SSDMResult:
	_resource_dictionary.erase(res_name)
	return SSDMResult.success()
	
	
func _rename_resource_reference_in_dictionary(old_name: String, new_name: String) -> SSDMResult:
	_resource_dictionary.set(new_name, _resource_dictionary.get(old_name))
	_resource_dictionary.erase(old_name)
	return SSDMResult.success()
