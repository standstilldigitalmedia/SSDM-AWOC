class_name SSDMWorkManager
extends RefCounted

signal resource_modified(type: String)
signal edit_resource(type: String, resource_reference: SSDMResourceReference)
signal show_resource(type: String, resource_reference: SSDMResourceReference, show: bool)

static var config: SSDMPluginConfig = null
var managers := {}


func set_library_ref(type: String, disk_resource_ref: SSDMResourceReference, lib: SSDMLibrary) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	manager.set_library_ref(disk_resource_ref, lib)
	return SSDMResult.success()
	
	
func has_refs(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	return manager.library.has_refs()
	
	
func get_refs(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	return manager.library.get_refs()
	
	
func get_ref_by_name(type: String, resource_name: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	return manager.library.get_ref_by_name(resource_name)
	
	
func get_ref_by_uid(type: String, uid: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	return manager.library.get_ref_by_uid(uid)
	
	
func get_sorted_name_array(type: String) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	return manager.library.get_sorted_name_array()
	
	
func modify_resource_property(type: String, resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	var modify_property_result: SSDMResult = manager.modify_resource_property(resource_reference, params)
	if modify_property_result.is_success():
		resource_modified.emit(type)
	return modify_property_result
	
	
func add_resource(type: String, params: Dictionary) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	var add_resource_result: SSDMResult = await manager.add_resource(params)
	if add_resource_result.is_success():
		resource_modified.emit(type)
	return add_resource_result
	
	
func rename_resource(type: String, new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	var rename_resource_result: SSDMResult = await manager.rename_resource(new_name, resource_reference)
	if rename_resource_result.is_success():
		resource_modified.emit(type) 
	return rename_resource_result
	
	
func delete_resource(type: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var manager: SSDMLibraryManagerBase = managers.get(type)
	if not manager:
		return SSDMResult.print_failure("Unknown resource type: " + type)
	var delete_resource_result: SSDMResult = await manager.delete_resource(resource_reference)
	if delete_resource_result.is_success():
		resource_modified.emit(type)
	return delete_resource_result


func validate_manager_entry(entry: SSDMRegistryEntry) -> SSDMResult:
	if entry.type_key.is_empty():
		return SSDMResult.print_failure("Manager entry has empty type_key")
	if not entry.manager_script:
		return SSDMResult.print_failure("Manager " + entry.type_key + " has no script assigned")
	var test_instance = entry.manager_script.new()
	if not test_instance is SSDMLibraryManagerBase:
		return SSDMResult.print_failure("Manager " + entry.type_key + " must extend AWOCResourceManagerBase")
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
