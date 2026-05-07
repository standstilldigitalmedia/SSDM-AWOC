@tool
class_name SSDMWorkManager
extends Node

static var config: SSDMPluginConfig = null

var managers := {}


func get_manager(type: String) -> SSDMResourceManagerBase:
	return managers.get(type)
	
	
func get_new_resource(type: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.get_new_resource()


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
	
	
func create_resource(type: String, res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = ""):
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.create_resource(res_name, resource_reference, additional_data, parent_name)
	
	
func rename_resource(type: String, old_name: String, new_name: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.rename_resource(old_name, new_name)
	
	
func delete_resource(type: String, resource_name: String) -> SSDMResult:
	var manager: SSDMResourceManagerBase = get_manager(type)
	if not manager:
		return SSDMResult.failure("SSDMManager: Unknown resource type: " + type)
	return manager.delete_resource(resource_name)


func validate_manager_entry(entry: SSDMRegistryEntry) -> SSDMResult:
	if entry.type_key.is_empty():
		return SSDMResult.failure("SSDMManager: Manager entry has empty type_key")

	if not entry.manager_script:
		return SSDMResult.failure("SSDMManager: Manager " + entry.type_key + " has no script assigned")

	var base = SSDMResourceManagerBase 
	var test_instance = entry.manager_script.new()

	if not test_instance is SSDMResourceManagerBase:
		test_instance.free()
		return SSDMResult.failure("SSDMManager: Manager " + entry.type_key + " must extend SSDMResourceManagerBase")

	test_instance.free()
	return SSDMResult.success()
	
	
func load_config(path: String):
	config = load(path)
	if !config:
		push_error("SSDMManager: Config could not be loaded: " + path)
		return
	for entry in config.manager_registry_entries:
		var validation: SSDMResult = validate_manager_entry(entry)
		if validation.error:
			push_error(validation.message)
			continue
		var manager = entry.manager_script.new()
		managers[entry.type_key] = manager
		
		
func _exit_tree() -> void:
	config = null
