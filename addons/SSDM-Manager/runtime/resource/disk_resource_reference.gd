@tool
class_name SSDMDiskResourceReference
extends SSDMResourceReference


@export var path_prefix: String = ""
@export var path_base: String = ""
@export var path_extension: String = ""
var loaded_resource: Resource = null


func set_res_path(prefix: String, base:String, name: String, extension: String) -> void:
	path_prefix = prefix
	path_base = base
	res_name = name
	path_extension = extension
	
	
func get_res_path() -> SSDMResult:
	if path_prefix.is_empty() or path_base.is_empty() or res_name.is_empty() or path_extension.is_empty():
		return SSDMResult.failure("SSDMWork: Could not determine path for resource")
	return SSDMResult.success("", path_prefix.path_join(path_base).path_join(res_name) + path_extension)


func get_base_res_path() -> SSDMResult:
	var res_path_result: SSDMResult = get_res_path()
	if res_path_result.error:
		return res_path_result
	var res_path: String = res_path_result.data
	return SSDMResult.success("", res_path.get_base_dir())


func get_resource() -> SSDMResult:
	if loaded_resource:
		return SSDMResult.success("", loaded_resource)
	
	var res_path_result: SSDMResult = get_res_path()
	if !res_path_result.is_success():
		return res_path_result
	var res_path: String = res_path_result.data
	if !FileAccess.file_exists(res_path):
		return SSDMResult.failure()
	
	if path_extension == ".tscn" or path_extension == ".scn":
		loaded_resource = ResourceLoader.load(res_path, "PackedScene", ResourceLoader.CACHE_MODE_REUSE)
	else:
		loaded_resource = ResourceLoader.load(res_path, "", ResourceLoader.CACHE_MODE_REUSE)

	if not loaded_resource:
		return SSDMResult.failure("SSDMWork: Failed to load resource at: " + res_path)

	return SSDMResult.success("", loaded_resource)
	
	
func wait_for_scan() -> void:
	var filesystem = EditorInterface.get_resource_filesystem()
	var tree = Engine.get_main_loop() as SceneTree
	if tree:
		while filesystem.is_scanning():
			await tree.process_frame
	filesystem.scan.call_deferred()
	
	
func create_dir_for_path(file_path: String) -> SSDMResult:
	if !SSDMValidator.is_valid_new_path(file_path):
		return SSDMResult.failure("SSDMDiskManager: Path is invalid: " + file_path)
	var dir = DirAccess.open(file_path)
	if !dir:
		dir = DirAccess.open(path_prefix)
		var err = dir.make_dir_recursive(file_path)
		if err != OK:
			return SSDMResult.failure("SSDMDiskManager: Could not create directory: '" + file_path + "'. Code: " + str(err))
	return SSDMResult.success()
	
	
func validate_disk_resource_reference() -> SSDMResult:
	if loaded_resource == null:
		return SSDMResult.failure("SSDMDiskManager: Resource reference must have a resource")
	var path_result: SSDMResult = get_res_path()
	if !path_result.is_success():
		return path_result
	return SSDMValidator.is_valid_new_path(path_result.data)
	
	
func validate_new_disk_resource() -> SSDMResult:
	if !SSDMValidator.is_valid_name(res_name):
		return SSDMResult.failure("SSDMDiskManager: You must enter a valid name: " + resource_name)
	return SSDMResult.success()
	
	
func validate_delete_resource_from_disk(do_not_delete_extensions: Array) -> SSDMResult:
	var res_path_result: SSDMResult = get_res_path()
	if !res_path_result.is_success():
		return res_path_result
	var file_path: String = res_path_result.data
	var extension = file_path.get_extension().to_lower()
	if extension in do_not_delete_extensions:
		return SSDMResult.failure("SSDMDiskManager: Attempted to delete reserved file type: " + file_path)
	if !FileAccess.file_exists(file_path):
		return SSDMResult.failure("SSDMDiskManager: Can not delete a file that does not exist: " + file_path)
	return SSDMResult.success()
	

