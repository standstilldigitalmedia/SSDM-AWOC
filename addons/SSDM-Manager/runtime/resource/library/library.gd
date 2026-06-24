@tool
class_name SSDMLibrary
extends Resource


@export var library_dictionary: Dictionary


func generate_dictionary_key() -> String:
	var valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*<>?~+=-_"
	var return_string = ""
	for i in range(16):
		return_string += valid_chars[randi() % valid_chars.length()]
	return return_string
	
	
func has_refs() -> SSDMResult:
	if library_dictionary.size() > 0:
		return SSDMResult.success()
	return SSDMResult.failure()
		
		
func get_ref_by_name(resource_name: String) -> SSDMResult:
	for key in library_dictionary.keys():
		if library_dictionary[key].res_name == resource_name:
			return SSDMResult.success("", library_dictionary[key])
	return SSDMResult.failure()
	
	
func get_ref_by_uid(uid: String) -> SSDMResult:
	if !library_dictionary.has(uid):
		return SSDMResult.failure()
	return SSDMResult.success("", library_dictionary.get(uid))
	

func get_sorted_name_array() -> SSDMResult:
	var names: Array[String] = []
	for key: String in library_dictionary.keys():
		names.append(library_dictionary[key].res_name)
	if names.size() < 1:
		return SSDMResult.failure()
	names.sort()
	return SSDMResult.success("", names)
	
	
func get_key_array() -> SSDMResult:
	var keys: Array[String] = []
	for key: String in library_dictionary.keys():
		keys.append(key)
	if keys.size() < 1:
		return SSDMResult.failure()
	return SSDMResult.success("", keys)
	
		
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


func validate_new_resource(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	var res_name = resource_reference.res_name
	var get_ref_result: SSDMResult = get_ref_by_name(res_name)
	if get_ref_result.is_success():
		return SSDMResult.print_failure("Can not add a resource that already exists: " + res_name)
	var validate_result := SSDMValidator.is_valid_name(res_name)
	if !validate_result.is_success():
		return SSDMResult.print_failure("Invalid name: " + res_name)
	if !resource_reference:
		return SSDMResult.print_failure("Can not add a resource reference that is null")
	return SSDMResult.success()
	
	
func validate_delete_resource(res_name:String, params: Dictionary = {}) -> SSDMResult:
	var ref_by_name_result := get_ref_by_name(res_name)
	if !ref_by_name_result.is_success():
		return SSDMResult.print_failure("Can not delete a resource that does not exist: " + res_name)
	return SSDMResult.success()
	
	
func validate_rename_resource(old_name: String, new_name: String, params: Dictionary = {}) -> SSDMResult:
	var get_old_result := get_ref_by_name(old_name)
	if !get_old_result.is_success():
		return SSDMResult.print_failure("Can not rename a resource that does not exist: " + old_name)
	var get_new_result := get_ref_by_name(new_name)
	if get_new_result.is_success():
		return SSDMResult.print_failure("A resource named " + new_name + " already exists")
	var validate_result := SSDMValidator.is_valid_name(new_name)
	if !validate_result.is_success():
		return SSDMResult.print_failure("Can not rename a resource to an invalid name: " + new_name)
	return SSDMResult.success()
		
		
func add_resource_reference(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	if resource_reference.res_uid.is_empty():
		var dictionary_key: String = generate_dictionary_key()
		resource_reference.res_uid = dictionary_key
		library_dictionary.set(dictionary_key, resource_reference)
	else:
		library_dictionary.set(resource_reference.res_uid, resource_reference)
	return SSDMResult.success()
	
	
func delete_resource_reference(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	library_dictionary.erase(resource_reference.res_uid)
	return SSDMResult.success()
	
	
func rename_resource_reference(old_name: String, new_name: String, params: Dictionary = {}) -> SSDMResult:
	var old_resource_result: SSDMResult = get_ref_by_name(old_name)
	if !old_resource_result.is_success():
		return old_resource_result
	old_resource_result.data.res_name = new_name
	return SSDMResult.success()
