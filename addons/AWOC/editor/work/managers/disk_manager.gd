@tool
class_name AWOCDiskManager
extends AWOCDictionaryManager

var _parent_resource_reference: AWOCResourceReference

func wait_for_scan() -> void:
	var filesystem = EditorInterface.get_resource_filesystem()
	if filesystem.is_scanning():
		await filesystem.filesystem_changed
		return
	filesystem.scan.call_deferred()
	await filesystem.filesystem_changed
	
	
func create_dir_for_path(file_path: String) -> AWOCResult:
	if !AWOCValidator.is_valid_new_path(file_path):
		return AWOCResult.failure("AWOCDiskManager: Path is invalid: " + file_path)
	var dir = DirAccess.open(file_path)
	if !dir:
		dir = DirAccess.open("res://")
		var err = dir.make_dir_recursive(file_path)
		if err != OK:
			return AWOCResult.failure("AWOCDiskManager: Could not create directory: '" + file_path + "'. Code: " + str(err))
	return AWOCResult.success()
	

func save_parent() -> AWOCResult:
	return await _save_resource_to_disk(_parent_resource_reference)
	
	
func validate_disk_resource_reference(resource_reference: AWOCResourceReference) -> AWOCResult:
	if resource_reference.resource == null:
		return AWOCResult.failure("AWOCDiskManager: Resource reference must have a resource")
	var path: AWOCResult = resource_reference.get_ref_path()
	if !path.is_success():
		return path
	return AWOCValidator.is_valid_new_path(path.data)
	
	
func validate_new_disk_resource(resource_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	if !AWOCValidator.is_valid_name(resource_name):
		return AWOCResult.failure("AWOCDiskManager: You must enter a valid name: " + resource_name)
	return AWOCResult.success()
	
	
func validate_delete_resource_from_disk(resource_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	var ref_path_result: AWOCResult = resource_reference.get_ref_path()
	if !ref_path_result.is_success():
		return ref_path_result
	var file_path: String = ref_path_result.data
	var extension = file_path.get_extension().to_lower()
	if extension in AWOCWorkManager.config.do_not_delete_extensions:
		return AWOCResult.failure("AWOCDiskManager: Attempted to delete reserved file type: " + file_path)
	if !FileAccess.file_exists(file_path):
		return AWOCResult.failure("AWOCDiskManager: Can not delete a file that does not exist: " + file_path)
	return AWOCResult.success()
	

func validate_rename_resource_on_disk(old_name: String, new_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	var ref_path_result: AWOCResult = resource_reference.get_ref_path()
	var old_path: String = ref_path_result.data
	if old_path.is_empty() or !FileAccess.file_exists(old_path):
		return AWOCResult.failure("AWOCDiskManager: Can not rename a resource that doesn't exist on disk: " + old_path)
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir() + "/" + new_name + "." + extension
	if FileAccess.file_exists(new_path):
		return AWOCResult.failure("AWOCDiskManager: File already exists at destination: " + new_path)
	return AWOCResult.success()
		
		
func _save_resource_to_disk(resource_reference: AWOCResourceReference, bundle: bool = false) -> AWOCResult:
	var ref_path_result: AWOCResult = resource_reference.get_ref_path()
	var path: String = ref_path_result.data
	var resource: Resource = resource_reference.resource
	resource.take_over_path(path)
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		var create_dir_result: AWOCResult = create_dir_for_path(path.get_base_dir())
		if create_dir_result.error:
			return create_dir_result
	var save_result: Error
	if bundle:
		save_result = ResourceSaver.save(resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	else:
		save_result = ResourceSaver.save(resource, path)
	if save_result != OK:
		return AWOCResult.failure("AWOCDiskManager: save_resource failed: " + str(save_result))
	await wait_for_scan()
	var uid = ResourceLoader.get_resource_uid(path)
	if uid == ResourceUID.INVALID_ID:
		return AWOCResult.failure("AWOCDiskManager: Failed to get UID for path: " + path)
	return AWOCResult.success("", uid)
	
	
func _add_resource_to_disk(resource_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	var path: AWOCResult = resource_reference.get_ref_path()
	if !path.is_success():
		return path
	var dir_created: AWOCResult = create_dir_for_path(path.data)
	if !dir_created.is_success():
		return dir_created
	var full_path: String = path.data.path_join(resource_name + ".tres")
	resource_reference.res_path = full_path
	if resource_reference == null:
		printerr("AWOCDiskManager: No resource reference here in disk resource manager 2nd")
	var save_result: AWOCResult = await _save_resource_to_disk(resource_reference)
	if save_result.error:
		return save_result
	var uid: int = save_result.data
	if uid == ResourceUID.INVALID_ID:
		return AWOCResult.failure("AWOCDiskManager: Failed to get UID for newly created resource: " + path.data)
	resource_reference.res_uid = uid
	return AWOCResult.success()


func _delete_resource_from_disk(resource_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	var ref_path_result: AWOCResult = resource_reference.get_ref_path()
	var file_path: String = ref_path_result.data
	var result: String = ""
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return AWOCResult.failure("AWOCDiskManager: Failed to open directory for deletion")
	if AWOCPlugin.config.send_to_recycle:
		var trash_result = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if trash_result != OK:
			result = "AWOCDiskManager: Failed to move file to trash: " + file_path + " (Error: " + str(trash_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_trash_result = OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
				if dir_trash_result != OK:
					push_warning("AWOCDiskManager: Failed to move empty directory to trash: " + base_dir + " (Error: " + str(dir_trash_result) + ")")
	else:
		var remove_result = dir.remove(file_path)
		if remove_result != OK:
			result = "AWOCDiskManager: Failed to remove file: " + file_path + " (Error: " + str(remove_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_remove_result = dir.remove(base_dir)
				if dir_remove_result != OK:
					push_warning("AWOCDiskManager: Failed to remove empty directory: " + base_dir + " (Error: " + str(dir_remove_result) + ")")
	if !result.is_empty():
		return AWOCResult.failure(result)
	await wait_for_scan()
	return AWOCResult.success()


func _rename_resource_on_disk(old_name: String, new_name: String, resource_reference: AWOCResourceReference) -> AWOCResult:
	var ref_path_result: AWOCResult = resource_reference.get_ref_path()
	var old_path: String = ref_path_result.data
	var extension = old_path.get_extension().to_lower()
	var new_path: String = old_path.get_base_dir().path_join(new_name + "." + extension)
	var dir: DirAccess = DirAccess.open("res://")
	if !dir:
		return AWOCResult.failure("AWOCDiskManager: Failed to open directory for rename")
	var rename_result = dir.rename(old_path, new_path)
	if rename_result != OK:
		return AWOCResult.failure("AWOCDiskManager: Failed to rename file from " + old_path + " to " + new_path + " (Error: " + str(rename_result) + ")")
	resource_reference.res_path = new_path
	await wait_for_scan()
	return AWOCResult.success()
