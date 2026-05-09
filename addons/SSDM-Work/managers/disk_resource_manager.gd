@tool
class_name SSDMDiskResourceManager
extends SSDMDictionaryResourceManager

var _parent_resource_reference: SSDMResourceReference

func wait_for_scan() -> void:
	var filesystem = EditorInterface.get_resource_filesystem()
	if filesystem.is_scanning():
		await filesystem.filesystem_changed
		return
	filesystem.scan.call_deferred()
	await filesystem.filesystem_changed
	
	
func create_dir_for_path(file_path: String) -> SSDMResult:
	if !SSDMValidator.is_valid_new_path(file_path):
		return SSDMResult.failure("Path is invalid: " + file_path)
	var dir = DirAccess.open(file_path)
	if !dir:
		dir = DirAccess.open("res://")
		var err = dir.make_dir_recursive(file_path)
		if err != OK:
			return SSDMResult.failure("SSDMManager: Could not create directory: '" + file_path + "'. Code: " + str(err))
	return SSDMResult.success()
	

func save_parent() -> SSDMResult:
	return await _save_resource_to_disk(_parent_resource_reference)
	
	
func validate_disk_resource_reference(resource_reference: SSDMResourceReference) -> SSDMResult:
	if resource_reference.resource == null:
		return SSDMResult.failure("Resource reference must have a resource")
	var path: SSDMResult = resource_reference.get_ref_path()
	if !path.is_success():
		return path
	return SSDMValidator.is_valid_new_path(path.data)
	
	
func validate_new_disk_resource(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	if !SSDMValidator.is_valid_name(resource_name):
		return SSDMResult.failure("You must enter a valid name: " + resource_name)
	return SSDMResult.success()
	
	
func validate_delete_resource_from_disk(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	if !ref_path_result.is_success():
		return ref_path_result
	var file_path: String = ref_path_result.data
	var extension = file_path.get_extension().to_lower()
	if extension in SSDMWorkManager.config.do_not_delete_extensions:
		return SSDMResult.failure("SSDMManager: Attempted to delete reserved file type: " + file_path)
	if !FileAccess.file_exists(file_path):
		return SSDMResult.failure("SSDMManager: Can not delete a file that does not exist: " + file_path)
	return SSDMResult.success()
	

func validate_rename_resource_on_disk(old_name: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	var old_path: String = ref_path_result.data
	if old_path.is_empty() or !FileAccess.file_exists(old_path):
		return SSDMResult.failure("SSDMManager: Can not rename a resource that doesn't exist on disk: " + old_path)
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir() + "/" + new_name + "." + extension
	if FileAccess.file_exists(new_path):
		return SSDMResult.failure("SSDMManager: File already exists at destination: " + new_path)
	return SSDMResult.success()
		
		
func _save_resource_to_disk(resource_reference: SSDMResourceReference, bundle: bool = false) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	var path: String = ref_path_result.data
	var resource: Resource = resource_reference.resource
	resource.take_over_path(path)
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		var create_dir_result: SSDMResult = create_dir_for_path(path.get_base_dir())
		if create_dir_result.error:
			return create_dir_result
	var save_result: Error
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
	
	
func _create_resource_on_disk(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var path: SSDMResult = resource_reference.get_ref_path()
	if !path.is_success():
		return path
	var dir_created: SSDMResult = create_dir_for_path(path.data)
	if !dir_created.is_success():
		return dir_created
	var full_path: String = path.data.path_join(resource_name + ".tres")
	resource_reference.res_path = full_path
	var save_result: SSDMResult = await _save_resource_to_disk(resource_reference)
	if save_result.error:
		return save_result
	var uid: int = save_result.data
	if uid == ResourceUID.INVALID_ID:
		return SSDMResult.failure("SSDMManager: Failed to get UID for newly created resource: " + path.data)
	resource_reference.res_uid = uid
	return SSDMResult.success()


func _delete_resource_from_disk(resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	var file_path: String = ref_path_result.data
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
	return SSDMResult.success()


func _rename_resource_on_disk(old_name: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var ref_path_result: SSDMResult = resource_reference.get_ref_path()
	var old_path: String = ref_path_result.data
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir().path_join(new_name + "." + extension)
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return SSDMResult.failure("SSDMManager: Failed to open directory for rename")
	var rename_result = dir.rename(old_path, new_path)
	if rename_result != OK:
		return SSDMResult.failure("SSDMManager: Failed to rename file from " + old_path + " to " + new_path + " (Error: " + str(rename_result) + ")")
	resource_reference.res_path = new_path
	await wait_for_scan()
	return SSDMResult.success()
