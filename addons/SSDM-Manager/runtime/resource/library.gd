class_name SSDMLibrary
extends Resource

@export var resource_dictionary: Dictionary
var library_ref: SSDMResourceReference


func has_refs_of_type(type: String) -> SSDMResult:
	for resource_ref: SSDMResourceReference in resource_dictionary:
		if resource_ref.type == type:
			return SSDMResult.success()
	return SSDMResult.failure()
		
		
func get_ref_by_name(resource_name: String) -> SSDMResult:
	for resource_ref: SSDMResourceReference in resource_dictionary:
		if resource_ref.res_name == resource_name:
			return SSDMResult.success("", resource_ref)
	return SSDMResult.failure("No resources with that name found")
	
	
func get_ref_by_uid(uid: String) -> SSDMResult:
	if !resource_dictionary.has(uid):
		return SSDMResult.failure()
	return SSDMResult.success("", resource_dictionary.get(uid))
	

func get_sorted_name_array_of_type(type: String) -> SSDMResult:
	var names: Array[String] = []
	for resource: SSDMResourceReference in resource_dictionary:
		if resource.type == type:
			names.append(resource.res_name)
	if names.size() < 1:
		return SSDMResult.failure()
	names.sort()
	return SSDMResult.success("", names)
	
		
func get_refs_by_type(type: String) -> SSDMResult:
	var name_array_result := get_sorted_name_array_of_type(type)
	if !name_array_result.is_success():
		return name_array_result
	var return_array = []
	for name in name_array_result.data:
		return_array.append(get_ref_by_name(name))
	return SSDMResult.success("", return_array)


func validate_new_dictionary_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	var res_name = resource_reference.res_name
	if get_ref_by_name(res_name):
		return SSDMResult.failure("SSDMDictionaryManager: Can not add a resource that already exists: " + res_name)
	if !SSDMValidator.is_valid_name(res_name):
		return SSDMResult.failure("SSDMDictionaryManager: Invalid name: " + res_name)
	if !resource_reference:
		return SSDMResult.failure("SSDMDictionaryManager: Can not add a resource reference that is null")
	return SSDMResult.success()
	
	
func validate_delete_dictionary_resource(res_name:String) -> SSDMResult:	
	if !get_ref_by_name(res_name):
		return SSDMResult.failure("SSDMDictionaryManager: Can not delete a resource that does not exist: " + res_name)
	return SSDMResult.success()
	
	
func validate_rename_dictionary_resource(old_name: String, new_name: String) -> SSDMResult:
	if !get_ref_by_name(old_name):
		return SSDMResult.failure("SSDMDictionaryManager: Can not rename a resource that does not exist: " + old_name)
	if get_ref_by_name(new_name):
		return SSDMResult.failure("SSDMDictionaryManager: A resource named " + new_name + " already exists")
	if !SSDMValidator.is_valid_name(new_name):
		return SSDMResult.failure("SSDMDictionaryManager: Can not rename a resource to an invalid name: " + new_name)
	return SSDMResult.success()
		
		
func add_resource_reference_to_dictionary(resource_reference: SSDMResourceReference) -> SSDMResult:
	var dictionary_key: String = resource_reference.generate_dictionary_key()
	resource_reference.res_uid = dictionary_key
	resource_dictionary.set(dictionary_key, resource_reference)
	return SSDMResult.success()
	
	
func delete_resource_reference_from_dictionary(resource_reference: SSDMResourceReference) -> SSDMResult:
	resource_dictionary.erase(resource_reference.res_uid)
	return SSDMResult.success()
	
	
func rename_resource_reference_in_dictionary(old_name: String, new_name: String) -> SSDMResult:
	var old_resource = get_ref_by_name(old_name)
	old_resource.res_name = new_name
	return SSDMResult.success()
