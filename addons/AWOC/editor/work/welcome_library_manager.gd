class_name AWOCWelcomeLibraryManager
extends SSDMLibraryManagerBase


func set_library_ref(resource_reference: SSDMResourceReference) -> SSDMResult:
	library_manager_ref = resource_reference
	library_manager_ref.set_res_path("res://", "addons/AWOC/welcome/", "welcome", ".tres")
	var library_manager_result: SSDMResult = library_manager_ref.get_resource()
	if !library_manager_result.is_success():
		var welcome_library := SSDMLibrary.new()
		resource_reference.loaded_resource = welcome_library
		library_manager = welcome_library
		return resource_reference.save_resource_to_disk()
	library_manager = library_manager_result.data
	return SSDMResult.success()
	
	
func add_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference is not SSDMEditorResourceReference:
		return SSDMResult.failure("Resource reference must be an editor resource reference")
	var dictionary_validate_result := library_manager.validate_new_dictionary_resource(resource_reference)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_new_disk_resource(resource_reference)
	if !disk_validate_result.is_success():
		return disk_validate_result
	var save_to_disk_result: SSDMResult = resource_reference.save_resource_to_disk()
	if !save_to_disk_result.is_success():
		return save_to_disk_result
	var add_to_dictionary_result: SSDMResult = library_manager.add_resource_reference_to_dictionary(resource_reference)
	if !add_to_dictionary_result.is_success():
		return add_to_dictionary_result
	return library_manager_ref.save_resource_to_disk()
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference is not SSDMEditorResourceReference:
		return SSDMResult.failure("Resource reference must be an editor resource reference")
	var dictionary_validate_result := library_manager.validate_rename_dictionary_resource(resource_reference.res_name, new_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_rename_resource_on_disk(new_name)
	if !disk_validate_result.is_success():
		return disk_validate_result
	return resource_reference.rename_resource_on_disk(new_name)
	

func delete_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference is not SSDMEditorResourceReference:
		return SSDMResult.failure("Resource reference must be an editor resource reference")
	var dictionary_validate_result := library_manager.validate_delete_dictionary_resource(resource_reference.res_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_delete_resource_from_disk([])
	if !disk_validate_result.is_success():
		return disk_validate_result
	var delete_from_disk_result: SSDMResult = resource_reference.delete_resource_from_disk()
	if !delete_from_disk_result.is_success():
		return delete_from_disk_result
	var delete_from_dictionary_result: SSDMResult = library_manager.delete_resource_reference_from_dictionary(resource_reference)
	if !delete_from_dictionary_result.is_success():
		return delete_from_dictionary_result
	return library_manager_ref.save_resource_to_disk()
