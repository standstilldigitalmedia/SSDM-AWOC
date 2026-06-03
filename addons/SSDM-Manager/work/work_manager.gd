class_name SSDMWorkManager
extends RefCounted


signal resource_created(type: String)

static var config: SSDMPluginConfig = null

var managers := {}


func get_manager(type: String) -> SSDMLibraryManagerBase:
	return managers.get(type)
	
	
func set_library_ref(resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(resource_reference.res_type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + resource_reference.res_type)
	manager.set_library_ref(resource_reference)
	return SSDMResult.success()
	
	
func has_resources(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.has_refs_of_type(type)
	
	
func get_ref_by_name(type: String, resource_name: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_ref_by_name(resource_name)
	
	
func get_sorted_name_array(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.library_manager.get_sorted_name_array_of_type(type)
	
	
func add_resource(type: String, res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = "") -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	var add_resource: SSDMResult = await manager.add_resource(resource_reference)
	if add_resource.is_success():
		resource_created.emit()
	return add_resource
	
	
func rename_resource(type: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return await manager.rename_resource(new_name, resource_reference)
	
	
func delete_resource(type: String, resource_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return await manager.delete_resource(resource_reference)


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
