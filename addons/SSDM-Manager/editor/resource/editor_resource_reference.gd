class_name SSDMEditorResourceReference
extends SSDMDiskResourceReference

@export var disk_uid: int


func get_res_path() -> SSDMResult:
	if disk_uid > 0 and disk_uid != ResourceUID.INVALID_ID:
		var res_path: String = ResourceUID.get_id_path(disk_uid)
		if path_prefix.is_empty():
			path_prefix = res_path.left(6)
			if path_prefix != "res://":
				return SSDMResult.failure("Resource path prefix is not valid")
		if path_extension.is_empty():
			path_extension = "." + res_path.get_extension()
		if resource_name.is_empty():
			var file_name: String = res_path.get_file()
			var explode = file_name.split(".")
			resource_name = file_name[0]
		if path_base.is_empty():
			path_base = res_path.trim_prefix(path_prefix)
	else:
		var path_result: SSDMResult = super()
		if !path_result.is_success():
			return path_result
		var res_path: String = path_result.data
		if FileAccess.file_exists(res_path):
			disk_uid = ResourceLoader.get_resource_uid(res_path)
	return super()
	
	
func save_resource_to_disk(bundle: bool = false) -> SSDMResult:
	var save_result: SSDMResult = await super()
	if !save_result.is_success():
		return save_result
	var path: String = save_result.data
	disk_uid = ResourceLoader.get_resource_uid(path)
	if disk_uid == ResourceUID.INVALID_ID:
		return SSDMResult.failure("SSDMDiskManager: Failed to get UID for path: " + path)
	return SSDMResult.success()