func validate_rename_resource_on_disk(new_name: String) -> SSDMResult:
	var res_path_result: SSDMResult = get_res_path()
	if !res_path_result.is_success():
		return res_path_result
	var old_path: String = res_path_result.data
	if old_path.is_empty() or !FileAccess.file_exists(old_path):
		return SSDMResult.failure("SSDMDiskManager: Can not rename a resource that doesn't exist on disk: " + old_path)
	var new_path: String = old_path.get_base_dir().path_join(new_name).path_join(path_extension)
	if FileAccess.file_exists(new_path):
		return SSDMResult.failure("SSDMDiskManager: File already exists at destination: " + new_path)
	return SSDMResult.success()
		
		
func save_resource_to_disk(bundle: bool = false) -> SSDMResult:
	var resource_result: SSDMResult = get_resource()
	if !resource_result.is_success():
		return resource_result
	var res_path_result: SSDMResult = get_res_path()
	if !res_path_result.is_success():
		return res_path_result
	var path: String = res_path_result.data
	loaded_resource.take_over_path(path)
	if !DirAccess.dir_exists_absolute(path.get_base_dir()):
		var create_dir_result: SSDMResult = create_dir_for_path(path.get_base_dir())
		if create_dir_result.error:
			return create_dir_result
	var save_result: Error
	if bundle:
		save_result = ResourceSaver.save(loaded_resource, path, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	else:
		save_result = ResourceSaver.save(loaded_resource, path)
	if save_result != OK:
		return SSDMResult.failure("SSDMDiskManager: save_resource failed: " + str(save_result))
	await wait_for_scan()
	return SSDMResult.success("", path)
	
	
func add_resource_to_disk() -> SSDMResult:
	var path: SSDMResult = get_res_path()
	if !path.is_success():
		return path
	var dir_created: SSDMResult = create_dir_for_path(path.data)
	if !dir_created.is_success():
		return dir_created
	var save_result: SSDMResult = await save_resource_to_disk()
	if !save_result.is_success():
		return save_result
	return SSDMResult.success()


func delete_resource_from_disk(send_to_recycle: bool = false) -> SSDMResult:
	var res_path_result: SSDMResult = get_res_path()
	if !res_path_result.is_success():
		return res_path_result
	var file_path: String = res_path_result.data
	var result: String = ""
	var base_dir = file_path.get_base_dir()
	var dir: DirAccess = DirAccess.open(path_prefix)
	if !dir:
		return SSDMResult.failure("SSDMDiskManager: Failed to open directory for deletion")
	if send_to_recycle:
		var trash_result = OS.move_to_trash(ProjectSettings.globalize_path(file_path))
		if trash_result != OK:
			result = "SSDMDiskManager: Failed to move file to trash: " + file_path + " (Error: " + str(trash_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_trash_result = OS.move_to_trash(ProjectSettings.globalize_path(base_dir))
				if dir_trash_result != OK:
					push_warning("SSDMDiskManager: Failed to move empty directory to trash: " + base_dir + " (Error: " + str(dir_trash_result) + ")")
	else:
		var remove_result = dir.remove(file_path)
		if remove_result != OK:
			result = "SSDMDiskManager: Failed to remove file: " + file_path + " (Error: " + str(remove_result) + ")"
		else:
			if dir.get_files_at(base_dir).size() < 1 and dir.get_directories_at(base_dir).size() < 1:
				var dir_remove_result = dir.remove(base_dir)
				if dir_remove_result != OK:
					push_warning("SSDMDiskManager: Failed to remove empty directory: " + base_dir + " (Error: " + str(dir_remove_result) + ")")
	if !result.is_empty():
		return SSDMResult.failure(result)
	await wait_for_scan()
	return SSDMResult.success()


func rename_resource_on_disk(new_name: String) -> SSDMResult:
	var dir: DirAccess = DirAccess.open(path_prefix)
	if !dir:
		return SSDMResult.failure("SSDMDiskManager: Failed to open directory for rename")
	var old_path_result: SSDMResult = get_res_path()
	if !old_path_result.is_success():
		return old_path_result
	var old_path: String = old_path_result.data
	res_name = new_name
	var new_path_result: SSDMResult = get_res_path()
	if !new_path_result.is_success():
		return new_path_result
	var new_path: String = new_path_result.data
	var rename_result = DirAccess.rename_absolute(old_path, new_path)
	if rename_result != OK:
		return SSDMResult.failure("SSDMDiskManager: Failed to rename file from " + old_path + " to " + new_path + " (Error: " + str(rename_result) + ")")
	await wait_for_scan()
	return SSDMResult.success()
