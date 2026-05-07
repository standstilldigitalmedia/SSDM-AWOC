@tool
@abstract class_name SSDMDiskResourceManager
extends SSDMDictionaryResourceManager


func save_resource_to_disk(resource_reference: SSDMResourceReference, bundle: bool = false) -> SSDMResult:
	var save_result: Error
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	if ref_path_result.error:
		return ref_path_result
	var path: String = ref_path_result.data
	var resource: Resource = resource_reference.resource
	resource.take_over_path(path)
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		var create_dir_result: SSDMResult = create_dir_for_path(path.get_base_dir())
		if create_dir_result.error:
			return create_dir_result
	if bundle:
		save_result = ResourceSaver.save(resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	else:
		save_result = ResourceSaver.save(resource, path)
	if save_result != OK:
		return SSDMResult.failure("SSDMManager: save_resource failed: " + str(save_result))
	await wait_for_scan()
	var uid = ResourceLoader.get_resource_uid(path)
	if uid == ResourceUID.INVALID_ID:
		return SSDMResult.failure("SSDMManager: Failed to get UID for path: " + path)
	return SSDMResult.success("", uid)
	
	
func wait_for_scan() -> void:
	var filesystem = EditorInterface.get_resource_filesystem()
	if filesystem.is_scanning():
		await filesystem.filesystem_changed
		return
	filesystem.scan.call_deferred()
	await filesystem.filesystem_changed
	
	
func create_dir_for_path(file_path: String) -> SSDMResult:
	if !SSDMValidator.is_valid_new_path(file_path):
		return SSDMResult.failure("SSDMManager: A valid path must be provided for resource creation: " + file_path)
	var dir = DirAccess.open(file_path)
	if !dir:
		dir = DirAccess.open("res://")
		var err = dir.make_dir_recursive(file_path)
		if err != OK:
			return SSDMResult.failure("SSDMManager: Could not create directory: '" + file_path + "'. Code: " + str(err))
	return SSDMResult.success()
	
	
func create_resource_on_disk(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	if ref_path_result.error:
		return ref_path_result
	var path: String = ref_path_result.data
	var dir_created: SSDMResult = create_dir_for_path(path)
	if dir_created.error:
		return dir_created
	var new_resource: Resource = resource_reference.resource
	if resource_reference.dictionary_resource:
		new_resource = resource_reference.dictionary_resource
	if !new_resource:
		return SSDMResult.failure("SSDMManager: Can not create a null resource on disk")
	var save_result: SSDMResult = await save_resource_to_disk(resource_reference)
	if save_result.error:
		return save_result
	var uid: int = save_result.data
	if uid == ResourceUID.INVALID_ID:
		return SSDMResult.failure("SSDMManager: Failed to get UID for newly created resource: " + path)
	resource_reference.res_uid = uid
	return add_resource_reference_to_dictionary(resource_name, resource_reference)


func delete_resource_from_disk(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	if ref_path_result.error:
		return ref_path_result
	var file_path: String = ref_path_result.data
	if file_path.is_empty():
		return SSDMResult.failure("SSDMManager: Can not delete empty file path")
	var extension = file_path.get_extension().to_lower()
	if extension in SSDMWorkManager.config.do_not_delete_extensions:
		return SSDMResult.failure("SSDMManager: Attempted to delete reserved file type: " + file_path)
	if !FileAccess.file_exists(file_path):
		return SSDMResult.failure("SSDMManager: Can not delete a file that does not exist: " + file_path)
	var result: String = ""
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return SSDMResult.failure("SSDMManager: Failed to open directory for deletion")
	if SSDMWorkManager.config.send_to_recylce:
		var trash_result = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if trash_result != OK:
			result = "SSDMManager: Failed to move file to trash: " + file_path + " (Error: " + str(trash_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_trash_result = OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
				if dir_trash_result != OK:
					push_warning("SSDMManager: Failed to move empty directory to trash: " + base_dir + " (Error: " + str(dir_trash_result) + ")")
	else:
		var remove_result = dir.remove(file_path)
		if remove_result != OK:
			result = "SSDMManager: Failed to remove file: " + file_path + " (Error: " + str(remove_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_remove_result = dir.remove(base_dir)
				if dir_remove_result != OK:
					push_warning("SSDMManager: Failed to remove empty directory: " + base_dir + " (Error: " + str(dir_remove_result) + ")")
	if !result.is_empty():
		return SSDMResult.failure(result)
	await wait_for_scan()
	return delete_resource_reference_from_dictionary(resource_name)


func rename_resource_on_disk(old_name: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	if ref_path_result.error:
		return ref_path_result
	var old_path: String = ref_path_result.data
	if old_path.is_empty() or !FileAccess.file_exists(old_path):
		return SSDMResult.failure("SSDMManager: Can not rename a resource that doesn't exist on disk: " + old_path)
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir() + "/" + new_name + "." + extension
	if FileAccess.file_exists(new_path):
		return SSDMResult.failure("SSDMManager: File already exists at destination: " + new_path)
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return SSDMResult.failure("SSDMManager: Failed to open directory for rename")
	var rename_result = dir.rename(old_path, new_path)
	if rename_result != OK:
		return SSDMResult.failure("SSDMManager: Failed to rename file from " + old_path + " to " + new_path + " (Error: " + str(rename_result) + ")")
	resource_reference.res_path = new_path
	await wait_for_scan()
	return rename_resource_reference_in_dictionary(old_name, new_name)
