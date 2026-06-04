class_name AWOCWelcomeLibraryManager
extends SSDMLibraryManagerBase


func set_library_ref(resource_reference: SSDMResourceReference) -> SSDMResult:
	library_manager_ref = SSDMEditorResourceReference.new()
	library_manager_ref.set_res_path("res://", "addons/AWOC/welcome/", "welcome", ".tres")
	var library_manager_result: SSDMResult = library_manager_ref.get_resource()
	if !library_manager_result.is_success():
		var welcome_library := SSDMLibrary.new()
		library_manager_ref.loaded_resource = welcome_library
		library_manager = welcome_library
		return await library_manager_ref.save_resource_to_disk()
	library_manager = library_manager_result.data
	return SSDMResult.success()
	
	
func add_resource(params: Dictionary) -> SSDMResult:
	var awoc_ref := SSDMEditorResourceReference.new()
	var awoc := AWOC.new()
	awoc_ref.loaded_resource = awoc
	var set_path_result: SSDMResult = set_ref_path(params, awoc_ref)
	if !set_path_result.is_success():
		return set_path_result
	awoc.asset_creation_path_uid = ResourceLoader.get_resource_uid(awoc_ref.path_prefix.path_join(awoc_ref.path_base))
	var add_disk_result: SSDMResult = await add_disk_resource(awoc_ref)
	if !add_disk_result.is_success():
		return add_disk_result
	var save_resource_result: SSDMResult = library_manager_ref.save_resource_to_disk()
	if !save_resource_result.is_success():
		return save_resource_result
	return SSDMResult.success("Resource " + awoc_ref.res_name + " created successfully")
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	return await rename_disk_resource(new_name, resource_reference)
	

func delete_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	return await delete_disk_resource(resource_reference)
