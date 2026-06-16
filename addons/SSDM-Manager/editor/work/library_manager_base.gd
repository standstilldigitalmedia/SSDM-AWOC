@tool
@abstract class_name SSDMLibraryManagerBase
extends RefCounted

var disk_resource_reference: SSDMResourceReference
var library: SSDMLibrary
	

@abstract func add_resource(params: Dictionary) -> SSDMResult
@abstract func rename_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult
@abstract func delete_resource(resource_reference: SSDMResourceReference) -> SSDMResult


func set_ref_path(params: Dictionary, resource_reference: SSDMResourceReference) -> SSDMResult:
	var base_path: String = params.get("path")
	var extension: String = base_path.get_extension()
	if !extension.is_empty():
		base_path = base_path.get_base_dir()
	var prefix_split := base_path.split(":")
	if prefix_split[0] == "res":
		resource_reference.path_prefix = "res://"
		resource_reference.path_base = base_path.trim_prefix("res://")
	elif prefix_split[0] == "user":
		resource_reference.path_prefix = "user://"
		resource_reference.path_base = base_path.trim_prefix("user://")
	else:
		return SSDMResult.failure("Invalid path: " + params.get("path"))
	resource_reference.res_name = params.get("name")
	resource_reference.path_extension = ".tres"
	return SSDMResult.success()
	
	
	
func set_library_ref(disk_resource_ref: SSDMResourceReference, lib: SSDMLibrary) -> void:
	disk_resource_reference = disk_resource_ref
	library = lib
	
	
func add_disk_resource(resource_reference: SSDMDiskResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_new_dictionary_resource(resource_reference)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_new_disk_resource()
	if !disk_validate_result.is_success():
		return disk_validate_result
	var save_to_disk_result: SSDMResult = await resource_reference.save_resource_to_disk()
	if !save_to_disk_result.is_success():
		return save_to_disk_result
	var add_to_dictionary_result: SSDMResult = library.add_resource_reference_to_dictionary(resource_reference)
	if !add_to_dictionary_result.is_success():
		return add_to_dictionary_result
	return disk_resource_reference.save_resource_to_disk()
	

func rename_disk_resource(new_name: String, resource_reference: SSDMDiskResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_rename_dictionary_resource(resource_reference.res_name, new_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_rename_resource_on_disk(new_name)
	if !disk_validate_result.is_success():
		return disk_validate_result
	return await resource_reference.rename_resource_on_disk(new_name)
	

func delete_disk_resource(resource_reference: SSDMDiskResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_delete_dictionary_resource(resource_reference.res_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var disk_validate_result: SSDMResult = resource_reference.validate_delete_resource_from_disk([])
	if !disk_validate_result.is_success():
		return disk_validate_result
	var delete_from_disk_result: SSDMResult = await resource_reference.delete_resource_from_disk()
	if !delete_from_disk_result.is_success():
		return delete_from_disk_result
	var delete_from_dictionary_result: SSDMResult = library.delete_resource_reference_from_dictionary(resource_reference)
	if !delete_from_dictionary_result.is_success():
		return delete_from_dictionary_result
	return disk_resource_reference.save_resource_to_disk()
	
	
func add_dictionary_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_new_dictionary_resource(resource_reference)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var add_to_dictionary_result: SSDMResult = library.add_resource_reference_to_dictionary(resource_reference)
	if !add_to_dictionary_result.is_success():
		return add_to_dictionary_result
	return disk_resource_reference.save_resource_to_disk()
	

func rename_dictionary_resource(new_name: String, resource_reference: SSDMResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_rename_dictionary_resource(resource_reference.res_name, new_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var rename_result: SSDMResult = library.rename_resource_reference_in_dictionary(resource_reference.res_name, new_name)
	if !rename_result.is_success():
		return rename_result
	return disk_resource_reference.save_resource_to_disk()
	

func delete_dictionary_resource(resource_reference: SSDMResourceReference) -> SSDMResult:
	var dictionary_validate_result := library.validate_delete_dictionary_resource(resource_reference.res_name)
	if !dictionary_validate_result.is_success():
		return dictionary_validate_result
	var delete_from_dictionary_result: SSDMResult = library.delete_resource_reference_from_dictionary(resource_reference)
	if !delete_from_dictionary_result.is_success():
		return delete_from_dictionary_result
	return disk_resource_reference.save_resource_to_disk()
