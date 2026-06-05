class_name SSDMWorkManager
extends RefCounted

signal resource_created(type: String)
signal resource_deleted(type: String)

static var config: SSDMPluginConfig = null
var managers := {}


func set_library_ref(type: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + resource_reference.res_type)
	manager.set_library_ref(resource_reference)
	return SSDMResult.success()
	
	
func has_refs(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.has_refs()
	
	
func get_refs(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_refs()
	
	
func get_ref_by_name(type: String, resource_name: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_ref_by_name(resource_name)
	
	
func get_ref_by_uid(type: String, uid: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_ref_by_uid(uid)
	
	
func get_sorted_name_array(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_sorted_name_array()
	
	
func add_resource(type: String, params: Dictionary) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	var add_resource_result: SSDMResult = await manager.add_resource(params)
	if add_resource_result.is_success():
		resource_created.emit(type)
	return add_resource_result
	
	
func rename_resource(type: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return await manager.rename_resource(new_name, resource_reference)
	
	
func delete_resource(type: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	var delete_resource_result: SSDMResult = await manager.delete_resource(resource_reference)
	if delete_resource_result.is_success():
		resource_deleted.emit(type)
	return delete_resource_result


func validate_manager_entry(entry: SSDMRegistryEntry) -> SSDMResult:
	if entry.type_key.is_empty():
		return SSDMResult.failure("AWOCWorkManager: Manager entry has empty type_key")

	if not entry.manager_script:
		return SSDMResult.failure("AWOCWorkManager: Manager " + entry.type_key + " has no script assigned")

	var test_instance = entry.manager_script.new()

	if not test_instance is SSDMLibraryManagerBase:
		return SSDMResult.failure("AWOCWorkManager: Manager " + entry.type_key + " must extend AWOCResourceManagerBase")
	return SSDMResult.success()
	
	
func _init(configure: SSDMPluginConfig) -> void:
	config = configure
	if !config:
		push_error("Config is null")
		return
	for entry in config.manager_registry_entries:
		var validation: SSDMResult = validate_manager_entry(entry)
		if validation.error:
			push_error(validation.message)
			continue
		var manager = entry.manager_script.new()
		managers[entry.type_key] = manager
