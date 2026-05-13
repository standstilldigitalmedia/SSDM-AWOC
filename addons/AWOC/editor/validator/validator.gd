@tool
class_name AWOCValidator
extends RefCounted

const MIN_NAME_LENGTH: int = 3
const MAX_NAME_LENGTH: int = 30
const USE_STRICT_NAMES: bool = true


static func get_base_path(path: String) -> String:
	var extension: String = path.get_extension()
	if extension == "":
		return path
	return path.get_base_dir()
	
	
static func is_valid_node_path(path: String) -> AWOCResult:
	var clean_path: String = path.strip_edges()
	if clean_path.is_empty():
		return AWOCResult.failure("AWOCValidator: Node path can not be empty")
	if (clean_path.begins_with("res://") or clean_path.begins_with("user://") or clean_path.begins_with("uid://")):
		return AWOCResult.failure("AWOCValidator: Node path can not be a file path")
	if ":" in clean_path:
		return AWOCResult.failure("AWOCValidator: Node paths do not contain colons")
	var np = NodePath(clean_path)
	if np.is_empty():
		return AWOCResult.failure("AWOCValidator: Node path string could not be converted to NodePath")
	return AWOCResult.success()


static func is_valid_new_path(path: String) -> AWOCResult:
	if path.is_empty():
		return AWOCResult.failure("AWOCValidator: New path is empty")
	var clean_path: String = path.strip_edges()
	if clean_path.is_empty():
		return AWOCResult.failure("AWOCValidator: Cleaned path is empty")
	if !clean_path.is_absolute_path():
		return AWOCResult.failure("AWOCValidator: New path is not an absolute path: " + clean_path)
	if !clean_path.begins_with("res://"):
		return AWOCResult.failure("AWOCValidator: New path does not begin with res:// : " + clean_path)
	if clean_path.contains(":") and clean_path.find(":") != 3:
		return AWOCResult.failure("AWOCValidator: New path format is not valid: " + clean_path)
	return AWOCResult.success()


static func path_exists(path: String) -> AWOCResult:
	if path.is_empty():
		return AWOCResult.failure("AWOCValidator: Path is empty")
	var clean_path: String = path.strip_edges()
	var valid_path_result: AWOCResult = is_valid_new_path(clean_path)
	if valid_path_result.error:
		return valid_path_result
	var base_path: String = get_base_path(clean_path)
	var dir_exists: bool = DirAccess.dir_exists_absolute(base_path)
	if !dir_exists:
		return AWOCResult.failure("AWOCValidator: Path does not exist: " + base_path)
	return AWOCResult.success()


static func is_valid_name(name: String) -> AWOCResult:
	var clean_name: String = name.strip_edges()
	var length = clean_name.length()
	if length < MIN_NAME_LENGTH:
		return AWOCResult.failure("AWOCValidator: Name must be at least " + str(MIN_NAME_LENGTH) + " characters long")
	if length > MAX_NAME_LENGTH:
		return AWOCResult.failure("AWOCValidator: Name must be no more than " + str(MAX_NAME_LENGTH) + " characters long")
	if USE_STRICT_NAMES:
		if !clean_name.is_valid_ascii_identifier():
			return AWOCResult.failure("AWOCValidator: Name must be a valid identifier")
	else:
		if !clean_name.is_valid_filename():
			return AWOCResult.failure("AWOCValidator: Name must be a valid name")
	return AWOCResult.success()
