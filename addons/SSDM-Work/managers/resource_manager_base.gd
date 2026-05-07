@tool
@abstract class_name SSDMResourceManagerBase
extends RefCounted

var parent_disk_resource_reference: SSDMResourceReference
var resource_dictionary: Dictionary[String, SSDMResourceReference]


@abstract func get_new_resource() -> SSDMResult
@abstract func has_resources() -> SSDMResult
@abstract func has_named_resource(resource_name: String) -> SSDMResult
@abstract func create_resource(res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = "") -> SSDMResult
@abstract func rename_resource(old_name: String, new_name: String) -> SSDMResult
@abstract func delete_resource(resource_name: String) -> SSDMResult


func get_sorted_name_array() -> SSDMResult:
	var names: Array[String] = []
	for key in resource_dictionary.keys():
		names.append(key)
	names.sort()
	return SSDMResult.success("", names)
