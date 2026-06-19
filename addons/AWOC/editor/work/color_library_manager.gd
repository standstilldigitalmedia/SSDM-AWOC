@tool
class_name AWOCColorLibraryManager
extends SSDMLibraryManagerBase


func modify_resource_property(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	if !params.has("prop") or !params.has("value"):
		return SSDMResult.print_failure("Paramaters does not have the correct keys")
	if params['prop'] != "color":
		return SSDMResult.print_failure("What are you trying to modify?")
	resource_reference.stored_value = params.get("value")
	return await disk_resource_reference.save_resource_to_disk()
	
	
func add_resource(params: Dictionary) -> SSDMResult:
	if !params.has("name") or !params.has("color"):
		return SSDMResult.print_failure("Paramaters does not have the correct keys")
	var color_ref := SSDMResourceReference.new()
	color_ref.res_name = params.get("name")
	color_ref.stored_value = params.get("color")
	var add_dictionary_result: SSDMResult = await _add_dictionary_resource(color_ref)
	if !add_dictionary_result.is_success():
		return add_dictionary_result
	var save_resource_result: SSDMResult = await disk_resource_reference.save_resource_to_disk()
	if !save_resource_result.is_success():
		return save_resource_result
	return SSDMResult.success("Resource " + color_ref.res_name + " created successfully")
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return await _rename_dictionary_resource(new_name, resource_reference)
	

func delete_resource(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return await _delete_dictionary_resource(resource_reference)
