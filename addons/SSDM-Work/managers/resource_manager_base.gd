@tool
@abstract class_name SSDMResourceManagerBase
extends SSDMDiskResourceManager


@abstract func get_new_resource() -> SSDMResult


func set_manager(ref: SSDMResourceReference, dict: Dictionary) -> void:
	_parent_resource_reference = ref
	_resource_dictionary = dict
	
	
func add_resource(res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = "") -> SSDMResult:
	if resource_reference.dictionary_resource:
		var reference_validate: SSDMResult = validate_dictionary_resource_reference(resource_reference)
		if !reference_validate.is_success():
			return reference_validate
		var dictionary_validate: SSDMResult = validate_new_dictionary_resource(res_name, resource_reference)
		if !dictionary_validate.is_success():
			return dictionary_validate
		var add_resource: SSDMResult = _add_resource_reference_to_dictionary(res_name, resource_reference)
		if !add_resource.is_success():
			return add_resource
		return await save_parent()
	elif resource_reference.resource:
		var reference_validate: SSDMResult = validate_disk_resource_reference(resource_reference)
		if !reference_validate.is_success():
			return reference_validate
		var dictionary_validate: SSDMResult = validate_new_dictionary_resource(res_name, resource_reference)
		if !dictionary_validate.is_success():
			return dictionary_validate
		var disk_validate: SSDMResult = validate_new_disk_resource(res_name,resource_reference)
		if !disk_validate.is_success():
			return disk_validate
		var disk_resource: SSDMResult = await _add_resource_to_disk(res_name, resource_reference)
		if !disk_resource.is_success():
			return disk_resource
		var add_resource: SSDMResult = _add_resource_reference_to_dictionary(res_name, resource_reference)
		if !add_resource.is_success():
			return add_resource
		return await save_parent()
	return SSDMResult.failure("Resource could not be created")
		

func delete_resource(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference.dictionary_resource:
		var validate_dictionary: SSDMResult = validate_delete_dictionary_resource(resource_name)
		if !validate_dictionary.is_success():
			return validate_dictionary
		var delete_resource: SSDMResult = _delete_resource_reference_from_dictionary(resource_name)
		if !delete_resource.is_success():
			return delete_resource
		return await save_parent()
	elif resource_reference.resource:
		var validate_dictionary: SSDMResult = validate_delete_dictionary_resource(resource_name)
		if !validate_dictionary.is_success():
			return validate_dictionary
		var validate_disk: SSDMResult = validate_delete_resource_from_disk(resource_name, resource_reference)
		if !validate_disk.is_success():
			return validate_disk
		var dictionary_delete: SSDMResult = _delete_resource_reference_from_dictionary(resource_name)
		if !dictionary_delete:
			return dictionary_delete
		var delete_resource: SSDMResult = await _delete_resource_from_disk(resource_name, resource_reference)
		if !delete_resource.is_success():
			return delete_resource
		return await save_parent()
	return SSDMResult.failure("Resource could not be deleted")
	
			
func rename_resource(old_name: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference.dictionary_resource:
		var validate_dictionary: SSDMResult = validate_rename_dictionary_resource(old_name, new_name)
		if !validate_dictionary.is_success():
			return validate_dictionary
		var rename_resource: SSDMResult = _rename_resource_reference_in_dictionary(old_name, new_name)
		if !rename_resource.is_success():
			return rename_resource
		return await save_parent()
	elif resource_reference.resource:
		var validate_dictionary: SSDMResult = validate_rename_dictionary_resource(old_name, new_name)
		if !validate_dictionary.is_success():
			return validate_dictionary
		var validate_disk: SSDMResult = validate_rename_resource_on_disk(old_name, new_name,resource_reference)
		if !validate_disk.is_success():
			return validate_disk
		var dictionary_rename: SSDMResult = _rename_resource_reference_in_dictionary(old_name, new_name)
		if !dictionary_rename.is_success():
			return dictionary_rename
		var disk_rename: SSDMResult = await _rename_resource_on_disk(old_name, new_name, resource_reference)
		if !disk_rename.is_success():
			return disk_rename
		return await save_parent()
	return SSDMResult.failure("Resource could not be renamed")
