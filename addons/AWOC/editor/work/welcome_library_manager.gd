class_name AWOCWelcomeLibraryManager
extends SSDMLibraryManagerBase


func set_library_ref(disk_resource_ref: SSDMResourceReference, lib: SSDMLibrary) -> void:
	disk_resource_reference = SSDMEditorResourceReference.new()
	disk_resource_reference.set_res_path("res://", "addons/AWOC/start_here", "welcome", ".tres")
	var get_resource_result: SSDMResult = disk_resource_reference.get_resource()
	if !get_resource_result.is_success():
		library = SSDMLibrary.new()
		disk_resource_reference.loaded_resource = library
		var save_result: SSDMResult= await disk_resource_reference.save_resource_to_disk()
		if !save_result.is_success():
			push_error(save_result.message)
		return
	library = get_resource_result.data
	return SSDMResult.success()
	
	
func set_awoc_libraries(awoc: AWOC) -> void:
	awoc.slot_library = SSDMLibrary.new()
	awoc.color_library = SSDMLibrary.new()
	awoc.material_library = SSDMLibrary.new()
	awoc.mesh_library = SSDMLibrary.new()
	awoc.recipe_library = SSDMLibrary.new()
	awoc.wardrobe_library = SSDMLibrary.new()
	
	
func modify_resource_property(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return SSDMResult.success()
	
	
func add_resource(params: Dictionary) -> SSDMResult:
	var awoc_ref := SSDMEditorResourceReference.new()
	var awoc := AWOC.new()
	set_awoc_libraries(awoc)
	awoc_ref.loaded_resource = awoc
	var set_path_result: SSDMResult = set_ref_path(params, awoc_ref)
	if !set_path_result.is_success():
		return set_path_result
	awoc.asset_creation_path_uid = ResourceLoader.get_resource_uid(awoc_ref.path_prefix.path_join(awoc_ref.path_base))
	var add_disk_result: SSDMResult = await _add_disk_resource(awoc_ref)
	if !add_disk_result.is_success():
		return add_disk_result
	var save_resource_result: SSDMResult = await disk_resource_reference.save_resource_to_disk()
	if !save_resource_result.is_success():
		return save_resource_result
	return SSDMResult.success("Resource " + awoc_ref.res_name + " created successfully")
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	var rename_result: SSDMResult = await _rename_disk_resource(new_name, resource_reference)
	if !rename_result.is_success():
		return rename_result
	return await disk_resource_reference.save_resource_to_disk()
	

func delete_resource(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return await _delete_disk_resource(resource_reference)
