@tool
class_name SSDMWorkManager
extends RefCounted

signal resource_created(type: String)

static var config: SSDMPluginConfig = null

var managers := {}


func get_manager(type: String) -> SSDMResourceManagerBase:
	return managers.get(type)
	

func set_manager(type: String, resource_reference: SSDMResourceReference, resource_dictionary: Dictionary) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	manager.set_manager(resource_reference, resource_dictionary)
	return SSDMResult.success()
	
	
func has_resources(type: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.has_resources()
	
	
func has_named_resource(type: String, resource_name: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.has_named_resource(resource_name)
	
	
func get_sorted_name_array(type: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.get_sorted_name_array()
	
	
func get_new_resource(type: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.get_new_resource()
	
	
func add_resource(type: String, res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = "") -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	var add_resource: SSDMResult = await manager.add_resource(res_name, resource_reference, additional_data, parent_name)
	if add_resource.is_success():
		resource_created.emit()
	return add_resource
	
	
func rename_resource(type: String, old_name: String, new_name: String, resource_reference: SSDMResourceReference = null) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return await manager.rename_resource(old_name, new_name, resource_reference)
	
	
func delete_resource(type: String, resource_name: String, resource_reference: SSDMResourceReference = null) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return await manager.delete_resource(resource_name, resource_reference)


func validate_manager_entry(entry: SSDMRegistryEntry) -> SSDMResult:
	if entry.type_key.is_empty():
		return SSDMResult.failure("SSDMManager: Manager entry has empty type_key")

	if not entry.manager_script:
		return SSDMResult.failure("SSDMManager: Manager " + entry.type_key + " has no script assigned")

	var base = SSDMResourceManagerBase 
	var test_instance = entry.manager_script.new()

	if not test_instance is SSDMResourceManagerBase:
		return SSDMResult.failure("SSDMManager: Manager " + entry.type_key + " must extend SSDMResourceManagerBase")
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
