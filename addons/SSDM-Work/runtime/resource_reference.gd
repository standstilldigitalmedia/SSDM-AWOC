@tool
class_name SSDMResourceReference
extends Resource

@export var res_uid: int = -1
@export var res_path: String = ""
@export var dictionary_resource: Resource = null

var resource: Resource = null


func set_ref_uid(new_uid: int) -> SSDMResult:
	if new_uid == ResourceUID.INVALID_ID:
		return SSDMResult.failure("SSDMWork: Invalid resource reference UID: " + str(new_uid))
	res_uid = new_uid
	return SSDMResult.success()


func set_ref_path(new_path: String) -> void:
	res_path = new_path


func set_resource(res: Resource) -> void:
	resource = res


func get_ref_path() -> SSDMResult:
	if res_uid > 0 and res_uid != ResourceUID.INVALID_ID:
		res_path = ResourceUID.get_id_path(res_uid)
	elif FileAccess.file_exists(res_path):
		res_uid = ResourceLoader.get_resource_uid(res_path)
	if res_path.is_empty():
		return SSDMResult.failure("SSDMWork: Could not determine path for resource")
	return SSDMResult.success("", res_path)


func get_base_ref_path() -> SSDMResult:
	var ref_path_result: SSDMResult = get_ref_path()
	if ref_path_result.error:
		return ref_path_result
	var ref_path: String = ref_path_result.data
	return SSDMResult.success("", ref_path.get_base_dir())


func get_resource() -> Resource:
	if dictionary_resource:
		return dictionary_resource
	if resource:
		return resource

	var ext = res_path.get_extension().to_lower()
	if ext == "tscn" or ext == "scn":
		resource = ResourceLoader.load(res_path, "PackedScene", ResourceLoader.CACHE_MODE_REUSE)
	else:
		resource = ResourceLoader.load(res_path, "", ResourceLoader.CACHE_MODE_REUSE)

	if not resource:
		push_error("SSDMWork: Failed to load resource at: " + res_path)
		return null

	return resource
