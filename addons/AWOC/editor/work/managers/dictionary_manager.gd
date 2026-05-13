@tool
class_name AWOCDictionaryManager
extends RefCounted

var _resource_dictionary: Dictionary[String, AWOCResourceReference]

func has_resources() -> AWOCResult:
	if _resource_dictionary.size() > 0:
		return AWOCResult.success()
	return AWOCResult.failure("AWOCDictionaryManager: No resources found")


func has_named_resource(resource_name: String) -> AWOCResult:
	if _resource_dictionary.has(resource_name):
		return AWOCResult.success()
	return AWOCResult.failure("AWOCDictionaryManager: A resource named " + resource_name + " could not be found")


func get_sorted_name_array() -> AWOCResult:
	var names: Array[String] = []
	for key in _resource_dictionary.keys():
		names.append(key)
	names.sort()
	return AWOCResult.success("", names)


func validate_dictionary_resource_reference(resource_reference: AWOCResourceReference) -> AWOCResult:
	if resource_reference.dictionary_resource == null:
		return AWOCResult.failure("AWOCDictionaryManager: Resource reference must have a resource")
	return AWOCResult.success()
	
	
func validate_new_dictionary_resource(res_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	if _resource_dictionary.has(res_name):
		return AWOCResult.failure("AWOCDictionaryManager: Can not add a resource that already exists: " + res_name)
	if !AWOCValidator.is_valid_name(res_name):
		return AWOCResult.failure("AWOCDictionaryManager: Invalid name: " + res_name)
	if !resource_reference:
		return AWOCResult.failure("AWOCDictionaryManager: Can not add a resource reference that is null")
	return AWOCResult.success()
	
	
func validate_delete_dictionary_resource(res_name:String) -> AWOCResult:	
	if !_resource_dictionary.has(res_name):
		return AWOCResult.failure("AWOCDictionaryManager: Can not delete a resource that does not exist: " + res_name)
	return AWOCResult.success()
	
	
func validate_rename_dictionary_resource(old_name: String, new_name: String) -> AWOCResult:
	if !_resource_dictionary.has(old_name):
		return AWOCResult.failure("AWOCDictionaryManager: Can not rename a resource that does not exist: " + old_name)
	if !AWOCValidator.is_valid_name(new_name):
		return AWOCResult.failure("AWOCDictionaryManager: Can not rename a resource to an invalid name: " + new_name)
	return AWOCResult.success()
		
		
func _add_resource_reference_to_dictionary(res_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	_resource_dictionary.set(res_name, resource_reference)
	return AWOCResult.success()
	
	
func _delete_resource_reference_from_dictionary(res_name: String) -> AWOCResult:
	_resource_dictionary.erase(res_name)
	return AWOCResult.success()
	
	
func _rename_resource_reference_in_dictionary(old_name: String, new_name: String) -> AWOCResult:
	_resource_dictionary.set(new_name, _resource_dictionary.get(old_name))
	_resource_dictionary.erase(old_name)
	return AWOCResult.success()
