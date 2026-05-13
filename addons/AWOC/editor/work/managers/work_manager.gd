@tool
class_name AWOCWorkManager
extends RefCounted

signal resource_created(type: String)

static var config: AWOCPluginConfig = null

var managers := {}


func get_manager(type: String) -> AWOCResourceManagerBase:
	return managers.get(type)
	

func set_manager(type: String, resource_reference: AWOCResourceReference, resource_dictionary: Dictionary) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	manager.set_manager(resource_reference, resource_dictionary)
	return AWOCResult.success()
	
	
func has_resources(type: String) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.has_resources()
	
	
func has_named_resource(type: String, resource_name: String) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.has_named_resource(resource_name)
	
	
func get_sorted_name_array(type: String) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.get_sorted_name_array()
	
	
func get_new_resource(type: String) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return manager.get_new_resource()
	
	
func add_resource(type: String, res_name: String, resource_reference: AWOCResourceReference, additional_data: Variant = null, parent_name: String = "") -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	var add_resource: AWOCResult = await manager.add_resource(res_name, resource_reference, additional_data, parent_name)
	if add_resource.is_success():
		resource_created.emit()
	return add_resource
	
	
func rename_resource(type: String, old_name: String, new_name: String, resource_reference: AWOCResourceReference = null) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return await manager.rename_resource(old_name, new_name, resource_reference)
	
	
func delete_resource(type: String, resource_name: String, resource_reference: AWOCResourceReference = null) -> AWOCResult:
	var manager: AWOCResourceManagerBase = get_manager(type)
	if not manager:
		return AWOCResult.failure("AWOCWorkManager: Unknown resource type: " + type)
	return await manager.delete_resource(resource_name, resource_reference)


func validate_manager_entry(entry: AWOCRegistryEntry) -> AWOCResult:
	if entry.type_key.is_empty():
		return AWOCResult.failure("AWOCWorkManager: Manager entry has empty type_key")

	if not entry.manager_script:
		return AWOCResult.failure("AWOCWorkManager: Manager " + entry.type_key + " has no script assigned")

	var base = AWOCResourceManagerBase 
	var test_instance = entry.manager_script.new()

	if not test_instance is AWOCResourceManagerBase:
		return AWOCResult.failure("AWOCWorkManager: Manager " + entry.type_key + " must extend AWOCResourceManagerBase")
	return AWOCResult.success()
	
	
func _init(configure: AWOCPluginConfig) -> void:
	config = configure
	if !config:
		push_error("Config is null")
		return
	for entry in config.manager_registry_entries:
		var validation: AWOCResult = validate_manager_entry(entry)
		if validation.error:
			push_error(validation.message)
			continue
		var manager = entry.manager_script.new()
		managers[entry.type_key] = manager
