@tool
class_name SSDMLibrary
extends Resource

@export var reference_dictionary: Dictionary


func has_refs() -> SSDMResult:
	if reference_dictionary.size() > 0:
		return SSDMResult.success()
	return SSDMResult.failure()
		
		
func get_ref_by_name(resource_name: String) -> SSDMResult:
	for key in reference_dictionary.keys():
		if reference_dictionary[key].res_name == resource_name:
			return SSDMResult.success("", reference_dictionary[key])
	return SSDMResult.failure("No resources with that name found")
	
	
func get_ref_by_uid(uid: String) -> SSDMResult:
	if !reference_dictionary.has(uid):
		return SSDMResult.failure()
	return SSDMResult.success("", reference_dictionary.get(uid))
	

func get_sorted_name_array() -> SSDMResult:
	var names: Array[String] = []
	for key: String in reference_dictionary.keys():
		names.append(reference_dictionary[key].res_name)
	if names.size() < 1:
		return SSDMResult.failure()
	names.sort()
	return SSDMResult.success("", names)
	
		
func get_refs() -> SSDMResult:
	var name_array_result := get_sorted_name_array()
	if !name_array_result.is_success():
		return name_array_result
	var return_array = []
	for name in name_array_result.data:
		var ref_by_name_result: SSDMResult = get_ref_by_name(name)
		if !ref_by_name_result.is_success():
			return ref_by_name_result
		return_array.append(ref_by_name_result.data)
	return SSDMResult.success("", return_array)


func validate_new_dictionary_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	var res_name = resource_reference.res_name
	var get_ref_result: SSDMResult = get_ref_by_name(res_name)
	if get_ref_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: Can not add a resource that already exists: " + res_name)
	var validate_result := SSDMValidator.is_valid_name(res_name)
	if !validate_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: Invalid name: " + res_name)
	if !resource_reference:
		return SSDMResult.failure("SSDMDictionaryManager: Can not add a resource reference that is null")
	return SSDMResult.success()
	
	
func validate_delete_dictionary_resource(res_name:String) -> SSDMResult:
	var ref_by_name_result := get_ref_by_name(res_name)
	if !ref_by_name_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: Can not delete a resource that does not exist: " + res_name)
	return SSDMResult.success()
	
	
func validate_rename_dictionary_resource(old_name: String, new_name: String) -> SSDMResult:
	var get_old_result := get_ref_by_name(old_name)
	if !get_old_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: Can not rename a resource that does not exist: " + old_name)
	var get_new_result := get_ref_by_name(new_name)
	if get_new_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: A resource named " + new_name + " already exists")
	var validate_result := SSDMValidator.is_valid_name(new_name)
	if !validate_result.is_success():
		return SSDMResult.failure("SSDMDictionaryManager: Can not rename a resource to an invalid name: " + new_name)
	return SSDMResult.success()
		
		
func add_resource_reference_to_dictionary(resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference.res_uid.is_empty():
		var dictionary_key: String = resource_reference.generate_dictionary_key()
		resource_reference.res_uid = dictionary_key
		reference_dictionary.set(dictionary_key, resource_reference)
	else:
		reference_dictionary.set(resource_reference.res_uid, resource_reference)
	return SSDMResult.success()
	
	
func delete_resource_reference_from_dictionary(resource_reference: SSDMResourceReference) -> SSDMResult:
	reference_dictionary.erase(resource_reference.res_uid)
	return SSDMResult.success()
	
	
func rename_resource_reference_in_dictionary(old_name: String, new_name: String) -> SSDMResult:
	var old_resource = get_ref_by_name(old_name)
	old_resource.res_name = new_name
	return SSDMResult.success()
