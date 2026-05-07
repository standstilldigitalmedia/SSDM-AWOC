@tool
@abstract class_name SSDMDictionaryResourceManager
extends SSDMResourceManagerBase


func add_resource_reference_to_dictionary(res_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_dictionary.has(res_name):
		return SSDMResult.failure("SSDMManager: Can not add a resource that already exists: " + res_name)
	if !SSDMValidator.is_valid_name(res_name):
		return SSDMResult.failure("SSDMManager: Invalid name: " + res_name)
	if !resource_reference:
		return SSDMResult.failure("SSDMManager: Can not add a resource reference that is null")
	resource_dictionary.set(res_name, resource_reference)
	return SSDMResult.success()
	
	
func delete_resource_reference_from_dictionary(res_name: String) -> SSDMResult:
	if !resource_dictionary.has(res_name):
		return SSDMResult.failure("SSDMManager: Can not delete a resource that does not exist: " + res_name)
	resource_dictionary.erase(res_name)
	return SSDMResult.success()
	
	
func rename_resource_reference_in_dictionary(old_name: String, new_name: String) -> SSDMResult:
	if !resource_dictionary.has(old_name):
		return SSDMResult.failure("SSDMManager: Can not rename a resource that does not exist: " + old_name)
	if !SSDMValidator.is_valid_name(new_name):
		return SSDMResult.failure("SSDMManager: Can not rename a resource to an invalid name: " + new_name)
	resource_dictionary.set(new_name, resource_dictionary.get(old_name))
	resource_dictionary.erase(old_name)
	return SSDMResult.success()
	
	
func _init(res_dictionary: Dictionary[String, SSDMResourceReference]) -> void:
	resource_dictionary = res_dictionary
